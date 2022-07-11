Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FDC856FCFD
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:49:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231209AbiGKJth (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:49:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50152 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233715AbiGKJsv (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:48:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C51A65F95;
        Mon, 11 Jul 2022 02:23:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BED861356;
        Mon, 11 Jul 2022 09:23:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F014CC34115;
        Mon, 11 Jul 2022 09:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531421;
        bh=da8zybw2cPdBWw+YaxzPCfdsoxLA+sIg0E0z/yJMA1U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v7ZeEz6zarO+jmz47stuUrPT9HFXUDmSvFPth+NHPSMx9sLHpBse0HuIMIW/fXGqn
         aB/p/cicfLX3Wwa8a8qo/cGrZGn7kltu4cXzR9SXzWm8PhowRYuOx842cEY0YMftKP
         H3pe2QF6vIVJjT0DixmFSd0+3n1ccylwMy3W8N7A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Randy Dunlap <rdunlap@infradead.org>,
        Andy Whitcroft <apw@canonical.com>,
        Christoph Lameter <cl@linux.com>,
        Daniel Micay <danielmicay@gmail.com>,
        David Rientjes <rientjes@google.com>,
        Dennis Zhou <dennis@kernel.org>,
        Dwaipayan Ray <dwaipayanray1@gmail.com>,
        Joe Perches <joe@perches.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Lukas Bulwahn <lukas.bulwahn@gmail.com>,
        Pekka Enberg <penberg@kernel.org>, Tejun Heo <tj@kernel.org>,
        Vlastimil Babka <vbabka@suse.cz>,
        Alexandre Bounine <alex.bou9@gmail.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Ira Weiny <ira.weiny@intel.com>,
        Jing Xiangfeng <jingxiangfeng@huawei.com>,
        John Hubbard <jhubbard@nvidia.com>,
        kernel test robot <lkp@intel.com>,
        Matt Porter <mporter@kernel.crashing.org>,
        Miguel Ojeda <ojeda@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Souptick Joarder <jrdr.linux@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 100/230] Compiler Attributes: add __alloc_size() for better bounds checking
Date:   Mon, 11 Jul 2022 11:05:56 +0200
Message-Id: <20220711090606.906431052@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit 86cffecdeaa278444870c8745ab166a65865dbf0 ]

GCC and Clang can use the "alloc_size" attribute to better inform the
results of __builtin_object_size() (for compile-time constant values).
Clang can additionally use alloc_size to inform the results of
__builtin_dynamic_object_size() (for run-time values).

Because GCC sees the frequent use of struct_size() as an allocator size
argument, and notices it can return SIZE_MAX (the overflow indication),
it complains about these call sites overflowing (since SIZE_MAX is
greater than the default -Walloc-size-larger-than=PTRDIFF_MAX).  This
isn't helpful since we already know a SIZE_MAX will be caught at
run-time (this was an intentional design).  To deal with this, we must
disable this check as it is both a false positive and redundant.  (Clang
does not have this warning option.)

Unfortunately, just checking the -Wno-alloc-size-larger-than is not
sufficient to make the __alloc_size attribute behave correctly under
older GCC versions.  The attribute itself must be disabled in those
situations too, as there appears to be no way to reliably silence the
SIZE_MAX constant expression cases for GCC versions less than 9.1:

   In file included from ./include/linux/resource_ext.h:11,
                    from ./include/linux/pci.h:40,
                    from drivers/net/ethernet/intel/ixgbe/ixgbe.h:9,
                    from drivers/net/ethernet/intel/ixgbe/ixgbe_lib.c:4:
   In function 'kmalloc_node',
       inlined from 'ixgbe_alloc_q_vector' at ./include/linux/slab.h:743:9:
   ./include/linux/slab.h:618:9: error: argument 1 value '18446744073709551615' exceeds maximum object size 9223372036854775807 [-Werror=alloc-size-larger-than=]
     return __kmalloc_node(size, flags, node);
            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   ./include/linux/slab.h: In function 'ixgbe_alloc_q_vector':
   ./include/linux/slab.h:455:7: note: in a call to allocation function '__kmalloc_node' declared here
    void *__kmalloc_node(size_t size, gfp_t flags, int node) __assume_slab_alignment __malloc;
          ^~~~~~~~~~~~~~

Specifically:
 '-Wno-alloc-size-larger-than' is not correctly handled by GCC < 9.1
    https://godbolt.org/z/hqsfG7q84 (doesn't disable)
    https://godbolt.org/z/P9jdrPTYh (doesn't admit to not knowing about option)
    https://godbolt.org/z/465TPMWKb (only warns when other warnings appear)

 '-Walloc-size-larger-than=18446744073709551615' is not handled by GCC < 8.2
    https://godbolt.org/z/73hh1EPxz (ignores numeric value)

Since anything marked with __alloc_size would also qualify for marking
with __malloc, just include __malloc along with it to avoid redundant
markings.  (Suggested by Linus Torvalds.)

Finally, make sure checkpatch.pl doesn't get confused about finding the
__alloc_size attribute on functions.  (Thanks to Joe Perches.)

