Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 220951F2D35
	for <lists+stable@lfdr.de>; Tue,  9 Jun 2020 02:33:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729566AbgFIAb2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Jun 2020 20:31:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:36522 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728582AbgFHXPb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Jun 2020 19:15:31 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74CE620872;
        Mon,  8 Jun 2020 23:15:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591658131;
        bh=ROkDuAVEAX5iprg27/OAqxRmFR4g+xJwM9tn3TX5o7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Md1E2cuGJA1uRpi9TJDRoRad33v4fq0h8wEt8zF/IKac2OYjcJYdYybCojuvIToFi
         iJmv2K7yLQoL4WjQdGcfjP1aKOe2Z6P04anJZ1IgiOIXIgVj1cHsxXun3jB05o1eQq
         zskhFM2EdiQerSberAgHlkr2pyMzUtkEWykXUnMM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sasha Levin <sashal@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Christoph Hellwig <hch@lst.de>,
        Ludovic Barre <ludovic.barre@st.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH AUTOSEL 5.6 166/606] Revert "driver core: platform: Initialize dma_parms for platform devices"
Date:   Mon,  8 Jun 2020 19:04:51 -0400
Message-Id: <20200608231211.3363633-166-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200608231211.3363633-1-sashal@kernel.org>
References: <20200608231211.3363633-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 1d2a14649ef5b5eb64ea5ce276d7df502bac4dbe ]

[ Upstream commit 885a64715fd81e6af6d94a038556e0b2e6deb19c ]

This reverts commit 7c8978c0837d40c302f5e90d24c298d9ca9fc097, a new
version will come in the next release cycle.

Cc: <stable@vger.kernel.org>
Cc: Russell King <linux@armlinux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Ludovic Barre <ludovic.barre@st.com>
Cc: Linus Walleij <linus.walleij@linaro.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/platform.c         | 2 --
 include/linux/platform_device.h | 1 -
 2 files changed, 3 deletions(-)

diff --git a/drivers/base/platform.c b/drivers/base/platform.c
index c81b68d5d66d..b5ce7b085795 100644
--- a/drivers/base/platform.c
+++ b/drivers/base/platform.c
@@ -361,8 +361,6 @@ struct platform_object {
  */
 static void setup_pdev_dma_masks(struct platform_device *pdev)
 {
-	pdev->dev.dma_parms = &pdev->dma_parms;
-
 	if (!pdev->dev.coherent_dma_mask)
 		pdev->dev.coherent_dma_mask = DMA_BIT_MASK(32);
 	if (!pdev->dev.dma_mask) {
diff --git a/include/linux/platform_device.h b/include/linux/platform_device.h
index 81900b3cbe37..041bfa412aa0 100644
--- a/include/linux/platform_device.h
+++ b/include/linux/platform_device.h
@@ -25,7 +25,6 @@ struct platform_device {
 	bool		id_auto;
 	struct device	dev;
 	u64		platform_dma_mask;
-	struct device_dma_parameters dma_parms;
 	u32		num_resources;
 	struct resource	*resource;
 
-- 
2.25.1

