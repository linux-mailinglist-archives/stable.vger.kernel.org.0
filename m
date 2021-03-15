Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5ED2133B91E
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:06:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231964AbhCOOF1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:05:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:35186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233204AbhCOOBK (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:01:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5229C64F06;
        Mon, 15 Mar 2021 14:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615816837;
        bh=myaF3D99RkWXV3VhgdD/gmpVZL5N7dsK6TT+Ici6Uaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sRreGn2fNInIQiDIHaHKY/1hAOxXieKrDoI/KOQRo3ahCMLc9fPJyYX28FgXe/PW0
         gU+GoSFKCbJYABPWmXJfrtFwNQxmB6XGpYo8oHz+mVjbSHUKWsaLRAJPXyZ2idLYvK
         ziaI3aWGgyKihNPPfBibS56oDef/aHr5aCJ0pdD8=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Catalin Marinas <catalin.marinas@arm.com>,
        Will Deacon <will@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        linux-arm-kernel@lists.infradead.org,
        David Hildenbrand <david@redhat.com>,
        Anshuman Khandual <anshuman.khandual@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 144/168] arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory
Date:   Mon, 15 Mar 2021 14:56:16 +0100
Message-Id: <20210315135555.075374670@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135550.333963635@linuxfoundation.org>
References: <20210315135550.333963635@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Anshuman Khandual <anshuman.khandual@arm.com>

[ Upstream commit eeb0753ba27b26f609e61f9950b14f1b934fe429 ]

pfn_valid() validates a pfn but basically it checks for a valid struct page
backing for that pfn. It should always return positive for memory ranges
backed with struct page mapping. But currently pfn_valid() fails for all
ZONE_DEVICE based memory types even though they have struct page mapping.

pfn_valid() asserts that there is a memblock entry for a given pfn without
MEMBLOCK_NOMAP flag being set. The problem with ZONE_DEVICE based memory is
that they do not have memblock entries. Hence memblock_is_map_memory() will
invariably fail via memblock_search() for a ZONE_DEVICE based address. This
eventually fails pfn_valid() which is wrong. memblock_is_map_memory() needs
to be skipped for such memory ranges. As ZONE_DEVICE memory gets hotplugged
into the system via memremap_pages() called from a driver, their respective
memory sections will not have SECTION_IS_EARLY set.

Normal hotplug memory will never have MEMBLOCK_NOMAP set in their memblock
regions. Because the flag MEMBLOCK_NOMAP was specifically designed and set
for firmware reserved memory regions. memblock_is_map_memory() can just be
skipped as its always going to be positive and that will be an optimization
for the normal hotplug memory. Like ZONE_DEVICE based memory, all normal
hotplugged memory too will not have SECTION_IS_EARLY set for their sections

Skipping memblock_is_map_memory() for all non early memory sections would
fix pfn_valid() problem for ZONE_DEVICE based memory and also improve its
performance for normal hotplug memory as well.

Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Robin Murphy <robin.murphy@arm.com>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-kernel@vger.kernel.org
Acked-by: David Hildenbrand <david@redhat.com>
Fixes: 73b20c84d42d ("arm64: mm: implement pte_devmap support")
Signed-off-by: Anshuman Khandual <anshuman.khandual@arm.com>
Acked-by: Catalin Marinas <catalin.marinas@arm.com>
Link: https://lore.kernel.org/r/1614921898-4099-2-git-send-email-anshuman.khandual@arm.com
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/mm/init.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 602bd19630ff..cbcac03c0e0d 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -245,6 +245,18 @@ int pfn_valid(unsigned long pfn)
 
 	if (!valid_section(__nr_to_section(pfn_to_section_nr(pfn))))
 		return 0;
+
+	/*
+	 * ZONE_DEVICE memory does not have the memblock entries.
+	 * memblock_is_map_memory() check for ZONE_DEVICE based
+	 * addresses will always fail. Even the normal hotplugged
+	 * memory will never have MEMBLOCK_NOMAP flag set in their
+	 * memblock entries. Skip memblock search for all non early
+	 * memory sections covering all of hotplug memory including
+	 * both normal and ZONE_DEVICE based.
+	 */
+	if (!early_section(__pfn_to_section(pfn)))
+		return pfn_section_valid(__pfn_to_section(pfn), pfn);
 #endif
 	return memblock_is_map_memory(addr);
 }
-- 
2.30.1



