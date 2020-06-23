Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1B3B4206344
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:29:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389982AbgFWUU5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:20:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:38406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387771AbgFWUUz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:20:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 903D9206C3;
        Tue, 23 Jun 2020 20:20:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592943655;
        bh=4hMKVjlVproshcN/Edkim4wPjbOfJOron7b84ERO0RE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DoNZoxPBG3/kJr7N31F5jBz8Ec3GbTZHWkqbk+cfKJAF4gfA1MXvsUwKT/Ik5fIN/
         pAAMMzdlkUW5L8Xn2G12mCTCxVGD2eqK2ZPc7BfEdwijs2dNONHaDqjKfePPmNUB+f
         xJj5+NtfweITaV2h+LIbgIndXm3onUkducrnH448=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Derrick <jonathan.derrick@intel.com>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        Joerg Roedel <jroedel@suse.de>,
        Sushma Kalakota <sushmax.kalakota@intel.com>
Subject: [PATCH 5.7 477/477] iommu/vt-d: Remove real DMA lookup in find_domain
Date:   Tue, 23 Jun 2020 21:57:54 +0200
Message-Id: <20200623195430.097419726@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195407.572062007@linuxfoundation.org>
References: <20200623195407.572062007@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Derrick <jonathan.derrick@intel.com>

commit bba9cc2cf82840bd3c9b3f4f7edac2dc8329c241 upstream.

By removing the real DMA indirection in find_domain(), we can allow
sub-devices of a real DMA device to have their own valid
device_domain_info. The dmar lookup and context entry removal paths have
been fixed to account for sub-devices.

Fixes: 2b0140c69637 ("iommu/vt-d: Use pci_real_dma_dev() for mapping")
Signed-off-by: Jon Derrick <jonathan.derrick@intel.com>
Acked-by: Lu Baolu <baolu.lu@linux.intel.com>
Link: https://lore.kernel.org/r/20200527165617.297470-4-jonathan.derrick@intel.com
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207575
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sushma Kalakota <sushmax.kalakota@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/intel-iommu.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -2518,9 +2518,6 @@ struct dmar_domain *find_domain(struct d
 	if (unlikely(attach_deferred(dev) || iommu_dummy(dev)))
 		return NULL;
 
-	if (dev_is_pci(dev))
-		dev = &pci_real_dma_dev(to_pci_dev(dev))->dev;
-
 	/* No lock here, assumes no domain exit in normal case */
 	info = dev->archdata.iommu;
 	if (likely(info))


