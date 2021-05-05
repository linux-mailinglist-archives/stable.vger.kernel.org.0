Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15B373741DC
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 18:46:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235074AbhEEQlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:40624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235486AbhEEQjp (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:39:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2A1446161F;
        Wed,  5 May 2021 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232450;
        bh=0OLzhgNg6Yx/Mcmtj6kddngeM0hyvGo6LAnM/BpS5B4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h4jsqK1OMqtZGZMQaWTDraQRSIDC8v535T7ZtbTYND7XgqUTW3vcmEmR0O9xNP3fv
         n9nI3mKBuw8z403+aNrL4XQTjbMhXLRihd0ZQu3fRyQjrVLms1QIAOlBiAzPW88r2/
         NMqymNcInJA0ofQgEuEaiSJFvViAOZNOaQ5Jtk6DeC4uX+n/T8lV/D1NC3mNYwTa58
         Z5EMetXfZ4HIoiN62AovRZLhM7RCW2cKNZDkxC/sH1NOzORliIKlUFpXLe0bgHLaFl
         DMlozAImB6usEK7RCBYEQ3zQP76MdVOh8GN/6ak/XxxxH1mvpnQGkXA39F6kZotgLx
         HI9yl5gwcH8fA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.12 115/116] watchdog: fix barriers when printing backtraces from all CPUs
Date:   Wed,  5 May 2021 12:31:23 -0400
Message-Id: <20210505163125.3460440-115-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163125.3460440-1-sashal@kernel.org>
References: <20210505163125.3460440-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit 9f113bf760ca90d709f8f89a733d10abb1f04a83 ]

Any parallel softlockup reports are skipped when one CPU is already
printing backtraces from all CPUs.

The exclusive rights are synchronized using one bit in
soft_lockup_nmi_warn.  There is also one memory barrier that does not make
much sense.

Use two barriers on the right location to prevent mixing two reports.

[pmladek@suse.com: use bit lock operations to prevent multiple soft-lockup reports]
  Link: https://lkml.kernel.org/r/YFSVsLGVWMXTvlbk@alley

Link: https://lkml.kernel.org/r/20210311122130.6788-6-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Acked-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index b8d4182d14cc..8cf0678378d2 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -410,11 +410,12 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 		if (kvm_check_and_clear_guest_paused())
 			return HRTIMER_RESTART;
 
+		/*
+		 * Prevent multiple soft-lockup reports if one cpu is already
+		 * engaged in dumping all cpu back traces.
+		 */
 		if (softlockup_all_cpu_backtrace) {
-			/* Prevent multiple soft-lockup reports if one cpu is already
-			 * engaged in dumping cpu back traces
-			 */
-			if (test_and_set_bit(0, &soft_lockup_nmi_warn))
+			if (test_and_set_bit_lock(0, &soft_lockup_nmi_warn))
 				return HRTIMER_RESTART;
 		}
 
@@ -432,14 +433,8 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			dump_stack();
 
 		if (softlockup_all_cpu_backtrace) {
-			/* Avoid generating two back traces for current
-			 * given that one is already made above
-			 */
 			trigger_allbutself_cpu_backtrace();
-
-			clear_bit(0, &soft_lockup_nmi_warn);
-			/* Barrier to sync with other cpus */
-			smp_mb__after_atomic();
+			clear_bit_unlock(0, &soft_lockup_nmi_warn);
 		}
 
 		add_taint(TAINT_SOFTLOCKUP, LOCKDEP_STILL_OK);
-- 
2.30.2

