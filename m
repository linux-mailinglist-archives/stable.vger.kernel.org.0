Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC22E3BA3
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:53:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2407165AbgL1Nwm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:52:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:53574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2407018AbgL1Nwl (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:52:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A660520738;
        Mon, 28 Dec 2020 13:52:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163546;
        bh=yyNTEGvidqyY7u2UNfNu6Uh8DCiiaOGctmRuLJ5eDAQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F7X9eP18oKo7dTay0rEC9Ffm5ccLXqyLC284hOiX0sCJ7ZayXHgfras4Q21TwAoFC
         7XLOvstcbjCJkvB4Gk+qNQk/g0FZfA7lnImJwlop8afgwV2RHsa2do4ByJ03+LATp2
         H/hGLcNLR+j97iOlh+4DYkTuuHq/L+60pvL9PQVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Kozlov Sergey <serjk@netup.ru>, Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.4 323/453] media: netup_unidvb: Dont leak SPI master in probe error path
Date:   Mon, 28 Dec 2020 13:49:19 +0100
Message-Id: <20201228124952.751312582@linuxfoundation.org>
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

commit e297ddf296de35037fa97f4302782def196d350a upstream.

If the call to spi_register_master() fails on probe of the NetUP
Universal DVB driver, the spi_master struct is erroneously not freed.

Likewise, if spi_new_device() fails, the spi_controller struct is
not unregistered.  Plug the leaks.

While at it, fix an ordering issue in netup_spi_release() wherein
spi_unregister_master() is called after fiddling with the IRQ control
register.  The correct order is to call spi_unregister_master() *before*
this teardown step because bus accesses may still be ongoing until that
function returns.

Fixes: 52b1eaf4c59a ("[media] netup_unidvb: NetUP Universal DVB-S/S2/T/T2/C PCI-E card driver")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc: <stable@vger.kernel.org> # v4.3+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v4.3+
Cc: Kozlov Sergey <serjk@netup.ru>
Link: https://lore.kernel.org/r/c4c24f333fc7840f4a3db24789e6e10dd660bede.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/pci/netup_unidvb/netup_unidvb_spi.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
+++ b/drivers/media/pci/netup_unidvb/netup_unidvb_spi.c
@@ -175,7 +175,7 @@ int netup_spi_init(struct netup_unidvb_d
 	struct spi_master *master;
 	struct netup_spi *nspi;
 
-	master = spi_alloc_master(&ndev->pci_dev->dev,
+	master = devm_spi_alloc_master(&ndev->pci_dev->dev,
 		sizeof(struct netup_spi));
 	if (!master) {
 		dev_err(&ndev->pci_dev->dev,
@@ -208,6 +208,7 @@ int netup_spi_init(struct netup_unidvb_d
 		ndev->pci_slot,
 		ndev->pci_func);
 	if (!spi_new_device(master, &netup_spi_board)) {
+		spi_unregister_master(master);
 		ndev->spi = NULL;
 		dev_err(&ndev->pci_dev->dev,
 			"%s(): unable to create SPI device\n", __func__);
@@ -226,13 +227,13 @@ void netup_spi_release(struct netup_unid
 	if (!spi)
 		return;
 
+	spi_unregister_master(spi->master);
 	spin_lock_irqsave(&spi->lock, flags);
 	reg = readw(&spi->regs->control_stat);
 	writew(reg | NETUP_SPI_CTRL_IRQ, &spi->regs->control_stat);
 	reg = readw(&spi->regs->control_stat);
 	writew(reg & ~NETUP_SPI_CTRL_IMASK, &spi->regs->control_stat);
 	spin_unlock_irqrestore(&spi->lock, flags);
-	spi_unregister_master(spi->master);
 	ndev->spi = NULL;
 }
 


