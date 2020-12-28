Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111652E6517
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:57:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389330AbgL1P5A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 10:57:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:35674 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389347AbgL1Nf2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:35:28 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 25CDA20719;
        Mon, 28 Dec 2020 13:35:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162512;
        bh=aRFtjc0P4kSaBuZtpRKNgR4103VojKbxB7pdrr3GHNA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HY07Z1laMZZk9SOzX6vYZ9+PlZ5f9XJJJHFMWkwuoZZej4pSCQta2Vz3uVEBW8xTW
         BVcQjYcpCMqGlfrGn1hEmBmulL4dUQaMoGsaQlkcxZt/hOucUFv0sCtsAhuFHbjAjT
         Gnd9pH3etmfC1Q4tAetfIKlSpbb63tjT3kwHbWl4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Purna Chandra Mandal <purna.mandal@microchip.com>,
        Mark Brown <broonie@kernel.org>
Subject: [PATCH 4.19 317/346] spi: pic32: Dont leak DMA channels in probe error path
Date:   Mon, 28 Dec 2020 13:50:36 +0100
Message-Id: <20201228124935.114493856@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit c575e9113bff5e024d75481613faed5ef9d465b2 upstream.

If the calls to devm_request_irq() or devm_spi_register_master() fail
on probe of the PIC32 SPI driver, the DMA channels requested by
pic32_spi_dma_prep() are erroneously not released.  Plug the leak.

Fixes: 1bcb9f8ceb67 ("spi: spi-pic32: Add PIC32 SPI master driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v4.7+
Cc: Purna Chandra Mandal <purna.mandal@microchip.com>
Link: https://lore.kernel.org/r/9624250e3a7aa61274b38219a62375bac1def637.1604874488.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/spi/spi-pic32.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/spi/spi-pic32.c
+++ b/drivers/spi/spi-pic32.c
@@ -839,6 +839,7 @@ static int pic32_spi_probe(struct platfo
 	return 0;
 
 err_bailout:
+	pic32_spi_dma_unprep(pic32s);
 	clk_disable_unprepare(pic32s->clk);
 err_master:
 	spi_master_put(master);


