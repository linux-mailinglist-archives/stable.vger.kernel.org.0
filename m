Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63BA25490F9
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:27:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357694AbiFMMA0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358191AbiFML7h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 07:59:37 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A2934DF7E;
        Mon, 13 Jun 2022 03:56:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A1EBC6139D;
        Mon, 13 Jun 2022 10:56:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AECCCC34114;
        Mon, 13 Jun 2022 10:56:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655117794;
        bh=HTFSOGHBWdRDwUFiV3IKhBF8OEM33YNKdbdeRaZD1kI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZ0wmuBRgNZ4chIBX6Be7U1G76rUmkbpOPLaDmtL5WCIw5Z82+BTSpMZeQ4/ZXlAV
         VSnMUHRloKAOzEbd/zHolyKBUfeWsvyJzJk0lM2Mr1vl9O0Dd5jv6hL+bG0a9WC5Z6
         oROUBibufwL/w6tsAEG3PnI3ytvUleroM1KonJ6Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 134/287] i2c: at91: use dma safe buffers
Date:   Mon, 13 Jun 2022 12:09:18 +0200
Message-Id: <20220613094927.943345073@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094923.832156175@linuxfoundation.org>
References: <20220613094923.832156175@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 03fbb903c8bf7e53e101e8d9a7b261264317c411 ]

The supplied buffer might be on the stack and we get the following error
message:
[    3.312058] at91_i2c e0070600.i2c: rejecting DMA map of vmalloc memory

Use i2c_{get,put}_dma_safe_msg_buf() to get a DMA-able memory region if
necessary.

Fixes: 60937b2cdbf9 ("i2c: at91: add dma support")
Signed-off-by: Michael Walle <michael@walle.cc>
Reviewed-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-at91.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/i2c/busses/i2c-at91.c b/drivers/i2c/busses/i2c-at91.c
index d51bf536bdf7..d5119a2adf5d 100644
--- a/drivers/i2c/busses/i2c-at91.c
+++ b/drivers/i2c/busses/i2c-at91.c
@@ -757,6 +757,7 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 	unsigned int_addr_flag = 0;
 	struct i2c_msg *m_start = msg;
 	bool is_read;
+	u8 *dma_buf;
 
 	dev_dbg(&adap->dev, "at91_xfer: processing %d messages:\n", num);
 
@@ -804,7 +805,17 @@ static int at91_twi_xfer(struct i2c_adapter *adap, struct i2c_msg *msg, int num)
 	dev->msg = m_start;
 	dev->recv_len_abort = false;
 
+	if (dev->use_dma) {
+		dma_buf = i2c_get_dma_safe_msg_buf(m_start, 1);
+		if (!dma_buf) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		dev->buf = dma_buf;
+	}
+
 	ret = at91_do_twi_transfer(dev);
+	i2c_put_dma_safe_msg_buf(dma_buf, m_start, !ret);
 
 	ret = (ret < 0) ? ret : num;
 out:
-- 
2.35.1



