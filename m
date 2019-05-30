Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AAE072EF57
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 05:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730474AbfE3Dyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 29 May 2019 23:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730507AbfE3DTR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:19:17 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DC2624858;
        Thu, 30 May 2019 03:19:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559186356;
        bh=rA9Hj3TBXRwB8sHqTiFbh7EgIX0uttYicRL5gPqMXVA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UigX2tISzjOUG/4SW8gpfQLRpJ+mfbIaEmdJoyfc9qwB43IU5qwcEDjZL6X31TK0F
         kwN+v9slj1JXe1pH1hnur6/wVWH43nHY6+0NkAwruD/DDUgy38mPZMCpZuVA/yf7Sa
         YgCN6v1XXx3xRDGK7zHMMb8HOy0soSbzMlkUvYSM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Roman Gushchin <guro@fb.com>,
        Tejun Heo <tj@kernel.org>, kernel-team@fb.com,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 099/193] cgroup: protect cgroup->nr_(dying_)descendants by css_set_lock
Date:   Wed, 29 May 2019 20:05:53 -0700
Message-Id: <20190530030502.750499610@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030446.953835040@linuxfoundation.org>
References: <20190530030446.953835040@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 4dcabece4c3a9f9522127be12cc12cc120399b2f ]

The number of descendant cgroups and the number of dying
descendant cgroups are currently synchronized using the cgroup_mutex.

The number of descendant cgroups will be required by the cgroup v2
freezer, which will use it to determine if a cgroup is frozen
(depending on total number of descendants and number of frozen
descendants). It's not always acceptable to grab the cgroup_mutex,
especially from quite hot paths (e.g. exit()).

To avoid this, let's additionally synchronize these counters using
the css_set_lock.

So, it's safe to read these counters with either cgroup_mutex or
css_set_lock locked, and for changing both locks should be acquired.

Signed-off-by: Roman Gushchin <guro@fb.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: kernel-team@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/cgroup-defs.h | 5 +++++
 kernel/cgroup/cgroup.c      | 6 ++++++
 2 files changed, 11 insertions(+)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index 93a2469a9130c..eb396f71285f7 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -287,6 +287,11 @@ struct cgroup {
 	 * Dying cgroups are cgroups which were deleted by a user,
 	 * but are still existing because someone else is holding a reference.
 	 * max_descendants is a maximum allowed number of descent cgroups.
+	 *
+	 * nr_descendants and nr_dying_descendants are protected
+	 * by cgroup_mutex and css_set_lock. It's fine to read them holding
+	 * any of cgroup_mutex and css_set_lock; for writing both locks
+	 * should be held.
 	 */
 	int nr_descendants;
 	int nr_dying_descendants;
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 694b1cc8d144e..d30a51da94e2f 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -4546,9 +4546,11 @@ static void css_release_work_fn(struct work_struct *work)
 		/* cgroup release path */
 		trace_cgroup_release(cgrp);
 
+		spin_lock_irq(&css_set_lock);
 		for (tcgrp = cgroup_parent(cgrp); tcgrp;
 		     tcgrp = cgroup_parent(tcgrp))
 			tcgrp->nr_dying_descendants--;
+		spin_unlock_irq(&css_set_lock);
 
 		cgroup_idr_remove(&cgrp->root->cgroup_idr, cgrp->id);
 		cgrp->id = -1;
@@ -4745,12 +4747,14 @@ static struct cgroup *cgroup_create(struct cgroup *parent)
 	cgrp->root = root;
 	cgrp->level = level;
 
+	spin_lock_irq(&css_set_lock);
 	for (tcgrp = cgrp; tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		cgrp->ancestor_ids[tcgrp->level] = tcgrp->id;
 
 		if (tcgrp != cgrp)
 			tcgrp->nr_descendants++;
 	}
+	spin_unlock_irq(&css_set_lock);
 
 	if (notify_on_release(parent))
 		set_bit(CGRP_NOTIFY_ON_RELEASE, &cgrp->flags);
@@ -5033,10 +5037,12 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	if (parent && cgroup_is_threaded(cgrp))
 		parent->nr_threaded_children--;
 
+	spin_lock_irq(&css_set_lock);
 	for (tcgrp = cgroup_parent(cgrp); tcgrp; tcgrp = cgroup_parent(tcgrp)) {
 		tcgrp->nr_descendants--;
 		tcgrp->nr_dying_descendants++;
 	}
+	spin_unlock_irq(&css_set_lock);
 
 	cgroup1_check_for_release(parent);
 
-- 
2.20.1



