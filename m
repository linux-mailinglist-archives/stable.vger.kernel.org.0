Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69EBB5218CA
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:36:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243297AbiEJNkQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41314 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245170AbiEJNig (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:38:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 563B2263DA3;
        Tue, 10 May 2022 06:27:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E9A5061811;
        Tue, 10 May 2022 13:27:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F33E2C385C6;
        Tue, 10 May 2022 13:27:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652189276;
        bh=vhZPAZC12jopcl22RGk4KShYkyUbXa5G4GTjYZOb4Gc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=B5+7xARIWHsJQVVofJF/SeGsdnfr182WjszsfPgIiYXyaAY6JwAHiBCrK2NSh7ZaQ
         AuNLeQkmrZ/8gzinGVRkpq7c0H3oQrKjBnMFS1I2FQ3hrLdLSK+ZSV/t7YLdbeDEoi
         n1JtOZCuXPa+8YP+4arVq24rmze8Jf6Zr3joliyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Hellstrom <daniel@gaisler.com>,
        Andreas Larsson <andreas@gaisler.com>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 28/70] can: grcan: use ofdev->dev when allocating DMA memory
Date:   Tue, 10 May 2022 15:07:47 +0200
Message-Id: <20220510130733.693424668@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130732.861729621@linuxfoundation.org>
References: <20220510130732.861729621@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Hellstrom <daniel@gaisler.com>

commit 101da4268626b00d16356a6bf284d66e44c46ff9 upstream.

Use the device of the device tree node should be rather than the
device of the struct net_device when allocating DMA buffers.

The driver got away with it on sparc32 until commit 53b7670e5735
("sparc: factor the dma coherent mapping into helper") after which the
driver oopses.

Fixes: 6cec9b07fe6a ("can: grcan: Add device driver for GRCAN and GRHCAN cores")
Link: https://lore.kernel.org/all/20220429084656.29788-2-andreas@gaisler.com
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Hellstrom <daniel@gaisler.com>
Signed-off-by: Andreas Larsson <andreas@gaisler.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/grcan.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/net/can/grcan.c
+++ b/drivers/net/can/grcan.c
@@ -248,6 +248,7 @@ struct grcan_device_config {
 struct grcan_priv {
 	struct can_priv can;	/* must be the first member */
 	struct net_device *dev;
+	struct device *ofdev_dev;
 	struct napi_struct napi;
 
 	struct grcan_registers __iomem *regs;	/* ioremap'ed registers */
@@ -924,7 +925,7 @@ static void grcan_free_dma_buffers(struc
 	struct grcan_priv *priv = netdev_priv(dev);
 	struct grcan_dma *dma = &priv->dma;
 
-	dma_free_coherent(&dev->dev, dma->base_size, dma->base_buf,
+	dma_free_coherent(priv->ofdev_dev, dma->base_size, dma->base_buf,
 			  dma->base_handle);
 	memset(dma, 0, sizeof(*dma));
 }
@@ -949,7 +950,7 @@ static int grcan_allocate_dma_buffers(st
 
 	/* Extra GRCAN_BUFFER_ALIGNMENT to allow for alignment */
 	dma->base_size = lsize + ssize + GRCAN_BUFFER_ALIGNMENT;
-	dma->base_buf = dma_alloc_coherent(&dev->dev,
+	dma->base_buf = dma_alloc_coherent(priv->ofdev_dev,
 					   dma->base_size,
 					   &dma->base_handle,
 					   GFP_KERNEL);
@@ -1602,6 +1603,7 @@ static int grcan_setup_netdev(struct pla
 	memcpy(&priv->config, &grcan_module_config,
 	       sizeof(struct grcan_device_config));
 	priv->dev = dev;
+	priv->ofdev_dev = &ofdev->dev;
 	priv->regs = base;
 	priv->can.bittiming_const = &grcan_bittiming_const;
 	priv->can.do_set_bittiming = grcan_set_bittiming;


