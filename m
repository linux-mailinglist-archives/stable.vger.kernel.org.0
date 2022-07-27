Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89E92582C45
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:44:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239572AbiG0Qoq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240121AbiG0QoI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:44:08 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9239A51A24;
        Wed, 27 Jul 2022 09:30:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70C56B821C5;
        Wed, 27 Jul 2022 16:30:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCB8FC433D6;
        Wed, 27 Jul 2022 16:30:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939435;
        bh=AJqytMV64rUASa1fC+FJDWlVKl+qrP5oT4VUCR05xaY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RPyvm3ySCXJqroclLKKHCyK4KsAcDeryglq7EthZiQhTG03kheqU6PTdf3xBKtGc2
         D1WkrRUiKfAh8gT3w6IZZgr1iZMP+MuUgQysH2DNGe3/U9WAeVQkW38WyxuP/a7SJb
         0HIDhrYM3LZb/jEpCeypaeBvu8dWaOgaMi40VFOQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Al Viro <viro@zeniv.linux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 68/87] x86: get rid of small constant size cases in raw_copy_{to,from}_user()
Date:   Wed, 27 Jul 2022 18:11:01 +0200
Message-Id: <20220727161011.803180178@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161008.993711844@linuxfoundation.org>
References: <20220727161008.993711844@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Al Viro <viro@zeniv.linux.org.uk>

[ Upstream commit 4b842e4e25b12951fa10dedb4bc16bc47e3b850c ]

Very few call sites where that would be triggered remain, and none
of those is anywhere near hot enough to bother.

Signed-off-by: Al Viro <viro@zeniv.linux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/uaccess.h    |  12 ----
 arch/x86/include/asm/uaccess_32.h |  27 --------
 arch/x86/include/asm/uaccess_64.h | 108 +-----------------------------
 3 files changed, 2 insertions(+), 145 deletions(-)

diff --git a/arch/x86/include/asm/uaccess.h b/arch/x86/include/asm/uaccess.h
index 61d93f062a36..a19effb98fdc 100644
--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -378,18 +378,6 @@ do {									\
 		     : "=r" (err), ltype(x)				\
 		     : "m" (__m(addr)), "i" (errret), "0" (err))
 
