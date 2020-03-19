Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EEE018B72A
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:32:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728094AbgCSNQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:16:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:36842 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729291AbgCSNQ0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:16:26 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3B2020724;
        Thu, 19 Mar 2020 13:16:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623785;
        bh=bg/H4w9x/Y5OH3AJYyYxL/aEubN2iXPYUHMOqSsRVOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2hVyp2okG7l9QaoZEdzf6TNG4S52qzSsj8XYiBfy8v1zHY6VMQV8Ms9cMiuT84hLW
         O+Dkq8F2TV02FDIC77evaqb12YOWoPx+tkKbXXk97QnNQNcJf8cb1RFuo96JCQw6Ge
         SfFCJhnV9G1CyFu7CXmL2OX/LmDPdvXu5Mw5u6uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lu Baolu <baolu.lu@linux.intel.com>,
        Moritz Fischer <mdf@kernel.org>,
        Yonghyun Hwang <yonghyun@google.com>,
        Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 4.14 53/99] iommu/vt-d: Fix a bug in intel_iommu_iova_to_phys() for huge page
Date:   Thu, 19 Mar 2020 14:03:31 +0100
Message-Id: <20200319123957.987008616@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123941.630731708@linuxfoundation.org>
References: <20200319123941.630731708@linuxfoundation.org>
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
@@ -5124,8 +5124,10 @@ static phys_addr_t intel_iommu_iova_to_p
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


