Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 29813492130
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 09:28:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235372AbiARI20 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Jan 2022 03:28:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229546AbiARI2X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Jan 2022 03:28:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B581C061574
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 00:28:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DF54161440
        for <stable@vger.kernel.org>; Tue, 18 Jan 2022 08:28:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F418CC00446;
        Tue, 18 Jan 2022 08:28:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642494502;
        bh=PxugBLLplZwVZ0bHKVqEBHjMAwOl8ZCLptyOi2c+4BA=;
        h=From:To:Cc:Subject:Date:From;
        b=Kf4La2/bgH4+0MLcV4yEWH0EtvEgmmPi/zWdn3U39sZccCLUg2t1ADCbOMwHLnR6a
         sxZjkKny11V6bxC1JoMdYl+942Ni/mS4cII6UVkICwoRqgGbHMDxx0xHWNrG908plh
         Ah0c076VwpR9vJThp0sxcjYBZkbtDg8wd+c/lUU3cYQcenD5MJJqtoRwJzDhq7MrLQ
         04kVP0CTDqo/09HzSM0B9FbhGeIuVDaLreFjraK9Euv4M6qPuXkOzfxE0hRH3LYtTi
         UPcn00aC9djT2XW7UO6NHGhFfbBm+WgptPdkI2Qj8v1iX+NwVA6ZnDjQecoRkvgI6h
         4DBDi7HkSsBYA==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux@armlinux.org.uk
Cc:     linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@linaro.org, Ard Biesheuvel <ardb@kernel.org>,
        stable@vger.kernel.org
Subject: [PATCH] ARM: uaccess: avoid alignment faults in copy_[from|to]_kernel_nofault
Date:   Tue, 18 Jan 2022 09:28:08 +0100
Message-Id: <20220118082808.931129-1-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=1971; h=from:subject; bh=PxugBLLplZwVZ0bHKVqEBHjMAwOl8ZCLptyOi2c+4BA=; b=owEB7QES/pANAwAKAcNPIjmS2Y8kAcsmYgBh5noX7EThvmZf1z1SIC7CZIogEejo9B1izlrZ8JHH x6sfrdaJAbMEAAEKAB0WIQT72WJ8QGnJQhU3VynDTyI5ktmPJAUCYeZ6FwAKCRDDTyI5ktmPJJ6DC/ 9pZRtK6a6MC/djLR5UCCxhBaH0VPu7b5Trf12XNXRfkAGmeHkarY/dm7s44VZ9545bZ+e6SP4agJtS pij0Tt+rfyBcidE1LGYB/HC1WGO0dpYFAl4UoDbzoOBHBeF/cp7CV73AgR+jSXEN/kTT3NuM7luOew o9M73+80voYsdPjuWJmf+6FVqaP71Rdl4d6subY/84xhD9K51VYXYLYoJbciOqB/7y0P8zNnvJ5f8T ymhcowfWURHff7TxlZPQDLUK3wvcImeO5/NtZIBEk5g3PfYHpTrqIc5naPbjp+7lW/7Q+rKHt07A5i ZlwLJiQ+PaeLj3aR+nX5NOSA/+Qel/Zn2/7awpb248jjZU0o1ZuW9euH+0Q8lym8EXpCG1zlER/uAL vNR5RgQtZa3FcmnHTUy/DGru5ROPs5qcLbxYEjr7L2ha6lzBNnwNi9jfVX9LswOmLxVYrj7YmF7wuX 5tumUwG5pRw4FuPLMRGphm+jAerSl2Xe+5S1mZPReKLvs=
X-Developer-Key: i=ardb@kernel.org; a=openpgp; fpr=F43D03328115A198C90016883D200E9CA6329909
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The helpers that are used to implement copy_from_kernel_nofault() and
copy_to_kernel_nofault() cast a void* to a pointer to a wider type,
which may result in alignment faults on ARM if the compiler decides to
use double-word or multiple-word load/store instructions.

So use the unaligned accessors where needed: when the type's size > 1
and the input was not aligned already by the caller.

Cc: <stable@vger.kernel.org>
Fixes: 2df4c9a741a0 ("ARM: 9112/1: uaccess: add __{get,put}_kernel_nofault")
Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 arch/arm/include/asm/uaccess.h | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/arch/arm/include/asm/uaccess.h b/arch/arm/include/asm/uaccess.h
index 36fbc3329252..32dbfd81f42a 100644
--- a/arch/arm/include/asm/uaccess.h
+++ b/arch/arm/include/asm/uaccess.h
@@ -11,6 +11,7 @@
 #include <linux/string.h>
 #include <asm/memory.h>
 #include <asm/domain.h>
+#include <asm/unaligned.h>
 #include <asm/unified.h>
 #include <asm/compiler.h>
 
@@ -497,7 +498,10 @@ do {									\
 	}								\
 	default: __err = __get_user_bad(); break;			\
 	}								\
-	*(type *)(dst) = __val;						\
+	if (IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS))		\
+		put_unaligned(__val, (type *)(dst));			\
+	else								\
+		*(type *)(dst) = __val; /* aligned by caller */		\
 	if (__err)							\
 		goto err_label;						\
 } while (0)
@@ -507,7 +511,9 @@ do {									\
 	const type *__pk_ptr = (dst);					\
 	unsigned long __dst = (unsigned long)__pk_ptr;			\
 	int __err = 0;							\
-	type __val = *(type *)src;					\
+	type __val = IS_ENABLED(CONFIG_HAVE_EFFICIENT_UNALIGNED_ACCESS)	\
+		     ? get_unaligned((type *)(src))			\
+		     : *(type *)(src);	/* aligned by caller */		\
 	switch (sizeof(type)) {						\
 	case 1: __put_user_asm_byte(__val, __dst, __err, ""); break;	\
 	case 2:	__put_user_asm_half(__val, __dst, __err, ""); break;	\
-- 
2.30.2

