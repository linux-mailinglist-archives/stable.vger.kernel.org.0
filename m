Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9E044526CC
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 03:07:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245691AbhKPCKe (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 21:10:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:40774 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238908AbhKOR7Q (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 12:59:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E8642632CD;
        Mon, 15 Nov 2021 17:35:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636997737;
        bh=wtnOxFHU44filqddQzw5KkDsIsaeifUehuCZof6zjOU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wm0tPbUV/fUXP6YwmUxtEHBnAoGKJf33VbnR//bVjFUeC5i+d/pmcctiW56HEpJsF
         Tt/jYnGXdC40lxac5Rlo8lDKMQ4HOHkFDutmoyR6BKRseIXvcduy59N32lunNEKalz
         1qDRJ8e3ZAtGf+GhryGO+wIEi08rUYXxleCqIVLE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mengen Sun <mengensun@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 224/575] workqueue: make sysfs of unbound kworker cpumask more clever
Date:   Mon, 15 Nov 2021 17:59:09 +0100
Message-Id: <20211115165351.459731622@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165343.579890274@linuxfoundation.org>
References: <20211115165343.579890274@linuxfoundation.org>
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
index 4cb622b2661b5..d02073b9d56e2 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5326,9 +5326,6 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
 	int ret = -EINVAL;
 	cpumask_var_t saved_cpumask;
 
-	if (!zalloc_cpumask_var(&saved_cpumask, GFP_KERNEL))
-		return -ENOMEM;
-
 	/*
 	 * Not excluding isolated cpus on purpose.
 	 * If the user wishes to include them, we allow that.
@@ -5336,6 +5333,15 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
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
@@ -5348,10 +5354,11 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
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



