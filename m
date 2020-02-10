Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D67E215759B
	for <lists+stable@lfdr.de>; Mon, 10 Feb 2020 13:42:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730223AbgBJMmT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 Feb 2020 07:42:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:46392 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730209AbgBJMmT (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 Feb 2020 07:42:19 -0500
Received: from localhost (unknown [209.37.97.194])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B2E5020873;
        Mon, 10 Feb 2020 12:42:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581338537;
        bh=dPGGYG730kGvUiiEz56yXK7yM3zLDXSsz94INHQxq6k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TjqnL9q228B5PinGzbPihFIa+QnDvaJ5L+cEP4YhlKZL9uJkpkdPRC7FAB3aW/a/E
         RUC2CnWUNAe47f9ELf9tQL4D/LSkl9dYZwbDjoHIxPw0lShm7OhLVjAr0k1XsUHklz
         epLhAnGl+qT9Ephw5y0h5iThxA9PxGYtFKIB8eAQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christophe Leroy <christophe.leroy@c-s.fr>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.5 367/367] powerpc/kuap: Fix set direction in allow/prevent_user_access()
Date:   Mon, 10 Feb 2020 04:34:40 -0800
Message-Id: <20200210122456.173888537@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200210122423.695146547@linuxfoundation.org>
References: <20200210122423.695146547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

[ Upstream commit 1d8f739b07bd538f272f60bf53f10e7e6248d295 ]

__builtin_constant_p() always return 0 for pointers, so on RADIX
we always end up opening both direction (by writing 0 in SPR29):

  0000000000000170 <._copy_to_user>:
  ...
   1b0:	4c 00 01 2c 	isync
   1b4:	39 20 00 00 	li      r9,0
   1b8:	7d 3d 03 a6 	mtspr   29,r9
   1bc:	4c 00 01 2c 	isync
   1c0:	48 00 00 01 	bl      1c0 <._copy_to_user+0x50>
  			1c0: R_PPC64_REL24	.__copy_tofrom_user
  ...
  0000000000000220 <._copy_from_user>:
  ...
   2ac:	4c 00 01 2c 	isync
   2b0:	39 20 00 00 	li      r9,0
   2b4:	7d 3d 03 a6 	mtspr   29,r9
   2b8:	4c 00 01 2c 	isync
   2bc:	7f c5 f3 78 	mr      r5,r30
   2c0:	7f 83 e3 78 	mr      r3,r28
   2c4:	48 00 00 01 	bl      2c4 <._copy_from_user+0xa4>
  			2c4: R_PPC64_REL24	.__copy_tofrom_user
  ...

Use an explicit parameter for direction selection, so that GCC
is able to see it is a constant:

  00000000000001b0 <._copy_to_user>:
  ...
   1f0:	4c 00 01 2c 	isync
   1f4:	3d 20 40 00 	lis     r9,16384
   1f8:	79 29 07 c6 	rldicr  r9,r9,32,31
   1fc:	7d 3d 03 a6 	mtspr   29,r9
   200:	4c 00 01 2c 	isync
   204:	48 00 00 01 	bl      204 <._copy_to_user+0x54>
  			204: R_PPC64_REL24	.__copy_tofrom_user
  ...
  0000000000000260 <._copy_from_user>:
  ...
   2ec:	4c 00 01 2c 	isync
   2f0:	39 20 ff ff 	li      r9,-1
   2f4:	79 29 00 04 	rldicr  r9,r9,0,0
   2f8:	7d 3d 03 a6 	mtspr   29,r9
   2fc:	4c 00 01 2c 	isync
   300:	7f c5 f3 78 	mr      r5,r30
   304:	7f 83 e3 78 	mr      r3,r28
   308:	48 00 00 01 	bl      308 <._copy_from_user+0xa8>
  			308: R_PPC64_REL24	.__copy_tofrom_user
  ...

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
[mpe: Spell out the directions, s/KUAP_R/KUAP_READ/ etc.]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/f4e88ec4941d5facb35ce75026b0112f980086c3.1579866752.git.christophe.leroy@c-s.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/32/kup.h      | 13 ++++++--
 .../powerpc/include/asm/book3s/64/kup-radix.h | 11 +++----
 arch/powerpc/include/asm/kup.h                | 30 ++++++++++++++-----
 arch/powerpc/include/asm/nohash/32/kup-8xx.h  |  4 +--
 arch/powerpc/include/asm/uaccess.h            |  4 +--
 5 files changed, 43 insertions(+), 19 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/32/kup.h b/arch/powerpc/include/asm/book3s/32/kup.h
