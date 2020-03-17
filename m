Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 910031881E6
	for <lists+stable@lfdr.de>; Tue, 17 Mar 2020 12:21:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727466AbgCQK7e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Mar 2020 06:59:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:38084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726484AbgCQK7d (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Mar 2020 06:59:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F71F2071C;
        Tue, 17 Mar 2020 10:59:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584442772;
        bh=W7m8I0W5QGkkJExlg6OH8ER9RwjZ/AsI4j8yc/030EY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UVlpwHHzP0YRd0PCaqCf6hLfQwnIK3MdL807nTx3u49EFBeAGxHVD2+nIogGbozfA
         SqCoBUn96PqcnQV4lVUxuFm+sDewO08b48yf1nMZnC6MYAPQdL1Nzay5ORviGhMUOV
         4cGXNFrrCLySNphezsu0kUVOFNOoyG0wSGQDRTdo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Moritz Fischer <mdf@kernel.org>,
        Yonghyun Hwang <yonghyun@google.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.19 69/89] iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page
Date:   Tue, 17 Mar 2020 11:55:18 +0100
Message-Id: <20200317103307.898438830@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200317103259.744774526@linuxfoundation.org>
References: <20200317103259.744774526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghyun Hwang <yonghyun@google.com>

commit 77a1bce84bba01f3f143d77127b72e872b573795 upstream.

intel_iommu_iova_to_phys() has a bug when it translates an IOVA for a huge
page onto its corresponding physical address. This commit fixes the bug by
accomodating the level of page entry for the IOVA and adds IOVA's lower
address to the physical address.

Cc: <stable@vger.kernel.org>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Reviewed-by: Moritz Fischer <mdf@kernel.org>
Signed-off-by: Yonghyun Hwang <yonghyun@google.com>
Fixes: 3871794642579 ("VT-d: Changes to support KVM")
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5144,8 +5144,10 @@ static phys_addr_t intel_iommu_iova_to_p
 	u64 phys = 0;
 
 	pte = pfn_to_dma_pte(dmar_domain, iova >> VTD_PAGE_SHIFT, &level);
-	if (pte)
-		phys = dma_pte_addr(pte);
+	if (pte && dma_pte_present(pte))
+		phys = dma_pte_addr(pte) +
+			(iova & (BIT_MASK(level_to_offset_bits(level) +
+						VTD_PAGE_SHIFT) - 1));
 
 	return phys;
 }


