Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8ED2C4C8875
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 10:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234008AbiCAJr2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Mar 2022 04:47:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234002AbiCAJr1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Mar 2022 04:47:27 -0500
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B5DC8BF31;
        Tue,  1 Mar 2022 01:46:45 -0800 (PST)
Received: from integral2.. (unknown [182.2.70.248])
        by gnuweeb.org (Postfix) with ESMTPSA id 9621F7EDA1;
        Tue,  1 Mar 2022 09:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1646128005;
        bh=WBPkvI6aPFsjLmmXFdKcv2XaHR9dWe3/s/g6sbGKna4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DRpW3A0VFw2Sq92C1uOIr/E11mt1vg2SdIFiQFmGHPuY97NhfuYU/24Qk43MyGXYW
         FquRXuiD6x+aVARdJZSitV02GgthHfiyh/W1WcAjct15pTzw2sL+w3+ggcykXim1aO
         +RJU0olmEEVAGquOKgauUkLBVJ6c+Ui8gGiVog2GLffna6vKqOJ43AiT2QFLnVV6AT
         RUZklZCZPBeG31EKWWQaeykyvOT8/PB7qMhfkBFw8WOKQMuTIQozXX5pmw7Cb965cv
         i8o/HaQX/OeIoyz+SREw5nu1QMdSbTh7e7RB5c6d+X2qwOqUnnH3xyipSKrsthwthk
         CeqJf7S2rMH/A==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>
Cc:     Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Tony Luck <tony.luck@intel.com>, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, gwml@vger.gnuweeb.org,
        x86@kernel.org, stable@vger.kernel.org,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Jiri Hladky <hladky.jiri@googlemail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ammar Faizi <ammarfaizi2@gnuweeb.org>
Subject: [PATCH v4 1/2] x86/delay: Fix the wrong asm constraint in `delay_loop()`
Date:   Tue,  1 Mar 2022 16:46:07 +0700
Message-Id: <20220301094608.118879-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
References: <20220301094608.118879-1-ammarfaizi2@gnuweeb.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ammar Faizi <ammarfaizi2@gnuweeb.org>

The asm constraint does not reflect that the asm statement can modify
the value of @loops. But the asm statement in delay_loop() does change
the @loops.

If by any chance the compiler inlines this function, it may clobber
random stuff (e.g. local variable, important temporary value in reg,
etc.).

Fortunately, delay_loop() is only called indirectly (so it can't
inline), and then the register it clobbers is %rax (which is by the
nature of the calling convention, it's a caller saved register), so it
didn't yield any bug.

^ That shouldn't be an excuse for using the wrong constraint anyway.

This changes "a" (as an input) to "+a" (as an input and output).

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Jiri Hladky <hladky.jiri@googlemail.com>
Fixes: e01b70ef3eb3 ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

Fortunately, the constraint violation that's fixed by patch 1 doesn't
yield any bug due to the nature of System V ABI. Should we backport
this?

 arch/x86/lib/delay.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/lib/delay.c b/arch/x86/lib/delay.c
index 65d15df6212d..0e65d00e2339 100644
--- a/arch/x86/lib/delay.c
+++ b/arch/x86/lib/delay.c
@@ -54,8 +54,8 @@ static void delay_loop(u64 __loops)
 		"	jnz 2b		\n"
 		"3:	dec %0		\n"
 
-		: /* we don't need output */
-		:"a" (loops)
+		: "+a" (loops)
+		:
 	);
 }
 
-- 
2.32.0

