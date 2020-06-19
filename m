Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4248C200F4D
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392367AbgFSPPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:45558 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392364AbgFSPPB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:15:01 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B3BB21582;
        Fri, 19 Jun 2020 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579700;
        bh=JaSA0y9H0u9VT7Sa2VOBq9V9x7Xl24eC4nujKM3HZKw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5se3Bboz9D+Rp7VfbBuoxOnrlYs9hQ6nptOfV8LVorWCXIY7a1DLhSQbGTTGinHK
         HGaX428/+mkV8l3jgrhNVNDXeITYisaStkq8SDYPlAd06ipvk1VW/4VP3OLLjqPxFU
         QDVUOCrPDx21cRHSrUNbvP8iEEG0Fx+4ifKegkrc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kbuild test robot <lkp@intel.com>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.4 234/261] powerpc/32: Disable KASAN with pages bigger than 16k
Date:   Fri, 19 Jun 2020 16:34:05 +0200
Message-Id: <20200619141701.085476819@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 888468ce725a4cd56d72dc7e5096078f7a9251a0 upstream.

Mapping of early shadow area is implemented by using a single static
page table having all entries pointing to the same early shadow page.
The shadow area must therefore occupy full PGD entries.

The shadow area has a size of 128MB starting at 0xf8000000.
With 4k pages, a PGD entry is 4MB
With 16k pages, a PGD entry is 64MB
With 64k pages, a PGD entry is 1GB which is too big.

Until we rework the early shadow mapping, disable KASAN when the page
size is too big.

Fixes: 2edb16efc899 ("powerpc/32: Add KASAN support")
Cc: stable@vger.kernel.org # v5.2+
Reported-by: kbuild test robot <lkp@intel.com>
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/7195fcde7314ccbf7a081b356084a69d421b10d4.1590660977.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/Kconfig
+++ b/arch/powerpc/Kconfig
@@ -171,7 +171,7 @@ config PPC
 	select HAVE_ARCH_AUDITSYSCALL
 	select HAVE_ARCH_HUGE_VMAP		if PPC_BOOK3S_64 && PPC_RADIX_MMU
 	select HAVE_ARCH_JUMP_LABEL
-	select HAVE_ARCH_KASAN			if PPC32
+	select HAVE_ARCH_KASAN			if PPC32 && PPC_PAGE_SHIFT <= 14
 	select HAVE_ARCH_KGDB
 	select HAVE_ARCH_MMAP_RND_BITS
 	select HAVE_ARCH_MMAP_RND_COMPAT_BITS	if COMPAT


