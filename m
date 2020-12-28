Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 286B52E67F9
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:32:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2633366AbgL1Qax (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:30:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:33926 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728574AbgL1NGY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:06:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 298D8206ED;
        Mon, 28 Dec 2020 13:06:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609160768;
        bh=HKVBM16avOEKdjz+NaHmxjroT+xlNi3GmgGkoe+Jq/U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IM9jtQWpRnoS5Vo+eVgySK8AzUCOUHdEu6YGVM31bTP0DUBfWGu2MC4u32tnf8zwB
         18HwGM4GBz0zNWrgslyPiJmL3szQugTM45wcYD+Ya/rQhaXr2F6OCmmEkV1H6hxl+t
         Iqs+7jTLDVbHhTm1dQ6SuXX9hW+B6UZGQjNvP/eU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Bert Vermeulen <bert@biot.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.9 165/175] spi: rb4xx: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:18 +0100
Message-Id: <20201228124901.233708312@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124853.216621466@linuxfoundation.org>
References: <20201228124853.216621466@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit a4729c3506c3eb1a6ca5c0289f4e7cafa4115065 upstream.

If the calls to devm_clk_get(), devm_spi_register_master() or
clk_prepare_enable() fail on probe of the Mikrotik RB4xx SPI driver,
the spi_master struct is erroneously not freed.

Fix by switching over to the new devm_spi_alloc_master() helper.

Fixes: 05aec357871f ("spi: Add SPI driver for Mikrotik RB4xx series boards")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.2+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.2+
Cc: Bert Vermeulen <bert@biot.com>
Link: https://lore.kernel.org/r/369bf26d71927f60943b1d9d8f51810f00b0237d.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-rb4xx.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/spi/spi-rb4xx.c
+++ b/drivers/spi/spi-rb4xx.c
@@ -148,7 +148,7 @@ static int rb4xx_spi_probe(struct platfo
 	if (IS_ERR(spi_base))
 		return PTR_ERR(spi_base);
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*rbspi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*rbspi));
 	if (!master)
 		return -ENOMEM;
 


