Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 28E2D17FD64
	for <lists+stable@lfdr.de>; Tue, 10 Mar 2020 14:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728948AbgCJMxh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Mar 2020 08:53:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:59748 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729188AbgCJMxg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Mar 2020 08:53:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C3A1120674;
        Tue, 10 Mar 2020 12:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583844816;
        bh=X7tG5Nb9FdI0XtMkJSgMz6obTbzw75umNhrHk6RRrbA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kRgw0/vx5pGTweZfYAEl0bxrnBcqG8CHgKse/4fakgiuOCXWUD2Yt0f7uA5/F/0OC
         C/RmzzGe6elqOOBrEO/ApYgb4d/NSlPWkMhVjJr8Qln/DwqSxhEXsrPKocX2WO0OLY
         YP4Rqu+0qw9mBbqlDvaAuBQ6iJt/D6wOomqrm5nY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 129/168] spi: atmel-quadspi: fix possible MMIO window size overrun
Date:   Tue, 10 Mar 2020 13:39:35 +0100
Message-Id: <20200310123648.527892444@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200310123635.322799692@linuxfoundation.org>
References: <20200310123635.322799692@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 8e093ea4d3593379be46b845b9e823179558047e upstream.

The QSPI controller memory space is limited to 128MB:
0x9000_00000-0x9800_00000/0XD000_0000--0XD800_0000.

There are nor flashes that are bigger in size than the memory size
supported by the controller: Micron MT25QL02G (256 MB).

Check if the address exceeds the MMIO window size. An improvement
would be to add support for regular SPI mode and fall back to it
when the flash memories overrun the controller's memory space.

Fixes: 0e6aae08e9ae ("spi: Add QuadSPI driver for Atmel SAMA5D2")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/20200228155437.1558219-1-tudor.ambarus@microchip.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/atmel-quadspi.c |   11 +++++++++++
 1 file changed, 11 insertions(+)

--- a/drivers/spi/atmel-quadspi.c
+++ b/drivers/spi/atmel-quadspi.c
@@ -149,6 +149,7 @@ struct atmel_qspi {
 	struct clk		*qspick;
 	struct platform_device	*pdev;
 	const struct atmel_qspi_caps *caps;
+	resource_size_t		mmap_size;
 	u32			pending;
 	u32			mr;
 	u32			scr;
@@ -329,6 +330,14 @@ static int atmel_qspi_exec_op(struct spi
 	u32 sr, offset;
 	int err;
 
+	/*
+	 * Check if the address exceeds the MMIO window size. An improvement
+	 * would be to add support for regular SPI mode and fall back to it
+	 * when the flash memories overrun the controller's memory space.
+	 */
+	if (op->addr.val + op->data.nbytes > aq->mmap_size)
+		return -ENOTSUPP;
+
 	err = atmel_qspi_set_cfg(aq, op, &offset);
 	if (err)
 		return err;
@@ -480,6 +489,8 @@ static int atmel_qspi_probe(struct platf
 		goto exit;
 	}
 
+	aq->mmap_size = resource_size(res);
+
 	/* Get the peripheral clock */
 	aq->pclk = devm_clk_get(&pdev->dev, "pclk");
 	if (IS_ERR(aq->pclk))


