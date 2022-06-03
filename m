Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AD9A053CFB3
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345823AbiFCR4X (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346006AbiFCRzf (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:55:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E070554F9A;
        Fri,  3 Jun 2022 10:53:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 59A6060F38;
        Fri,  3 Jun 2022 17:53:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 68497C385A9;
        Fri,  3 Jun 2022 17:53:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278795;
        bh=p5qYFyl5YpYTIl/vNi0jkIZyCIS0CkvR5OJ9QNEFNCg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EZS/KDamsQtbHqjIfEsyln7q7hTvf310Nz/xI9f0UExwCNmO5WskFNbXGOjrcolRL
         BNBhYL8LzC6/6BtuIlRWicS+J0FBx+Bc5/1jMiBfO/Nf4Yk5s6adiy94HE7DSWoCS+
         806BN117mM8iuqlAICg1JOsN6iAjL+6qoS9YTLY8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sean Christopherson <seanjc@google.com>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.17 30/75] x86/uaccess: Implement macros for CMPXCHG on user addresses
Date:   Fri,  3 Jun 2022 19:43:14 +0200
Message-Id: <20220603173822.602877991@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

From: Peter Zijlstra <peterz@infradead.org>

commit 989b5db215a2f22f89d730b607b071d964780f10 upstream.

Add support for CMPXCHG loops on userspace addresses.  Provide both an
"unsafe" version for tight loops that do their own uaccess begin/end, as
well as a "safe" version for use cases where the CMPXCHG is not buried in
a loop, e.g. KVM will resume the guest instead of looping when emulation
of a guest atomic accesses fails the CMPXCHG.

Provide 8-byte versions for 32-bit kernels so that KVM can do CMPXCHG on
guest PAE PTEs, which are accessed via userspace addresses.

Guard the asm_volatile_goto() variation with CC_HAS_ASM_GOTO_TIED_OUTPUT,
the "+m" constraint fails on some compilers that otherwise support
CC_HAS_ASM_GOTO_OUTPUT.

Cc: stable@vger.kernel.org
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Co-developed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20220202004945.2540433-3-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/uaccess.h |  142 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 142 insertions(+)

--- a/arch/x86/include/asm/uaccess.h
+++ b/arch/x86/include/asm/uaccess.h
@@ -409,6 +409,103 @@ do {									\
 
 #endif // CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
+#ifdef CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm_volatile_goto("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     _ASM_EXTABLE_UA(1b, %l[label])			\
+		     : CC_OUT(z) (success),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory"						\
+		     : label);						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+#endif // CONFIG_X86_32
+#else  // !CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+#define __try_cmpxchg_user_asm(itype, ltype, _ptr, _pold, _new, label)	({ \
+	int __err = 0;							\
+	bool success;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg"itype" %[new], %[ptr]\n"\
+		     CC_SET(z)						\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG,	\
+					   %[errout])			\
+		     : CC_OUT(z) (success),				\
+		       [errout] "+r" (__err),				\
+		       [ptr] "+m" (*_ptr),				\
+		       [old] "+a" (__old)				\
+		     : [new] ltype (__new)				\
+		     : "memory", "cc");					\
+	if (unlikely(__err))						\
+		goto label;						\
+	if (unlikely(!success))						\
+		*_old = __old;						\
+	likely(success);					})
+
+#ifdef CONFIG_X86_32
+/*
+ * Unlike the normal CMPXCHG, hardcode ECX for both success/fail and error.
+ * There are only six GPRs available and four (EAX, EBX, ECX, and EDX) are
+ * hardcoded by CMPXCHG8B, leaving only ESI and EDI.  If the compiler uses
+ * both ESI and EDI for the memory operand, compilation will fail if the error
+ * is an input+output as there will be no register available for input.
+ */
+#define __try_cmpxchg64_user_asm(_ptr, _pold, _new, label)	({	\
+	int __result;							\
+	__typeof__(_ptr) _old = (__typeof__(_ptr))(_pold);		\
+	__typeof__(*(_ptr)) __old = *_old;				\
+	__typeof__(*(_ptr)) __new = (_new);				\
+	asm volatile("\n"						\
+		     "1: " LOCK_PREFIX "cmpxchg8b %[ptr]\n"		\
+		     "mov $0, %%ecx\n\t"				\
+		     "setz %%cl\n"					\
+		     "2:\n"						\
+		     _ASM_EXTABLE_TYPE_REG(1b, 2b, EX_TYPE_EFAULT_REG, %%ecx) \
+		     : [result]"=c" (__result),				\
+		       "+A" (__old),					\
+		       [ptr] "+m" (*_ptr)				\
+		     : "b" ((u32)__new),				\
+		       "c" ((u32)((u64)__new >> 32))			\
+		     : "memory", "cc");					\
+	if (unlikely(__result < 0))					\
+		goto label;						\
+	if (unlikely(!__result))					\
+		*_old = __old;						\
+	likely(__result);					})
+#endif // CONFIG_X86_32
+#endif // CONFIG_CC_HAS_ASM_GOTO_TIED_OUTPUT
+
 /* FIXME: this hack is definitely wrong -AK */
 struct __large_struct { unsigned long buf[100]; };
 #define __m(x) (*(struct __large_struct __user *)(x))
@@ -501,6 +598,51 @@ do {										\
 } while (0)
 #endif // CONFIG_CC_HAS_ASM_GOTO_OUTPUT
 
+extern void __try_cmpxchg_user_wrong_size(void);
+
+#ifndef CONFIG_X86_32
+#define __try_cmpxchg64_user_asm(_ptr, _oldp, _nval, _label)		\
+	__try_cmpxchg_user_asm("q", "r", (_ptr), (_oldp), (_nval), _label)
+#endif
+
+/*
+ * Force the pointer to u<size> to match the size expected by the asm helper.
+ * clang/LLVM compiles all cases and only discards the unused paths after
+ * processing errors, which breaks i386 if the pointer is an 8-byte value.
+ */
+#define unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label) ({			\
+	bool __ret;								\
+	__chk_user_ptr(_ptr);							\
+	switch (sizeof(*(_ptr))) {						\
+	case 1:	__ret = __try_cmpxchg_user_asm("b", "q",			\
+					       (__force u8 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 2:	__ret = __try_cmpxchg_user_asm("w", "r",			\
+					       (__force u16 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 4:	__ret = __try_cmpxchg_user_asm("l", "r",			\
+					       (__force u32 *)(_ptr), (_oldp),	\
+					       (_nval), _label);		\
+		break;								\
+	case 8:	__ret = __try_cmpxchg64_user_asm((__force u64 *)(_ptr), (_oldp),\
+						 (_nval), _label);		\
+		break;								\
+	default: __try_cmpxchg_user_wrong_size();				\
+	}									\
+	__ret;						})
+
+/* "Returns" 0 on success, 1 on failure, -EFAULT if the access faults. */
+#define __try_cmpxchg_user(_ptr, _oldp, _nval, _label)	({		\
+	int __ret = -EFAULT;						\
+	__uaccess_begin_nospec();					\
+	__ret = !unsafe_try_cmpxchg_user(_ptr, _oldp, _nval, _label);	\
+_label:									\
+	__uaccess_end();						\
+	__ret;								\
+							})
+
 /*
  * We want the unsafe accessors to always be inlined and use
  * the error labels - thus the macro games.


