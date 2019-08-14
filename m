Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8E8E58DB44
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:24:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729798AbfHNRHI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:07:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:56508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729792AbfHNRHH (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:07:07 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AA8A21721;
        Wed, 14 Aug 2019 17:07:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802426;
        bh=VtbA8zZWqby0Q8Drx6N71oFgtMUHUf+gQidEJvzWYpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lnp9yVpXPh5Cme8FyTmYMW8iprfxEZnpk+NcOKdraPHnrDynq2QL43vXrf5h6NSaH
         2VPEjrDrUiAbM4Ol4F8ixBKIiZD7C9pIe79jAWEoKLAumkZyamvRjGimpzewmNW3Ow
         17C8sTSU3rCPvz3gtDm/rwkPui7cXOMgqujJMRGo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Joerg Roedel <joro@8bytes.org>,
        Lu Baolu <baolu.lu@linux.intel.com>,
        iommu@lists.linux-foundation.org, Dmitry Safonov <dima@arista.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 085/144] iommu/vt-d: Check if domain->pgd was allocated
Date:   Wed, 14 Aug 2019 19:00:41 +0200
Message-Id: <20190814165803.429413517@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165759.466811854@linuxfoundation.org>
References: <20190814165759.466811854@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 3ee9eca760e7d0b68c55813243de66bbb499dc3b ]

There is a couple of places where on domain_init() failure domain_exit()
is called. While currently domain_init() can fail only if
alloc_pgtable_page() has failed.

Make domain_exit() check if domain->pgd present, before calling
domain_unmap(), as it theoretically should crash on clearing pte entries
in dma_pte_clear_level().

Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Lu Baolu <baolu.lu@linux.intel.com>
Cc: iommu@lists.linux-foundation.org
Signed-off-by: Dmitry Safonov <dima@arista.com>
Reviewed-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/intel-iommu.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index 2101601adf57d..1ad24367373f4 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -1900,7 +1900,6 @@ static int domain_init(struct dmar_domain *domain, struct intel_iommu *iommu,
 
 static void domain_exit(struct dmar_domain *domain)
 {
-	struct page *freelist;
 
 	/* Remove associated devices and clear attached or cached domains */
 	rcu_read_lock();
@@ -1910,9 +1909,12 @@ static void domain_exit(struct dmar_domain *domain)
 	/* destroy iovas */
 	put_iova_domain(&domain->iovad);
 
-	freelist = domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
+	if (domain->pgd) {
+		struct page *freelist;
 
-	dma_free_pagelist(freelist);
+		freelist = domain_unmap(domain, 0, DOMAIN_MAX_PFN(domain->gaw));
+		dma_free_pagelist(freelist);
+	}
 
 	free_domain_mem(domain);
 }
-- 
2.20.1



