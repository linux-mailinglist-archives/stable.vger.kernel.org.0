Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E380165D311
	for <lists+stable@lfdr.de>; Wed,  4 Jan 2023 13:51:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229740AbjADMvG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Jan 2023 07:51:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33994 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbjADMvF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 4 Jan 2023 07:51:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE9D3E0C7
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 04:51:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7DDDC615B1
        for <stable@vger.kernel.org>; Wed,  4 Jan 2023 12:51:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B79DC433EF;
        Wed,  4 Jan 2023 12:51:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672836663;
        bh=PLzVBOpfURW1Vp79tRXIdI3Gra96BuFv0wgmD3WybtQ=;
        h=Subject:To:Cc:From:Date:From;
        b=S7NsDu+kRNWka4nwW5e358IsFYQuhw9GLfW/XYXTNeDtgj8yf76OfHF0TCvh2XSy+
         hkCjvs2TyWrsRYfZVLO4Zd9t/zld5FmxfdI9ESVuyi14Ui0Efcbu1mJpQmbuA8cB18
         g+gWNuXP6kJUMyMevshkHJ9ILAhjZqbMlYDA5qb4=
Subject: FAILED: patch "[PATCH] clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register" failed to apply to 6.0-stable tree
To:     joe.korty@concurrent-rt.com, daniel.lezcano@kernel.org,
        maz@kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Wed, 04 Jan 2023 13:50:52 +0100
Message-ID: <16728366529050@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

45ae272a948a ("clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register math error")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 45ae272a948a03a7d55748bf52d2f47d3b4e1d5a Mon Sep 17 00:00:00 2001
From: Joe Korty <joe.korty@concurrent-rt.com>
Date: Mon, 21 Nov 2022 14:53:43 +0000
Subject: [PATCH] clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register
 math error

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

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index 9c3420a0d19d..e2920da18ea1 100644
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

