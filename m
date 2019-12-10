Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15CE9119336
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:08:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727701AbfLJVH6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:07:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:54654 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727542AbfLJVHz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:07:55 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E53920836;
        Tue, 10 Dec 2019 21:07:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012074;
        bh=MlG9exxlQ96joQ8jTOQ8joUO6pD4ZycdLLJfsJLHePs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GmvlZrSfyxaGh5SuMSwE2OLUEwCu/2taQJQXTnsCQv9pHVXaTjEdV96/7ruM/k3NQ
         Wlh8lMPB8sxKA21u9EbUd2TK1KeS2+3Pc7zV6+IW+Xp8+veot3Dmmn9Li8UkNmgICy
         +kYRo+CI9j5Q1gmIlTv3oS4LUVrOzpZyMkEcqAXk=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Arnd Bergmann <arnd@arndb.de>, Borislav Petkov <bp@suse.de>,
        Kees Cook <keescook@chromium.org>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Bill Metzenthen <billm@melbpc.org.au>,
        Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>, x86-ml <x86@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 054/350] x86/math-emu: Check __copy_from_user() result
Date:   Tue, 10 Dec 2019 16:02:39 -0500
Message-Id: <20191210210735.9077-15-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
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
index f98a0c9567646..9b41391867dca 100644
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
index f3779743d15e6..fe6246ff98870 100644
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

