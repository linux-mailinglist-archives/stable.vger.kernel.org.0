Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA35046F46C
	for <lists+stable@lfdr.de>; Thu,  9 Dec 2021 20:56:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhLIUAb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Dec 2021 15:00:31 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:41456 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231209AbhLIUAa (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Dec 2021 15:00:30 -0500
Date:   Thu, 09 Dec 2021 19:56:53 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639079815;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmssyvAR2Oe5wtBTqoQ9+F0KcYjYoAoJ54907SQvQGo=;
        b=XgPT8aaVzpUZGp3OpZMg54MOdc1gr0F77j4D8BhbrbFl7gqUPj+rAwl0rJQvNFnBehbpjq
        RLo33oLYIOR1dgnJAavAXhUjlM6bxhfC9xpaJN1s+5f9OLE4ttH2WLYZfJ9VCKYdVKI7TC
        L2kMmbethAeULLu9qwnXIpX7ZBv0H+am7056GSE3BJir3rmCDFx5zU61Dsiy9Et6Ub0CdQ
        dnyFUvBQTWKd/+JpsUcqk+dWr5r9oMIJNYHS9zICaVoXAofnNMpN1Tz7k7i6S0diyzepc1
        wMFkk6qtX8o2YWqAYCJ83nT0xmIUIu8E9ClDum2tmo31h77JUjWyKFbxr7eoNA==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639079815;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=pmssyvAR2Oe5wtBTqoQ9+F0KcYjYoAoJ54907SQvQGo=;
        b=Hd9VpU9pEULJDRUQ+w4nZs7YDoQPnYLCqWGix6E7pU/ciRj1OqC9NH2J2FPwfCsML1tY9s
        uxF3U7d1Z1NBmDBA==
From:   "tip-bot2 for Kees Cook" <tip-bot2@linutronix.de>
Sender: tip-bot2@linutronix.de
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: x86/cleanups] x86/uaccess: Move variable into switch case statement
Cc:     stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <20211209043456.1377875-1-keescook@chromium.org>
References: <20211209043456.1377875-1-keescook@chromium.org>
MIME-Version: 1.0
Message-ID: <163907981387.23020.13292835544312035646.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2@linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the x86/cleanups branch of tip:

Commit-ID:     f529cc537b8e907c25f29eb00f50979e8e532cbc
Gitweb:        https://git.kernel.org/tip/f529cc537b8e907c25f29eb00f50979e8e532cbc
Author:        Kees Cook <keescook@chromium.org>
AuthorDate:    Wed, 08 Dec 2021 20:34:56 -08:00
Committer:     Dave Hansen <dave.hansen@linux.intel.com>
CommitterDate: Thu, 09 Dec 2021 11:48:18 -08:00

x86/uaccess: Move variable into switch case statement

When building with automatic stack variable initialization, GCC 12
complains about variables defined outside of switch case statements.
Move the variable into the case that uses it, which silences the warning:

./arch/x86/include/asm/uaccess.h:317:23: warning: statement will never be executed [-Wswitch-unreachable]
  317 |         unsigned char x_u8__; \
      |                       ^~~~~~

Cc: stable@vger.kernel.org
Fixes: 865c50e1d279 ("x86/uaccess: utilize CONFIG_CC_HAS_ASM_GOTO_OUTPUT")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Link: https://lkml.kernel.org/r/20211209043456.1377875-1-keescook@chromium.org
---
 arch/x86/include/asm/uaccess.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 33a6840..8ab9e79 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -314,11 +314,12 @@ do {									\
 do {									\
 	__chk_user_ptr(ptr);						\
 	switch (size) {							\
-	unsigned char x_u8__;						\
-	case 1:								\
+	case 1:	{							\
+		unsigned char x_u8__;					\
 		__get_user_asm(x_u8__, ptr, "b", "=q", label);		\
 		(x) = x_u8__;						\
 		break;							\
+	}								\
 	case 2:								\
 		__get_user_asm(x, ptr, "w", "=r", label);		\
 		break;							\
