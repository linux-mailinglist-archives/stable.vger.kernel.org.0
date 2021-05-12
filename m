Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E153A37C7ED
	for <lists+stable@lfdr.de>; Wed, 12 May 2021 18:38:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237033AbhELQDU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 May 2021 12:03:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:38450 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238269AbhELP5f (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 12 May 2021 11:57:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 02BF561CB4;
        Wed, 12 May 2021 15:31:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620833478;
        bh=mUVS9Ll7TCgvXkDaEevOf7FgfCdqWZyPhFYSSRyxL/A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Lcz5esSiAu4ksDn+XHoKphgL38AKcnZVDJraj8SFTP8/sJeTmhjWRYD9uqt0SN3Sv
         JepApNngU/z/jM5ZHUdgkbBzVDuzK7GQmXLhN8TlDce8fidKt+hxZ5uS27J6zQ0Fp1
         VBrj35i2GA/sjcpOcZJfeZiU7kZSOesUmOjm4Et8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Pratyush Yadav <p.yadav@ti.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 165/601] spi: rockchip: avoid objtool warning
Date:   Wed, 12 May 2021 16:44:02 +0200
Message-Id: <20210512144833.268387658@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210512144827.811958675@linuxfoundation.org>
References: <20210512144827.811958675@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnd Bergmann <arnd@arndb.de>

[ Upstream commit e50989527faeafb79f45a0f7529ba8e01dff1fff ]

Building this file with clang leads to a an unreachable code path
causing a warning from objtool:

drivers/spi/spi-rockchip.o: warning: objtool: rockchip_spi_transfer_one()+0x2e0: sibling call from callable instruction with modified stack frame

Change the unreachable() into an error return that can be
handled if it ever happens, rather than silently crashing
the kernel.

Fixes: 65498c6ae241 ("spi: rockchip: support 4bit words")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Pratyush Yadav <p.yadav@ti.com>
Link: https://lore.kernel.org/r/20210226140109.3477093-1-arnd@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-rockchip.c | 13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

diff --git a/drivers/spi/spi-rockchip.c b/drivers/spi/spi-rockchip.c
index 09d8e92400eb..0e2c377e9e55 100644
--- a/drivers/spi/spi-rockchip.c
+++ b/drivers/spi/spi-rockchip.c
@@ -476,7 +476,7 @@ static int rockchip_spi_prepare_dma(struct rockchip_spi *rs,
 	return 1;
 }
 
-static void rockchip_spi_config(struct rockchip_spi *rs,
+static int rockchip_spi_config(struct rockchip_spi *rs,
 		struct spi_device *spi, struct spi_transfer *xfer,
 		bool use_dma, bool slave_mode)
 {
@@ -521,7 +521,9 @@ static void rockchip_spi_config(struct rockchip_spi *rs,
 		 * ctlr->bits_per_word_mask, so this shouldn't
 		 * happen
 		 */
-		unreachable();
+		dev_err(rs->dev, "unknown bits per word: %d\n",
+			xfer->bits_per_word);
+		return -EINVAL;
 	}
 
 	if (use_dma) {
@@ -554,6 +556,8 @@ static void rockchip_spi_config(struct rockchip_spi *rs,
 	 */
 	writel_relaxed(2 * DIV_ROUND_UP(rs->freq, 2 * xfer->speed_hz),
 			rs->regs + ROCKCHIP_SPI_BAUDR);
+
+	return 0;
 }
 
 static size_t rockchip_spi_max_transfer_size(struct spi_device *spi)
@@ -577,6 +581,7 @@ static int rockchip_spi_transfer_one(
 		struct spi_transfer *xfer)
 {
 	struct rockchip_spi *rs = spi_controller_get_devdata(ctlr);
+	int ret;
 	bool use_dma;
 
 	WARN_ON(readl_relaxed(rs->regs + ROCKCHIP_SPI_SSIENR) &&
@@ -596,7 +601,9 @@ static int rockchip_spi_transfer_one(
 
 	use_dma = ctlr->can_dma ? ctlr->can_dma(ctlr, spi, xfer) : false;
 
-	rockchip_spi_config(rs, spi, xfer, use_dma, ctlr->slave);
+	ret = rockchip_spi_config(rs, spi, xfer, use_dma, ctlr->slave);
+	if (ret)
+		return ret;
 
 	if (use_dma)
 		return rockchip_spi_prepare_dma(rs, ctlr, xfer);
-- 
2.30.2



