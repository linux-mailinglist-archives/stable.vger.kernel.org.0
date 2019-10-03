Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C25B8CA721
	for <lists+stable@lfdr.de>; Thu,  3 Oct 2019 18:57:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2393104AbfJCQu4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Oct 2019 12:50:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393016AbfJCQuy (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Oct 2019 12:50:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1274620865;
        Thu,  3 Oct 2019 16:50:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570121453;
        bh=M6VcYHds2t3Z7mJRluXiW0l6s3aloK5gfnKNOcKV3R4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nogjFYfSD5hBagKQT72iIEZRrYvpsYxQdVohVrPtnYyZ9il29OrdwXYPuvKwNTyIk
         wDB+VrKnPQEViMnEOJ9ZfRwTXiPX4w1LtC41PKVA08ZJNQ16VMwXq3+8JPEVEhOu1O
         CDuYwV2AvzdReNf3OJf0KJBROm5u/DMxSsWaUzj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robin Murphy <robin.murphy@arm.com>,
        Will Deacon <will@kernel.org>
Subject: [PATCH 5.3 284/344] iommu/arm-smmu-v3: Disable detection of ATS and PRI
Date:   Thu,  3 Oct 2019 17:54:09 +0200
Message-Id: <20191003154607.910791690@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191003154540.062170222@linuxfoundation.org>
References: <20191003154540.062170222@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Will Deacon <will@kernel.org>

commit b5e86196b83fd68e065a7c811ab8925fb0dc3893 upstream.

Detecting the ATS capability of the SMMU at probe time introduces a
spinlock into the ->unmap() fast path, even when ATS is not actually
in use. Furthermore, the ATC invalidation that exists is broken, as it
occurs before invalidation of the main SMMU TLB which leaves a window
where the ATC can be repopulated with stale entries.

Given that ATS is both a new feature and a specialist sport, disable it
for now whilst we fix it properly in subsequent patches. Since PRI
requires ATS, disable that too.

Cc: <stable@vger.kernel.org>
Fixes: 9ce27afc0830 ("iommu/arm-smmu-v3: Add support for PCI ATS")
Acked-by: Robin Murphy <robin.murphy@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iommu/arm-smmu-v3.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/iommu/arm-smmu-v3.c
+++ b/drivers/iommu/arm-smmu-v3.c
@@ -2843,11 +2843,13 @@ static int arm_smmu_device_hw_probe(stru
 	}
 
 	/* Boolean feature flags */
+#if 0	/* ATS invalidation is slow and broken */
 	if (IS_ENABLED(CONFIG_PCI_PRI) && reg & IDR0_PRI)
 		smmu->features |= ARM_SMMU_FEAT_PRI;
 
 	if (IS_ENABLED(CONFIG_PCI_ATS) && reg & IDR0_ATS)
 		smmu->features |= ARM_SMMU_FEAT_ATS;
+#endif
 
 	if (reg & IDR0_SEV)
 		smmu->features |= ARM_SMMU_FEAT_SEV;


