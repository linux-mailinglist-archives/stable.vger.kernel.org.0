Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D01C53CDC93
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:34:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244713AbhGSOxD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:53:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:34044 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238242AbhGSOoc (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:44:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 37B75610A5;
        Mon, 19 Jul 2021 15:23:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626708185;
        bh=aYmCmLwlanssdjfVPHfag2Uu6KXtTJuNJ4MyqSbVFVE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rmhq6ZdKoHEnBG3wVsIo+6b3WIuE3oWerNAVaa3HEyLngunq8V/7Q1BGfI0pL4frP
         S4F+gg5PmHYDjcSuy5e97sumfADHT9wg2myfSeowHccmVanvJMuI+DK4ie1eQglcLB
         2B/yIcyQkcx2/ktTqCsAjV105RjG6u1ni4tEaQTA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Timo Sigurdsson <public_timo.s@silentcreek.de>,
        Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 4.14 213/315] ata: ahci_sunxi: Disable DIPM
Date:   Mon, 19 Jul 2021 16:51:42 +0200
Message-Id: <20210719144950.435832764@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144942.861561397@linuxfoundation.org>
References: <20210719144942.861561397@linuxfoundation.org>
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


