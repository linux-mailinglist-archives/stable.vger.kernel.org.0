Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF9645111B
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 19:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243469AbhKOTBS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:01:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:59664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243480AbhKOS7x (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:59:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A973361AA5;
        Mon, 15 Nov 2021 18:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000013;
        bh=M9W8ECSQIv7+V0E32wvWvnQRRQ6el4KhvAoCq1OnRns=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jrKSULMfqA12UuZhtHxHKmTgS0lbKmkOxYSH5iZlcLkwZolta2IeOYV3+MlS4rJAP
         vIisxHk3JccqAinafYH8w7R5qqWtYrrywsQB30EuDFQimn55HnSzlTf+0ZkWyWBAMd
         WXGJZifPmF6BuXZ8Gs2DciR8DN5xDnMi/WUiGobw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 506/849] ARM: 9142/1: kasan: work around LPAE build warning
Date:   Mon, 15 Nov 2021 17:59:49 +0100
Message-Id: <20211115165437.403036110@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit c2e6df3eaaf120cde5e7c3a70590dd82e427458a ]

pgd_page_vaddr() returns an 'unsigned long' address, causing a warning
with the memcpy() call in kasan_init():

arch/arm/mm/kasan_init.c: In function 'kasan_init':
include/asm-generic/pgtable-nop4d.h:44:50: error: passing argument 2 of '__memcpy' makes pointer from integer without a cast [-Werror=int-conversion]
   44 | #define pgd_page_vaddr(pgd)                     ((unsigned long)(p4d_pgtable((p4d_t){ pgd })))
      |                                                 ~^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
      |                                                  |
      |                                                  long unsigned int
arch/arm/include/asm/string.h:58:45: note: in definition of macro 'memcpy'
   58 | #define memcpy(dst, src, len) __memcpy(dst, src, len)
      |                                             ^~~
arch/arm/mm/kasan_init.c:229:16: note: in expansion of macro 'pgd_page_vaddr'
  229 |                pgd_page_vaddr(*pgd_offset_k(KASAN_SHADOW_START)),
      |                ^~~~~~~~~~~~~~
arch/arm/include/asm/string.h:21:47: note: expected 'const void *' but argument is of type 'long unsigned int'
   21 | extern void *__memcpy(void *dest, const void *src, __kernel_size_t n);
      |                                   ~~~~~~~~~~~~^~~

Avoid this by adding an explicit typecast.

Link: https://lore.kernel.org/all/CACRpkdb3DMvof3-xdtss0Pc6KM36pJA-iy=WhvtNVnsDpeJ24Q@mail.gmail.com/

Fixes: 5615f69bc209 ("ARM: 9016/2: Initialize the mapping of KASan shadow memory")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mm/kasan_init.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mm/kasan_init.c b/arch/arm/mm/kasan_init.c
index 9c348042a7244..4b1619584b23c 100644
--- a/arch/arm/mm/kasan_init.c
+++ b/arch/arm/mm/kasan_init.c
@@ -226,7 +226,7 @@ void __init kasan_init(void)
 	BUILD_BUG_ON(pgd_index(KASAN_SHADOW_START) !=
 		     pgd_index(KASAN_SHADOW_END));
 	memcpy(tmp_pmd_table,
-	       pgd_page_vaddr(*pgd_offset_k(KASAN_SHADOW_START)),
+	       (void*)pgd_page_vaddr(*pgd_offset_k(KASAN_SHADOW_START)),
 	       sizeof(tmp_pmd_table));
 	set_pgd(&tmp_pgd_table[pgd_index(KASAN_SHADOW_START)],
 		__pgd(__pa(tmp_pmd_table) | PMD_TYPE_TABLE | L_PGD_SWAPPER));
-- 
2.33.0



