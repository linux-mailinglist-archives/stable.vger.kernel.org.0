Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D1A756FB17
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231263AbiGKJZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:25:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232408AbiGKJYj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:24:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 798AA2A427;
        Mon, 11 Jul 2022 02:15:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D532F6123B;
        Mon, 11 Jul 2022 09:15:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8FFEC341C0;
        Mon, 11 Jul 2022 09:15:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530903;
        bh=Thsqa8+oXxSlU5z5RVlpc5ANmuoUcNe2Gohr70520l0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=izkg/dP0IREvJoxSbtbPLGhy3rgx9JI0VU11q4eTPwd684LYCfOwtH8BvND2ZCIXW
         gZU/Zh97egZvz7LAFjqtkBi0QpTtQrfgO5XgmF6smUJXAWAe1K+lmh2MWzV1AOOsiN
         Ja8zqFl+wAT5USu0fiaGhg9rjMCo3lacbIllgKiY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Rasmus Villemoes <rasmus.villemoes@prevas.dk>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.18 025/112] can: mcp251xfd: mcp251xfd_register_get_dev_id(): fix endianness conversion
Date:   Mon, 11 Jul 2022 11:06:25 +0200
Message-Id: <20220711090550.274324178@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Marc Kleine-Budde <mkl@pengutronix.de>

commit 1c0e78a287e3493e22bde8553d02f3b89177eaf7 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
+++ b/drivers/net/can/spi/mcp251xfd/mcp251xfd-core.c
@@ -12,6 +12,7 @@
 // Copyright (c) 2019 Martin Sperl <kernel@martin.sperl.org>
 //
 
+#include <asm/unaligned.h>
 #include <linux/bitfield.h>
 #include <linux/clk.h>
 #include <linux/device.h>
@@ -1778,7 +1779,7 @@ mcp251xfd_register_get_dev_id(const stru
 	if (err)
 		goto out_kfree_buf_tx;
 
-	*dev_id = be32_to_cpup((__be32 *)buf_rx->data);
+	*dev_id = get_unaligned_le32(buf_rx->data);
 	*effective_speed_hz_slow = xfer[0].effective_speed_hz;
 	*effective_speed_hz_fast = xfer[1].effective_speed_hz;
 


