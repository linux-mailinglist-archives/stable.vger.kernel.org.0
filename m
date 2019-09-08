Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 59388ACE96
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 15:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbfIHM7U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:59:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:33382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730268AbfIHMqB (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:46:01 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A1B38218AC;
        Sun,  8 Sep 2019 12:46:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946761;
        bh=0OjlmtzajQP3fonjsDscpmVG6sUf8ItzbOVzKh6nRrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZfCgzEvAd3ZvLGcqyNgebzjAwRcyndpwbrD3SYz+MTGRVLPv6OFGxFHTh0p91Ll/9
         LVYq4NEk6UMUwIFZZ5OkbSYv8RGC2cZ0dlMhrguIuonn7h6vZicTeRAuoTJDZkcwxd
         CATRwYIB46TfXer5iL+lsXO2fERRvQhOgXHG3OZI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hubert Denkmair <h.denkmair@intence.de>,
        Martin Sperl <kernel@martin.sperl.org>,
        Stefan Wahren <stefan.wahren@i2se.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 30/40] spi: bcm2835aux: remove dangerous uncontrolled read of fifo
Date:   Sun,  8 Sep 2019 13:42:03 +0100
Message-Id: <20190908121128.360829184@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121114.260662089@linuxfoundation.org>
References: <20190908121114.260662089@linuxfoundation.org>
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
index 97cb3beb9cc62..4454d9c6a3dd4 100644
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



