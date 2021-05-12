Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD6E37CE9B
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 19:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345042AbhELRF6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 13:05:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:43882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234759AbhELQqw (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 12:46:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5ABE361C79;
        Wed, 12 May 2021 16:15:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620836108;
        bh=28Xy0yGesv1npO/6p7GtuwHjGranM2ozuAzC5ZMcBGM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=abSs/uSF9gZ1oJU1mApmprkrUVjsZCPCTnTHqFy7Y/kgHyqOrR/L3TG5OvtCa/TuN
         mGQBQOYxOcIXMytpYic1rkFiNEfB60IMf16u79aOOxfYwMa6vkeVPT6+6loEfDPUac
         spo1oEkF4qjlXq49XyUEq1YfK7mqZpBQWKalboFw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Leonardo Bras <leobras.c@gmail.com>,
        Alexey Kardashevskiy <aik@ozlabs.ru>,
        Michael Ellerman <mpe@ellerman.id.au>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 614/677] powerpc/pseries/iommu: Fix window size for direct mapping with pmem
Date:   Wed, 12 May 2021 16:51:00 +0200
Message-Id: <20210512144857.773392341@linuxfoundation.org>
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

From: Leonardo Bras <leobras.c@gmail.com>

[ Upstream commit a9d2f9bb225fd2a764aef57738ab6c7f38d782ae ]

As of today, if the DDW is big enough to fit (1 << MAX_PHYSMEM_BITS)
it's possible to use direct DMA mapping even with pmem region.

But, if that happens, the window size (len) is set to (MAX_PHYSMEM_BITS
- page_shift) instead of MAX_PHYSMEM_BITS, causing a pagesize times
smaller DDW to be created, being insufficient for correct usage.

Fix this so the correct window size is used in this case.

Fixes: bf6e2d562bbc4 ("powerpc/dma: Fallback to dma_ops when persistent memory present")
Signed-off-by: Leonardo Bras <leobras.c@gmail.com>
Reviewed-by: Alexey Kardashevskiy <aik@ozlabs.ru>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20210420045404.438735-1-leobras.c@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/platforms/pseries/iommu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/platforms/pseries/iommu.c b/arch/powerpc/platforms/pseries/iommu.c
index 9fc5217f0c8e..836cbbe0ecc5 100644
--- a/arch/powerpc/platforms/pseries/iommu.c
+++ b/arch/powerpc/platforms/pseries/iommu.c
@@ -1229,7 +1229,7 @@ static u64 enable_ddw(struct pci_dev *dev, struct device_node *pdn)
 	if (pmem_present) {
 		if (query.largest_available_block >=
 		    (1ULL << (MAX_PHYSMEM_BITS - page_shift)))
-			len = MAX_PHYSMEM_BITS - page_shift;
+			len = MAX_PHYSMEM_BITS;
 		else
 			dev_info(&dev->dev, "Skipping ibm,pmemory");
 	}
-- 
2.30.2



