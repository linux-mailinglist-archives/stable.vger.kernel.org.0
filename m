Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 648772B9EF0
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 00:59:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727451AbgKSX6G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Nov 2020 18:58:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727444AbgKSX6G (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 19 Nov 2020 18:58:06 -0500
Received: from mail-pl1-x643.google.com (mail-pl1-x643.google.com [IPv6:2607:f8b0:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AF36C0613CF
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:06 -0800 (PST)
Received: by mail-pl1-x643.google.com with SMTP id 5so3875348plj.8
        for <stable@vger.kernel.org>; Thu, 19 Nov 2020 15:58:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=axtens.net; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=GHHMyfABjsK2ExGWAwHqBzxTHV66BKa6BIigIAHptvc=;
        b=nfQzNm6OnEiF7dcX19+1FLyF66BpoYEs4Xrn0iSrAjerxmWfvp8B1Y9tn5I53DYz6h
         WYd8NnGLaimvSR1rKf76SrRhLc6M4oqimBYgcfO3idgKjBkq/WXjO7ZnnP8rU0ErNq6X
         1HKHPYYZ0JSGDFb+JOWvoW0G4EcRdHmiTSy4k=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=GHHMyfABjsK2ExGWAwHqBzxTHV66BKa6BIigIAHptvc=;
        b=Ub9JbUv9QD8Brlg+CQVqAzcYPOCEw9oeBfgngI+4uC5Oo4zzzhaR3SvAxygYviSPnG
         vj3mhvljrCoMJ3uKSyZTfk/yXVkDzPcIBeC7o+/WZLxSLSl47ahM1etTo/YUfdKPlNaP
         I9jxMBXPpzpvkUG+aIgY9NRn8e5cDuundvRFV+81mHd6ptfKQUoYROhuF6TLESRp72GD
         Ag35zPCJmhVPFtzf/phZOhGfZFPKNeS8AAbcWgNBrv2rsTgB6LzfjeCkZvpnrTFzhJuI
         06sGq58YkUFiTolnG81+EHvwZaoDAbnzhaibVbTv2Vd3l46RtcZD8g5rM83Hx6316Kct
         Nkcw==
X-Gm-Message-State: AOAM53065D0aaggxxg+pwmlDkpSywYB2Wk4ZYU4c3IhNwDvyAenAbxvY
        iy+YLxl8zOVs1ifL57z5DNjG5mA73Y4ugw==
X-Google-Smtp-Source: ABdhPJxRPeG82GFFinWThYMcqYPlcVQp/2mwF163N7H43GCSAR/eHAaoQXLZw6LdnovHXitpOiU93w==
X-Received: by 2002:a17:902:aa85:b029:d9:e383:6851 with SMTP id d5-20020a170902aa85b02900d9e3836851mr2686173plr.35.1605830285329;
        Thu, 19 Nov 2020 15:58:05 -0800 (PST)
Received: from localhost (2001-44b8-1113-6700-4d44-522c-3789-8f33.static.ipv6.internode.on.net. [2001:44b8:1113:6700:4d44:522c:3789:8f33])
        by smtp.gmail.com with ESMTPSA id m18sm1160215pff.144.2020.11.19.15.58.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 19 Nov 2020 15:58:04 -0800 (PST)
From:   Daniel Axtens <dja@axtens.net>
To:     stable@vger.kernel.org
Cc:     dja@axtens.net
Subject: [PATCH 4.9 5/8] powerpc: Implement user_access_begin and friends
Date:   Fri, 20 Nov 2020 10:57:40 +1100
Message-Id: <20201119235743.373635-6-dja@axtens.net>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201119235743.373635-1-dja@axtens.net>
References: <20201119235743.373635-1-dja@axtens.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@c-s.fr>

commit 5cd623333e7cf4e3a334c70529268b65f2a6c2c7 upstream.

Today, when a function like strncpy_from_user() is called,
the userspace access protection is de-activated and re-activated
for every word read.

By implementing user_access_begin and friends, the protection
is de-activated at the beginning of the copy and re-activated at the
end.

Implement user_access_begin(), user_access_end() and
unsafe_get_user(), unsafe_put_user() and unsafe_copy_to_user()

For the time being, we keep user_access_save() and
user_access_restore() as nops.

Signed-off-by: Christophe Leroy <christophe.leroy@c-s.fr>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/36d4fbf9e56a75994aca4ee2214c77b26a5a8d35.1579866752.git.christophe.leroy@c-s.fr
Signed-off-by: Daniel Axtens <dja@axtens.net>
---
 arch/powerpc/include/asm/uaccess.h | 60 +++++++++++++++++++++++-------
 1 file changed, 46 insertions(+), 14 deletions(-)

diff --git a/arch/powerpc/include/asm/uaccess.h b/arch/powerpc/include/asm/uaccess.h
index 9521028eebfa..a395e440c320 100644
--- a/arch/powerpc/include/asm/uaccess.h
+++ b/arch/powerpc/include/asm/uaccess.h
@@ -106,9 +106,14 @@ struct exception_table_entry {
 	__put_user_check((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
 
 #define __get_user(x, ptr) \
-	__get_user_nocheck((x), (ptr), sizeof(*(ptr)))
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)), true)
 #define __put_user(x, ptr) \
-	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)))
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)), true)
+
+#define __get_user_allowed(x, ptr) \
+	__get_user_nocheck((x), (ptr), sizeof(*(ptr)), false)
+#define __put_user_allowed(x, ptr) \
+	__put_user_nocheck((__typeof__(*(ptr)))(x), (ptr), sizeof(*(ptr)), false)
 
 #define __get_user_inatomic(x, ptr) \
 	__get_user_nosleep((x), (ptr), sizeof(*(ptr)))
