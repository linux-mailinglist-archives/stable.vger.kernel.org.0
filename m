Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C7035658222
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:33:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233760AbiL1QdX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:33:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234730AbiL1Qc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:32:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A4EC1ADAD
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:30:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F4224B81729
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:30:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B763C433EF;
        Wed, 28 Dec 2022 16:30:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672245009;
        bh=vKaZSK5O3xjBuWvuSPFnIXobmetEYXklgh6CZ0eCcC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uH3MZVsJLiV7I2Vvr30uEwnhvQPBWDosJeNRYJHBaozbcqqmpGpDU6T9zZiikPv7E
         4+mxzkI9sJIttVsYgUgvbfST1G2fgsrRnY7fNMxunMs0xdNSsenEDAAkG5E8P+oZZz
         FyvsCXm+OdeCwx2rkIennTN+EOpTT/KX6DpDe5So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jason Gunthorpe <jgg@nvidia.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Joerg Roedel <jroedel@suse.de>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0815/1073] iommu/sun50i: Remove IOMMU_DOMAIN_IDENTITY
Date:   Wed, 28 Dec 2022 15:40:03 +0100
Message-Id: <20221228144350.145451244@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jason Gunthorpe <jgg@nvidia.com>

[ Upstream commit ef5bb8e7a7127218f826b9ccdf7508e7a339f4c2 ]

This driver treats IOMMU_DOMAIN_IDENTITY the same as UNMANAGED, which
cannot possibly be correct.

UNMANAGED domains are required to start out blocking all DMAs. This seems
to be what this driver does as it allocates a first level 'dt' for the IO
page table that is 0 filled.

Thus UNMANAGED looks like a working IO page table, and so IDENTITY must be
a mistake. Remove it.

Fixes: 4100b8c229b3 ("iommu: Add Allwinner H6 IOMMU driver")
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Reviewed-by: Robin Murphy <robin.murphy@arm.com>
Link: https://lore.kernel.org/r/0-v1-97f0adf27b5e+1f0-s50_identity_jgg@nvidia.com
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/sun50i-iommu.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/iommu/sun50i-iommu.c b/drivers/iommu/sun50i-iommu.c
index d7c5e9b1a087..1d81a6aa939b 100644
--- a/drivers/iommu/sun50i-iommu.c
+++ b/drivers/iommu/sun50i-iommu.c
@@ -672,7 +672,6 @@ static struct iommu_domain *sun50i_iommu_domain_alloc(unsigned type)
 	struct sun50i_iommu_domain *sun50i_domain;
 
 	if (type != IOMMU_DOMAIN_DMA &&
-	    type != IOMMU_DOMAIN_IDENTITY &&
 	    type != IOMMU_DOMAIN_UNMANAGED)
 		return NULL;
 
-- 
2.35.1



