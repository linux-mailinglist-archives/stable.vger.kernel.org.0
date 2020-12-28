Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5160C2E4299
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:25:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407827AbgL1N6j (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:58:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:60410 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407791AbgL1N6g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:58:36 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 951AF206E5;
        Mon, 28 Dec 2020 13:57:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163876;
        bh=4/UIqvR/aOD/azOYDLGSWkRRB7cyUOx2lvDnvdFIVjM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tpiVy+yHxyX2zWH3HUr57/ItAKDlvF7iUBkCk6OD1+IsjW7p5nil92DD81kpuZYjO
         ClKi9Fr49+hINm/9XSTuIGgNLCiODGm4AB/mQftqbkD1hFKxQzooMZUf5XraCtcoLi
         JqsH3Oc2GTXF+6VaHuH1h5tkoFJFV8Luh3vLwNKc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Bert Vermeulen <bert@biot.com>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 409/453] spi: rb4xx: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:50:45 +0100
Message-Id: <20201228124956.898047047@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
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
@@ -142,7 +142,7 @@ static int rb4xx_spi_probe(struct platfo
 	if (IS_ERR(spi_base))
 		return PTR_ERR(spi_base);
 
-	master = spi_alloc_master(&pdev->dev, sizeof(*rbspi));
+	master = devm_spi_alloc_master(&pdev->dev, sizeof(*rbspi));
 	if (!master)
 		return -ENOMEM;
 