@@ -162,10 +167,9 @@ extern long __put_user_bad(void);
 		: "r" (x), "b" (addr), "i" (-EFAULT), "0" (err))
 #endif /* __powerpc64__ */
 
-#define __put_user_size(x, ptr, size, retval)			\
+#define __put_user_size_allowed(x, ptr, size, retval)		\
 do {								\
 	retval = 0;						\
-	allow_write_to_user(ptr, size);				\
 	switch (size) {						\
 	  case 1: __put_user_asm(x, ptr, retval, "stb"); break;	\
 	  case 2: __put_user_asm(x, ptr, retval, "sth"); break;	\
@@ -173,17 +177,26 @@ do {								\
 	  case 8: __put_user_asm2(x, ptr, retval); break;	\
 	  default: __put_user_bad();				\
 	}							\
+} while (0)
+
+#define __put_user_size(x, ptr, size, retval)			\
+do {								\
+	allow_write_to_user(ptr, size);				\
+	__put_user_size_allowed(x, ptr, size, retval);		\
 	prevent_write_to_user(ptr, size);			\
 } while (0)
 
-#define __put_user_nocheck(x, ptr, size)			\
+#define __put_user_nocheck(x, ptr, size, do_allow)			\
 ({								\
 	long __pu_err;						\
 	__typeof__(*(ptr)) __user *__pu_addr = (ptr);		\
 	if (!is_kernel_addr((unsigned long)__pu_addr))		\
 		might_fault();					\
 	__chk_user_ptr(ptr);					\
-	__put_user_size((x), __pu_addr, (size), __pu_err);	\
+	if (do_allow)								\
+		__put_user_size((x), __pu_addr, (size), __pu_err);		\
+	else									\
+		__put_user_size_allowed((x), __pu_addr, (size), __pu_err);	\
 	__pu_err;						\
 })
 
@@ -249,13 +262,12 @@ extern long __get_user_bad(void);
 		: "b" (addr), "i" (-EFAULT), "0" (err))
 #endif /* __powerpc64__ */
 
