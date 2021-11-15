Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D901451E0E
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 01:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354321AbhKPAfE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 19:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233400AbhKOTYy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:24:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C248163321;
        Mon, 15 Nov 2021 18:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637002745;
        bh=zBCsemRnDpXLZ1NcLFO8pi2JteQM58ljLbuSkvFBjc0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GGyq9yEbK0bfAd80LaogF0qUZltxGE0EchkgVVFIuieO7XSfmbEhfn7bl3X20RJ9B
         T4eh6wqw0bQvBYkWkGUZRoZh1mYBabRGDezVJb2ZvWgjSIIHJLTP0HpDAULy82MVV/
         T2DCjOU045qecfSPCIE/kGEqEloPIbbkb3A7Bmp8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 682/917] powerpc: Dont provide __kernel_map_pages() without ARCH_SUPPORTS_DEBUG_PAGEALLOC
Date:   Mon, 15 Nov 2021 18:02:57 +0100
Message-Id: <20211115165452.020672914@linuxfoundation.org>
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

[ Upstream commit f8c0e36b48e32b14bb83332d24e0646acd31d9e9 ]

When ARCH_SUPPORTS_DEBUG_PAGEALLOC is not selected, the user can
still select CONFIG_DEBUG_PAGEALLOC in which case __kernel_map_pages()
is provided by mm/page_poison.c

So only define __kernel_map_pages() when both
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC and CONFIG_DEBUG_PAGEALLOC
are defined.

Fixes: 68b44f94d637 ("powerpc/booke: Disable STRICT_KERNEL_RWX, DEBUG_PAGEALLOC and KFENCE")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/971b69739ff4746252e711a9845210465c023a9e.1635425947.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/pgtable_32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/mm/pgtable_32.c b/arch/powerpc/mm/pgtable_32.c
index dcf5ecca19d99..fde1ed445ca46 100644
--- a/arch/powerpc/mm/pgtable_32.c
+++ b/arch/powerpc/mm/pgtable_32.c
@@ -173,7 +173,7 @@ void mark_rodata_ro(void)
 }
 #endif
 
-#ifdef CONFIG_DEBUG_PAGEALLOC
+#if defined(CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC) && defined(CONFIG_DEBUG_PAGEALLOC)
 void __kernel_map_pages(struct page *page, int numpages, int enable)
 {
 	unsigned long addr = (unsigned long)page_address(page);
-- 
2.33.0



