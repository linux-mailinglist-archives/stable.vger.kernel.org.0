Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82AAA469D5D
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:33:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378382AbhLFP3U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:29:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1385770AbhLFPZs (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:25:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8E7EC08EC37;
        Mon,  6 Dec 2021 07:15:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6E6C4B81154;
        Mon,  6 Dec 2021 15:15:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52C2C341C7;
        Mon,  6 Dec 2021 15:15:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638803753;
        bh=qLE1sVRzJypqraWu05K6YqnHauSd7DGbUmMaCeixQhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GRaEirm1jYbRUy0lG3Eq7aRDnYrrL2Ceg8pyW29sEc9y1Tmng0Q/BfkNg5jEFhymH
         5wA6hzZFoytB5xhR8YcuBNC2TV0WpTMA69Yd+hNmHmu5iK/vJzAzXjDYfD6bF919oO
         V3Dh8jl1NpfiK6NhVsQWkjKKDEn3hgUlIZ75EEVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 007/130] powerpc/pseries/ddw: Revert "Extend upper limit for huge DMA window for persistent memory"
Date:   Mon,  6 Dec 2021 15:55:24 +0100
Message-Id: <20211206145559.867146408@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145559.607158688@linuxfoundation.org>
References: <20211206145559.607158688@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexey Kardashevskiy <aik@ozlabs.ru>

[ Upstream commit 2d33f5504490a9d90924476dbccd4a5349ee1ad0 ]

This reverts commit 54fc3c681ded9437e4548e2501dc1136b23cfa9a
which does not allow 1:1 mapping even for the system RAM which
is usually possible.

Signed-off-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20211108040320.3857636-2-aik@ozlabs.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index e4198700ed1a3..245f1f8df6563 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1034,15 +1034,6 @@ static phys_addr_t ddw_memory_hotplug_max(void)
 	phys_addr_t max_addr = memory_hotplug_max();
 	struct device_node *memory;
 
-	/*
-	 * The "ibm,pmemory" can appear anywhere in the address space.
-	 * Assuming it is still backed by page structs, set the upper limit
-	 * for the huge DMA window as MAX_PHYSMEM_BITS.
-	 */
-	if (of_find_node_by_type(NULL, "ibm,pmemory"))
-		return (sizeof(phys_addr_t) * 8 <= MAX_PHYSMEM_BITS) ?
-			(phys_addr_t) -1 : (1ULL << MAX_PHYSMEM_BITS);
-
 	for_each_node_by_type(memory, "memory") {
 		unsigned long start, size;
 		int n_mem_addr_cells, n_mem_size_cells, len;
-- 
2.33.0



