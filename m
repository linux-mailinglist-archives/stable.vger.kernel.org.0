Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A99B1426920
	for <lists+stable@lfdr.de>; Fri,  8 Oct 2021 13:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241780AbhJHLeH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Oct 2021 07:34:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:59432 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240930AbhJHLc5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 Oct 2021 07:32:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DF49461353;
        Fri,  8 Oct 2021 11:30:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633692643;
        bh=mUgukess8O9s+KgtEGp2K/ZCeaegdNTLZV51hG4FIk8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=f+fDam0dY66dDZuaWxnFgyP/obIlHjjWJM2d/KPd8PpHDH8D0Olc9V8kxcZ6EHkw6
         tQeKMvpvG2HuKl7K7Jtk2AGQ4NoYDl0uQDwP3RZ6gx08O51PEqsIJtjT7TLF9aE6f8
         6ed7DCPl7aXvUmfr5UxNSO2eTc7Yn5pIlxD+jZ0M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tobias Schramm <t.schramm@manjaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 01/29] spi: rockchip: handle zero length transfers without timing out
Date:   Fri,  8 Oct 2021 13:27:48 +0200
Message-Id: <20211008112716.971550767@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211008112716.914501436@linuxfoundation.org>
References: <20211008112716.914501436@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 0aab37cd64e7..624273d0e727 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -582,6 +582,12 @@ static int rockchip_spi_transfer_one(
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



