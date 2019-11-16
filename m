Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9A6FFF307
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:23:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728583AbfKPPnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 10:43:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:46950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728579AbfKPPnF (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:05 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3831F2072D;
        Sat, 16 Nov 2019 15:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918985;
        bh=4VAPqQgAlJy/yPDODSgeBfqeL47lgcICU6o7du9+2sY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pigAi4HV3hUZ9Hfnq4WTOrV8P15/8RcL87RvRke9dsq0yFaMwzYM7oUoAPu+zsTP4
         ThgaN/9ntOI7pwCvwiYCeUoPIdB+ZpaHW8JRgt9ewnbtn5ynV2wLtN5l5OBividO95
         LvV2TvlI3Nw8rNFRsOtTRMKV2oARrZC8384biJGM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 092/237] powerpc/mm/radix: Fix off-by-one in split mapping logic
Date:   Sat, 16 Nov 2019 10:38:47 -0500
Message-Id: <20191116154113.7417-92-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191116154113.7417-1-sashal@kernel.org>
References: <20191116154113.7417-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Ellerman <mpe@ellerman.id.au>

[ Upstream commit 5c6499b7041b43807dfaeda28aa87fc0e62558f7 ]

When we have CONFIG_STRICT_KERNEL_RWX enabled, we try to split the
kernel linear (1:1) mapping so that the kernel text is in a separate
page to kernel data, so we can mark the former read-only.

We could achieve that just by always using 64K pages for the linear
mapping, but we try to be smarter. Instead we use huge pages when
possible, and only switch to smaller pages when necessary.

However we have an off-by-one bug in that logic, which causes us to
calculate the wrong boundary between text and data.

For example with the end of the kernel text at 16M we see:

  radix-mmu: Mapped 0x0000000000000000-0x0000000001200000 with 64.0 KiB pages
  radix-mmu: Mapped 0x0000000001200000-0x0000000040000000 with 2.00 MiB pages
  radix-mmu: Mapped 0x0000000040000000-0x0000000100000000 with 1.00 GiB pages

ie. we mapped from 0 to 18M with 64K pages, even though the boundary
between text and data is at 16M.

With the fix we see we're correctly hitting the 16M boundary:

  radix-mmu: Mapped 0x0000000000000000-0x0000000001000000 with 64.0 KiB pages
  radix-mmu: Mapped 0x0000000001000000-0x0000000040000000 with 2.00 MiB pages
  radix-mmu: Mapped 0x0000000040000000-0x0000000100000000 with 1.00 GiB pages

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/pgtable-radix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index 3ea4c1f107d7e..24a2eadc8c21a 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -294,14 +294,14 @@ static int __meminit create_physical_mapping(unsigned long start,
 		}
 
 		if (split_text_mapping && (mapping_size == PUD_SIZE) &&
-			(addr <= __pa_symbol(__init_begin)) &&
+			(addr < __pa_symbol(__init_begin)) &&
 			(addr + mapping_size) >= __pa_symbol(_stext)) {
 			max_mapping_size = PMD_SIZE;
 			goto retry;
 		}
 
 		if (split_text_mapping && (mapping_size == PMD_SIZE) &&
-		    (addr <= __pa_symbol(__init_begin)) &&
+		    (addr < __pa_symbol(__init_begin)) &&
 		    (addr + mapping_size) >= __pa_symbol(_stext)) {
 			mapping_size = PAGE_SIZE;
 			psize = mmu_virtual_psize;
-- 
2.20.1

