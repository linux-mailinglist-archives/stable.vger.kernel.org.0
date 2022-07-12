Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6BDFC572340
	for <lists+stable@lfdr.de>; Tue, 12 Jul 2022 20:47:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234108AbiGLSpQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Jul 2022 14:45:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiGLSoq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Jul 2022 14:44:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F300FDA0E5;
        Tue, 12 Jul 2022 11:42:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1C2ECB81BAB;
        Tue, 12 Jul 2022 18:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 455C5C3411C;
        Tue, 12 Jul 2022 18:42:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657651333;
        bh=2RZAygbDaVQjxYKpwYLxrZgZ1eBMkhJLQtxtddsgiTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=c2lKg74TX9Z13naACZZZw+/tv6mBriaOIJYbxE4Oon36JYdis62crEcuBIp8d80/P
         aSuWu9QAVC9rQy3C1kX7wiRh9sUIpY+EU8F+8AOtQCvDFX5ot1Q4KHfwWEubP8kVvS
         UXfcBC3kn5pNrAzm9uK5Sb5B3/ne298bycr4cjcw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Juergen Gross <jgross@suse.com>,
        Borislav Petkov <bp@suse.de>,
        Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 5.10 014/130] x86/alternative: Use ALTERNATIVE_TERNARY() in _static_cpu_has()
Date:   Tue, 12 Jul 2022 20:37:40 +0200
Message-Id: <20220712183247.060887637@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220712183246.394947160@linuxfoundation.org>
References: <20220712183246.394947160@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Juergen Gross <jgross@suse.com>

commit 2fe2a2c7a97c9bc32acc79154b75e754280f7867 upstream.

_static_cpu_has() contains a completely open coded version of
ALTERNATIVE_TERNARY(). Replace that with the macro instead.

Signed-off-by: Juergen Gross <jgross@suse.com>
Signed-off-by: Borislav Petkov <bp@suse.de>
Link: https://lkml.kernel.org/r/20210311142319.4723-8-jgross@suse.com
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/cpufeature.h |   41 ++++++++------------------------------
 1 file changed, 9 insertions(+), 32 deletions(-)

--- a/arch/x86/include/asm/cpufeature.h
+++ b/arch/x86/include/asm/cpufeature.h
@@ -8,6 +8,7 @@
 
 #include <asm/asm.h>
 #include <linux/bitops.h>
+#include <asm/alternative.h>
 
 enum cpuid_leafs
 {
@@ -172,39 +173,15 @@ extern void clear_cpu_cap(struct cpuinfo
  */
 static __always_inline bool _static_cpu_has(u16 bit)
 {
-	asm_volatile_goto("1: jmp 6f\n"
-		 "2:\n"
-		 ".skip -(((5f-4f) - (2b-1b)) > 0) * "
-			 "((5f-4f) - (2b-1b)),0x90\n"
-		 "3:\n"
-		 ".section .altinstructions,\"a\"\n"
-		 " .long 1b - .\n"		/* src offset */
-		 " .long 4f - .\n"		/* repl offset */
-		 " .word %P[always]\n"		/* always replace */
-		 " .byte 3b - 1b\n"		/* src len */
-		 " .byte 5f - 4f\n"		/* repl len */
-		 " .byte 3b - 2b\n"		/* pad len */
-		 ".previous\n"
-		 ".section .altinstr_replacement,\"ax\"\n"
-		 "4: jmp %l[t_no]\n"
-		 "5:\n"
-		 ".previous\n"
-		 ".section .altinstructions,\"a\"\n"
-		 " .long 1b - .\n"		/* src offset */
-		 " .long 0\n"			/* no replacement */
-		 " .word %P[feature]\n"		/* feature bit */
-		 " .byte 3b - 1b\n"		/* src len */
-		 " .byte 0\n"			/* repl len */
-		 " .byte 0\n"			/* pad len */
-		 ".previous\n"
-		 ".section .altinstr_aux,\"ax\"\n"
-		 "6:\n"
-		 " testb %[bitnum],%[cap_byte]\n"
-		 " jnz %l[t_yes]\n"
-		 " jmp %l[t_no]\n"
-		 ".previous\n"
+	asm_volatile_goto(
+		ALTERNATIVE_TERNARY("jmp 6f", %P[feature], "", "jmp %l[t_no]")
+		".section .altinstr_aux,\"ax\"\n"
+		"6:\n"
+		" testb %[bitnum],%[cap_byte]\n"
+		" jnz %l[t_yes]\n"
+		" jmp %l[t_no]\n"
+		".previous\n"
 		 : : [feature]  "i" (bit),
-		     [always]   "i" (X86_FEATURE_ALWAYS),
 		     [bitnum]   "i" (1 << (bit & 7)),
 		     [cap_byte] "m" (((const char *)boot_cpu_data.x86_capability)[bit >> 3])
 		 : : t_yes, t_no);


