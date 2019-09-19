Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A9149B872C
	for <lists+stable@lfdr.de>; Fri, 20 Sep 2019 00:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405442AbfISWJd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Sep 2019 18:09:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:47786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405437AbfISWJc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Sep 2019 18:09:32 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 972D621907;
        Thu, 19 Sep 2019 22:09:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568930972;
        bh=2vjN1mTgWrVfPYXSq4C3quBd4Ijtnf7GY7w2gVNMFUw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cULZrZgm80e8dykXA/U6jC+zm/i0QknXbhd+rPfah7qC3Wl8kQGzgrPIJGds38aFt
         IWHSe7YV6FzzgBjfY7bi1LwJO0IyZ4Vbt9heWeLGEcM0praVKh7r2gJbpN4Vl/+Z2W
         7eEQ2g8PmnbmGYpgNF8slvrZfSgyViO8+x0IzifA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nagarjuna Kristam <nkristam@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 082/124] usb: host: xhci-tegra: Set DMA mask correctly
Date:   Fri, 20 Sep 2019 00:02:50 +0200
Message-Id: <20190919214822.000675695@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190919214819.198419517@linuxfoundation.org>
References: <20190919214819.198419517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nagarjuna Kristam <nkristam@nvidia.com>

[ Upstream commit 993cc8753453fccfe060a535bbe21fcf1001b626 ]

The Falcon microcontroller that runs the XUSB firmware and which is
responsible for exposing the XHCI interface can address only 40 bits of
memory. Typically that's not a problem because Tegra devices don't have
enough system memory to exceed those 40 bits.

However, if the ARM SMMU is enable on Tegra186 and later, the addresses
passed to the XUSB controller can be anywhere in the 48-bit IOV address
space of the ARM SMMU. Since the DMA/IOMMU API starts allocating from
the top of the IOVA space, the Falcon microcontroller is not able to
load the firmware successfully.

Fix this by setting the DMA mask to 40 bits, which will force the DMA
API to map the buffer for the firmware to an IOVA that is addressable by
the Falcon.

Signed-off-by: Nagarjuna Kristam <nkristam@nvidia.com>
Signed-off-by: Thierry Reding <treding@nvidia.com>
Link: https://lore.kernel.org/r/1566989697-13049-1-git-send-email-nkristam@nvidia.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/usb/host/xhci-tegra.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/drivers/usb/host/xhci-tegra.c b/drivers/usb/host/xhci-tegra.c
index 294158113d62c..77142f9bf26ae 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1217,6 +1217,16 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 
 	tegra_xusb_config(tegra, regs);
 
+	/*
+	 * The XUSB Falcon microcontroller can only address 40 bits, so set
+	 * the DMA mask accordingly.
+	 */
+	err = dma_set_mask_and_coherent(tegra->dev, DMA_BIT_MASK(40));
+	if (err < 0) {
+		dev_err(&pdev->dev, "failed to set DMA mask: %d\n", err);
+		goto put_rpm;
+	}
+
 	err = tegra_xusb_load_firmware(tegra);
 	if (err < 0) {
 		dev_err(&pdev->dev, "failed to load firmware: %d\n", err);
-- 
2.20.1