index d88008c8eb852..91c8f1d9bceef 100644
--- a/arch/powerpc/include/asm/book3s/32/kup.h
+++ b/arch/powerpc/include/asm/book3s/32/kup.h
@@ -102,11 +102,13 @@ static inline void kuap_update_sr(u32 sr, u32 addr, u32 end)
 	isync();	/* Context sync required after mtsrin() */
 }
 
-static inline void allow_user_access(void __user *to, const void __user *from, u32 size)
+static __always_inline void allow_user_access(void __user *to, const void __user *from,
+					      u32 size, unsigned long dir)
 {
 	u32 addr, end;
 
-	if (__builtin_constant_p(to) && to == NULL)
+	BUILD_BUG_ON(!__builtin_constant_p(dir));
+	if (!(dir & KUAP_WRITE))
 		return;
 
 	addr = (__force u32)to;
@@ -119,11 +121,16 @@ static inline void allow_user_access(void __user *to, const void __user *from, u
 	kuap_update_sr(mfsrin(addr) & ~SR_KS, addr, end);	/* Clear Ks */
 }
 
-static inline void prevent_user_access(void __user *to, const void __user *from, u32 size)
+static __always_inline void prevent_user_access(void __user *to, const void __user *from,
+						u32 size, unsigned long dir)
 {
 	u32 addr = (__force u32)to;
 	u32 end = min(addr + size, TASK_SIZE);
 
+	BUILD_BUG_ON(!__builtin_constant_p(dir));
+	if (!(dir & KUAP_WRITE))
+		return;
+
 	if (!addr || addr >= TASK_SIZE || !size)
 		return;
 
diff --git a/arch/powerpc/include/asm/book3s/64/kup-radix.h b/arch/powerpc/include/asm/book3s/64/kup-radix.h
index dbbd22cb80f5a..c8d1076e0ebbf 100644
--- a/arch/powerpc/include/asm/book3s/64/kup-radix.h
+++ b/arch/powerpc/include/asm/book3s/64/kup-radix.h
@@ -77,20 +77,21 @@ static inline void set_kuap(unsigned long value)
 	isync();
 }
 
-static inline void allow_user_access(void __user *to, const void __user *from,
-				     unsigned long size)
+static __always_inline void allow_user_access(void __user *to, const void __user *from,
+					      unsigned long size, unsigned long dir)
 {
 	// This is written so we can resolve to a single case at build time
-	if (__builtin_constant_p(to) && to == NULL)
+	BUILD_BUG_ON(!__builtin_constant_p(dir));
+	if (dir == KUAP_READ)
 		set_kuap(AMR_KUAP_BLOCK_WRITE);
-	else if (__builtin_constant_p(from) && from == NULL)
+	else if (dir == KUAP_WRITE)
 		set_kuap(AMR_KUAP_BLOCK_READ);
 	else
 		set_kuap(0);
 }
 
 static inline void prevent_user_access(void __user *to, const void __user *from,
-				       unsigned long size)
+				       unsigned long size, unsigned long dir)
 {
 	set_kuap(AMR_KUAP_BLOCKED);
 }
diff --git a/arch/powerpc/include/asm/kup.h b/arch/powerpc/include/asm/kup.h
index 812e66f31934f..94f24928916a8 100644
--- a/arch/powerpc/include/asm/kup.h
+++ b/arch/powerpc/include/asm/kup.h
@@ -2,6 +2,10 @@
 #ifndef _ASM_POWERPC_KUP_H_
 #define _ASM_POWERPC_KUP_H_
 
