Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518D53114AE
	for <lists+stable@lfdr.de>; Fri,  5 Feb 2021 23:14:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232761AbhBEWMB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Feb 2021 17:12:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:43230 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232727AbhBEOld (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Feb 2021 09:41:33 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C3C4D64FCF;
        Fri,  5 Feb 2021 14:09:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612534157;
        bh=cra8A94u+hPofX3vU1u/3WtQJERS54ohnojJXvInYnA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Jzl5Z04IjxnZJC1r6FTWzeHL10thSZal9vIZk4oroUgNGU2WcN2cFibJU7vXVk37S
         G47hL1y7UMev5OriIExKXwxz7tWQRvTHKTUOB3Fbt5mFH2Lkle2z84mejLl6tuxTO4
         2N6MDU5FCOwY84IC0FompTjgwQuLtnzfSZ4n6pyA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Steven Price <steven.price@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.10 10/57] iommu/io-pgtable-arm: Support coherency for Mali LPAE
Date:   Fri,  5 Feb 2021 15:06:36 +0100
Message-Id: <20210205140656.420373829@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210205140655.982616732@linuxfoundation.org>
References: <20210205140655.982616732@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Robin Murphy <robin.murphy@arm.com>

commit 728da60da7c1ec1e21ae64648e376666de3c279c upstream.

Midgard GPUs have ACE-Lite master interfaces which allows systems to
integrate them in an I/O-coherent manner. It seems that from the GPU's
viewpoint, the rest of the system is its outer shareable domain, and so
even when snoop signals are wired up, they are only emitted for outer
shareable accesses. As such, setting the TTBR_SHARE_OUTER bit does
indeed get coherent pagetable walks working nicely for the coherent
T620 in the Arm Juno SoC.

Signed-off-by: Robin Murphy <robin.murphy@arm.com>
Tested-by: Neil Armstrong <narmstrong@baylibre.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Acked-by: Will Deacon <will@kernel.org>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/8df778355378127ea7eccc9521d6427e3e48d4f2.1600780574.git.robin.murphy@arm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/io-pgtable-arm.c |   11 ++++++++++-
 1 file changed, 10 insertions(+), 1 deletion(-)

--- a/drivers/iommu/io-pgtable-arm.c
+++ b/drivers/iommu/io-pgtable-arm.c
@@ -417,7 +417,13 @@ static arm_lpae_iopte arm_lpae_prot_to_p
 				<< ARM_LPAE_PTE_ATTRINDX_SHIFT);
 	}
 
-	if (prot & IOMMU_CACHE)
+	/*
+	 * Also Mali has its own notions of shareability wherein its Inner
+	 * domain covers the cores within the GPU, and its Outer domain is
+	 * "outside the GPU" (i.e. either the Inner or System domain in CPU
+	 * terms, depending on coherency).
+	 */
+	if (prot & IOMMU_CACHE && data->iop.fmt != ARM_MALI_LPAE)
 		pte |= ARM_LPAE_PTE_SH_IS;
 	else
 		pte |= ARM_LPAE_PTE_SH_OS;
@@ -1021,6 +1027,9 @@ arm_mali_lpae_alloc_pgtable(struct io_pg
 	cfg->arm_mali_lpae_cfg.transtab = virt_to_phys(data->pgd) |
 					  ARM_MALI_LPAE_TTBR_READ_INNER |
 					  ARM_MALI_LPAE_TTBR_ADRMODE_TABLE;
+	if (cfg->coherent_walk)
+		cfg->arm_mali_lpae_cfg.transtab |= ARM_MALI_LPAE_TTBR_SHARE_OUTER;
+
 	return &data->iop;
 
 out_free_data:


