Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB9E645BFD9
	for <lists+stable@lfdr.de>; Wed, 24 Nov 2021 13:59:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346057AbhKXNCV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Nov 2021 08:02:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:41112 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346754AbhKXNAU (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Nov 2021 08:00:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A68661175;
        Wed, 24 Nov 2021 12:34:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637757270;
        bh=ufrqD5GM6BCWE6ozeSLbaaPWgc65jOD7AnWNkV4ajrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cMtOLrc2JOj6/Durfdp9WeD2JHjE9CP3yKepjlcHx4N68W2CqDdPSw89a9nT0ABNA
         X5xfqYGJiCjVTRY/BwtfyNgcnhhWTGtc/BiMs5N5Ah4GLNr1TiQTyjLYw6dQHVsckI
         LTXnOW9wpZWBmlQlwzG6OI5AkNXsqu7tX3oib3z0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mengen Sun <mengensun@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 112/323] workqueue: make sysfs of unbound kworker cpumask more clever
Date:   Wed, 24 Nov 2021 12:55:02 +0100
Message-Id: <20211124115722.737647454@linuxfoundation.org>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <20211124115718.822024889@linuxfoundation.org>
References: <20211124115718.822024889@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



