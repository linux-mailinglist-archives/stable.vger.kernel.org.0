Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CDFF26B721
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 02:17:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbgIPARx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 20:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726885AbgIOOWr (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:22:47 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0EC4A22275;
        Tue, 15 Sep 2020 14:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179458;
        bh=WrnlAqu4pYVCGlc1rGq/4Sm+z4IbESJor4R40Xlh220=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z2IPMIHUrSa14G7F4u/NK0PR2/MWSpSoRM/Dd5ebu0qvebfKsTwad7Sm+8SPE3tjh
         hJqlhYurbI0su8r+DhnJFpWPuh5qWMO4njXy/BM6B4umIMEspazF8GP4AB27nIeRHh
         GT8AZtR/RCdmCGCyV8HBwWTywwpWTi6BD0DdmfUQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Joerg Roedel <jroedel@suse.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 38/78] iommu/amd: Do not use IOMMUv2 functionality when SME is active
Date:   Tue, 15 Sep 2020 16:13:03 +0200
Message-Id: <20200915140635.495652007@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140633.552502750@linuxfoundation.org>
References: <20200915140633.552502750@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Joerg Roedel <jroedel@suse.de>

[ Upstream commit 2822e582501b65707089b097e773e6fd70774841 ]

When memory encryption is active the device is likely not in a direct
mapped domain. Forbid using IOMMUv2 functionality for now until finer
grained checks for this have been implemented.

Signed-off-by: Joerg Roedel <jroedel@suse.de>
Link: https://lore.kernel.org/r/20200824105415.21000-3-joro@8bytes.org
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/amd_iommu_v2.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/iommu/amd_iommu_v2.c b/drivers/iommu/amd_iommu_v2.c
index 58da65df03f5e..7a59a8ebac108 100644
--- a/drivers/iommu/amd_iommu_v2.c
+++ b/drivers/iommu/amd_iommu_v2.c
@@ -776,6 +776,13 @@ int amd_iommu_init_device(struct pci_dev *pdev, int pasids)
 
 	might_sleep();
 
+	/*
+	 * When memory encryption is active the device is likely not in a
+	 * direct-mapped domain. Forbid using IOMMUv2 functionality for now.
+	 */
+	if (mem_encrypt_active())
+		return -ENODEV;
+
 	if (!amd_iommu_v2_supported())
 		return -ENODEV;
 
-- 
2.25.1



