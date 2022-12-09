Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66BD76485D0
	for <lists+stable@lfdr.de>; Fri,  9 Dec 2022 16:47:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230398AbiLIPra (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Dec 2022 10:47:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230210AbiLIPr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 9 Dec 2022 10:47:27 -0500
Received: from galois.linutronix.de (Galois.linutronix.de [193.142.43.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 644E232BB7;
        Fri,  9 Dec 2022 07:47:26 -0800 (PST)
Date:   Fri, 09 Dec 2022 15:47:23 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1670600843;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLXLVl15Agv4rT+zQgqgDQnDqWKoh34bozALYEOSHwU=;
        b=GD0Mvc8RCaOJ8pAq1CIiQFLmEfO1e9r6/VKR7InClof5USWp0O8l75nq3TaisIpAKNq0js
        3kp+9J2xTQXjyctdJWEAs33tAKUrvpcJ04x3SIiO8b7c6U0GjhW4RAPyio561HNuIUG3Fh
        tcL3ciR2y/6GUPJr2fYRyVMWuzFi3CYQnGJ3R6teACm4lnzXwBdDJ9esnpbts5G8tQzUhV
        g6pJ3QuwVaQqfdiE0p4o3uFRhra2TxIlXs1+Z2pjw6cSzU6g5zchJCCPfuZsAiAKwoOCSR
        lTpe+HkDxdoHsludbXtiwDSFMiccV72y5yakKwztqbdS4vKiDp2gXPo41sdVUg==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1670600843;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cLXLVl15Agv4rT+zQgqgDQnDqWKoh34bozALYEOSHwU=;
        b=GMo1rO6Sopwa/BGNUYitqNIgaTzygJvkEhgmrdEQ2eGK1K6dObAM8zULlYP74aoD3GNdVc
        Kbu1r61J99xmXPDQ==
From:   "tip-bot2 for Joe Korty" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: timers/core] clocksource/drivers/arm_arch_timer: Fix XGene-1
 TVAL register math error
Cc:     stable@vger.kernel.org, #@tip-bot2.tec.linutronix.de,
        5.16+@tip-bot2.tec.linutronix.de,
        Joe Korty <joe.korty@concurrent-rt.com>,
        Marc Zyngier <maz@kernel.org>,
        Daniel Lezcano <daniel.lezcano@kernel.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20221024165422.GA51107@zipoli.concurrent-rt.com>
References: <20221024165422.GA51107@zipoli.concurrent-rt.com>
MIME-Version: 1.0
Message-ID: <167060084328.4906.18410377274761206137.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the timers/core branch of tip:

Commit-ID:     45ae272a948a03a7d55748bf52d2f47d3b4e1d5a
Gitweb:        https://git.kernel.org/tip/45ae272a948a03a7d55748bf52d2f47d3b4e1d5a
Author:        Joe Korty <joe.korty@concurrent-rt.com>
AuthorDate:    Mon, 21 Nov 2022 14:53:43 
Committer:     Daniel Lezcano <daniel.lezcano@kernel.org>
CommitterDate: Fri, 02 Dec 2022 12:48:28 +01:00

clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register math error

The TVAL register is 32 bit signed.  Thus only the lower 31 bits are
available to specify when an interrupt is to occur at some time in the
near future.  Attempting to specify a larger interval with TVAL results
in a negative time delta which means the timer fires immediately upon
being programmed, rather than firing at that expected future time.

The solution is for Linux to declare that TVAL is a 31 bit register rather
than give its true size of 32 bits.  This prevents Linux from programming
TVAL with a too-large value.  Note that, prior to 5.16, this little trick
was the standard way to handle TVAL in Linux, so there is nothing new
happening here on that front.

The softlockup detector hides the issue, because it keeps generating
short timer deadlines that are within the scope of the broken timer.

Disable it, and you start using NO_HZ with much longer timer deadlines,
which turns into an interrupt flood:

 11: 1124855130  949168462  758009394   76417474  104782230   30210281
         310890 1734323687     GICv2  29 Level     arch_timer

And "much longer" isn't that long: it takes less than 43s to underflow
TVAL at 50MHz (the frequency of the counter on XGene-1).

Some comments on the v1 version of this patch by Marc Zyngier:

  XGene implements CVAL (a 64bit comparator) in terms of TVAL (a countdown
  register) instead of the other way around. TVAL being a 32bit register,
  the width of the counter should equally be 32.  However, TVAL is a
  *signed* value, and keeps counting down in the negative range once the
  timer fires.

  It means that any TVAL value with bit 31 set will fire immediately,
  as it cannot be distinguished from an already expired timer. Reducing
  the timer range back to a paltry 31 bits papers over the issue.

  Another problem cannot be fixed though, which is that the timer interrupt
  *must* be handled within the negative countdown period, or the interrupt
  will be lost (TVAL will rollover to a positive value, indicative of a
  new timer deadline).

Cc: stable@vger.kernel.org # 5.16+
Fixes: 012f18850452 ("clocksource/drivers/arm_arch_timer: Work around broken CVAL implementations")
Signed-off-by: Joe Korty <joe.korty@concurrent-rt.com>
Reviewed-by: Marc Zyngier <maz@kernel.org>
[maz: revamped the commit message]
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20221024165422.GA51107@zipoli.concurrent-rt.com
Link: https://lore.kernel.org/r/20221121145343.896018-1-maz@kernel.org
Signed-off-by: Daniel Lezcano <daniel.lezcano@kernel.org>
---
 drivers/clocksource/arm_arch_timer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 9c3420a..e2920da 100644
--- a/drivers/clocksource/arm_arch_timer.c
+++ b/drivers/clocksource/arm_arch_timer.c
@@ -806,6 +806,9 @@ static u64 __arch_timer_check_delta(void)
 		/*
 		 * XGene-1 implements CVAL in terms of TVAL, meaning
 		 * that the maximum timer range is 32bit. Shame on them.
+		 *
+		 * Note that TVAL is signed, thus has only 31 of its
+		 * 32 bits to express magnitude.
 		 */
 		MIDR_ALL_VERSIONS(MIDR_CPU_MODEL(ARM_CPU_IMP_APM,
 						 APM_CPU_PART_POTENZA)),
@@ -813,8 +816,8 @@ static u64 __arch_timer_check_delta(void)
 	};
 
 	if (is_midr_in_range_list(read_cpuid_id(), broken_cval_midrs)) {
-		pr_warn_once("Broken CNTx_CVAL_EL1, limiting width to 32bits");
-		return CLOCKSOURCE_MASK(32);
+		pr_warn_once("Broken CNTx_CVAL_EL1, using 32 bit TVAL instead.\n");
+		return CLOCKSOURCE_MASK(31);
 	}
 #endif
 	return CLOCKSOURCE_MASK(arch_counter_get_width());
