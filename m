Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A6D6CC3B6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:56:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbjC1O4n (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:56:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233575AbjC1O4l (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:56:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 447EBD33A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:56:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D37FCB81D68
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:56:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 259F8C433D2;
        Tue, 28 Mar 2023 14:56:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680015396;
        bh=RNFwa18Oo4RwKvSJdNGd4MX+4jvZTzgq3AWMHP9L8ys=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hawNZTQDHGF13UpmEGFvV9PmlWtcJUQj0LTmf89SK9flXpm1C3eaj97Xi2NpHC7Fs
         W+j2xa91iakuloJh3pOXzf67nUhloxkFcGmq1MWVkGjn8UvPP73oYFIPeG15KYDNwP
         5NFWJ6fwnaJ1iPAmee+hOHJtVtjRFfQEYgfm8i30=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Matthias Schiffer <matthias.schiffer@ew.tq-group.com>,
        Wolfram Sang <wsa@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 033/224] i2c: mxs: ensure that DMA buffers are safe for DMA
Date:   Tue, 28 Mar 2023 16:40:29 +0200
Message-Id: <20230328142618.711452761@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142617.205414124@linuxfoundation.org>
References: <20230328142617.205414124@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>

[ Upstream commit 5190417bdf72c71b65bd9892103c6186816a6e8b ]

We found that after commit 9c46929e7989
("ARM: implement THREAD_INFO_IN_TASK for uniprocessor systems"), the
PCF85063 RTC driver stopped working on i.MX28 due to regmap_bulk_read()
reading bogus data into a stack buffer. This is caused by the i2c-mxs
driver using DMA transfers even for messages without the I2C_M_DMA_SAFE
flag, and the aforementioned commit enabling vmapped stacks.

As the MXS I2C controller requires DMA for reads of >4 bytes, DMA can't be
disabled, so the issue is fixed by using i2c_get_dma_safe_msg_buf() to
create a bounce buffer when needed.

Fixes: 9c46929e7989 ("ARM: implement THREAD_INFO_IN_TASK for uniprocessor systems")
Signed-off-by: Matthias Schiffer <matthias.schiffer@ew.tq-group.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-mxs.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/i2c/busses/i2c-mxs.c b/drivers/i2c/busses/i2c-mxs.c
index d113bed795452..e0f3b3545cfe4 100644
--- a/drivers/i2c/busses/i2c-mxs.c
+++ b/drivers/i2c/busses/i2c-mxs.c
@@ -171,7 +171,7 @@ static void mxs_i2c_dma_irq_callback(void *param)
 }
 
 static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
-			struct i2c_msg *msg, uint32_t flags)
+			struct i2c_msg *msg, u8 *buf, uint32_t flags)
 {
 	struct dma_async_tx_descriptor *desc;
 	struct mxs_i2c_dev *i2c = i2c_get_adapdata(adap);
@@ -226,7 +226,7 @@ static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
 		}
 
 		/* Queue the DMA data transfer. */
-		sg_init_one(&i2c->sg_io[1], msg->buf, msg->len);
+		sg_init_one(&i2c->sg_io[1], buf, msg->len);
 		dma_map_sg(i2c->dev, &i2c->sg_io[1], 1, DMA_FROM_DEVICE);
 		desc = dmaengine_prep_slave_sg(i2c->dmach, &i2c->sg_io[1], 1,
 					DMA_DEV_TO_MEM,
@@ -259,7 +259,7 @@ static int mxs_i2c_dma_setup_xfer(struct i2c_adapter *adap,
 		/* Queue the DMA data transfer. */
 		sg_init_table(i2c->sg_io, 2);
 		sg_set_buf(&i2c->sg_io[0], &i2c->addr_data, 1);
-		sg_set_buf(&i2c->sg_io[1], msg->buf, msg->len);
+		sg_set_buf(&i2c->sg_io[1], buf, msg->len);
 		dma_map_sg(i2c->dev, i2c->sg_io, 2, DMA_TO_DEVICE);
 		desc = dmaengine_prep_slave_sg(i2c->dmach, i2c->sg_io, 2,
 					DMA_MEM_TO_DEV,
@@ -563,6 +563,7 @@ static int mxs_i2c_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg,
 	struct mxs_i2c_dev *i2c = i2c_get_adapdata(adap);
 	int ret;
 	int flags;
+	u8 *dma_buf;
 	int use_pio = 0;
 	unsigned long time_left;
 
@@ -588,13 +589,20 @@ static int mxs_i2c_xfer_msg(struct i2c_adapter *adap, struct i2c_msg *msg,
 		if (ret && (ret != -ENXIO))
 			mxs_i2c_reset(i2c);
 	} else {
+		dma_buf = i2c_get_dma_safe_msg_buf(msg, 1);
+		if (!dma_buf)
+			return -ENOMEM;
+
 		reinit_completion(&i2c->cmd_complete);
-		ret = mxs_i2c_dma_setup_xfer(adap, msg, flags);
-		if (ret)
+		ret = mxs_i2c_dma_setup_xfer(adap, msg, dma_buf, flags);
+		if (ret) {
+			i2c_put_dma_safe_msg_buf(dma_buf, msg, false);
 			return ret;
+		}
 
 		time_left = wait_for_completion_timeout(&i2c->cmd_complete,
 						msecs_to_jiffies(1000));
+		i2c_put_dma_safe_msg_buf(dma_buf, msg, true);
 		if (!time_left)
 			goto timeout;
 
-- 
2.39.2



