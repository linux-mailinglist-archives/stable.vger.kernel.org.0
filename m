Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DE425FF302
	for <lists+stable@lfdr.de>; Sat, 16 Nov 2019 17:22:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727532AbfKPQWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 16 Nov 2019 11:22:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:46996 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728589AbfKPPnI (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 16 Nov 2019 10:43:08 -0500
Received: from sasha-vm.mshome.net (unknown [50.234.116.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4365B2073B;
        Sat, 16 Nov 2019 15:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573918987;
        bh=JBQjh57E1Ndhk4dCtXRsycP+umjDUfzghAGmYQhFalo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DiCle8aVQ1+TFNBe0ZGRZPqYP4/raLrYW0l2u6KLVSQl0cp1rmn2Uf7DCsgz8WU8J
         wjmdOfT2XldSn1JGK88lG8dt+yAhEkTISCLTQauaM4XLaHDdS0XITE9kzUO752iy/S
         NHwOo+QPdJuqMIr6dgH2vzTMoSLjx7OAushChkzw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: [PATCH AUTOSEL 4.19 093/237] powerpc/mm/radix: Fix overuse of small pages in splitting logic
Date:   Sat, 16 Nov 2019 10:38:48 -0500
Message-Id: <20191116154113.7417-93-sashal@kernel.org>
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

[ Upstream commit 3b5657ed5b4e27ccf593a41ff3c5aa27dae8df18 ]

When we have CONFIG_STRICT_KERNEL_RWX enabled, we want to split the
linear mapping at the text/data boundary so we can map the kernel text
read only.

But the current logic uses small pages for the entire text section,
regardless of whether a larger page size would fit. eg. with the
boundary at 16M we could use 2M pages, but instead we use 64K pages up
to the 16M boundary:

  Mapped 0x0000000000000000-0x0000000001000000 with 64.0 KiB pages
  Mapped 0x0000000001000000-0x0000000040000000 with 2.00 MiB pages
  Mapped 0x0000000040000000-0x0000000100000000 with 1.00 GiB pages

This is because the test is checking if addr is < __init_begin
and addr + mapping_size is >= _stext. But that is true for all pages
between _stext and __init_begin.

Instead what we want to check is if we are crossing the text/data
boundary, which is at __init_begin. With that fixed we see:

  Mapped 0x0000000000000000-0x0000000000e00000 with 2.00 MiB pages
  Mapped 0x0000000000e00000-0x0000000001000000 with 64.0 KiB pages
  Mapped 0x0000000001000000-0x0000000040000000 with 2.00 MiB pages
  Mapped 0x0000000040000000-0x0000000100000000 with 1.00 GiB pages

ie. we're correctly using 2MB pages below __init_begin, but we still
drop down to 64K pages unnecessarily at the boundary.

Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/pgtable-radix.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/mm/pgtable-radix.c b/arch/powerpc/mm/pgtable-radix.c
index 24a2eadc8c21a..b387c7b917b7e 100644
--- a/arch/powerpc/mm/pgtable-radix.c
+++ b/arch/powerpc/mm/pgtable-radix.c
@@ -295,14 +295,14 @@ static int __meminit create_physical_mapping(unsigned long start,
 
 		if (split_text_mapping && (mapping_size == PUD_SIZE) &&
 			(addr < __pa_symbol(__init_begin)) &&
-			(addr + mapping_size) >= __pa_symbol(_stext)) {
+			(addr + mapping_size) >= __pa_symbol(__init_begin)) {
 			max_mapping_size = PMD_SIZE;
 			goto retry;
 		}
 
 		if (split_text_mapping && (mapping_size == PMD_SIZE) &&
 		    (addr < __pa_symbol(__init_begin)) &&
-		    (addr + mapping_size) >= __pa_symbol(_stext)) {
+		    (addr + mapping_size) >= __pa_symbol(__init_begin)) {
 			mapping_size = PAGE_SIZE;
 			psize = mmu_virtual_psize;
 		}
-- 
2.20.1

