Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9034D383859
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:51:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245404AbhEQPv4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:51:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344018AbhEQPtq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:49:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DACFB6143C;
        Mon, 17 May 2021 14:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262728;
        bh=JaP8JF+iAXaoiUiigp6hkLEMLv2p2rM5QI0GfBWiHJM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b/0ZNka8zfFg1HRtaH3Fm7N4rKWRFBsd8JAXFcB7nVMX686lorQPpSF4jp4wMcTqb
         meYiCZUtWnnFk8DKMgi6UucTi3Xb9qbTH724u4V3c9NzjHX349n7hgLbwa2olR/m1m
         0Gr8ag8IYfTc7hZCM4VQ4sEyg7A9W84AOzL1mKGI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Ashok Raj <ashok.raj@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 5.10 264/289] iommu/vt-d: Remove WO permissions on second-level paging entries
Date:   Mon, 17 May 2021 16:03:09 +0200
Message-Id: <20210517140314.031244314@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140305.140529752@linuxfoundation.org>
References: <20210517140305.140529752@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lu Baolu <baolu.lu@linux.intel.com>

commit eea53c5816889ee8b64544fa2e9311a81184ff9c upstream.

When the first level page table is used for IOVA translation, it only
supports Read-Only and Read-Write permissions. The Write-Only permission
is not supported as the PRESENT bit (implying Read permission) should
always set. When using second level, we still give separate permissions
that allows WriteOnly which seems inconsistent and awkward. We want to
have consistent behavior. After moving to 1st level, we don't want things
to work sometimes, and break if we use 2nd level for the same mappings.
Hence remove this configuration.

Suggested-by: Ashok Raj <ashok.raj@intel.com>
Fixes: b802d070a52a1 ("iommu/vt-d: Use iova over first level")
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20210320025415.641201-3-baolu.lu@linux.intel.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/iommu.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iommu/intel/iommu.c
+++ b/drivers/iommu/intel/iommu.c
@@ -2362,8 +2362,9 @@ static int __domain_mapping(struct dmar_
 		return -EINVAL;
 
 	attr = prot & (DMA_PTE_READ | DMA_PTE_WRITE | DMA_PTE_SNP);
+	attr |= DMA_FL_PTE_PRESENT;
 	if (domain_use_first_level(domain)) {
-		attr |= DMA_FL_PTE_PRESENT | DMA_FL_PTE_XD | DMA_FL_PTE_US;
+		attr |= DMA_FL_PTE_XD | DMA_FL_PTE_US;
 
 		if (domain->domain.type == IOMMU_DOMAIN_DMA) {
 			attr |= DMA_FL_PTE_ACCESS;


