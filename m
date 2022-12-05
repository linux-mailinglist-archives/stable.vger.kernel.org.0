Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E30B6433EE
	for <lists+stable@lfdr.de>; Mon,  5 Dec 2022 20:40:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234401AbiLETkt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Dec 2022 14:40:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234374AbiLETka (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Dec 2022 14:40:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53B3128728
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 11:37:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E553661311
        for <stable@vger.kernel.org>; Mon,  5 Dec 2022 19:37:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0466EC433B5;
        Mon,  5 Dec 2022 19:37:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1670269072;
        bh=uA5CALhIq667XGurqqub0EGPcy/ZohPRsfwHvF25Kbg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gS2aMk7FCczXshxNCqueOX1INLKSl/CL6ngtLSF/A+OVLQ18m/GKH+Da2D6kMQy2J
         5MAHfnNqGX6FVHjyy5ZwVZJLEPTV7DRPDgG17gWItztIFZSabROtXJrUepsRVVFy57
         pQ689YTB3594dGIfDmLVJGZIekaO1wUzecy1wo2Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Andrew Lunn <andrew@lunn.ch>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 115/120] i2c: imx: Only DMA messages with I2C_M_DMA_SAFE flag set
Date:   Mon,  5 Dec 2022 20:10:55 +0100
Message-Id: <20221205190809.976493071@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221205190806.528972574@linuxfoundation.org>
References: <20221205190806.528972574@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit d36678f7905cbd1dc55a8a96e066dafd749d4600 ]

Recent changes to the DMA code has resulting in the IMX driver failing
I2C transfers when the buffer has been vmalloc. Only perform DMA
transfers if the message has the I2C_M_DMA_SAFE flag set, indicating
the client is providing a buffer which is DMA safe.

This is a minimal fix for stable. The I2C core provides helpers to
allocate a bounce buffer. For a fuller fix the master should make use
of these helpers.

Fixes: 4544b9f25e70 ("dma-mapping: Add vmap checks to dma_map_single()")
Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Acked-by: Oleksij Rempel <o.rempel@pengutronix.de>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx.c b/drivers/i2c/busses/i2c-imx.c
index 2e4d05040e50..5e8853d3f8da 100644
--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1051,7 +1051,8 @@ static int i2c_imx_read(struct imx_i2c_struct *i2c_imx, struct i2c_msg *msgs,
 	int i, result;
 	unsigned int temp;
 	int block_data = msgs->flags & I2C_M_RECV_LEN;
-	int use_dma = i2c_imx->dma && msgs->len >= DMA_THRESHOLD && !block_data;
+	int use_dma = i2c_imx->dma && msgs->flags & I2C_M_DMA_SAFE &&
+		msgs->len >= DMA_THRESHOLD && !block_data;
 
 	dev_dbg(&i2c_imx->adapter.dev,
 		"<%s> write slave address: addr=0x%x\n",
@@ -1217,7 +1218,8 @@ static int i2c_imx_xfer_common(struct i2c_adapter *adapter,
 			result = i2c_imx_read(i2c_imx, &msgs[i], is_lastmsg, atomic);
 		} else {
 			if (!atomic &&
-			    i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD)
+			    i2c_imx->dma && msgs[i].len >= DMA_THRESHOLD &&
+				msgs[i].flags & I2C_M_DMA_SAFE)
 				result = i2c_imx_dma_write(i2c_imx, &msgs[i]);
 			else
 				result = i2c_imx_write(i2c_imx, &msgs[i], atomic);
-- 
2.35.1



