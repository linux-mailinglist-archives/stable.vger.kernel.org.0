Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 477762AB9CC
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731917AbgKINMs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:12:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:38426 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731702AbgKINMo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:12:44 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6288420789;
        Mon,  9 Nov 2020 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927562;
        bh=Ijt2dyziR77eHjXfyZfowT0wt48JJFm+4TmuKig9Gcg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V/mUmrvOht+cw8eVViPpxBrSnWU/fmNcxcpoKfqqHe+EHYUWprAL3BUtrlI4Lb1wj
         tYzkU78ERj/PQdpHDkDgK2EbAaCkXawKZiqstG/TUpWG8omCVvhUbnWwdUxy/ZwVbt
         +oW5oRYYxJ9JvH/x/ziOYAJdwjPedNLFHJ5J7lH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Brown <broonie@kernel.org>,
        Will Deacon <will@kernel.org>, Jian Cai <jiancai@google.com>
Subject: [PATCH 5.4 06/85] arm64: asm: Add new-style position independent function annotations
Date:   Mon,  9 Nov 2020 13:55:03 +0100
Message-Id: <20201109125022.921210756@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125022.614792961@linuxfoundation.org>
References: <20201109125022.614792961@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Brown <broonie@kernel.org>

commit 35e61c77ef386555f3df1bc2057098c6997ca10b upstream.

As part of an effort to make the annotations in assembly code clearer and
more consistent new macros have been introduced, including replacements
for ENTRY() and ENDPROC().

On arm64 we have ENDPIPROC(), a custom version of ENDPROC() which is
used for code that will need to run in position independent environments
like EFI, it creates an alias for the function with the prefix __pi_ and
then emits the standard ENDPROC. Add new-style macros to replace this
which expand to the standard SYM_FUNC_*() and SYM_FUNC_ALIAS_*(),
resulting in the same object code. These are added in linkage.h for
consistency with where the generic assembler code has its macros.

Signed-off-by: Mark Brown <broonie@kernel.org>
[will: Rename 'WEAK' macro, use ';' instead of ASM_NL, deprecate ENDPIPROC]
Signed-off-by: Will Deacon <will@kernel.org>
Cc: Jian Cai <jiancai@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/arm64/include/asm/assembler.h |    1 +
 arch/arm64/include/asm/linkage.h   |   16 ++++++++++++++++
 2 files changed, 17 insertions(+)

--- a/arch/arm64/include/asm/assembler.h
+++ b/arch/arm64/include/asm/assembler.h
@@ -462,6 +462,7 @@ USER(\label, ic	ivau, \tmp2)			// invali
 	.endm
 
 /*
+ * Deprecated! Use SYM_FUNC_{START,START_WEAK,END}_PI instead.
  * Annotate a function as position independent, i.e., safe to be called before
  * the kernel virtual mapping is activated.
  */
--- a/arch/arm64/include/asm/linkage.h
+++ b/arch/arm64/include/asm/linkage.h
@@ -4,4 +4,20 @@
 #define __ALIGN		.align 2
 #define __ALIGN_STR	".align 2"
 
+/*
+ * Annotate a function as position independent, i.e., safe to be called before
+ * the kernel virtual mapping is activated.
+ */
+#define SYM_FUNC_START_PI(x)			\
+		SYM_FUNC_START_ALIAS(__pi_##x);	\
+		SYM_FUNC_START(x)
+
+#define SYM_FUNC_START_WEAK_PI(x)		\
+		SYM_FUNC_START_ALIAS(__pi_##x);	\
+		SYM_FUNC_START_WEAK(x)
+
+#define SYM_FUNC_END_PI(x)			\
+		SYM_FUNC_END(x);		\
+		SYM_FUNC_END_ALIAS(__pi_##x)
+
 #endif


