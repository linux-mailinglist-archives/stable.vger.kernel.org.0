Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C35C56B87A
	for <lists+stable@lfdr.de>; Fri,  8 Jul 2022 13:29:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237828AbiGHL1R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 Jul 2022 07:27:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237747AbiGHL1P (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 8 Jul 2022 07:27:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0683904DB
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 04:27:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48FB8B82180
        for <stable@vger.kernel.org>; Fri,  8 Jul 2022 11:27:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B5E8C341C0;
        Fri,  8 Jul 2022 11:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657279631;
        bh=1n6ppU3B0YAN0hj/0aIKAtnpPqdqXQ3jw1w1TXehLTw=;
        h=Subject:To:Cc:From:Date:From;
        b=UtlqP0Tw1tgUYGTd+2p+oK8D62RsO+d4lkdq+d5MEJ2RYpImZMIu0o5rYcEL9IGSw
         q4bQQ53atfPb5m9kxnjgP6u6gSV6gc9GBtnmKh1gavmYbEgBtU2TJ5Nzj2vvnlP/sM
         PMd2ieOyD5zf93IXfOEIyyb9JIsVXvcX+/IyDTI0=
Subject: FAILED: patch "[PATCH] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix" failed to apply to 5.15-stable tree
To:     mkl@pengutronix.de, manivannan.sadhasivam@linaro.org,
        rasmus.villemoes@prevas.dk
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Fri, 08 Jul 2022 13:27:06 +0200
Message-ID: <165727962680181@kroah.com>
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


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 1c0e78a287e3493e22bde8553d02f3b89177eaf7 Mon Sep 17 00:00:00 2001
From: Marc Kleine-Budde <mkl@pengutronix.de>
Date: Mon, 20 Jun 2022 11:49:24 +0200
Subject: [PATCH] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix
 endianness conversion

In mcp251xfd_register_get_dev_id() the device ID register is read with
handcrafted SPI transfers. As all registers, this register is in
little endian. Further it is not naturally aligned in struct
mcp251xfd_map_buf_nocrc::data. However after the transfer the register
content is converted from big endian to CPU endianness not taking care
of being unaligned.

Fix the conversion by converting from little endian to CPU endianness
taking the unaligned source into account.

Side note: So far the register content is 0x0 on all mcp251xfd
compatible chips, and is only used for an informative printk.

Link: https://lore.kernel.org/all/20220627092859.809042-1-mkl@pengutronix.de
Fixes: 55e5b97f003e ("can: mcp25xxfd: add driver for Microchip MCP25xxFD SPI CAN")
Reviewed-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>

diff --git a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
index 3160881e89d9..9b47b07162fe 100644
--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -12,6 +12,7 @@
 // Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
 //
 
+#include <asm/unaligned.h>
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/device.h>
@@ -1787,7 +1788,7 @@ mcp251xfd_register_get_dev_id(const struct mcp251xfd_priv *priv, u32 *dev_id,
 	if (err)
 		goto out_kfree_buf_tx;
 
-	*dev_id = be32_to_cpup((__be32 *)buf_rx->data);
+	*dev_id = get_unaligned_le32(buf_rx->data);
 	*effective_speed_hz_slow = xfer[0].effective_speed_hz;
 	*effective_speed_hz_fast = xfer[1].effective_speed_hz;
 

