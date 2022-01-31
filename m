Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08EDA4A4292
	for <lists+stable@lfdr.de>; Mon, 31 Jan 2022 12:12:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376312AbiAaLM2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 Jan 2022 06:12:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377578AbiAaLKM (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 31 Jan 2022 06:10:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 805D5C061748;
        Mon, 31 Jan 2022 03:10:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3CC92B82A5C;
        Mon, 31 Jan 2022 11:10:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54B5CC340E8;
        Mon, 31 Jan 2022 11:09:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643627399;
        bh=iR9hY3IqjOE1ue4iMbGK2j5YSp6jRQF+xRAFaUlFEMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xCudqSCJzPau45j6nakr4Ot9one0G4JxTKsYQZVlCnx9ANupr0mUM8N13NiV/8ZDG
         zUaeKORaMyE7r1daYwuNVWpXCgcGkavylQfFGS3AMxiBghl8499dkWuNX+RrfXW7vo
         TTI3vIzVlkQKzFHggHXJCPKHiXp0WnLryZwZXetQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.15 072/171] powerpc/32s: Allocate one 256k IBAT instead of two consecutives 128k IBATs
Date:   Mon, 31 Jan 2022 11:55:37 +0100
Message-Id: <20220131105232.471574454@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220131105229.959216821@linuxfoundation.org>
References: <20220131105229.959216821@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe Leroy <christophe.leroy@csgroup.eu>

commit 37eb7ca91b692e8e49e7dd50158349a6c8fb5b09 upstream.

Today we have the following IBATs allocated:

	---[ Instruction Block Address Translation ]---
	0: 0xc0000000-0xc03fffff 0x00000000         4M Kernel   x     m
	1: 0xc0400000-0xc05fffff 0x00400000         2M Kernel   x     m
	2: 0xc0600000-0xc06fffff 0x00600000         1M Kernel   x     m
	3: 0xc0700000-0xc077ffff 0x00700000       512K Kernel   x     m
	4: 0xc0780000-0xc079ffff 0x00780000       128K Kernel   x     m
	5: 0xc07a0000-0xc07bffff 0x007a0000       128K Kernel   x     m
	6:         -
	7:         -

The two 128K should be a single 256K instead.

When _etext is not aligned to 128Kbytes, the system will allocate
all necessary BATs to the lower 128Kbytes boundary, then allocate
an additional 128Kbytes BAT for the remaining block.

Instead, align the top to 128Kbytes so that the function directly
allocates a 256Kbytes last block:

	---[ Instruction Block Address Translation ]---
	0: 0xc0000000-0xc03fffff 0x00000000         4M Kernel   x     m
	1: 0xc0400000-0xc05fffff 0x00400000         2M Kernel   x     m
	2: 0xc0600000-0xc06fffff 0x00600000         1M Kernel   x     m
	3: 0xc0700000-0xc077ffff 0x00700000       512K Kernel   x     m
	4: 0xc0780000-0xc07bffff 0x00780000       256K Kernel   x     m
	5:         -
	6:         -
	7:         -

Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/ab58b296832b0ec650e2203200e060adbcb2677d.1637930421.git.christophe.leroy@csgroup.eu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/mm/book3s32/mmu.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/arch/powerpc/mm/book3s32/mmu.c
+++ b/arch/powerpc/mm/book3s32/mmu.c
@@ -196,18 +196,17 @@ void mmu_mark_initmem_nx(void)
 	int nb = mmu_has_feature(MMU_FTR_USE_HIGH_BATS) ? 8 : 4;
 	int i;
 	unsigned long base = (unsigned long)_stext - PAGE_OFFSET;
-	unsigned long top = (unsigned long)_etext - PAGE_OFFSET;
+	unsigned long top = ALIGN((unsigned long)_etext - PAGE_OFFSET, SZ_128K);
 	unsigned long border = (unsigned long)__init_begin - PAGE_OFFSET;
 	unsigned long size;
 
-	for (i = 0; i < nb - 1 && base < top && top - base > (128 << 10);) {
+	for (i = 0; i < nb - 1 && base < top;) {
 		size = block_size(base, top);
 		setibat(i++, PAGE_OFFSET + base, base, size, PAGE_KERNEL_TEXT);
 		base += size;
 	}
 	if (base < top) {
 		size = block_size(base, top);
-		size = max(size, 128UL << 10);
 		if ((top - base) > size) {
 			size <<= 1;
 			if (strict_kernel_rwx_enabled() && base + size > border)


