Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D69B32F7AE5
	for <lists+stable@lfdr.de>; Fri, 15 Jan 2021 13:58:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387449AbhAOMeN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jan 2021 07:34:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40840 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387444AbhAOMeM (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 15 Jan 2021 07:34:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A29C02339D;
        Fri, 15 Jan 2021 12:33:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610714037;
        bh=aoInMzShLeeeTg/+4PHS2tDkgza81v84yMhCYK+h/ec=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DLoIjnRtjS0DK1B7wOzlWXWUoLaXkUZdZxBiohsD0AZ95c50KzXndvYsAkJXdjVME
         AWgy1sjRFzsK6exdHbIG2ElLfvMfue2O56h7A5gNBxkdUcL09/UHf4splbs3SHJRi0
         07TsUqlHtKMMIfsQwSxKvDyni8zHm9aruQLiEa6U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        Chris Zankel <chris@zankel.net>,
        Finn Thain <fthain@telegraphics.com.au>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 09/62] net/sonic: Fix some resource leaks in error handling paths
Date:   Fri, 15 Jan 2021 13:27:31 +0100
Message-Id: <20210115121958.849755936@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115121958.391610178@linuxfoundation.org>
References: <20210115121958.391610178@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 0f7ba7bc46fa0b574ccacf5672991b321e028492 ]

A call to dma_alloc_coherent() is wrapped by sonic_alloc_descriptors().

This is correctly freed in the remove function, but not in the error
handling path of the probe function. Fix this by adding the missing
dma_free_coherent() call.

While at it, rename a label in order to be slightly more informative.

Cc: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc: Thomas Bogendoerfer <tsbogend@alpha.franken.de>
Cc: Chris Zankel <chris@zankel.net>
Fixes: 74f2a5f0ef64 ("xtensa: Add support for the Sonic Ethernet device for the XT2000 board.")
Fixes: efcce839360f ("[PATCH] macsonic/jazzsonic network drivers update")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/natsemi/macsonic.c |   12 ++++++++++--
 drivers/net/ethernet/natsemi/xtsonic.c  |    7 +++++--
 2 files changed, 15 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/natsemi/macsonic.c
+++ b/drivers/net/ethernet/natsemi/macsonic.c
@@ -540,10 +540,14 @@ static int mac_sonic_platform_probe(stru
 
 	err = register_netdev(dev);
 	if (err)
-		goto out;
+		goto undo_probe;
 
 	return 0;
 
+undo_probe:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 out:
 	free_netdev(dev);
 
@@ -618,12 +622,16 @@ static int mac_sonic_nubus_probe(struct
 
 	err = register_netdev(ndev);
 	if (err)
-		goto out;
+		goto undo_probe;
 
 	nubus_set_drvdata(board, ndev);
 
 	return 0;
 
+undo_probe:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 out:
 	free_netdev(ndev);
 	return err;
--- a/drivers/net/ethernet/natsemi/xtsonic.c
+++ b/drivers/net/ethernet/natsemi/xtsonic.c
@@ -265,11 +265,14 @@ int xtsonic_probe(struct platform_device
 	sonic_msg_init(dev);
 
 	if ((err = register_netdev(dev)))
-		goto out1;
+		goto undo_probe1;
 
 	return 0;
 
-out1:
+undo_probe1:
+	dma_free_coherent(lp->device,
+			  SIZEOF_SONIC_DESC * SONIC_BUS_SCALE(lp->dma_bitmode),
+			  lp->descriptors, lp->descriptors_laddr);
 	release_region(dev->base_addr, SONIC_MEM_SIZE);
 out:
 	free_netdev(dev);


