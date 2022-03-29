Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB2FC4EAB9B
	for <lists+stable@lfdr.de>; Tue, 29 Mar 2022 12:47:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234675AbiC2KtI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Mar 2022 06:49:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235382AbiC2KtG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 29 Mar 2022 06:49:06 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40CA82493E1;
        Tue, 29 Mar 2022 03:47:24 -0700 (PDT)
Received: from integral2.. (unknown [182.2.70.161])
        by gnuweeb.org (Postfix) with ESMTPSA id 0076C7E72E;
        Tue, 29 Mar 2022 10:47:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1648550843;
        bh=ZrvJYaZ/dGXaHa3O2COi7cmDKWMxBGfg7zKTtQwreOY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BYMidkgOUanB8Jk52lhdqv8mYzAyg8q4Ijnp/myJPf7Vgw/ziXMUl85zhC2+7+ztn
         JsK3WO/cYNkN4jpG4x37opvzFjmOPLZcQFJUXYhZbGfiiWncLAIM9GRmQWOEMnRgLE
         AYaabsatBt7OPsn3x1D0LNU0G8mT2uOU8kai0gaNCntbCyHksKMfUDvX9rbmOBTfz2
         +FHCFVpEUIHEoXxwp3uhYsJbWLc76IRj5nMo/snsUR2VpYINsHKmovy/3zJwjcadbu
         ISH6A1iT1XDM9DICHKwdYq2Ftj+WJhEXB8NWZcYUxGqf14Nk14g+pmVafuo7OSX72U
         0zD/VGonGv9SA==
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
To:     Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>
Cc:     Ammar Faizi <ammarfaizi2@gnuweeb.org>,
        Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Tony Luck <tony.luck@intel.com>,
        Yazen Ghannam <yazen.ghannam@amd.com>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Stable Kernel <stable@vger.kernel.org>,
        GNU/Weeb Mailing List <gwml@vger.gnuweeb.org>,
        x86 Mailing List <x86@kernel.org>,
        David Laight <David.Laight@ACULAB.COM>,
        Jiri Hladky <hladky.jiri@googlemail.com>
Subject: [PATCH v6 1/2] x86/delay: Fix the wrong asm constraint in `delay_loop()`
Date:   Tue, 29 Mar 2022 17:47:04 +0700
Message-Id: <20220329104705.65256-2-ammarfaizi2@gnuweeb.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
References: <20220329104705.65256-1-ammarfaizi2@gnuweeb.org>
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

The asm constraint does not reflect that the asm statement can modify
the value of @loops. But the asm statement in delay_loop() does modify
the @loops.

Specifiying the wrong constraint may lead to undefined behavior, it may
clobber random stuff (e.g. local variable, important temporary value in
regs, etc.). This is especially dangerous when the compiler decides to
inline the function and since it doesn't know that the value gets
modified, it might decide to use it from a register directly without
reloading it.

Fix this by changing the constraint from "a" (as an input) to "+a" (as
an input and output).

Cc: David Laight <David.Laight@ACULAB.COM>
Cc: Jiri Hladky <hladky.jiri@googlemail.com>
Cc: Alviro Iskandar Setiawan <alviro.iskandar@gnuweeb.org>
Fixes: e01b70ef3eb3 ("x86: fix bug in arch/i386/lib/delay.c file, delay_loop function")
Signed-off-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
---

   v6:
     - Remove unnecessary Cc tags.
     - Update commit message, emphasize the danger when the
       compiler decides to inline the function.
     - Fix the Fixes tag sha1.
     - Remove stable Cc.

---
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
Ammar Faizi

