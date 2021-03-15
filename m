Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BBDD933BA64
	for <lists+stable@lfdr.de>; Mon, 15 Mar 2021 15:10:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230250AbhCOOJI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Mar 2021 10:09:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:49790 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230408AbhCOOD2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Mar 2021 10:03:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4604964EF3;
        Mon, 15 Mar 2021 14:03:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615817008;
        bh=3K2/gUiXGJ4t/u1MAqj4oCX1prLgPfHabLROMX+2Rjs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TUGF32q5lYjwSWbSSZVn2DnCRoJYZOQdO0TG04yNje3WD9LfpV3w5boFoP6rT5QDG
         usLrZiru0zgmoGSteBh6j68CExFUq/ArvJfxNjB/Ra9yp5/MUC5Z++8CTtKl/KF5qg
         MfhX6WmpAiN2kjOD1gdSj1QPVjEoe+yaiQlPap2s=
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
Subject: [PATCH 5.10 244/290] arm64/mm: Fix pfn_valid() for ZONE_DEVICE based memory
Date:   Mon, 15 Mar 2021 14:55:37 +0100
Message-Id: <20210315135550.253891009@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210315135541.921894249@linuxfoundation.org>
References: <20210315135541.921894249@linuxfoundation.org>
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
index b913844ab740..916e0547fdcc 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -218,6 +218,18 @@ int pfn_valid(unsigned long pfn)
 
 	if (!valid_section(__pfn_to_section(pfn)))
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



