Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54E22408EF7
	for <lists+stable@lfdr.de>; Mon, 13 Sep 2021 15:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242593AbhIMNi0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Sep 2021 09:38:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:37748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242326AbhIMNgU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 13 Sep 2021 09:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 255C1613A5;
        Mon, 13 Sep 2021 13:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631539658;
        bh=9s60/hmGtUabFvqryUmJCN2nkfZaoBKAEfL5FNuBKkg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b69BQFQDPpVJpJrCkqhQvEFswhXoFUgXSF9U6Ch5BOmNba7bP+6B+IzuhmsGWVH6I
         Qwz8FKQK7PY/NQzosuMVug5U71oeVfuq/CyPhBWcR03acgnefnyTeuW5CWjdXsZANc
         fktlvBZMaD0nYCdEhGnb/GoZDDxEbnPZrN7T6gvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Waiman Long <longman@redhat.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 110/236] cgroup/cpuset: Fix a partition bug with hotplug
Date:   Mon, 13 Sep 2021 15:13:35 +0200
Message-Id: <20210913131104.082308864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210913131100.316353015@linuxfoundation.org>
References: <20210913131100.316353015@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Waiman Long <longman@redhat.com>

[ Upstream commit 15d428e6fe77fffc3f4fff923336036f5496ef17 ]

In cpuset_hotplug_workfn(), the detection of whether the cpu list
has been changed is done by comparing the effective cpus of the top
cpuset with the cpu_active_mask. However, in the rare case that just
all the CPUs in the subparts_cpus are offlined, the detection fails
and the partition states are not updated correctly. Fix it by forcing
the cpus_updated flag to true in this particular case.

Fixes: 4b842da276a8 ("cpuset: Make CPU hotplug work with partition")
Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/cgroup/cpuset.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 53c70c470a38..e1601d8dac29 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3168,6 +3168,13 @@ static void cpuset_hotplug_workfn(struct work_struct *work)
 	cpus_updated = !cpumask_equal(top_cpuset.effective_cpus, &new_cpus);
 	mems_updated = !nodes_equal(top_cpuset.effective_mems, new_mems);
 
+	/*
+	 * In the rare case that hotplug removes all the cpus in subparts_cpus,
+	 * we assumed that cpus are updated.
+	 */
+	if (!cpus_updated && top_cpuset.nr_subparts_cpus)
+		cpus_updated = true;
+
 	/* synchronize cpus_allowed to cpu_active_mask */
 	if (cpus_updated) {
 		spin_lock_irq(&callback_lock);
-- 
2.30.2



