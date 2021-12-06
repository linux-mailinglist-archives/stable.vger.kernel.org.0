Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B22C7469E66
	for <lists+stable@lfdr.de>; Mon,  6 Dec 2021 16:39:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348881AbhLFPiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 Dec 2021 10:38:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59832 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348901AbhLFPgL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 6 Dec 2021 10:36:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F033AC08EA50;
        Mon,  6 Dec 2021 07:21:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9ADA2B8101C;
        Mon,  6 Dec 2021 15:21:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2BBEC341C9;
        Mon,  6 Dec 2021 15:21:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638804066;
        bh=Jv3BnxnFmO1k1pQIMOFHGj4dfinV+FM4fH8EKjVIP4s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gWzKSEH6uowR0gDf53xkN03YkRcqy/9QkG39shftri4PbHignpWRLI3MSJDb97vEO
         gGHbmfMgHXRTrOVYw03BFqC42V7kPw0Dyl32GZqSeielnkCHgpmmz/vz8MWrynaaRr
         EKW2v0X20PrEF4pHvFm55tgTD0gQh1aMvf7xA9qE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 015/207] powerpc/pseries/ddw: Revert "Extend upper limit for huge DMA window for persistent memory"
Date:   Mon,  6 Dec 2021 15:54:29 +0100
Message-Id: <20211206145610.728422630@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211206145610.172203682@linuxfoundation.org>
References: <20211206145610.172203682@linuxfoundation.org>
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
index a52af8fbf5711..ad96d6e13d1f6 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1092,15 +1092,6 @@ static phys_addr_t ddw_memory_hotplug_max(void)
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



