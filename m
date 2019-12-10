Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D72C21194F4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:19:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727444AbfLJVR0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:17:26 -0500
Received: from mail.kernel.org ([198.145.29.99]:38490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729142AbfLJVM5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:12:57 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 812FF214AF;
        Tue, 10 Dec 2019 21:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012376;
        bh=fs8JSDLuW2dEyYdyDybBSXTeMzo+5VJFwmn7GzATvqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CbusRGHu+PUtmLCTukUgYTsiy6yf65YpE4xd3e+l6J2PpDn50boUi/H693QZF+sOP
         BNOA2TGbZCLsmkUyFc3KATUSBVrG0KuN/13zWdtfZHzrXHLr/xQ/gngSpyd5MhcpAz
         Pm0mfV6bDBzQ5nlOjtma3C1QsLoyih2pA2yaAZSg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Valentin Schneider <valentin.schneider@arm.com>,
        Qais Yousef <qais.yousef@arm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        Dietmar.Eggemann@arm.com,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        patrick.bellasi@matbug.net, qperret@google.com, surenb@google.com,
        tj@kernel.org, Ingo Molnar <mingo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 301/350] sched/uclamp: Fix overzealous type replacement
Date:   Tue, 10 Dec 2019 16:06:46 -0500
Message-Id: <20191210210735.9077-262-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit 7763baace1b738d65efa46d68326c9406311c6bf ]

Some uclamp helpers had their return type changed from 'unsigned int' to
'enum uclamp_id' by commit

  0413d7f33e60 ("sched/uclamp: Always use 'enum uclamp_id' for clamp_id values")

but it happens that some do return a value in the [0, SCHED_CAPACITY_SCALE]
range, which should really be unsigned int. The affected helpers are
uclamp_none(), uclamp_rq_max_value() and uclamp_eff_value(). Fix those up.

Note that this doesn't lead to any obj diff using a relatively recent
aarch64 compiler (8.3-2019.03). The current code of e.g. uclamp_eff_value()
properly returns an 11 bit value (bits_per(1024)) and doesn't seem to do
anything funny. I'm still marking this as fixing the above commit to be on
the safe side.

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Reviewed-by: Qais Yousef <qais.yousef@arm.com>
Acked-by: Vincent Guittot <vincent.guittot@linaro.org>
Cc: Dietmar.Eggemann@arm.com
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: patrick.bellasi@matbug.net
Cc: qperret@google.com
Cc: surenb@google.com
Cc: tj@kernel.org
Fixes: 0413d7f33e60 ("sched/uclamp: Always use 'enum uclamp_id' for clamp_id values")
Link: https://lkml.kernel.org/r/20191115103908.27610-1-valentin.schneider@arm.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c  | 6 +++---
 kernel/sched/sched.h | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 44123b4d14e82..8dacda4b03627 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -810,7 +810,7 @@ static inline unsigned int uclamp_bucket_base_value(unsigned int clamp_value)
 	return UCLAMP_BUCKET_DELTA * uclamp_bucket_id(clamp_value);
 }
 
-static inline enum uclamp_id uclamp_none(enum uclamp_id clamp_id)
+static inline unsigned int uclamp_none(enum uclamp_id clamp_id)
 {
 	if (clamp_id == UCLAMP_MIN)
 		return 0;
@@ -853,7 +853,7 @@ static inline void uclamp_idle_reset(struct rq *rq, enum uclamp_id clamp_id,
 }
 
 static inline
-enum uclamp_id uclamp_rq_max_value(struct rq *rq, enum uclamp_id clamp_id,
+unsigned int uclamp_rq_max_value(struct rq *rq, enum uclamp_id clamp_id,
 				   unsigned int clamp_value)
 {
 	struct uclamp_bucket *bucket = rq->uclamp[clamp_id].bucket;
@@ -918,7 +918,7 @@ uclamp_eff_get(struct task_struct *p, enum uclamp_id clamp_id)
 	return uc_req;
 }
 
-enum uclamp_id uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id)
+unsigned int uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id)
 {
 	struct uclamp_se uc_eff;
 
diff --git a/kernel/sched/sched.h b/kernel/sched/sched.h
index c8870c5bd7df2..49ed949f850c4 100644
--- a/kernel/sched/sched.h
+++ b/kernel/sched/sched.h
@@ -2309,7 +2309,7 @@ static inline void cpufreq_update_util(struct rq *rq, unsigned int flags) {}
 #endif /* CONFIG_CPU_FREQ */
 
 #ifdef CONFIG_UCLAMP_TASK
-enum uclamp_id uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id);
+unsigned int uclamp_eff_value(struct task_struct *p, enum uclamp_id clamp_id);
 
 static __always_inline
 unsigned int uclamp_util_with(struct rq *rq, unsigned int util,
-- 
2.20.1

