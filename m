Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0590644A28E
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243024AbhKIBTa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:19:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:44370 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243201AbhKIBPR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:15:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9202D61A52;
        Tue,  9 Nov 2021 01:06:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419973;
        bh=ufrqD5GM6BCWE6ozeSLbaaPWgc65jOD7AnWNkV4ajrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XZJZYziWSgEhKpqTIvBN0xr6T9GrulfjbPkUgBv4WazI5M9moRcCp3/mOTtQBVAVD
         y0vOWSEeSDTKeLYEBqa7N5o953QbDGlbw64fQBNSjhjrEDavG5zmTGWpNDKaaIaSv3
         6b+YM91PBgiFo74vKiVdIXodJ4rYOjw0Xd6UFZeWfIkd8rOjAUeyGqAy7MECfD1Zrb
         qJNivpmwiWMkKq/Sjavp+1/HfauMxamWb/rUuDmEwx+240R7w2rXRxxdC+4sCDezEf
         h+GrCuLX/0z2ImbvLm0EqI3b9NrQa7Hdnw4a5IXHAmiVRF+/Jnux8VaiCWGPrQvPX7
         9/YW/R7MBopKw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Menglong Dong <imagedong@tencent.com>,
        Mengen Sun <mengensun@tencent.com>, Tejun Heo <tj@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 32/47] workqueue: make sysfs of unbound kworker cpumask more clever
Date:   Mon,  8 Nov 2021 12:50:16 -0500
Message-Id: <20211108175031.1190422-32-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108175031.1190422-1-sashal@kernel.org>
References: <20211108175031.1190422-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <imagedong@tencent.com>

[ Upstream commit d25302e46592c97d29f70ccb1be558df31a9a360 ]

Some unfriendly component, such as dpdk, write the same mask to
unbound kworker cpumask again and again. Every time it write to
this interface some work is queue to cpu, even though the mask
is same with the original mask.

So, fix it by return success and do nothing if the cpumask is
equal with the old one.

Signed-off-by: Mengen Sun <mengensun@tencent.com>
Signed-off-by: Menglong Dong <imagedong@tencent.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/workqueue.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 1573d1bf63007..b1bb6cb5802ec 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5125,9 +5125,6 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
 	int ret = -EINVAL;
 	cpumask_var_t saved_cpumask;
 
-	if (!zalloc_cpumask_var(&saved_cpumask, GFP_KERNEL))
-		return -ENOMEM;
-
 	/*
 	 * Not excluding isolated cpus on purpose.
 	 * If the user wishes to include them, we allow that.
@@ -5135,6 +5132,15 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
 	cpumask_and(cpumask, cpumask, cpu_possible_mask);
 	if (!cpumask_empty(cpumask)) {
 		apply_wqattrs_lock();
+		if (cpumask_equal(cpumask, wq_unbound_cpumask)) {
+			ret = 0;
+			goto out_unlock;
+		}
+
+		if (!zalloc_cpumask_var(&saved_cpumask, GFP_KERNEL)) {
+			ret = -ENOMEM;
+			goto out_unlock;
+		}
 
 		/* save the old wq_unbound_cpumask. */
 		cpumask_copy(saved_cpumask, wq_unbound_cpumask);
@@ -5147,10 +5153,11 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
 		if (ret < 0)
 			cpumask_copy(wq_unbound_cpumask, saved_cpumask);
 
+		free_cpumask_var(saved_cpumask);
+out_unlock:
 		apply_wqattrs_unlock();
 	}
 
-	free_cpumask_var(saved_cpumask);
 	return ret;
 }
 
-- 
2.33.0

