Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40599395C84
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:33:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232449AbhEaNd5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:33:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:37634 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232042AbhEaNbz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A093C613EA;
        Mon, 31 May 2021 13:23:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467430;
        bh=wxtoUfqWMXTdNfadc7sU/GNV6l0LpwXlGpF4M7rLEoo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=l3E3XegdoXa0h7+f73mSbUo8HBzmEajXq1c0vLFQdDnBu6Uu7lSnZCzC5zlzrw4H3
         uXLgGq/CXtZj+Zp4IcONoqm1Tu/P677YxyhQfny46RVjJ7Yzq8r5auPrk03Be5hL4W
         41GioA7hfeXFR+Knbs1M0TNh9xXH86es6JVAaCJ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Stefan Roese <sr@denx.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 061/116] spi: mt7621: Dont leak SPI master in probe error path
Date:   Mon, 31 May 2021 15:13:57 +0200
Message-Id: <20210531130642.238746730@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130640.131924542@linuxfoundation.org>
References: <20210531130640.131924542@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 46b5c4fb87ce8211e0f9b0383dbde72c3652d2ba upstream.

If the calls to device_reset() or devm_spi_register_controller() fail on
probe of the MediaTek MT7621 SPI driver, the spi_controller struct is
erroneously not freed.  Fix by switching over to the new
devm_spi_alloc_master() helper.

Additionally, there's an ordering issue in mt7621_spi_remove() wherein
the spi_controller is unregistered after disabling the SYS clock.
The correct order is to call spi_unregister_controller() *before* this
teardown step because bus accesses may still be ongoing until that
function returns.

All of these bugs have existed since the driver was first introduced,
so it seems fair to fix them together in a single commit.

Fixes: 1ab7f2a43558 ("staging: mt7621-spi: add mt7621 support")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Stefan Roese <sr@denx.de>
Cc: <stable@vger.kernel.org> # v4.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.17+
Link: https://lore.kernel.org/r/72b680796149f5fcda0b3f530ffb7ee73b04f224.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[lukas: backport to v4.19.192]
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/mt7621-spi/spi-mt7621.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -452,7 +452,7 @@ static int mt7621_spi_probe(struct platf
 	if (status)
 		return status;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*rs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*rs));
 	if (master == NULL) {
 		dev_info(&pdev->dev, "master allocation failed\n");
 		clk_disable_unprepare(clk);
@@ -502,8 +502,8 @@ static int mt7621_spi_remove(struct plat
 	master = dev_get_drvdata(&pdev->dev);
 	rs = spi_master_get_devdata(master);
 
-	clk_disable(rs->clk);
 	spi_unregister_master(master);
+	clk_disable_unprepare(rs->clk);
 
 	return 0;
 }


