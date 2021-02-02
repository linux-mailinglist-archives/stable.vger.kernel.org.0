Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EAAD530CBDD
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 20:41:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239908AbhBBThT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 14:37:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:43136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233345AbhBBNzM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 08:55:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6669B64FD9;
        Tue,  2 Feb 2021 13:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612273488;
        bh=go4SPvgeIuHW/8Lu/BFVhDHVezjnaaH4IC5azLhxwIc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ss0HJKx6Kqr9oHCSYsNDm8f3fGSGctEQTFv44g9w6HQv0gFYl709Va6IzvGd5xv85
         VxmFyAgMOpe50jMEOmA0l9nxBtp0DcQR7SbK+/CFjIVXd/bUhhAclxevZ+9Je4O/kn
         KjM8Ql4tqahuMBAnOPzgCy7BnB3c4BQJ/l9Id1cQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Moritz Fischer <mdf@kernel.org>,
        Robin Murphy <robin.murphy@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 126/142] ACPI/IORT: Do not blindly trust DMA masks from firmware
Date:   Tue,  2 Feb 2021 14:38:09 +0100
Message-Id: <20210202133002.896592479@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210202132957.692094111@linuxfoundation.org>
References: <20210202132957.692094111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Moritz Fischer <mdf@kernel.org>

[ Upstream commit a1df829ead5877d4a1061e976a50e2e665a16f24 ]

Address issue observed on real world system with suboptimal IORT table
where DMA masks of PCI devices would get set to 0 as result.

iort_dma_setup() would query the root complex'/named component IORT
entry for a DMA mask, and use that over the one the device has been
configured with earlier.

Ideally we want to use the minimum mask of what the IORT contains for
the root complex and what the device was configured with.

Fixes: 5ac65e8c8941 ("ACPI/IORT: Support address size limit for root complexes")
Signed-off-by: Moritz Fischer <mdf@kernel.org>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Acked-by: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
Link: https://lore.kernel.org/r/20210122012419.95010-1-mdf@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/arm64/iort.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/arm64/iort.c b/drivers/acpi/arm64/iort.c
index 770d84071a328..94f34109695c9 100644
--- a/drivers/acpi/arm64/iort.c
+++ b/drivers/acpi/arm64/iort.c
@@ -1107,6 +1107,11 @@ static int nc_dma_get_range(struct device *dev, u64 *size)
 
 	ncomp = (struct acpi_iort_named_component *)node->node_data;
 
+	if (!ncomp->memory_address_limit) {
+		pr_warn(FW_BUG "Named component missing memory address limit\n");
+		return -EINVAL;
+	}
+
 	*size = ncomp->memory_address_limit >= 64 ? U64_MAX :
 			1ULL<<ncomp->memory_address_limit;
 
@@ -1126,6 +1131,11 @@ static int rc_dma_get_range(struct device *dev, u64 *size)
 
 	rc = (struct acpi_iort_root_complex *)node->node_data;
 
+	if (!rc->memory_address_limit) {
+		pr_warn(FW_BUG "Root complex missing memory address limit\n");
+		return -EINVAL;
+	}
+
 	*size = rc->memory_address_limit >= 64 ? U64_MAX :
 			1ULL<<rc->memory_address_limit;
 
@@ -1173,8 +1183,8 @@ void iort_dma_setup(struct device *dev, u64 *dma_addr, u64 *dma_size)
 		end = dmaaddr + size - 1;
 		mask = DMA_BIT_MASK(ilog2(end) + 1);
 		dev->bus_dma_limit = end;
-		dev->coherent_dma_mask = mask;
-		*dev->dma_mask = mask;
+		dev->coherent_dma_mask = min(dev->coherent_dma_mask, mask);
+		*dev->dma_mask = min(*dev->dma_mask, mask);
 	}
 
 	*dma_addr = dmaaddr;
-- 
2.27.0



