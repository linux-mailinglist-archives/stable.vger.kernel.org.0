Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932472A5712
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:34:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387785AbgKCVdy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:33:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:58730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729971AbgKCU4p (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 15:56:45 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6DC1320732;
        Tue,  3 Nov 2020 20:56:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437004;
        bh=625CS+VVUcH2j+DlX50bWniL4e5cbojM1+nNSZ7KK1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BtWTVWism9dSQ9hxcnhNQHfCn/2RPjBfyz3uL97IA+m8Io5ZB+rOJsy6+x7ir1CRG
         mUfmhuKZTqCiGSKCBWdBUyUxy4pJyEbBP5Erz9w6IcOqbLLjdNnBbioWgHRgBW7SqQ
         JbPDIkJ54WMfzpcOU2deYEeZy5suo1SwbSu9KVpM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Krzysztof Kozlowski <krzk@kernel.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 104/214] spi: sprd: Release DMA channel also on probe deferral
Date:   Tue,  3 Nov 2020 21:35:52 +0100
Message-Id: <20201103203300.738353279@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203249.448706377@linuxfoundation.org>
References: <20201103203249.448706377@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Krzysztof Kozlowski <krzk@kernel.org>

commit 687a2e76186dcfa42f22c14b655c3fb159839e79 upstream.

If dma_request_chan() for TX channel fails with EPROBE_DEFER, the RX
channel would not be released and on next re-probe it would be requested
second time.

Fixes: 386119bc7be9 ("spi: sprd: spi: sprd: Add DMA mode support")
Cc: <stable@vger.kernel.org>
Signed-off-by: Krzysztof Kozlowski <krzk@kernel.org>
Acked-by: Chunyan Zhang <zhang.lyra@gmail.com>
Link: https://lore.kernel.org/r/20200901152713.18629-1-krzk@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-sprd.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-sprd.c
+++ b/drivers/spi/spi-sprd.c
@@ -563,11 +563,11 @@ static int sprd_spi_dma_request(struct s
 
 	ss->dma.dma_chan[SPRD_SPI_TX]  = dma_request_chan(ss->dev, "tx_chn");
 	if (IS_ERR_OR_NULL(ss->dma.dma_chan[SPRD_SPI_TX])) {
+		dma_release_channel(ss->dma.dma_chan[SPRD_SPI_RX]);
 		if (PTR_ERR(ss->dma.dma_chan[SPRD_SPI_TX]) == -EPROBE_DEFER)
 			return PTR_ERR(ss->dma.dma_chan[SPRD_SPI_TX]);
 
 		dev_err(ss->dev, "request TX DMA channel failed!\n");
-		dma_release_channel(ss->dma.dma_chan[SPRD_SPI_RX]);
 		return PTR_ERR(ss->dma.dma_chan[SPRD_SPI_TX]);
 	}
 


