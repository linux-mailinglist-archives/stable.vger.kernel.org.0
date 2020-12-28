Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 042E12E3EBF
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503626AbgL1OaR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:30:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:38076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2503617AbgL1OaQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:30:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B54FB20715;
        Mon, 28 Dec 2020 14:30:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165801;
        bh=1BSslsqxMy717FWz4yCJakZK4RQeXyjOWZHJDGse5vE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cy65uM1CVcqNzXgFlRe8RkdWzM4RUi9dav6MfughIlMWucNp+KRq9iRRuLP8XMEtC
         yY2e0i/sXYLqfFECPuUm+zVB5aTcG8EichjWAL0shf8mKDnBmrRWYAkYH8pHIO4Csg
         M3nT7kEuUolxay1EvuYTlbtIEWVGsPHDu1S90zAk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Stefan Roese <sr@denx.de>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 660/717] spi: mt7621: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:58 +0100
Message-Id: <20201228125052.585986478@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-mt7621.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-mt7621.c
+++ b/drivers/spi/spi-mt7621.c
@@ -350,7 +350,7 @@ static int mt7621_spi_probe(struct platf
 	if (status)
 		return status;
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*rs));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*rs));
 	if (!master) {
 		dev_info(&pdev->dev, "master allocation failed\n");
 		clk_disable_unprepare(clk);
@@ -382,7 +382,7 @@ static int mt7621_spi_probe(struct platf
 		return ret;
 	}
 
-	ret = devm_spi_register_controller(&pdev->dev, master);
+	ret = spi_register_controller(master);
 	if (ret)
 		clk_disable_unprepare(clk);
 
@@ -397,6 +397,7 @@ static int mt7621_spi_remove(struct plat
 	master = dev_get_drvdata(&pdev->dev);
 	rs = spi_controller_get_devdata(master);
 
+	spi_unregister_controller(master);
 	clk_disable_unprepare(rs->clk);
 
 	return 0;


