Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D0BF94520BA
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358784AbhKPA4R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:56:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:44626 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343540AbhKOTVS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:21:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 11E4A635AD;
        Mon, 15 Nov 2021 18:41:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637001700;
        bh=aA7zCIUHOIkNJvWKO3490jiM+is53Y1ocJJDwBGLFgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mBbaI/BjwhMo442da9ppwNxR2+jbLcNYoVwKJNRnr9OsLKQaKjTY7Psda30yjN09P
         6tifQ1qgMErWE7KsZAh5zvTI2NYdJtSbSgeZFNEMXWC2vJ6LzD9cbT3JZhNizELV8K
         Hl6cU8LNNO4LA/sNiieasOAnMykEfvWHDQBAVTJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mengen Sun <mengensun@tencent.com>,
        Menglong Dong <imagedong@tencent.com>,
        Tejun Heo <tj@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 270/917] workqueue: make sysfs of unbound kworker cpumask more clever
Date:   Mon, 15 Nov 2021 17:56:05 +0100
Message-Id: <20211115165437.931344761@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
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
index 1b3eb1e9531f4..76988f39ed5ac 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5384,9 +5384,6 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
 	int ret = -EINVAL;
 	cpumask_var_t saved_cpumask;
 
-	if (!zalloc_cpumask_var(&saved_cpumask, GFP_KERNEL))
-		return -ENOMEM;
-
 	/*
 	 * Not excluding isolated cpus on purpose.
 	 * If the user wishes to include them, we allow that.
@@ -5394,6 +5391,15 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
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
@@ -5406,10 +5412,11 @@ int workqueue_set_unbound_cpumask(cpumask_var_t cpumask)
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



