Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBE2823F9F6
	for <lists+stable@lfdr.de>; Sun,  9 Aug 2020 01:39:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728561AbgHHXja (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 8 Aug 2020 19:39:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54312 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728558AbgHHXja (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 8 Aug 2020 19:39:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 98E612075D;
        Sat,  8 Aug 2020 23:39:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596929969;
        bh=aYG/jnikgEWyVG2dqQNg2g22DSYc7s2Ba/lJaKzMlRw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guc6XZv0/WcKC90L6iSV6HI/ZOsRRT8WZTytEa5RFMkRG5958Jxr4rUaTn7TlY7z1
         tegcgNVInVSQLTboN763qsVlyVDNf4pFQbnmBh/tKazJOzXCmSWJ4cLAhPjRI6BCgG
         H6NSTYrh1aNq6HLGWRhcuN1oXQE2MJReW5imrd+Y=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jon Lin <jon.lin@rock-chips.com>,
        Emil Renner Berthing <kernel@esmil.dk>,
        Heiko Stuebner <heiko@sntech.de>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, linux-spi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.4 31/40] spi: rockchip: Fix error in SPI slave pio read
Date:   Sat,  8 Aug 2020 19:38:35 -0400
Message-Id: <20200808233844.3618823-31-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200808233844.3618823-1-sashal@kernel.org>
References: <20200808233844.3618823-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

