Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D6E7B2E42A5
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407888AbgL1N5r (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:59524 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406743AbgL1N5r (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:57:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 571D020791;
        Mon, 28 Dec 2020 13:57:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163826;
        bh=t1gGUelAwP2A+EmHeUClX4L/LHo/xQfFUa6r+6dbcDo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qmzf4aIN/6QGyR1seJzW7mRx38WTECkRBLkSn0XuKyIsGaYQTleabhPOG1zNJ4d4m
         pM+cXOeR0vhs2R20+mDA9OZqAq/bn3NXNsvVPLyK/nGAFEuLzv515zoeSMZRHXCpGD
         HMSblJsxHVWQSopKO2CZcRBK3qPc9JyW7qAHtmNY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Peter Ujfalusi <peter.ujfalusi@ti.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 404/453] spi: davinci: Fix use-after-free on unbind
Date:   Mon, 28 Dec 2020 13:50:40 +0100
Message-Id: <20201228124956.651942015@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 373afef350a93519b4b8d636b0895da8650b714b upstream.

davinci_spi_remove() accesses the driver's private data after it's been
freed with spi_master_put().

Fix by moving the spi_master_put() to the end of the function.

Fixes: fe5fd2540947 ("spi: davinci: Use dma_request_chan() for requesting DMA channel")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Acked-by: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: <stable@vger.kernel.org> # v4.7+
Link: https://lore.kernel.org/r/412f7eb1cf8990e0a3a2153f4c577298deab623e.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-davinci.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-davinci.c
+++ b/drivers/spi/spi-davinci.c
@@ -1040,13 +1040,13 @@ static int davinci_spi_remove(struct pla
 	spi_bitbang_stop(&dspi->bitbang);
 
 	clk_disable_unprepare(dspi->clk);
-	spi_master_put(master);
 
 	if (dspi->dma_rx) {
 		dma_release_channel(dspi->dma_rx);
 		dma_release_channel(dspi->dma_tx);
 	}
 
+	spi_master_put(master);
 	return 0;
 }
 


