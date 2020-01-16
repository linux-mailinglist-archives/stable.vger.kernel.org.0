Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD7713E19C
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729882AbgAPQrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:56976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729862AbgAPQrO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:47:14 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DA502207FF;
        Thu, 16 Jan 2020 16:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193234;
        bh=9vrH7eGOuyb/R/jiwPq/xiEbrRzRYIOG8/WpfWE1YTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yDP/cl00kURY0MmPHmozWNhpgdoRvQIJ9I5ayn6Tr2VO0BtNTpVUhLDGlh7WuAL5q
         6x9jVc/mDGKRVQ5gcIurimJsMUJM87g7mGmBR0BQbTC+P5RAKzS+kqU+9e7JGkVmfn
         GeTWaR7aCrv0V94OaQR6nLN2G4vL2pFIfAr3ix20=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sam Ravnborg <sam@ravnborg.org>,
        =?UTF-8?q?Noralf=20Tr=C3=B8nnes?= <noralf@tronnes.org>,
        Andy Shevchenko <andriy.shevchenko@intel.com>,
        Daniel Mack <daniel@zonque.org>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        Robert Jarzmik <robert.jarzmik@free.fr>,
        Mark Brown <broonie@kernel.org>,
        linux-arm-kernel@lists.infradead.org, linux-spi@vger.kernel.org,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 051/205] spi: pxa2xx: Set controller->max_transfer_size in dma mode
Date:   Thu, 16 Jan 2020 11:40:26 -0500
Message-Id: <20200116164300.6705-51-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Vetter <daniel.vetter@ffwll.ch>

[ Upstream commit b2662a164f9dc48da8822e56600686d639056282 ]

In DMA mode we have a maximum transfer size, past that the driver
falls back to PIO (see the check at the top of pxa2xx_spi_transfer_one).
Falling back to PIO for big transfers defeats the point of a dma engine,
hence set the max transfer size to inform spi clients that they need
to do something smarter.

This was uncovered by the drm_mipi_dbi spi panel code, which does
large spi transfers, but stopped splitting them after:

commit e143364b4c1774f68e923a5a0bb0fca28ac25888
Author: Noralf Trønnes <noralf@tronnes.org>
Date:   Fri Jul 19 17:59:10 2019 +0200

    drm/tinydrm: Remove tinydrm_spi_max_transfer_size()

After this commit the code relied on the spi core to split transfers
into max dma-able blocks, which also papered over the PIO fallback issue.

Fix this by setting the overall max transfer size to the DMA limit,
but only when the controller runs in DMA mode.

Fixes: e143364b4c17 ("drm/tinydrm: Remove tinydrm_spi_max_transfer_size()")
Cc: Sam Ravnborg <sam@ravnborg.org>
Cc: Noralf Trønnes <noralf@tronnes.org>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>
Reported-and-tested-by: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Daniel Mack <daniel@zonque.org>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: Mark Brown <broonie@kernel.org>
Cc: linux-arm-kernel@lists.infradead.org
Cc: linux-spi@vger.kernel.org
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://lore.kernel.org/r/20191017064426.30814-1-daniel.vetter@ffwll.ch
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-pxa2xx.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/spi/spi-pxa2xx.c b/drivers/spi/spi-pxa2xx.c
index ae95ec0bc964..9f92165fe09f 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1612,6 +1612,11 @@ static int pxa2xx_spi_fw_translate_cs(struct spi_controller *controller,
 	return cs;
 }
 
+static size_t pxa2xx_spi_max_dma_transfer_size(struct spi_device *spi)
+{
+	return MAX_DMA_LEN;
+}
+
 static int pxa2xx_spi_probe(struct platform_device *pdev)
 {
 	struct device *dev = &pdev->dev;
@@ -1717,6 +1722,8 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		} else {
 			controller->can_dma = pxa2xx_spi_can_dma;
 			controller->max_dma_len = MAX_DMA_LEN;
+			controller->max_transfer_size =
+				pxa2xx_spi_max_dma_transfer_size;
 		}
 	}
 
-- 
2.20.1

