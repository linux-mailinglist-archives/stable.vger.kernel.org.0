Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D7F52106E3F
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:07:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731758AbfKVLFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:05:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:33618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730559AbfKVLFu (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:05:50 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DC07B2070E;
        Fri, 22 Nov 2019 11:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420750;
        bh=mHyJix8TS0iTdx7zM4Zt5aMG7j8CE7oo13sYuj57jpA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R98rN+72j2hiVWGMXUBThcO8F1n04Bn+utztytYBMKzXdlTf8x5IiCVY/Pbl++Psr
         MTTx8VTbcxW41vLwuOjEIGVxgMuZvQLbz6m0how9X9NG7rue8xrm2649qPs7k+6wow
         tUelbvAfVWtVPys247xm92TUaSATzTG5bxudP1vc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Huibin Hong <huibin.hong@rock-chips.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 211/220] spi: rockchip: initialize dma_slave_config properly
Date:   Fri, 22 Nov 2019 11:29:36 +0100
Message-Id: <20191122100928.876722792@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Huibin Hong <huibin.hong@rock-chips.com>

[ Upstream commit dd8fd2cbc73f8650f651da71fc61a6e4f30c1566 ]

The rxconf and txconf structs are allocated on the
stack, so make sure we zero them before filling out
the relevant fields.

Signed-off-by: Huibin Hong <huibin.hong@rock-chips.com>
Signed-off-by: Emil Renner Berthing <kernel@esmil.dk>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index fdcf3076681b5..185bbdce62b14 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -445,6 +445,9 @@ static int rockchip_spi_prepare_dma(struct rockchip_spi *rs)
 	struct dma_slave_config rxconf, txconf;
 	struct dma_async_tx_descriptor *rxdesc, *txdesc;
 
+	memset(&rxconf, 0, sizeof(rxconf));
+	memset(&txconf, 0, sizeof(txconf));
+
 	spin_lock_irqsave(&rs->lock, flags);
 	rs->state &= ~RXBUSY;
 	rs->state &= ~TXBUSY;
-- 
2.20.1



