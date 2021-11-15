Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82F64451F14
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:36:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355527AbhKPAia (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:38:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:45396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344447AbhKOTYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 149AC6349C;
        Mon, 15 Nov 2021 18:57:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002673;
        bh=5gZoJW6fAe3iLPqtbq8ca458ZHCj5o0fRRvw4XD+L58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Yt1gDMH2OR8/644FVgJPo4q/Fsqz6VVTk/l7KZroFhqW1gTr9MohJmNk9XejbScyb
         FWIyurhls2iNWqGFo65FOC92nhyJe1UorIAxpkAloqEOIw8NNnbQDil8rfHjo5Jc0C
         TwjNx9uT6WGGmoiJUZ0Hz05FyYZczVSV+mMBVpvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 655/917] powerpc/booke: Disable STRICT_KERNEL_RWX, DEBUG_PAGEALLOC and KFENCE
Date:   Mon, 15 Nov 2021 18:02:30 +0100
Message-Id: <20211115165451.081434779@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165428.722074685@linuxfoundation.org>
References: <20211115165428.722074685@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 68b44f94d6370e2c6c790fedd28e637fa9964a93 ]

fsl_booke and 44x are not able to map kernel linear memory with
pages, so they can't support DEBUG_PAGEALLOC and KFENCE, and
STRICT_KERNEL_RWX is also a problem for now.

Enable those only on book3s (both 32 and 64 except KFENCE), 8xx and 40x.

Fixes: 88df6e90fa97 ("[POWERPC] DEBUG_PAGEALLOC for 32-bit")
Fixes: 95902e6c8864 ("powerpc/mm: Implement STRICT_KERNEL_RWX on PPC32")
Fixes: 90cbac0e995d ("powerpc: Enable KFENCE for PPC32")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/d1ad9fdd9b27da3fdfa16510bb542ed51fa6e134.1634292136.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/Kconfig | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/powerpc/Kconfig b/arch/powerpc/Kconfig
index ba5b661893588..6b9f523882c58 100644
--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -138,7 +138,7 @@ config PPC
 	select ARCH_HAS_PTE_SPECIAL
 	select ARCH_HAS_SCALED_CPUTIME		if VIRT_CPU_ACCOUNTING_NATIVE && PPC_BOOK3S_64
 	select ARCH_HAS_SET_MEMORY
-	select ARCH_HAS_STRICT_KERNEL_RWX	if ((PPC_BOOK3S_64 || PPC32) && !HIBERNATION)
+	select ARCH_HAS_STRICT_KERNEL_RWX	if (PPC_BOOK3S || PPC_8xx || 40x) && !HIBERNATION
 	select ARCH_HAS_STRICT_MODULE_RWX	if ARCH_HAS_STRICT_KERNEL_RWX && !PPC_BOOK3S_32
 	select ARCH_HAS_TICK_BROADCAST		if GENERIC_CLOCKEVENTS_BROADCAST
 	select ARCH_HAS_UACCESS_FLUSHCACHE
@@ -150,7 +150,7 @@ config PPC
 	select ARCH_OPTIONAL_KERNEL_RWX		if ARCH_HAS_STRICT_KERNEL_RWX
 	select ARCH_STACKWALK
 	select ARCH_SUPPORTS_ATOMIC_RMW
-	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC32 || PPC_BOOK3S_64
+	select ARCH_SUPPORTS_DEBUG_PAGEALLOC	if PPC_BOOK3S || PPC_8xx || 40x
 	select ARCH_USE_BUILTIN_BSWAP
 	select ARCH_USE_CMPXCHG_LOCKREF		if PPC64
 	select ARCH_USE_MEMTEST
@@ -190,7 +190,7 @@ config PPC
 	select HAVE_ARCH_JUMP_LABEL_RELATIVE
 	select HAVE_ARCH_KASAN			if PPC32 && PPC_PAGE_SHIFT <= 14
 	select HAVE_ARCH_KASAN_VMALLOC		if PPC32 && PPC_PAGE_SHIFT <= 14
-	select HAVE_ARCH_KFENCE			if PPC32
+	select HAVE_ARCH_KFENCE			if PPC_BOOK3S_32 || PPC_8xx || 40x
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if COMPAT
-- 
2.33.0



