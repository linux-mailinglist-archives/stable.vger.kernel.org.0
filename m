Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 74D3411971F
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:31:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728183AbfLJVJc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:09:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:58036 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726913AbfLJVJ3 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:09:29 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98335246A4;
        Tue, 10 Dec 2019 21:09:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576012168;
        bh=7zS+SDS48IEOsmWMqVS9szWqKcLCdfqqnTboh0ROiA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h6NxWoHpf4jvOfFxe1TcDdN66B9NfEhuAvGYzUvSytyKFEvWNW4G395qKHB5wvlHy
         voAnrDcVu7njwomCeYAW3X3oaqVY+Gwtvg/sW6x1Q9JqWGNe6ecpWZ13yoFcF69wBu
         ES9JBeHCzoyzWZZxdvcydSeqNnOFQw00LhNZaiG4=
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
Subject: [PATCH AUTOSEL 5.4 128/350] spi: pxa2xx: Set controller->max_transfer_size in dma mode
Date:   Tue, 10 Dec 2019 16:03:53 -0500
Message-Id: <20191210210735.9077-89-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210210735.9077-1-sashal@kernel.org>
References: <20191210210735.9077-1-sashal@kernel.org>
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
index bb6a14d1ab0f9..068c210376799 100644
--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1602,6 +1602,11 @@ static int pxa2xx_spi_fw_translate_cs(struct spi_controller *controller,
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
@@ -1707,6 +1712,8 @@ static int pxa2xx_spi_probe(struct platform_device *pdev)
 		} else {
 			controller->can_dma = pxa2xx_spi_can_dma;
 			controller->max_dma_len = MAX_DMA_LEN;
+			controller->max_transfer_size =
+				pxa2xx_spi_max_dma_transfer_size;
 		}
 	}
 
-- 
2.20.1

