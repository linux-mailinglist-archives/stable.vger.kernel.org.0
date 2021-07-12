Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D4233C4D23
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245356AbhGLHMD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:42134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244185AbhGLHK3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:10:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C1060613D4;
        Mon, 12 Jul 2021 07:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073624;
        bh=h/Ohe38gD02ghfKe08hLeUHUHkf5p7Y1xWoRa6HSz6c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WUivJgfgzyA7qC7AeAoOMysz8119fFSmzeQZ8oTOxTpVFlZiJonB23ffDqPfidUBn
         0/PXTXONFdV3Q9VG74OgW2UCCV97E1BedoHnDRLFFDaw3iwqEdyAdX0h8fWglDkv4z
         w9gEabKw2KhLV+t/rA3RuTydXKX70o41bLxkxbjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Quentin Perret <qperret@google.com>,
        Qais Yousef <qais.yousef@arm.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 261/700] sched/uclamp: Fix locking around cpu_util_update_eff()
Date:   Mon, 12 Jul 2021 08:05:44 +0200
Message-Id: <20210712061003.930651224@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qais Yousef <qais.yousef@arm.com>

[ Upstream commit 93b73858701fd01de26a4a874eb95f9b7156fd4b ]

cpu_cgroup_css_online() calls cpu_util_update_eff() without holding the
uclamp_mutex or rcu_read_lock() like other call sites, which is
a mistake.

The uclamp_mutex is required to protect against concurrent reads and
writes that could update the cgroup hierarchy.

The rcu_read_lock() is required to traverse the cgroup data structures
in cpu_util_update_eff().

Surround the caller with the required locks and add some asserts to
better document the dependency in cpu_util_update_eff().

Fixes: 7226017ad37a ("sched/uclamp: Fix a bug in propagating uclamp value in new cgroups")
Reported-by: Quentin Perret <qperret@google.com>
Signed-off-by: Qais Yousef <qais.yousef@arm.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20210510145032.1934078-3-qais.yousef@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 3fe7daf9d31d..f59166fe499a 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8693,7 +8693,11 @@ static int cpu_cgroup_css_online(struct cgroup_subsys_state *css)
 
 #ifdef CONFIG_UCLAMP_TASK_GROUP
 	/* Propagate the effective uclamp value for the new group */
+	mutex_lock(&uclamp_mutex);
+	rcu_read_lock();
 	cpu_util_update_eff(css);
+	rcu_read_unlock();
+	mutex_unlock(&uclamp_mutex);
 #endif
 
 	return 0;
@@ -8783,6 +8787,9 @@ static void cpu_util_update_eff(struct cgroup_subsys_state *css)
 	enum uclamp_id clamp_id;
 	unsigned int clamps;
 
+	lockdep_assert_held(&uclamp_mutex);
+	SCHED_WARN_ON(!rcu_read_lock_held());
+
 	css_for_each_descendant_pre(css, top_css) {
 		uc_parent = css_tg(css)->parent
 			? css_tg(css)->parent->uclamp : NULL;
-- 
2.30.2