-#define __get_user_size(x, ptr, size, retval)			\
+#define __get_user_size_allowed(x, ptr, size, retval)		\
 do {								\
 	retval = 0;						\
 	__chk_user_ptr(ptr);					\
 	if (size > sizeof(x))					\
 		(x) = __get_user_bad();				\
-	allow_read_from_user(ptr, size);			\
 	switch (size) {						\
 	case 1: __get_user_asm(x, ptr, retval, "lbz"); break;	\
 	case 2: __get_user_asm(x, ptr, retval, "lhz"); break;	\
@@ -263,10 +275,16 @@ do {								\
 	case 8: __get_user_asm2(x, ptr, retval);  break;	\
 	default: (x) = __get_user_bad();			\
 	}							\
+} while (0)
+
+#define __get_user_size(x, ptr, size, retval)			\
+do {								\
+	allow_read_from_user(ptr, size);			\
+	__get_user_size_allowed(x, ptr, size, retval);		\
 	prevent_read_from_user(ptr, size);			\
 } while (0)
 
-#define __get_user_nocheck(x, ptr, size)			\
+#define __get_user_nocheck(x, ptr, size, do_allow)			\
 ({								\
 	long __gu_err;						\
 	unsigned long __gu_val;					\
@@ -275,7 +293,10 @@ do {								\
 	if (!is_kernel_addr((unsigned long)__gu_addr))		\
 		might_fault();					\
 	barrier_nospec();					\
-	__get_user_size(__gu_val, __gu_addr, (size), __gu_err);	\
+	if (do_allow)								\
+		__get_user_size(__gu_val, __gu_addr, (size), __gu_err);		\
+	else									\
+		__get_user_size_allowed(__gu_val, __gu_addr, (size), __gu_err);	\
 	(x) = (__typeof__(*(ptr)))__gu_val;			\
 	__gu_err;						\
 })
@@ -396,21 +417,22 @@ static inline unsigned long __copy_to_user_inatomic(void __user *to,
 		const void *from, unsigned long n)
 {
 	unsigned long ret;
+
 	if (__builtin_constant_p(n) && (n <= 8)) {
 		ret = 1;
 
 		switch (n) {
 		case 1:
-			__put_user_size(*(u8 *)from, (u8 __user *)to, 1, ret);
+			__put_user_size_allowed(*(u8 *)from, (u8 __user *)to, 1, ret);
 			break;
 		case 2:
-			__put_user_size(*(u16 *)from, (u16 __user *)to, 2, ret);
+			__put_user_size_allowed(*(u16 *)from, (u16 __user *)to, 2, ret);
 			break;
 		case 4:
-			__put_user_size(*(u32 *)from, (u32 __user *)to, 4, ret);
+			__put_user_size_allowed(*(u32 *)from, (u32 __user *)to, 4, ret);
 			break;
 		case 8:
-			__put_user_size(*(u64 *)from, (u64 __user *)to, 8, ret);
+			__put_user_size_allowed(*(u64 *)from, (u64 __user *)to, 8, ret);
 			break;
 		}
 		if (ret == 0)
@@ -456,6 +478,16 @@ extern long strncpy_from_user(char *dst, const char __user *src, long count);
 extern __must_check long strlen_user(const char __user *str);
 extern __must_check long strnlen_user(const char __user *str, long n);
 
+
+#define user_access_begin()	do { } while (0)
+#define user_access_end()	prevent_user_access(NULL, NULL, ~0ul)
+
+#define unsafe_op_wrap(op, err) do { if (unlikely(op)) goto err; } while (0)
+#define unsafe_get_user(x, p, e) unsafe_op_wrap(__get_user_allowed(x, p), e)
+#define unsafe_put_user(x, p, e) unsafe_op_wrap(__put_user_allowed(x, p), e)
+#define unsafe_copy_to_user(d, s, l, e) \
+	unsafe_op_wrap(__copy_to_user_inatomic(d, s, l), e)
+
 #endif  /* __ASSEMBLY__ */
 #endif /* __KERNEL__ */
 
-- 
2.25.1

