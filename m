Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EAF60A8C23
	for <lists+stable@lfdr.de>; Wed,  4 Sep 2019 21:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731666AbfIDQKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 4 Sep 2019 12:10:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:36110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732868AbfIDQBB (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 4 Sep 2019 12:01:01 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B3E072341C;
        Wed,  4 Sep 2019 16:00:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567612860;
        bh=F5CQ1+YvvSFo1TXnBiXKLipZLDPWDY9aNPbQDEsQ2n0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rGO/8ah+la9taMk6jwiEMxs3YA2GFORtg44hxnMU6+BEm2l1EdEYm6Yq6YwIfhvQ5
         7TX0OTSVbb19hANC1oruMN4Q88kXSUOmNbut5OP7bkhaKxY+zwzuNXqCclintXDuUe
         ShG33QjZDMnGmh40rbPNJ/cPsvBXgV54HMNx1X70=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nagarjuna Kristam <nkristam@nvidia.com>,
        Thierry Reding <treding@nvidia.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-usb@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 39/52] usb: host: xhci-tegra: Set DMA mask correctly
Date:   Wed,  4 Sep 2019 11:59:51 -0400
Message-Id: <20190904160004.3671-39-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190904160004.3671-1-sashal@kernel.org>
References: <20190904160004.3671-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index b1cce989bd123..fe37dacc695fc 100644
--- a/drivers/usb/host/xhci-tegra.c
+++ b/drivers/usb/host/xhci-tegra.c
@@ -1148,6 +1148,16 @@ static int tegra_xusb_probe(struct platform_device *pdev)
 
 	tegra_xusb_ipfs_config(tegra, regs);
 
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