Link: https://lkml.kernel.org/r/20210930222704.2631604-3-keescook@chromium.org
Signed-off-by: Kees Cook <keescook@chromium.org>
Tested-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Andy Whitcroft <apw@canonical.com>
Cc: Christoph Lameter <cl@linux.com>
Cc: Daniel Micay <danielmicay@gmail.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Dennis Zhou <dennis@kernel.org>
Cc: Dwaipayan Ray <dwaipayanray1@gmail.com>
Cc: Joe Perches <joe@perches.com>
Cc: Joonsoo Kim <iamjoonsoo.kim@lge.com>
Cc: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Tejun Heo <tj@kernel.org>
Cc: Vlastimil Babka <vbabka@suse.cz>
Cc: Alexandre Bounine <alex.bou9@gmail.com>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Jing Xiangfeng <jingxiangfeng@huawei.com>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: kernel test robot <lkp@intel.com>
Cc: Matt Porter <mporter@kernel.crashing.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Souptick Joarder <jrdr.linux@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile                            | 15 +++++++++++++++
 include/linux/compiler-gcc.h        |  8 ++++++++
 include/linux/compiler_attributes.h | 10 ++++++++++
 include/linux/compiler_types.h      | 12 ++++++++++++
 scripts/checkpatch.pl               |  3 ++-
 5 files changed, 47 insertions(+), 1 deletion(-)

diff --git a/Makefile b/Makefile
index c7750d260a55..397fb08d17f2 100644
--- a/Makefile
+++ b/Makefile
@@ -1011,6 +1011,21 @@ ifdef CONFIG_CC_IS_GCC
 KBUILD_CFLAGS += -Wno-maybe-uninitialized
 endif
 
+ifdef CONFIG_CC_IS_GCC
+# The allocators already balk at large sizes, so silence the compiler
+# warnings for bounds checks involving those possible values. While
+# -Wno-alloc-size-larger-than would normally be used here, earlier versions
+# of gcc (<9.1) weirdly don't handle the option correctly when _other_
+# warnings are produced (?!). Using -Walloc-size-larger-than=SIZE_MAX
+# doesn't work (as it is documented to), silently resolving to "0" prior to
+# version 9.1 (and producing an error more recently). Numeric values larger
+# than PTRDIFF_MAX also don't work prior to version 9.1, which are silently
+# ignored, continuing to default to PTRDIFF_MAX. So, left with no other
+# choice, we must perform a versioned check to disable this warning.
+# https://lore.kernel.org/lkml/20210824115859.187f272f@canb.auug.org.au
+KBUILD_CFLAGS += $(call cc-ifversion, -ge, 0901, -Wno-alloc-size-larger-than)
+endif
+
 # disable invalid "can't wrap" optimizations for signed / pointers
 KBUILD_CFLAGS	+= -fno-strict-overflow
 
diff --git a/include/linux/compiler-gcc.h b/include/linux/compiler-gcc.h
index bd2b881c6b63..b9d5f9c373a0 100644
--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -144,3 +144,11 @@
 #else
 #define __diag_GCC_8(s)
 #endif
+
+/*
+ * Prior to 9.1, -Wno-alloc-size-larger-than (and therefore the "alloc_size"
+ * attribute) do not work, and must be disabled.
+ */
+#if GCC_VERSION < 90100
+#undef __alloc_size__
+#endif
diff --git a/include/linux/compiler_attributes.h b/include/linux/compiler_attributes.h
index e6ec63403965..3de06a8fae73 100644
--- a/include/linux/compiler_attributes.h
+++ b/include/linux/compiler_attributes.h
@@ -33,6 +33,15 @@
 #define __aligned(x)                    __attribute__((__aligned__(x)))
 #define __aligned_largest               __attribute__((__aligned__))
 
+/*
+ * Note: do not use this directly. Instead, use __alloc_size() since it is conditionally
+ * available and includes other attributes.
+ *
+ *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-alloc_005fsize-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#alloc-size
+ */
+#define __alloc_size__(x, ...)		__attribute__((__alloc_size__(x, ## __VA_ARGS__)))
+
 /*
  * Note: users of __always_inline currently do not write "inline" themselves,
  * which seems to be required by gcc to apply the attribute according
@@ -153,6 +162,7 @@
 
 /*
  *   gcc: https://gcc.gnu.org/onlinedocs/gcc/Common-Function-Attributes.html#index-malloc-function-attribute
+ * clang: https://clang.llvm.org/docs/AttributeReference.html#malloc
  */
 #define __malloc                        __attribute__((__malloc__))
 
diff --git a/include/linux/compiler_types.h b/include/linux/compiler_types.h
index b6ff83a714ca..4f2203c4a257 100644
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -250,6 +250,18 @@ struct ftrace_likely_data {
 # define __cficanonical
 #endif
 
+/*
+ * Any place that could be marked with the "alloc_size" attribute is also
+ * a place to be marked with the "malloc" attribute. Do this as part of the
+ * __alloc_size macro to avoid redundant attributes and to avoid missing a
+ * __malloc marking.
+ */
+#ifdef __alloc_size__
+# define __alloc_size(x, ...)	__alloc_size__(x, ## __VA_ARGS__) __malloc
+#else
+# define __alloc_size(x, ...)	__malloc
+#endif
+
 #ifndef asm_volatile_goto
 #define asm_volatile_goto(x...) asm goto(x)
 #endif
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
index c27d2312cfc3..88cb294dc447 100755
--- a/scripts/checkpatch.pl
+++ b/scripts/checkpatch.pl
@@ -489,7 +489,8 @@ our $Attribute	= qr{
 			____cacheline_aligned|
 			____cacheline_aligned_in_smp|
 			____cacheline_internodealigned_in_smp|
-			__weak
+			__weak|
+			__alloc_size\s*\(\s*\d+\s*(?:,\s*\d+\s*)?\)
 		  }x;
 our $Modifier;
 our $Inline	= qr{inline|__always_inline|noinline|__inline|__inline__};
-- 
2.35.1



