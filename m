Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F1A2F7BFF
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 14:09:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732376AbhAONHk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 08:07:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:36412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732352AbhAOMa7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:30:59 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 50142223E0;
        Fri, 15 Jan 2021 12:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610713808;
        bh=vYOnBMwlgCdd1Ail6yvVLfbz0Ss/2pImnzoiell7SrA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yi2H+YAceVsjuq88zUwHK3Ga+UM0Jlu/N33x+A8qzIABsg5pDs0PCwmTLRYuMRh88
         Nf+BtD9xIlEit5aZ7NMZxi0urb4K5R2LOYxkQ21XVrpM47Oz4zzQ7tjZGuZyPv/TE/
         VH+8NcNb9HTb1MXgbxnKF0rhSiOGEAcuqu7d7TXE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lukas Wunner <lukas@wunner.de>,
        Mark Brown <broonie@kernel.org>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.9 13/25] spi: pxa2xx: Fix use-after-free on unbind
Date:   Fri, 15 Jan 2021 13:27:44 +0100
Message-Id: <20210115121957.335128789@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121956.679956165@linuxfoundation.org>
References: <20210115121956.679956165@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>

commit 5626308bb94d9f930aa5f7c77327df4c6daa7759 upstream

pxa2xx_spi_remove() accesses the driver's private data after calling
spi_unregister_controller() even though that function releases the last
reference on the spi_controller and thereby frees the private data.

Fix by switching over to the new devm_spi_alloc_master/slave() helper
which keeps the private data accessible until the driver has unbound.

Fixes: 32e5b57232c0 ("spi: pxa2xx: Fix controller unregister order")
Signed-off-by: Lukas Wunner <lukas@wunner.de>
Cc: <stable@vger.kernel.org> # v2.6.17+: 5e844cc37a5c: spi: Introduce device-managed SPI controller allocation
Cc: <stable@vger.kernel.org> # v2.6.17+: 32e5b57232c0: spi: pxa2xx: Fix controller unregister order
Cc: <stable@vger.kernel.org> # v2.6.17+
Link: https://lore.kernel.org/r/5764b04d4a6e43069ebb7808f64c2f774ac6f193.1607286887.git.lukas@wunner.de
Signed-off-by: Mark Brown <broonie@kernel.org>
[sudip: adjust context]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-pxa2xx.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/spi/spi-pxa2xx.c
+++ b/drivers/spi/spi-pxa2xx.c
@@ -1606,7 +1606,7 @@ static int pxa2xx_spi_probe(struct platf
 		return -ENODEV;
 	}
 
-	master = spi_alloc_master(dev, sizeof(struct driver_data));
+	master = devm_spi_alloc_master(dev, sizeof(*drv_data));
 	if (!master) {
 		dev_err(&pdev->dev, "cannot alloc spi_master\n");
 		pxa_ssp_free(ssp);
@@ -1788,7 +1788,6 @@ out_error_clock_enabled:
 	free_irq(ssp->irq, drv_data);
 
 out_error_master_alloc:
-	spi_master_put(master);
 	pxa_ssp_free(ssp);
 	return status;
 }


