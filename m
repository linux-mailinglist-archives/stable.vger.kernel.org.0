Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 460B7604751
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 15:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231940AbiJSNhE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 09:37:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230187AbiJSNgU (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 09:36:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D453167251;
        Wed, 19 Oct 2022 06:25:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6D6CFB8247D;
        Wed, 19 Oct 2022 09:05:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C404DC4347C;
        Wed, 19 Oct 2022 09:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666170330;
        bh=gjDljZl/wvRQcLjS5e2kmaL29MSYEY38YuRzoP9nEaE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTiKQq4cAzSTKayBKU/8755HWQQyYkN/oNrq2DFBNgQglPeVCI9a5cY7130s4XkWw
         bOUzKwaPJB49Ei0cgLS+VShOw1VrjXOeTXrb9p4XRQX31ZFesF9EJti5jFVyHmLMYG
         DoT01Ix8JQBtJJQ8GkW3Ic/mLb89rs6feuN/J0sk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Rohan McLure <rmclure@linux.ibm.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 615/862] powerpc: Fix fallocate and fadvise64_64 compat parameter combination
Date:   Wed, 19 Oct 2022 10:31:42 +0200
Message-Id: <20221019083317.105704974@linuxfoundation.org>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <20221019083249.951566199@linuxfoundation.org>
References: <20221019083249.951566199@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Rohan McLure <rmclure@linux.ibm.com>

[ Upstream commit 016ff72bd2090903715c0f9422a44afbb966f4ee ]

As reported[1] by Arnd, the arch-specific fadvise64_64 and fallocate
compatibility handlers assume parameters are passed with 32-bit
big-endian ABI. This affects the assignment of odd-even parameter pairs
to the high or low words of a 64-bit syscall parameter.

Fix fadvise64_64 fallocate compat handlers to correctly swap upper/lower
32 bits conditioned on endianness.

A future patch will replace the arch-specific compat fallocate with an
asm-generic implementation. This patch is intended for ease of
back-port.

[1]: https://lore.kernel.org/all/be29926f-226e-48dc-871a-e29a54e80583@www.fastmail.com/

Fixes: 57f48b4b74e7 ("powerpc/compat_sys: swap hi/lo parts of 64-bit syscall args in LE mode")
Reported-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Rohan McLure <rmclure@linux.ibm.com>
Reviewed-by: Arnd Bergmann <arnd@arndb.de>
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20220921065605.1051927-9-rmclure@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/syscalls.h | 12 ++++++++++++
 arch/powerpc/kernel/sys_ppc32.c     | 14 +-------------
 arch/powerpc/kernel/syscalls.c      |  4 ++--
 3 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/powerpc/include/asm/syscalls.h b/arch/powerpc/include/asm/syscalls.h
index a2b13e55254f..da40219b303a 100644
--- a/arch/powerpc/include/asm/syscalls.h
+++ b/arch/powerpc/include/asm/syscalls.h
@@ -8,6 +8,18 @@
 #include <linux/types.h>
 #include <linux/compat.h>
 
+/*
+ * long long munging:
+ * The 32 bit ABI passes long longs in an odd even register pair.
+ * High and low parts are swapped depending on endian mode,
+ * so define a macro (similar to mips linux32) to handle that.
+ */
+#ifdef __LITTLE_ENDIAN__
+#define merge_64(low, high) (((u64)high << 32) | low)
+#else
+#define merge_64(high, low) (((u64)high << 32) | low)
+#endif
+
 struct rtas_args;
 
 asmlinkage long sys_mmap(unsigned long addr, size_t len,
diff --git a/arch/powerpc/kernel/sys_ppc32.c b/arch/powerpc/kernel/sys_ppc32.c
index 16ff0399a257..719bfc6d1e3f 100644
--- a/arch/powerpc/kernel/sys_ppc32.c
+++ b/arch/powerpc/kernel/sys_ppc32.c
@@ -56,18 +56,6 @@ unsigned long compat_sys_mmap2(unsigned long addr, size_t len,
 	return sys_mmap(addr, len, prot, flags, fd, pgoff << 12);
 }
 
-/* 
- * long long munging:
- * The 32 bit ABI passes long longs in an odd even register pair.
- * High and low parts are swapped depending on endian mode,
- * so define a macro (similar to mips linux32) to handle that.
- */
-#ifdef __LITTLE_ENDIAN__
-#define merge_64(low, high) ((u64)high << 32) | low
-#else
-#define merge_64(high, low) ((u64)high << 32) | low
-#endif
-
 compat_ssize_t compat_sys_pread64(unsigned int fd, char __user *ubuf, compat_size_t count,
 			     u32 reg6, u32 pos1, u32 pos2)
 {
@@ -94,7 +82,7 @@ asmlinkage int compat_sys_truncate64(const char __user * path, u32 reg4,
 asmlinkage long compat_sys_fallocate(int fd, int mode, u32 offset1, u32 offset2,
 				     u32 len1, u32 len2)
 {
-	return ksys_fallocate(fd, mode, ((loff_t)offset1 << 32) | offset2,
+	return ksys_fallocate(fd, mode, merge_64(offset1, offset2),
 			     merge_64(len1, len2));
 }
 
diff --git a/arch/powerpc/kernel/syscalls.c b/arch/powerpc/kernel/syscalls.c
index fc999140bc27..abc3fbb3c490 100644
--- a/arch/powerpc/kernel/syscalls.c
+++ b/arch/powerpc/kernel/syscalls.c
@@ -98,8 +98,8 @@ long ppc64_personality(unsigned long personality)
 long ppc_fadvise64_64(int fd, int advice, u32 offset_high, u32 offset_low,
 		      u32 len_high, u32 len_low)
 {
-	return ksys_fadvise64_64(fd, (u64)offset_high << 32 | offset_low,
-				 (u64)len_high << 32 | len_low, advice);
+	return ksys_fadvise64_64(fd, merge_64(offset_high, offset_low),
+				 merge_64(len_high, len_low), advice);
 }
 
 SYSCALL_DEFINE0(switch_endian)
-- 
2.35.1



