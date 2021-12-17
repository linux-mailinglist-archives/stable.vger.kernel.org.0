Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5411D47830A
	for <lists+stable@lfdr.de>; Fri, 17 Dec 2021 03:17:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229982AbhLQCRE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Dec 2021 21:17:04 -0500
Received: from out2.migadu.com ([188.165.223.204]:28507 "EHLO out2.migadu.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229733AbhLQCRE (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Dec 2021 21:17:04 -0500
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1639707422;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=uMigS+pNPz4JoxL7AW7Hx0wGyz7OYXv14jFz4Dq7WuY=;
        b=Fijp2w8r8Xl5FOxxfSDV4SzJxABMZHQZ4VUVTBwEb79z+NaI0wH1PAkmMmUgZO0uxs4NTF
        evlO1x+Upx2yRZecfE+3MPKrY7VcC/hNpSm/wkgX/KYXcFLhJs2T7nWB35Ip/LUOsJCa1J
        8yobmWvguL17FEzgD/f4DcVzGc5e9CQ=
From:   Yajun Deng <yajun.deng@linux.dev>
To:     song@kernel.org
Cc:     masahiroy@kernel.org, williams@redhat.com, pmenzel@molgen.mpg.de,
        linux-kernel@vger.kernel.org, linux-rt-users@vger.kernel.org,
        linux-raid@vger.kernel.org, stable@vger.kernel.org,
        Yajun Deng <yajun.deng@linux.dev>
Subject: [PATCH v3] lib/raid6: Reduce high latency by using migrate instead of preempt
Date:   Fri, 17 Dec 2021 10:16:10 +0800
Message-Id: <20211217021610.12801-1-yajun.deng@linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We found an abnormally high latency when executing modprobe raid6_pq, the
latency is greater than 1.2s when CONFIG_PREEMPT_VOLUNTARY=y, greater than
67ms when CONFIG_PREEMPT=y, and greater than 16ms when CONFIG_PREEMPT_RT=y.

How to reproduce:
 - Install cyclictest
     sudo apt install rt-tests
 - Run cyclictest example in one terminal
     sudo cyclictest -S -p 95 -d 0 -i 1000 -D 24h -m
 - Modprobe raid6_pq in another terminal
     sudo modprobe raid6_pq

This is caused by ksoftirqd fail to scheduled due to disable preemption,
this time is too long and unreasonable.

Reduce high latency by using migrate_disabl()/emigrate_enable() instead of
preempt_disable()/preempt_enable(), the latency won't greater than 100us.

This patch beneficial for CONFIG_PREEMPT=y or CONFIG_PREEMPT_RT=y, but no
effect for CONFIG_PREEMPT_VOLUNTARY=y.

Cc: stable@vger.kernel.org
Fixes: fe5cbc6e06c7 ("md/raid6 algorithms: delta syndrome functions")
Fixes: cc4589ebfae6 ("Rename raid6 files now they're in a 'raid6' directory.")
Link: https://lore.kernel.org/linux-raid/b06c5e3ef3413f12a2c2b2a241005af9@linux.dev/T/#t # v1
Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
---
 lib/raid6/algos.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/lib/raid6/algos.c b/lib/raid6/algos.c
index 6d5e5000fdd7..21611d05c34c 100644
--- a/lib/raid6/algos.c
+++ b/lib/raid6/algos.c
@@ -162,7 +162,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
 			perf = 0;
 
-			preempt_disable();
+			migrate_disable();
 			j0 = jiffies;
 			while ((j1 = jiffies) == j0)
 				cpu_relax();
@@ -171,7 +171,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 				(*algo)->gen_syndrome(disks, PAGE_SIZE, *dptrs);
 				perf++;
 			}
-			preempt_enable();
+			migrate_enable();
 
 			if (perf > bestgenperf) {
 				bestgenperf = perf;
@@ -186,7 +186,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 
 			perf = 0;
 
-			preempt_disable();
+			migrate_disable();
 			j0 = jiffies;
 			while ((j1 = jiffies) == j0)
 				cpu_relax();
@@ -196,7 +196,7 @@ static inline const struct raid6_calls *raid6_choose_gen(
 						      PAGE_SIZE, *dptrs);
 				perf++;
 			}
-			preempt_enable();
+			migrate_enable();
 
 			if (best == *algo)
 				bestxorperf = perf;
-- 
2.32.0

