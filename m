Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA57026B45E
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:22:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727437AbgIOXWY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:22:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:48800 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727205AbgIOOiG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:38:06 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AFF0523BF0;
        Tue, 15 Sep 2020 14:28:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600180094;
        bh=KSyvzOcpC3ZDVAqUAEqom48/2QAjeD5TFMKttdGjgrI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UL17d0/AIvFuQY11ZPVq2GS6AcT+YdAlSsUcOk9i3q/shnNvqne2vxwZutyb5Gpke
         I1PCRZNVCvn0xcLxj+fG9aMBSKz8ry0lwnJ5P6TyAYVpnvM1Re9nXRzTjSDzVlMrY3
         PXTPOHKZFM91u1INARzg6LdlLgmi+NC3x8ts9uKY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 106/177] iommu/amd: Do not force direct mapping when SME is active
Date:   Tue, 15 Sep 2020 16:12:57 +0200
Message-Id: <20200915140658.731123376@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 7cad554887f1c5fd77e57e6bf4be38370c2160cb ]

Do not force devices supporting IOMMUv2 to be direct mapped when memory
encryption is active. This might cause them to be unusable because their
DMA mask does not include the encryption bit.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200824105415.21000-2-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd/iommu.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/iommu/amd/iommu.c b/drivers/iommu/amd/iommu.c
index 200ee948f6ec1..37c74c842f3a3 100644
--- a/drivers/iommu/amd/iommu.c
+++ b/drivers/iommu/amd/iommu.c
@@ -2650,7 +2650,12 @@ static int amd_iommu_def_domain_type(struct device *dev)
 	if (!dev_data)
 		return 0;
 
-	if (dev_data->iommu_v2)
+	/*
+	 * Do not identity map IOMMUv2 capable devices when memory encryption is
+	 * active, because some of those devices (AMD GPUs) don't have the
+	 * encryption bit in their DMA-mask and require remapping.
+	 */
+	if (!mem_encrypt_active() && dev_data->iommu_v2)
 		return IOMMU_DOMAIN_IDENTITY;
 
 	return 0;
-- 
2.25.1