-#define __get_user_asm_nozero(x, addr, err, itype, rtype, ltype, errret)	\
-	asm volatile("\n"						\
-		     "1:	mov"itype" %2,%"rtype"1\n"		\
-		     "2:\n"						\
-		     ".section .fixup,\"ax\"\n"				\
-		     "3:	mov %3,%0\n"				\
-		     "	jmp 2b\n"					\
-		     ".previous\n"					\
-		     _ASM_EXTABLE_UA(1b, 3b)				\
-		     : "=r" (err), ltype(x)				\
-		     : "m" (__m(addr)), "i" (errret), "0" (err))
-
 /*
  * This doesn't do __uaccess_begin/end - the exception handling
  * around it must do that.
diff --git a/arch/x86/include/asm/uaccess_32.h b/arch/x86/include/asm/uaccess_32.h
index ba2dc1930630..388a40660c7b 100644
--- a/arch/x86/include/asm/uaccess_32.h
+++ b/arch/x86/include/asm/uaccess_32.h
@@ -23,33 +23,6 @@ raw_copy_to_user(void __user *to, const void *from, unsigned long n)
 static __always_inline unsigned long
 raw_copy_from_user(void *to, const void __user *from, unsigned long n)
 {
-	if (__builtin_constant_p(n)) {
-		unsigned long ret;
-
-		switch (n) {
-		case 1:
-			ret = 0;
-			__uaccess_begin_nospec();
-			__get_user_asm_nozero(*(u8 *)to, from, ret,
-					      "b", "b", "=q", 1);
-			__uaccess_end();
-			return ret;
-		case 2:
-			ret = 0;
-			__uaccess_begin_nospec();
-			__get_user_asm_nozero(*(u16 *)to, from, ret,
-					      "w", "w", "=r", 2);
-			__uaccess_end();
-			return ret;
-		case 4:
-			ret = 0;
-			__uaccess_begin_nospec();
-			__get_user_asm_nozero(*(u32 *)to, from, ret,
-					      "l", "k", "=r", 4);
-			__uaccess_end();
-			return ret;
-		}
-	}
 	return __copy_user_ll(to, (__force const void *)from, n);
 }
 
diff --git a/arch/x86/include/asm/uaccess_64.h b/arch/x86/include/asm/uaccess_64.h
index 5cd1caa8bc65..bc10e3dc64fe 100644
--- a/arch/x86/include/asm/uaccess_64.h
+++ b/arch/x86/include/asm/uaccess_64.h
@@ -65,117 +65,13 @@ copy_to_user_mcsafe(void *to, const void *from, unsigned len)
 static __always_inline __must_check unsigned long
 raw_copy_from_user(void *dst, const void __user *src, unsigned long size)
 {
-	int ret = 0;
-
-	if (!__builtin_constant_p(size))
-		return copy_user_generic(dst, (__force void *)src, size);
-	switch (size) {
-	case 1:
-		__uaccess_begin_nospec();
-		__get_user_asm_nozero(*(u8 *)dst, (u8 __user *)src,
-			      ret, "b", "b", "=q", 1);
-		__uaccess_end();
-		return ret;
-	case 2:
-		__uaccess_begin_nospec();
-		__get_user_asm_nozero(*(u16 *)dst, (u16 __user *)src,
-			      ret, "w", "w", "=r", 2);
-		__uaccess_end();
-		return ret;
-	case 4:
-		__uaccess_begin_nospec();
-		__get_user_asm_nozero(*(u32 *)dst, (u32 __user *)src,
-			      ret, "l", "k", "=r", 4);
-		__uaccess_end();
-		return ret;
-	case 8:
-		__uaccess_begin_nospec();
-		__get_user_asm_nozero(*(u64 *)dst, (u64 __user *)src,
-			      ret, "q", "", "=r", 8);
-		__uaccess_end();
-		return ret;
-	case 10:
-		__uaccess_begin_nospec();
-		__get_user_asm_nozero(*(u64 *)dst, (u64 __user *)src,
-			       ret, "q", "", "=r", 10);
-		if (likely(!ret))
-			__get_user_asm_nozero(*(u16 *)(8 + (char *)dst),
-				       (u16 __user *)(8 + (char __user *)src),
-				       ret, "w", "w", "=r", 2);
-		__uaccess_end();
-		return ret;
-	case 16:
-		__uaccess_begin_nospec();
-		__get_user_asm_nozero(*(u64 *)dst, (u64 __user *)src,
-			       ret, "q", "", "=r", 16);
-		if (likely(!ret))
-			__get_user_asm_nozero(*(u64 *)(8 + (char *)dst),
-				       (u64 __user *)(8 + (char __user *)src),
-				       ret, "q", "", "=r", 8);
-		__uaccess_end();
-		return ret;
-	default:
-		return copy_user_generic(dst, (__force void *)src, size);
-	}
+	return copy_user_generic(dst, (__force void *)src, size);
 }
 
 static __always_inline __must_check unsigned long
 raw_copy_to_user(void __user *dst, const void *src, unsigned long size)
 {
-	int ret = 0;
-
-	if (!__builtin_constant_p(size))
-		return copy_user_generic((__force void *)dst, src, size);
-	switch (size) {
-	case 1:
-		__uaccess_begin();
-		__put_user_asm(*(u8 *)src, (u8 __user *)dst,
-			      ret, "b", "b", "iq", 1);
-		__uaccess_end();
-		return ret;
-	case 2:
-		__uaccess_begin();
-		__put_user_asm(*(u16 *)src, (u16 __user *)dst,
-			      ret, "w", "w", "ir", 2);
-		__uaccess_end();
-		return ret;
-	case 4:
-		__uaccess_begin();
-		__put_user_asm(*(u32 *)src, (u32 __user *)dst,
-			      ret, "l", "k", "ir", 4);
-		__uaccess_end();
-		return ret;
-	case 8:
-		__uaccess_begin();
-		__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			      ret, "q", "", "er", 8);
-		__uaccess_end();
-		return ret;
-	case 10:
-		__uaccess_begin();
-		__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			       ret, "q", "", "er", 10);
-		if (likely(!ret)) {
-			asm("":::"memory");
-			__put_user_asm(4[(u16 *)src], 4 + (u16 __user *)dst,
-				       ret, "w", "w", "ir", 2);
-		}
-		__uaccess_end();
-		return ret;
-	case 16:
-		__uaccess_begin();
-		__put_user_asm(*(u64 *)src, (u64 __user *)dst,
-			       ret, "q", "", "er", 16);
-		if (likely(!ret)) {
-			asm("":::"memory");
-			__put_user_asm(1[(u64 *)src], 1 + (u64 __user *)dst,
-				       ret, "q", "", "er", 8);
-		}
-		__uaccess_end();
-		return ret;
-	default:
-		return copy_user_generic((__force void *)dst, src, size);
-	}
+	return copy_user_generic((__force void *)dst, src, size);
 }
 
 static __always_inline __must_check
-- 
2.35.1



