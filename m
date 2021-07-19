Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 318C43CD9A4
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:12:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243721AbhGSObK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:31:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:39078 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S244838AbhGSOaF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:30:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 859AA6024A;
        Mon, 19 Jul 2021 15:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707444;
        bh=aYmCmLwlanssdjfVPHfag2Uu6KXtTJuNJ4MyqSbVFVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=osOF94Rid2XS8SRHzi6Lv79l7BuuPaFJe/HeF9vh92bn6TTwubElOQH7Uf2qRF8FD
         wEqPk9VhsCLnEhmq5Dk7xGSf5TBe+WOmr8Oywgrw62hy4mgirg3TwOsYAFxDi+XPXf
         73ijEuJF+QfqLSDqSlusCcBQbmbLTBYbHaMCIF+o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Timo Sigurdsson <public_timo.s@silentcreek.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.9 165/245] ata: ahci_sunxi: Disable DIPM
Date:   Mon, 19 Jul 2021 16:51:47 +0200
Message-Id: <20210719144945.746283148@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Timo Sigurdsson <public_timo.s@silentcreek.de>

commit f6bca4d91b2ea052e917cca3f9d866b5cc1d500a upstream.

DIPM is unsupported or broken on sunxi. Trying to enable the power
management policy med_power_with_dipm on an Allwinner A20 SoC based board
leads to immediate I/O errors and the attached SATA disk disappears from
the /dev filesystem. A reset (power cycle) is required to make the SATA
controller or disk work again. The A10 and A20 SoC data sheets and manuals
don't mention DIPM at all [1], so it's fair to assume that it's simply not
supported. But even if it was, it should be considered broken and best be
disabled in the ahci_sunxi driver.

[1] https://github.com/allwinner-zh/documents/tree/master/

Fixes: c5754b5220f0 ("ARM: sunxi: Add support for Allwinner SUNXi SoCs sata to ahci_platform")
Cc: stable@vger.kernel.org
Signed-off-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
Tested-by: Timo Sigurdsson <public_timo.s@silentcreek.de>
Link: https://lore.kernel.org/r/20210614072539.3307-1-public_timo.s@silentcreek.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/ata/ahci_sunxi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/ata/ahci_sunxi.c
+++ b/drivers/ata/ahci_sunxi.c
@@ -165,7 +165,7 @@ static void ahci_sunxi_start_engine(stru
 }
 
 static const struct ata_port_info ahci_sunxi_port_info = {
-	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ,
+	.flags		= AHCI_FLAG_COMMON | ATA_FLAG_NCQ | ATA_FLAG_NO_DIPM,
 	.pio_mask	= ATA_PIO4,
 	.udma_mask	= ATA_UDMA6,
 	.port_ops	= &ahci_platform_ops,


