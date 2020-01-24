Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93BCF1480F4
	for <lists+stable@lfdr.de>; Fri, 24 Jan 2020 12:16:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390078AbgAXLPw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jan 2020 06:15:52 -0500
Received: from mail.kernel.org ([198.145.29.99]:52502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389650AbgAXLPv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 24 Jan 2020 06:15:51 -0500
Received: from localhost (ip-213-127-102-57.ip.prioritytelecom.net [213.127.102.57])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 53D1220708;
        Fri, 24 Jan 2020 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579864551;
        bh=bliT4xAUHVM4G1mgu4NFRD4uUW0oCWzxaiplPWcbVyA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dhQjRWjLU5SSFmrv5DawpSl8ekuuJ3BFwHvmw7L07may4gHnu9wehGPDhy2TXVgxf
         PaAjO/Ni5gsDQEOvyzOcB1xvmwWZr0DWZWoW/L6SPRV/LcsdIaY0ETLfQ0dMKhknxV
         T6Xf2IXE6jLaLR1RO6bElUEEB0BaBbPM6N90K1mc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sowjanya Komatineni <skomatineni@nvidia.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 284/639] spi: tegra114: terminate dma and reset on transfer timeout
Date:   Fri, 24 Jan 2020 10:27:34 +0100
Message-Id: <20200124093122.422579088@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200124093047.008739095@linuxfoundation.org>
References: <20200124093047.008739095@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sowjanya Komatineni <skomatineni@nvidia.com>

[ Upstream commit 32bd1a9551cae34e6889afa235c7afdfede9aeac ]

Fixes: terminate DMA and perform controller reset on transfer timeout
to clear the FIFO's and errors.

Signed-off-by: Sowjanya Komatineni <skomatineni@nvidia.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-tegra114.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/spi/spi-tegra114.c b/drivers/spi/spi-tegra114.c
index 17c2c78318f71..b1b726673f850 100644
--- a/drivers/spi/spi-tegra114.c
+++ b/drivers/spi/spi-tegra114.c
@@ -869,7 +869,16 @@ static int tegra_spi_transfer_one_message(struct spi_master *master,
 		if (WARN_ON(ret == 0)) {
 			dev_err(tspi->dev,
 				"spi transfer timeout, err %d\n", ret);
+			if (tspi->is_curr_dma_xfer &&
+			    (tspi->cur_direction & DATA_DIR_TX))
+				dmaengine_terminate_all(tspi->tx_dma_chan);
+			if (tspi->is_curr_dma_xfer &&
+			    (tspi->cur_direction & DATA_DIR_RX))
+				dmaengine_terminate_all(tspi->rx_dma_chan);
 			ret = -EIO;
+			reset_control_assert(tspi->rst);
+			udelay(2);
+			reset_control_deassert(tspi->rst);
 			goto complete_xfer;
 		}
 
-- 
2.20.1



