Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8CE9E9A1B5
	for <lists+stable@lfdr.de>; Thu, 22 Aug 2019 23:11:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733079AbfHVVKs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 22 Aug 2019 17:10:48 -0400
Received: from foss.arm.com ([217.140.110.172]:52502 "EHLO foss.arm.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730991AbfHVVKs (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 22 Aug 2019 17:10:48 -0400
Received: from usa-sjc-imap-foss1.foss.arm.com (unknown [10.121.207.14])
        by usa-sjc-mx-foss1.foss.arm.com (Postfix) with ESMTP id 8D63B337;
        Thu, 22 Aug 2019 14:10:47 -0700 (PDT)
Received: from [10.0.2.15] (unknown [172.31.20.19])
        by usa-sjc-imap-foss1.foss.arm.com (Postfix) with ESMTPA id 3B9583F706;
        Thu, 22 Aug 2019 14:10:46 -0700 (PDT)
Subject: Re: [PATCH] sched/fair: Add missing unthrottle_cfs_rq()
From:   Valentin Schneider <valentin.schneider@arm.com>
To:     bsegall@google.com
Cc:     linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, liangyan.peng@linux.alibaba.com,
        shanpeic@linux.alibaba.com, xlpang@linux.alibaba.com,
        pjt@google.com, stable@vger.kernel.org
References: <0004fb54-cdee-2197-1cbf-6e2111d39ed9@arm.com>
 <20190820105420.7547-1-valentin.schneider@arm.com>
 <xm26lfvlhw93.fsf@bsegall-linux.svl.corp.google.com>
 <20382abf-4741-7792-d830-34603409361e@arm.com>
Message-ID: <0df3e0e2-b5cc-d689-7776-c7a31ad244dc@arm.com>
Date:   Thu, 22 Aug 2019 22:10:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20382abf-4741-7792-d830-34603409361e@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 22/08/2019 21:40, Valentin Schneider wrote:
> On 22/08/2019 19:48, bsegall@google.com wrote:

Re we shouldn't get account_cfs_rq_runtime() called on throttled cfs_rq's,
with this:
---
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 171eef3f08f9..1acb88024cad 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -4385,6 +4385,11 @@ static inline u64 cfs_rq_clock_task(struct cfs_rq *cfs_rq)
 	return rq_clock_task(rq_of(cfs_rq)) - cfs_rq->throttled_clock_task_time;
 }
 
+static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
+{
+	return cfs_bandwidth_used() && cfs_rq->throttled;
+}
+
 /* returns 0 on failure to allocate runtime */
 static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 {
@@ -4411,6 +4416,8 @@ static int assign_cfs_rq_runtime(struct cfs_rq *cfs_rq)
 
 	cfs_rq->runtime_remaining += amount;
 
+	WARN_ON(cfs_rq_throttled(cfs_rq) && cfs_rq->runtime_remaining > 0);
+
 	return cfs_rq->runtime_remaining > 0;
 }
 
@@ -4436,12 +4443,9 @@ void account_cfs_rq_runtime(struct cfs_rq *cfs_rq, u64 delta_exec)
 	if (!cfs_bandwidth_used() || !cfs_rq->runtime_enabled)
 		return;
 
-	__account_cfs_rq_runtime(cfs_rq, delta_exec);
-}
+	WARN_ON(cfs_rq_throttled(cfs_rq));
 
-static inline int cfs_rq_throttled(struct cfs_rq *cfs_rq)
-{
-	return cfs_bandwidth_used() && cfs_rq->throttled;
+	__account_cfs_rq_runtime(cfs_rq, delta_exec);
 }
 
 /* check whether cfs_rq, or any parent, is throttled */
---

I get this:

[  204.798643] Call Trace:
[  204.798645]  put_prev_entity+0x8d/0x100
[  204.798647]  put_prev_task_fair+0x22/0x40
[  204.798648]  pick_next_task_idle+0x36/0x50
[  204.798650]  __schedule+0x61d/0x6c0
[  204.798651]  schedule+0x2d/0x90
[  204.798653]  exit_to_usermode_loop+0x61/0x100
[  204.798654]  prepare_exit_to_usermode+0x91/0xa0
[  204.798656]  retint_user+0x8/0x8

(this is a hit on the account_cfs_rq_runtime() WARN_ON)
