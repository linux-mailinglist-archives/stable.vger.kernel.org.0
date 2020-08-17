Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 669412471A1
	for <lists+stable@lfdr.de>; Mon, 17 Aug 2020 20:31:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389318AbgHQSbX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Aug 2020 14:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:48326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730863AbgHQQA4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 Aug 2020 12:00:56 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6297E208C7;
        Mon, 17 Aug 2020 16:00:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597680055;
        bh=aYG/jnikgEWyVG2dqQNg2g22DSYc7s2Ba/lJaKzMlRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VdLD3bHTQdXMV/Yz1BS/gYvpAI/wSB2QUwHwsUeLZOElYVLTD4mP+mNRZw4/aN3sE
         IhafmQ5dpJmAUn+vSodg1nvWntJwI42UnXtJMw9CaIIwHnBsTOE6SHYHTQO03WcQ/a
         xlq4skhAANZNPKWKOyTa77lV3Vk9dS2VmpWrbZ/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Lin <jon.lin@rock-chips.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 036/270] spi: rockchip: Fix error in SPI slave pio read
Date:   Mon, 17 Aug 2020 17:13:57 +0200
Message-Id: <20200817143757.592848129@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200817143755.807583758@linuxfoundation.org>
References: <20200817143755.807583758@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jon Lin <jon.lin@rock-chips.com>

[ Upstream commit 4294e4accf8d695ea5605f6b189008b692e3e82c ]

The RXFLR is possible larger than rx_left in Rockchip SPI, fix it.

Fixes: 01b59ce5dac8 ("spi: rockchip: use irq rather than polling")
Signed-off-by: Jon Lin <jon.lin@rock-chips.com>
Tested-by: Emil Renner Berthing <kernel@esmil.dk>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Emil Renner Berthing <kernel@esmil.dk>
Link: https://lore.kernel.org/r/20200723004356.6390-3-jon.lin@rock-chips.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 2cc6d9951b52e..008b64f4e031a 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -286,7 +286,7 @@ static void rockchip_spi_pio_writer(struct rockchip_spi *rs)
 static void rockchip_spi_pio_reader(struct rockchip_spi *rs)
 {
 	u32 words = readl_relaxed(rs->regs + ROCKCHIP_SPI_RXFLR);
-	u32 rx_left = rs->rx_left - words;
+	u32 rx_left = (rs->rx_left > words) ? rs->rx_left - words : 0;
 
 	/* the hardware doesn't allow us to change fifo threshold
 	 * level while spi is enabled, so instead make sure to leave
-- 
2.25.1



