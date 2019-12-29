Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F31D812C644
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:53:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730852AbfL2RpN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:45:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730844AbfL2RpJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:45:09 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8223B207FD;
        Sun, 29 Dec 2019 17:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641509;
        bh=qwBSQ4mPR8y2C+OqTwzQ7Ingo8tM8DD5G2X5Hxi3gfA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GI/DqzphNPPWoBwdi3YBsNdL0tGpnmb8YPAmSs6nUhCOYRTnEkYfJ87coLozde1Zt
         akF2QsfXvE8o1kLA9/kEkyJnbAqpLhmXn576euzIMNtdnW8y25bjEh8j+OVZcYfL19
         Rtfl5QfIsmi4qnEm6CK2lHJiBIfC5fzxN8bt5nx8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bill Metzenthen <billm@melbpc.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 094/434] x86/math-emu: Check __copy_from_user() result
Date:   Sun, 29 Dec 2019 18:22:27 +0100
Message-Id: <20191229172707.810344347@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e6b44ce1925a8329a937c57f0d60ba0d9bb5d226 ]

The new __must_check annotation on __copy_from_user() successfully
identified some code that has lacked the check since at least
linux-2.1.73:

  arch/x86/math-emu/reg_ld_str.c:88:2: error: ignoring return value of \
  function declared with 'warn_unused_result' attribute [-Werror,-Wunused-result]
          __copy_from_user(sti_ptr, s, 10);
          ^~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~
  arch/x86/math-emu/reg_ld_str.c:1129:2: error: ignoring return value of \
  function declared with 'warn_unused_result' attribute [-Werror,-Wunused-result]
          __copy_from_user(register_base + offset, s, other);
          ^~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
  arch/x86/math-emu/reg_ld_str.c:1131:3: error: ignoring return value of \
  function declared with 'warn_unused_result' attribute [-Werror,-Wunused-result]
                  __copy_from_user(register_base, s + other, offset);
                ^~~~~~~~~~~~~~~~ ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

In addition, the get_user()/put_user() helpers do not enforce a return
value check, but actually still require one. These have been missing for
even longer.

Change the internal wrappers around get_user()/put_user() to force
a signal and add a corresponding wrapper around __copy_from_user()
to check all such cases.

 [ bp: Break long lines. ]

Fixes: 257e458057e5 ("Import 2.1.73")
Fixes: 9dd819a15162 ("uaccess: add missing __must_check attributes")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Kees Cook <keescook@chromium.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: Bill Metzenthen <billm@melbpc.org.au>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: x86-ml <x86@kernel.org>
Link: https://lkml.kernel.org/r/20191001142344.1274185-1-arnd@arndb.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/math-emu/fpu_system.h | 6 ++++--
 arch/x86/math-emu/reg_ld_str.c | 6 +++---
 2 files changed, 7 insertions(+), 5 deletions(-)

diff --git a/arch/x86/math-emu/fpu_system.h b/arch/x86/math-emu/fpu_system.h
index f98a0c956764..9b41391867dc 100644
--- a/arch/x86/math-emu/fpu_system.h
+++ b/arch/x86/math-emu/fpu_system.h
@@ -107,6 +107,8 @@ static inline bool seg_writable(struct desc_struct *d)
 #define FPU_access_ok(y,z)	if ( !access_ok(y,z) ) \
 				math_abort(FPU_info,SIGSEGV)
 #define FPU_abort		math_abort(FPU_info, SIGSEGV)
+#define FPU_copy_from_user(to, from, n)	\
+		do { if (copy_from_user(to, from, n)) FPU_abort; } while (0)
 
 #undef FPU_IGNORE_CODE_SEGV
 #ifdef FPU_IGNORE_CODE_SEGV
@@ -122,7 +124,7 @@ static inline bool seg_writable(struct desc_struct *d)
 #define	FPU_code_access_ok(z) FPU_access_ok((void __user *)FPU_EIP,z)
 #endif
 
-#define FPU_get_user(x,y)       get_user((x),(y))
-#define FPU_put_user(x,y)       put_user((x),(y))
+#define FPU_get_user(x,y) do { if (get_user((x),(y))) FPU_abort; } while (0)
+#define FPU_put_user(x,y) do { if (put_user((x),(y))) FPU_abort; } while (0)
 
 #endif
diff --git a/arch/x86/math-emu/reg_ld_str.c b/arch/x86/math-emu/reg_ld_str.c
index f3779743d15e..fe6246ff9887 100644
--- a/arch/x86/math-emu/reg_ld_str.c
+++ b/arch/x86/math-emu/reg_ld_str.c
@@ -85,7 +85,7 @@ int FPU_load_extended(long double __user *s, int stnr)
 
 	RE_ENTRANT_CHECK_OFF;
 	FPU_access_ok(s, 10);
-	__copy_from_user(sti_ptr, s, 10);
+	FPU_copy_from_user(sti_ptr, s, 10);
 	RE_ENTRANT_CHECK_ON;
 
 	return FPU_tagof(sti_ptr);
@@ -1126,9 +1126,9 @@ void frstor(fpu_addr_modes addr_modes, u_char __user *data_address)
 	/* Copy all registers in stack order. */
 	RE_ENTRANT_CHECK_OFF;
 	FPU_access_ok(s, 80);
-	__copy_from_user(register_base + offset, s, other);
+	FPU_copy_from_user(register_base + offset, s, other);
 	if (offset)
-		__copy_from_user(register_base, s + other, offset);
+		FPU_copy_from_user(register_base, s + other, offset);
 	RE_ENTRANT_CHECK_ON;
 
 	for (i = 0; i < 8; i++) {
-- 
2.20.1



