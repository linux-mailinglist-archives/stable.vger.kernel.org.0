Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA4437448C
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 19:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236622AbhEEQ6I (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 12:58:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:44938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235838AbhEEQzl (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 12:55:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4DBBC6145E;
        Wed,  5 May 2021 16:38:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620232731;
        bh=exRUsy11EDsYD0fvsmHuAxt/ZSh/ofMXZtzCPeXxHW4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oRil7Fx5ocx3iynt6yh7vudWtvt28t6yyp8pOdUYqkjBzY0nexqs6swCvTogWNNxQ
         1i0j4BHa2KzFFCelI31KmFAq1BGdgJPe3RoXwJgkOx25c7VC0H+k29EMhcVVhmf2IQ
         nY6FzNJBiNBSZogOatkmS3zUVtSJCzMEiCIqi4HEY//aPZ6/oYP9NbXz7OQGOd8sRV
         Y0ClkXik8QfYQGrCcl0Eq64U8J9YUnBGDlPB3MLopjMzJzR2X5VmvHnvXesQ7e4c2i
         gjG9g8Vj9c+zRgTdYgOlXMoZt+A3OBBJyDKdnnBlfABN8GkiCs7q9G85QPfxLQFuJ1
         MGtgzN063Ss3w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>, Ingo Molnar <mingo@kernel.org>,
        Laurence Oberman <loberman@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Vincent Whitchurch <vincent.whitchurch@axis.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.10 83/85] watchdog: explicitly update timestamp when reporting softlockup
Date:   Wed,  5 May 2021 12:36:46 -0400
Message-Id: <20210505163648.3462507-83-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210505163648.3462507-1-sashal@kernel.org>
References: <20210505163648.3462507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit c9ad17c991492f4390f42598f6ab0531f87eed07 ]

The softlockup situation might stay for a long time or even forever.  When
it happens, the softlockup debug messages are printed in regular intervals
defined by get_softlockup_thresh().

There is a mystery.  The repeated message is printed after the full
interval that is defined by get_softlockup_thresh().  But the timer
callback is called more often as defined by sample_period.  The code looks
like the soflockup should get reported in every sample_period when it was
once behind the thresh.

It works only by chance.  The watchdog is touched when printing the stall
report, for example, in printk_stack_address().

Make the behavior clear and predictable by explicitly updating the
timestamp in watchdog_timer_fn() when the report gets printed.

Link: https://lkml.kernel.org/r/20210311122130.6788-3-pmladek@suse.com
Signed-off-by: Petr Mladek <pmladek@suse.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Laurence Oberman <loberman@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Vincent Whitchurch <vincent.whitchurch@axis.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watchdog.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/watchdog.c b/kernel/watchdog.c
index c58244064de8..7776d53a015c 100644
--- a/kernel/watchdog.c
+++ b/kernel/watchdog.c
@@ -409,6 +409,9 @@ static enum hrtimer_restart watchdog_timer_fn(struct hrtimer *hrtimer)
 			}
 		}
 
+		/* Start period for the next softlockup warning. */
+		update_touch_ts();
+
 		pr_emerg("BUG: soft lockup - CPU#%d stuck for %us! [%s:%d]\n",
 			smp_processor_id(), duration,
 			current->comm, task_pid_nr(current));
-- 
2.30.2

