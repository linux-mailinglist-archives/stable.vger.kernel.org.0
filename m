Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 47F6C632749
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 16:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231960AbiKUPFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 10:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232000AbiKUPFg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 10:05:36 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E8DD193712;
        Mon, 21 Nov 2022 06:53:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7ECDE6127C;
        Mon, 21 Nov 2022 14:53:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E30F2C433D6;
        Mon, 21 Nov 2022 14:53:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669042428;
        bh=bqrmQUUmbJntk+XLa3gMFFAwGFQOUQ7jGAucwYvcn0Q=;
        h=From:To:Cc:Subject:Date:From;
        b=Sn+FduJliHfaLAfDB65joc7FqvgzxLx1vSALsbL9vvnXoJyEh7Xmi4oLTPCQlCQ4L
         NJbupDzmcB49CJjC3hMit049LrLkrUuRQ9ijbB31LntbbXxJmBOdnS2++/oYke51QY
         JN9nRhyQaRprW067sO0xgiZteQPrBp+wFDq6mDiPK5oh6zkkZ+ZldBUAul5YicFkVp
         +Tiju9B3/JHQ+tzb+ITy0QALtOVTjgfE8qBiHvNCb7uGdMYQj29/z29BJd+3QUpMc4
         aMFA96nQ9VP7vo0G+JRjWJaMzDy4r1GbO0c8T07CEPEPOSPIJUBhp5FzGSGSkVHftO
         t0QJnollYjcqg==
Received: from sofa.misterjones.org ([185.219.108.64] helo=valley-girl.lan)
        by disco-boy.misterjones.org with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.95)
        (envelope-from <maz@kernel.org>)
        id 1ox8B8-007XaS-GN;
        Mon, 21 Nov 2022 14:53:46 +0000
From:   Marc Zyngier <maz@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc:     Thomas Gleixner <tglx@linutronix.de>, daniel.lezcano@linaro.org,
        Joe Korty <joe.korty@concurrent-rt.com>, stable@vger.kernel.org
Subject: [PATCH] clocksource/drivers/arm_arch_timer: Fix XGene-1 TVAL register math error
Date:   Mon, 21 Nov 2022 14:53:43 +0000
Message-Id: <20221121145343.896018-1-maz@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 185.219.108.64
X-SA-Exim-Rcpt-To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, tglx@linutronix.de, daniel.lezcano@linaro.org, joe.korty@concurrent-rt.com, stable@vger.kernel.org
X-SA-Exim-Mail-From: maz@kernel.org
X-SA-Exim-Scanned: No (on disco-boy.misterjones.org); SAEximRunCond expanded to false
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joe Korty <joe.korty@concurrent-rt.com>

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
---

Notes:
    v3: rejigged commit message along the lines of the v2 review.

 drivers/clocksource/arm_arch_timer.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/clocksource/arm_arch_timer.c b/drivers/clocksource/arm_arch_timer.c
index a7ff77550e17..41323c2bc0b1 100644
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
-- 
2.34.1

