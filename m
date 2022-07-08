Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFA1856B882
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 13:29:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbiGHL1G (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 07:27:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237827AbiGHL1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 07:27:05 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F9D904E1
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 04:27:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3D7E624AB
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:27:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CCFE1C341C7;
        Fri,  8 Jul 2022 11:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657279624;
        bh=IUOI+09nImQzKFruDuGv2llyq5r98jswgXwOTQuZ8A4=;
        h=Subject:To:Cc:From:Date:From;
        b=ByGKXKAioEhARkaUEfybQd2yDLaFFC3VHcwt1JUM8rVhi7v+jn0JW26XTlOCu4eZl
         hXTrW0PdBRhL0HD9mrLr49rok69VIvpsCSWd/VDGUm6ycyUpKoXPtuXXawQehb4jN+
         RW4SP9RvhtUnJDK5P3hIwds8sgWmQV3el+M2dOxA=
Subject: FAILED: patch "[PATCH] can: mcp251xfd: mcp251xfd_register_get_dev_id(): use correct" failed to apply to 5.10-stable tree
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        rasmus.villemoes@prevas.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Jul 2022 13:26:53 +0200
Message-ID: <16572796136867@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.10-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0ff32bfa0e794ccc3601de7158b522bf736fa63c Mon Sep 17 00:00:00 2001
From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Thu, 16 Jun 2022 11:38:00 +0200
Subject: [PATCH] can: mcp251xfd: mcp251xfd_register_get_dev_id(): use correct
 length to read dev_id

The device ID register is 32 bits wide. The driver uses incorrectly
the size of a pointer to a u32 to calculate the length of the SPI
transfer. This results in a read of 2 registers on 64 bit platforms.
This is no problem on the Linux side, as the RX buffer of the SPI
transfer is large enough. In the mpc251xfd chip this results in the
read of an undocumented register. So far no problems were observed.

Fix the length of the SPI transfer to read the device ID register
only.

Link: https://lore.kernel.org/all/20220616094914.244440-1-mkl@pengutronix.de
Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Reported-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 34b160024ce3..3160881e89d9 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -1778,7 +1778,7 @@ mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv, u32 *dev_id,
 	xfer[0].len = sizeof(buf_tx->cmd);
 	xfer[0].speed_hz = priv->spi_max_speed_hz_slow;
 	xfer[1].rx_buf = buf_rx->data;
-	xfer[1].len = sizeof(dev_id);
+	xfer[1].len = sizeof(*dev_id);
 	xfer[1].speed_hz = priv->spi_max_speed_hz_fast;
 
 	mcp251xfd_spi_cmd_read_nocrc(&buf_tx->cmd, MCP251XFD_REG_DEVID);

