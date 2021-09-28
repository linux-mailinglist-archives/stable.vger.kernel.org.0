Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6AE6641A7D9
	for <lists+stable@lfdr.de>; Tue, 28 Sep 2021 07:58:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239476AbhI1F7l (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Sep 2021 01:59:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:48798 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239105AbhI1F6l (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Sep 2021 01:58:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8D6366127C;
        Tue, 28 Sep 2021 05:56:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1632808605;
        bh=mUgukess8O9s+KgtEGp2K/ZCeaegdNTLZV51hG4FIk8=;
        h=From:To:Cc:Subject:Date:From;
        b=RKNMLXMJdQSLwZfJmTa0NwBQXb9+d24I/74wNXbfBD34PAvSCfF2Bx8LPIin6GNGj
         HPluCpMfQgYkaSLZdSHsILGH91/1ObdZ2qRLUOSuu4+6NXqB0xzXYwtMnuwHFbVlI6
         CBNIk3cgD3KxOMXtXoVcdjMYSPy0ZPB89KS9fDbi/3kJ35zMK2t/RZl71x7PBYBhwL
         L/fj8jZ5uN/a7vgOJEy+Ove9biZGiEYtXBEXIUQSXeUkn9wdKjutRRauaYaunKL09H
         MH2hKYAAcZ5mdTR6zkwg3YE/vTEqxoLpnGKFIkhwIOxFNl/+cezNbiGG2wRj6i3Rc5
         HEuyBZLkJYqvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tobias Schramm <t.schramm@manjaro.org>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>, heiko@sntech.de,
        linux-spi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org
Subject: [PATCH AUTOSEL 5.10 01/23] spi: rockchip: handle zero length transfers without timing out
Date:   Tue, 28 Sep 2021 01:56:22 -0400
Message-Id: <20210928055645.172544-1-sashal@kernel.org>
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

