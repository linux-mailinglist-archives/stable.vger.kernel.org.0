Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 772CD394C1F
	for <lists+stable@lfdr.de>; Sat, 29 May 2021 14:08:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbhE2MKQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 29 May 2021 08:10:16 -0400
Received: from bmailout2.hostsharing.net ([83.223.78.240]:41719 "EHLO
        bmailout2.hostsharing.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229602AbhE2MKQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 29 May 2021 08:10:16 -0400
Received: from h08.hostsharing.net (h08.hostsharing.net [83.223.95.28])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (Client CN "*.hostsharing.net", Issuer "RapidSSL TLS DV RSA Mixed SHA256 2020 CA-1" (verified OK))
        by bmailout2.hostsharing.net (Postfix) with ESMTPS id C48452800B3C2;
        Sat, 29 May 2021 14:08:35 +0200 (CEST)
Received: by h08.hostsharing.net (Postfix, from userid 100393)
        id B6CDB1AFD99; Sat, 29 May 2021 14:08:35 +0200 (CEST)
Date:   Sat, 29 May 2021 14:08:35 +0200
From:   Lukas Wunner <lukas@wunner.de>
To:     gregkh@linuxfoundation.org
Cc:     broonie@kernel.org, sr@denx.de, stable@vger.kernel.org
Subject: Re: FAILED: patch "[PATCH] spi: mt7621: Don't leak SPI master in
 probe error path" failed to apply to 4.19-stable tree
Message-ID: <20210529120835.GB31339@wunner.de>
References: <1609153649331@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1609153649331@kroah.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Dec 28, 2020 at 12:07:29PM +0100, gregkh@linuxfoundation.org wrote:
> The patch below does not apply to the 4.19-stable tree.
> If someone wants it applied there, or to any other stable or longterm
> tree, then please email the backport, including the original git commit
> id to <stable@vger.kernel.org>.

Here's the backport of 46b5c4fb87ce to v4.19.192:

-- >8 --
From: Lukas Wunner <lukas@wunner.de>
Date: Mon, 7 Dec 2020 09:17:14 +0100
Subject: [PATCH] spi: mt7621: Don't leak SPI master in probe error path

commit 46b5c4fb87ce8211e0f9b0383dbde72c3652d2ba upstream.

If the calls to device_reset() or spi_register_master() fail on
probe of the MediaTek MT7621 SPI driver, the spi_master struct is
erroneously not freed.  Fix by switching over to the new
devm_spi_alloc_master() helper.

Additionally, there's an ordering issue in mt7621_spi_remove() wherein
the spi_master is unregistered after disabling the SYS clock.
The correct order is to call spi_unregister_master() *before* this
teardown step because bus accesses may still be ongoing until that
function returns.  Moreover, the clock is disabled but not unprepared.

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
---
 drivers/staging/mt7621-spi/spi-mt7621.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/mt7621-spi/spi-mt7621.c b/drivers/staging/mt7621-spi/spi-mt7621.c
index ebfbe5ee479a..75ed48f60c8c 100644
--- a/drivers/staging/mt7621-spi/spi-mt7621.c
+++ b/drivers/staging/mt7621-spi/spi-mt7621.c
@@ -452,7 +452,7 @@ static int mt7621_spi_probe(struct platform_device *pdev)
 	if (status)
 		return status;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*rs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*rs));
 	if (master == NULL) {
 		dev_info(&pdev->dev, "master allocation failed\n");
 		clk_disable_unprepare(clk);
@@ -502,8 +502,8 @@ static int mt7621_spi_remove(struct platform_device *pdev)
 	master = dev_get_drvdata(&pdev->dev);
 	rs = spi_master_get_devdata(master);
 
-	clk_disable(rs->clk);
 	spi_unregister_master(master);
+	clk_disable_unprepare(rs->clk);
 
 	return 0;
 }
-- 
2.31.1

