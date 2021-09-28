Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B4F241A753
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:55:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237168AbhI1F5E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:57:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:47422 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234207AbhI1F5E (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:57:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5C03A611C3;
        Tue, 28 Sep 2021 05:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808525;
        bh=kE7fRXuUwpMLCFyX72ic6RwxCWG3c0BVu7eSXiZ6SEc=;
        h=From:To:Cc:Subject:Date:From;
        b=RxrSidJOgdvWwU4pQTgqC5Xeh/XsaYaTtI47Y37PxSocqNcwL0GfH6gUKk9CYPtiY
         +lzC2AffIVF2M3J6PNW7ZF/3nZxAi8NJKJ8suoxb/hjJ2iJa6sdIwxQnh2myNSQQLF
         woQPhH8MIz5SdvHLg9fu8lJofcJ6lL41Iv+c8fATLIa75NFqfzW2EpAcBeHGeqnlvX
         OpkxsBjVFAirmdzXzDKih/+Yw4UQNI/a+b2L/4S1yTxVMsUQBHmNTM9Nv+eF+x7EJ4
         LSA2t9kgeQPO39edV/9gnJ23CF8fOAZu7TopMfqHoVhBPIwC69qZUhOQACT+UbilSP
         9VoB8r0DCU2sg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Schramm <t.schramm@manjaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.14 01/40] spi: rockchip: handle zero length transfers without timing out
Date:   Tue, 28 Sep 2021 01:54:45 -0400
Message-Id: <20210928055524.172051-1-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tobias Schramm <t.schramm@manjaro.org>

[ Upstream commit 5457773ef99f25fcc4b238ac76b68e28273250f4 ]

Previously zero length transfers submitted to the Rokchip SPI driver would
time out in the SPI layer. This happens because the SPI peripheral does
not trigger a transfer completion interrupt for zero length transfers.

Fix that by completing zero length transfers immediately at start of
transfer.

Signed-off-by: Tobias Schramm <t.schramm@manjaro.org>
Link: https://lore.kernel.org/r/20210827050357.165409-1-t.schramm@manjaro.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 540861ca2ba3..553b6b9d0222 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -600,6 +600,12 @@ static int rockchip_spi_transfer_one(
 	int ret;
 	bool use_dma;
 
+	/* Zero length transfers won't trigger an interrupt on completion */
+	if (!xfer->len) {
+		spi_finalize_current_transfer(ctlr);
+		return 1;
+	}
+
 	WARN_ON(readl_relaxed(rs->regs + ROCKCHIP_SPI_SSIENR) &&
 		(readl_relaxed(rs->regs + ROCKCHIP_SPI_SR) & SR_BUSY));
 
-- 
2.33.0

