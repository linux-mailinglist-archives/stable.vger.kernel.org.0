Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6B1B37CED3
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbhELRGh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:06:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:49650 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244635AbhELQu5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C77FA61D65;
        Wed, 12 May 2021 16:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836234;
        bh=ABV/yAPn5IJyyGBoIH3Ba2BhzDamm2K4BmXl9M6tpDY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QiubiWmebukWwcvfBcmqMasnmn8XDmgMV2AGGPhuZi+ENEzV37+/BR5wFKl0xhzSu
         xqarR57IrhtpQUYnqO0Dc3WWWOv/BK6tMhmIPypy5VH2RQWHKh4eWqRPtxTsGJyJSC
         RxXFltW7dGFlOy9aGrU8qQNRk5jJagUwGOoRZPgI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sergei Trofimovich <slyfox@gentoo.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 664/677] ia64: fix EFI_DEBUG build
Date:   Wed, 12 May 2021 16:51:50 +0200
Message-Id: <20210512144859.431884775@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144837.204217980@linuxfoundation.org>
References: <20210512144837.204217980@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Trofimovich <slyfox@gentoo.org>

[ Upstream commit e3db00b79d74caaf84cd9e1d4927979abfd0d7c9 ]

When enabled local debugging via `#define EFI_DEBUG 1` noticed build
failure:

    arch/ia64/kernel/efi.c:564:8: error: 'i' undeclared (first use in this function)

While at it fixed benign string format mismatches visible only when
EFI_DEBUG is enabled:

    arch/ia64/kernel/efi.c:589:11:
        warning: format '%lx' expects argument of type 'long unsigned int',
        but argument 5 has type 'u64' {aka 'long long unsigned int'} [-Wformat=]

Link: https://lkml.kernel.org/r/20210328212246.685601-1-slyfox@gentoo.org
Fixes: 14fb42090943559 ("efi: Merge EFI system table revision and vendor checks")
Signed-off-by: Sergei Trofimovich <slyfox@gentoo.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/ia64/kernel/efi.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index c5fe21de46a8..31149e41f9be 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -415,10 +415,10 @@ efi_get_pal_addr (void)
 		mask  = ~((1 << IA64_GRANULE_SHIFT) - 1);
 
 		printk(KERN_INFO "CPU %d: mapping PAL code "
-                       "[0x%lx-0x%lx) into [0x%lx-0x%lx)\n",
-                       smp_processor_id(), md->phys_addr,
-                       md->phys_addr + efi_md_size(md),
-                       vaddr & mask, (vaddr & mask) + IA64_GRANULE_SIZE);
+			"[0x%llx-0x%llx) into [0x%llx-0x%llx)\n",
+			smp_processor_id(), md->phys_addr,
+			md->phys_addr + efi_md_size(md),
+			vaddr & mask, (vaddr & mask) + IA64_GRANULE_SIZE);
 #endif
 		return __va(md->phys_addr);
 	}
@@ -560,6 +560,7 @@ efi_init (void)
 	{
 		efi_memory_desc_t *md;
 		void *p;
+		unsigned int i;
 
 		for (i = 0, p = efi_map_start; p < efi_map_end;
 		     ++i, p += efi_desc_size)
@@ -586,7 +587,7 @@ efi_init (void)
 			}
 
 			printk("mem%02d: %s "
-			       "range=[0x%016lx-0x%016lx) (%4lu%s)\n",
+			       "range=[0x%016llx-0x%016llx) (%4lu%s)\n",
 			       i, efi_md_typeattr_format(buf, sizeof(buf), md),
 			       md->phys_addr,
 			       md->phys_addr + efi_md_size(md), size, unit);
-- 
2.30.2