+#define KUAP_READ	1
+#define KUAP_WRITE	2
+#define KUAP_READ_WRITE	(KUAP_READ | KUAP_WRITE)
+
 #ifdef CONFIG_PPC64
 #include <asm/book3s/64/kup-radix.h>
 #endif
@@ -42,9 +46,9 @@ void setup_kuap(bool disabled);
 #else
 static inline void setup_kuap(bool disabled) { }
 static inline void allow_user_access(void __user *to, const void __user *from,
-				     unsigned long size) { }
+				     unsigned long size, unsigned long dir) { }
 static inline void prevent_user_access(void __user *to, const void __user *from,
-				       unsigned long size) { }
+				       unsigned long size, unsigned long dir) { }
 static inline bool
 bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
 {
@@ -54,24 +58,36 @@ bad_kuap_fault(struct pt_regs *regs, unsigned long address, bool is_write)
 
 static inline void allow_read_from_user(const void __user *from, unsigned long size)
 {
-	allow_user_access(NULL, from, size);
+	allow_user_access(NULL, from, size, KUAP_READ);
 }
 
 static inline void allow_write_to_user(void __user *to, unsigned long size)
 {
-	allow_user_access(to, NULL, size);
+	allow_user_access(to, NULL, size, KUAP_WRITE);
+}
+
+static inline void allow_read_write_user(void __user *to, const void __user *from,
+					 unsigned long size)
+{
+	allow_user_access(to, from, size, KUAP_READ_WRITE);
 }
 
 static inline void prevent_read_from_user(const void __user *from, unsigned long size)
 {
-	prevent_user_access(NULL, from, size);
+	prevent_user_access(NULL, from, size, KUAP_READ);
 }
 
 static inline void prevent_write_to_user(void __user *to, unsigned long size)
 {
-	prevent_user_access(to, NULL, size);
+	prevent_user_access(to, NULL, size, KUAP_WRITE);
+}
+
+static inline void prevent_read_write_user(void __user *to, const void __user *from,
+					   unsigned long size)
+{
+	prevent_user_access(to, from, size, KUAP_READ_WRITE);
 }
 
 #endif /* !__ASSEMBLY__ */
 
-#endif /* _ASM_POWERPC_KUP_H_ */
+#endif /* _ASM_POWERPC_KUAP_H_ */
diff --git a/arch/powerpc/include/asm/nohash/32/kup-8xx.h b/arch/powerpc/include/asm/nohash/32/kup-8xx.h
index f2fea603b929a..1d70c80366fd3 100644
--- a/arch/powerpc/include/asm/nohash/32/kup-8xx.h
+++ b/arch/powerpc/include/asm/nohash/32/kup-8xx.h
@@ -35,13 +35,13 @@
 #include <asm/reg.h>
 
 static inline void allow_user_access(void __user *to, const void __user *from,
-				     unsigned long size)
+				     unsigned long size, unsigned long dir)
 {
 	mtspr(SPRN_MD_AP, MD_APG_INIT);
 }
 
 static inline void prevent_user_access(void __user *to, const void __user *from,
-				       unsigned long size)
+				       unsigned long size, unsigned long dir)
 {
 	mtspr(SPRN_MD_AP, MD_APG_KUAP);
 }
diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index c92fe7fe9692c..cafad1960e766 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -313,9 +313,9 @@ raw_copy_in_user(void __user *to, const void __user *from, unsigned long n)
 	unsigned long ret;
 
 	barrier_nospec();
-	allow_user_access(to, from, n);
+	allow_read_write_user(to, from, n);
 	ret = __copy_tofrom_user(to, from, n);
-	prevent_user_access(to, from, n);
+	prevent_read_write_user(to, from, n);
 	return ret;
 }
 #endif /* __powerpc64__ */
-- 
2.20.1



