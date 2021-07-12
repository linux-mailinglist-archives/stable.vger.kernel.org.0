Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F189E3C51B2
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:48:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349534AbhGLHmx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:42:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:46794 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347664AbhGLHj7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:39:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5B2C76143D;
        Mon, 12 Jul 2021 07:35:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626075326;
        bh=FWdpgeLZjTV3yUDS9DmJf5529C3/nxBDlPw9YGo3gao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YL9ycaXgnFyY35qRnZR33bg7DlI8jlWJhJ8yb0M21FYn9EogPBe6qb82V0cx9Iuri
         N9Ks7hjEmUG8db/cdz5zhNH7pehsxURvd26LRtTDzSrW1GHAcwyIqlpazy2GPzPKyK
         vL+4SUtdgxWBJ+kRUdl71W1JpaH0CHCHlG2fiAHQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, zpershuai <zpershuai@gmail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 181/800] spi: meson-spicc: fix memory leak in meson_spicc_probe
Date:   Mon, 12 Jul 2021 08:03:24 +0200
Message-Id: <20210712060938.502661250@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: zpershuai <zpershuai@gmail.com>

[ Upstream commit b2d501c13470409ee7613855b17e5e5ec4111e1c ]

when meson_spicc_clk_init returns failed, it should goto the
out_clk label.

Signed-off-by: zpershuai <zpershuai@gmail.com>
Reviewed-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://lore.kernel.org/r/1623562156-21995-1-git-send-email-zpershuai@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-meson-spicc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/spi/spi-meson-spicc.c b/drivers/spi/spi-meson-spicc.c
index 51aef2c6e966..b2c4621db34d 100644
--- a/drivers/spi/spi-meson-spicc.c
+++ b/drivers/spi/spi-meson-spicc.c
@@ -752,7 +752,7 @@ static int meson_spicc_probe(struct platform_device *pdev)
 	ret = meson_spicc_clk_init(spicc);
 	if (ret) {
 		dev_err(&pdev->dev, "clock registration failed\n");
-		goto out_master;
+		goto out_clk;
 	}
 
 	ret = devm_spi_register_master(&pdev->dev, master);
-- 
2.30.2



