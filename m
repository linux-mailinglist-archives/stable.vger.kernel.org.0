Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2D6456C131C
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 14:19:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231802AbjCTNTn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 09:19:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231784AbjCTNTW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 09:19:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B349241D5
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 06:19:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AB26A614C3
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 13:19:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48E26C433EF;
        Mon, 20 Mar 2023 13:18:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679318341;
        bh=fUhDyZHeBOcSwPnfZyfTu4hHOdwBeWOtcvESWQvwi/o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WwqD1Ph4rkX6rrIQGT9vQu5nhRh1dRMi73Vccu6thbWqJOjS2u1ECK7IAJ5FpglDL
         1OeIEjLEJXwK+Gj2P1/o2ZaQw1FH1hmrH7liwQ/+qB5/0z9evf9LrZGJBQThoq+tw/
         KdP3A/hDvxUb1hIdzVMAVmHzodYRrr1VafOQOTAWqNeiSLQ4dMzolhxKJZlUjimiCd
         fosR8QMY2z0i+zhQySQMU+XwkV+84ndniUY8bREARh5toTvDsawbUaGXyRSJ5wY+j7
         ya8p0Yf15IwvL7ACCFHpwWOlX5Jw5IZfHJuAYuPpek1Q+drgH9xvmF0VUHXpeCnB80
         mOdZXHCqtFTag==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-arm-kernel@lists.infradead.org, linux@armlinux.org.uk
Cc:     Ard Biesheuvel <ardb@kernel.org>,
        Frederic Weisbecker <frederic@kernel.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Peter Zijlstra <peterz@infradead.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org
Subject: [PATCH v4 04/12] ARM: entry: Fix iWMMXT TIF flag handling
Date:   Mon, 20 Mar 2023 14:18:37 +0100
Message-Id: <20230320131845.3138015-5-ardb@kernel.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230320131845.3138015-1-ardb@kernel.org>
References: <20230320131845.3138015-1-ardb@kernel.org>
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1993; i=ardb@kernel.org; h=from:subject; bh=fUhDyZHeBOcSwPnfZyfTu4hHOdwBeWOtcvESWQvwi/o=; b=owGbwMvMwCFmkMcZplerG8N4Wi2JIUUiVvN8tNzp6vicP0G/r6z68jNt3w2vCTOk34XF5l2I9 5DysNLoKGVhEONgkBVTZBGY/ffdztMTpWqdZ8nCzGFlAhnCwMUpABMp4mL4H7Ld8NTUzsoFOxI6 qkIm5Cw90xq8vFZa61cyo9DtD5V76xn+KcTrrjMUeM2595d1Yqf4bZv363Z3ebLb7PLnX2Azfe8 dDgA=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The conditional MOVS instruction that appears to have been added to test
for the TIF_USING_IWMMXT thread_info flag only sets the N and Z
condition flags and register R7, none of which are referenced in the
subsequent code. This means that the instruction does nothing, which
means that we might misidentify faulting FPE instructions as iWMMXT
instructions on kernels that were built to support both.

This seems to have been part of the original submission of the code, and
so this has never worked as intended, and nobody ever noticed, and so we
might decide to just leave this as-is. However, with the ongoing move
towards multiplatform kernels, the issue becomes more likely to
manifest, and so it is better to fix it.

So check whether we are dealing with an undef exception regarding
coprocessor index #0 or #1, and if so, load the thread_info flag and
only dispatch it as a iWMMXT trap if the flag is set.

Cc: <stable@vger.kernel.org> # v2.6.9+
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/kernel/entry-armv.S | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index c39303e5c23470e6..c5d2f07994fb0d87 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -606,10 +606,11 @@ call_fpe:
 	strb	r7, [r6, #TI_USED_CP]		@ set appropriate used_cp[]
 #ifdef CONFIG_IWMMXT
 	@ Test if we need to give access to iWMMXt coprocessors
-	ldr	r5, [r10, #TI_FLAGS]
-	rsbs	r7, r8, #(1 << 8)		@ CP 0 or 1 only
-	movscs	r7, r5, lsr #(TIF_USING_IWMMXT + 1)
-	bcs	iwmmxt_task_enable
+	tst	r8, #0xe << 8			@ CP 0 or 1?
+	ldreq	r5, [r10, #TI_FLAGS]		@ if so, load thread_info flags
+	andeq	r5, r5, #1 << TIF_USING_IWMMXT	@ isolate TIF_USING_IWMMXT flag
+	teqeq	r5, #1 << TIF_USING_IWMMXT	@ check whether it is set
+	beq	iwmmxt_task_enable		@ branch if set
 #endif
  ARM(	add	pc, pc, r8, lsr #6	)
  THUMB(	lsr	r8, r8, #6		)
-- 
2.39.2

