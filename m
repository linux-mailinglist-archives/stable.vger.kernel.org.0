Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2B1B3ACE8E
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:00:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726540AbfIHM6h (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:58:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:34924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730528AbfIHMq4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:46:56 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1D23216C8;
        Sun,  8 Sep 2019 12:46:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946816;
        bh=9zkCM/mi2gR3OHMRRpaCRsuGG0uWPCXUQDHBve/+Mgw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=icKt4V6PQxU1Y50rDLWvRp+5n5wtyJpSotSUaoAM/4ZyEufN/ImrWOxqghvvbbcl3
         agNJ5fUJLeWQGKzevXSQtyMIqjkKldC/GgMesRghJ2e6jtZVfll6CGASCFS7IrLqMB
         jC9m2eGg/bPNW120YZv1W2kHotG2Q/06qOr4UC6c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hubert Denkmair <h.denkmair@intence.de>,
        Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 11/57] spi: bcm2835aux: remove dangerous uncontrolled read of fifo
Date:   Sun,  8 Sep 2019 13:41:35 +0100
Message-Id: <20190908121128.976826503@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121125.608195329@linuxfoundation.org>
References: <20190908121125.608195329@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c7de8500fd8ecbb544846dd5f11dca578c3777e1 ]

This read of the fifo is a potential candidate for a race condition
as the spi transfer is not necessarily finished and so can lead to
an early read of the fifo that still misses data.

So it has been removed.

Fixes: 1ea29b39f4c812ec ("spi: bcm2835aux: add bcm2835 auxiliary spi device...")
Suggested-by: Hubert Denkmair <h.denkmair@intence.de>
Signed-off-by: Martin Sperl <kernel@martin.sperl.org>
Acked-by: Stefan Wahren <stefan.wahren@i2se.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-bcm2835aux.c | 7 -------
 1 file changed, 7 deletions(-)

diff --git a/drivers/spi/spi-bcm2835aux.c b/drivers/spi/spi-bcm2835aux.c
index 79306e654f735..b4217f9480014 100644
--- a/drivers/spi/spi-bcm2835aux.c
+++ b/drivers/spi/spi-bcm2835aux.c
@@ -194,13 +194,6 @@ static void bcm2835aux_spi_transfer_helper(struct bcm2835aux_spi *bs)
 		  BCM2835_AUX_SPI_STAT_TX_FULL))) {
 		bcm2835aux_wr_fifo(bs);
 	}
-
-	/* and check if we have reached "done" */
-	while (bs->rx_len &&
-	       (!(bcm2835aux_rd(bs, BCM2835_AUX_SPI_STAT) &
-		  BCM2835_AUX_SPI_STAT_BUSY))) {
-		bcm2835aux_rd_fifo(bs);
-	}
 }
 
 static irqreturn_t bcm2835aux_spi_interrupt(int irq, void *dev_id)
-- 
2.20.1



