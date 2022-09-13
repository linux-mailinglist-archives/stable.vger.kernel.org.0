Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FE0A5B6FB8
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:18:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233173AbiIMOSD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbiIMORb (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:17:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 550845A819;
        Tue, 13 Sep 2022 07:12:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90DF5B80F1A;
        Tue, 13 Sep 2022 14:12:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED914C433D6;
        Tue, 13 Sep 2022 14:12:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078324;
        bh=CppPIPq4XoujZ2QJi7/AL6afWAi5RDwIZTUQM0giRcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XxPKI/MDnkAh6IcKP7yRvLXQQcLROYd3VPivHRTRSTJAV0/643emmaUrxMChwhB8/
         NMsY+nm0O9MQ5VIGuy0oq4j1x8067BbyvQDTyAi0ZyLcjUHo1OgmTdmrywcFxc3qOP
         KDuDFfQ8+f6q58Fw3EU45C7sfSPMnITAANn7/VbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <mwalle@kernel.org>,
        Ajay Singh <ajay.kathat@microchip.com>,
        Kalle Valo <kvalo@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 095/192] wifi: wilc1000: fix DMA on stack objects
Date:   Tue, 13 Sep 2022 16:03:21 +0200
Message-Id: <20220913140414.698916490@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ajay.Kathat@microchip.com <Ajay.Kathat@microchip.com>

[ Upstream commit 40b717bfcefab28a0656b8caa5e43d5449e5a671 ]

Sometimes 'wilc_sdio_cmd53' is called with addresses pointing to an
object on the stack. Use dynamically allocated memory for cmd53 instead
of stack address which is not DMA'able.

Fixes: 5625f965d764 ("wilc1000: move wilc driver out of staging")
Reported-by: Michael Walle <mwalle@kernel.org>
Suggested-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Ajay Singh <ajay.kathat@microchip.com>
Reviewed-by: Michael Walle <mwalle@kernel.org>
Tested-by: Michael Walle <mwalle@kernel.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20220809075749.62752-1-ajay.kathat@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/wireless/microchip/wilc1000/netdev.h  |  1 +
 .../net/wireless/microchip/wilc1000/sdio.c    | 39 ++++++++++++++++---
 .../net/wireless/microchip/wilc1000/wlan.c    | 15 ++++++-
 3 files changed, 47 insertions(+), 8 deletions(-)

diff --git a/drivers/net/wireless/microchip/wilc1000/netdev.h b/drivers/net/wireless/microchip/wilc1000/netdev.h
index a067274c20144..bf001e9def6aa 100644
--- a/drivers/net/wireless/microchip/wilc1000/netdev.h
+++ b/drivers/net/wireless/microchip/wilc1000/netdev.h
@@ -254,6 +254,7 @@ struct wilc {
 	u8 *rx_buffer;
 	u32 rx_buffer_offset;
 	u8 *tx_buffer;
+	u32 *vmm_table;
 
 	struct txq_handle txq[NQUEUES];
 	int txq_entries;
diff --git a/drivers/net/wireless/microchip/wilc1000/sdio.c b/drivers/net/wireless/microchip/wilc1000/sdio.c
index 7962c11cfe848..56f924a31bc66 100644
--- a/drivers/net/wireless/microchip/wilc1000/sdio.c
+++ b/drivers/net/wireless/microchip/wilc1000/sdio.c
@@ -27,6 +27,7 @@ struct wilc_sdio {
 	bool irq_gpio;
 	u32 block_size;
 	int has_thrpt_enh3;
+	u8 *cmd53_buf;
 };
 
 struct sdio_cmd52 {
@@ -46,6 +47,7 @@ struct sdio_cmd53 {
 	u32 count:		9;
 	u8 *buffer;
 	u32 block_size;
+	bool use_global_buf;
 };
 
 static const struct wilc_hif_func wilc_hif_sdio;
@@ -90,6 +92,8 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 {
 	struct sdio_func *func = container_of(wilc->dev, struct sdio_func, dev);
 	int size, ret;
+	struct wilc_sdio *sdio_priv = wilc->bus_data;
+	u8 *buf = cmd->buffer;
 
 	sdio_claim_host(func);
 
@@ -100,12 +104,23 @@ static int wilc_sdio_cmd53(struct wilc *wilc, struct sdio_cmd53 *cmd)
 	else
 		size = cmd->count;
 
+	if (cmd->use_global_buf) {
+		if (size > sizeof(u32))
+			return -EINVAL;
+
+		buf = sdio_priv->cmd53_buf;
+	}
+
 	if (cmd->read_write) {  /* write */
-		ret = sdio_memcpy_toio(func, cmd->address,
-				       (void *)cmd->buffer, size);
+		if (cmd->use_global_buf)
+			memcpy(buf, cmd->buffer, size);
+
+		ret = sdio_memcpy_toio(func, cmd->address, buf, size);
 	} else {        /* read */
-		ret = sdio_memcpy_fromio(func, (void *)cmd->buffer,
-					 cmd->address,  size);
+		ret = sdio_memcpy_fromio(func, buf, cmd->address, size);
+
+		if (cmd->use_global_buf)
+			memcpy(cmd->buffer, buf, size);
 	}
 
 	sdio_release_host(func);
@@ -127,6 +142,12 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	if (!sdio_priv)
 		return -ENOMEM;
 
+	sdio_priv->cmd53_buf = kzalloc(sizeof(u32), GFP_KERNEL);
+	if (!sdio_priv->cmd53_buf) {
+		ret = -ENOMEM;
+		goto free;
+	}
+
 	ret = wilc_cfg80211_init(&wilc, &func->dev, WILC_HIF_SDIO,
 				 &wilc_hif_sdio);
 	if (ret)
@@ -160,6 +181,7 @@ static int wilc_sdio_probe(struct sdio_func *func,
 	irq_dispose_mapping(wilc->dev_irq_num);
 	wilc_netdev_cleanup(wilc);
 free:
+	kfree(sdio_priv->cmd53_buf);
 	kfree(sdio_priv);
 	return ret;
 }
@@ -171,6 +193,7 @@ static void wilc_sdio_remove(struct sdio_func *func)
 
 	clk_disable_unprepare(wilc->rtc_clk);
 	wilc_netdev_cleanup(wilc);
+	kfree(sdio_priv->cmd53_buf);
 	kfree(sdio_priv);
 }
 
@@ -367,8 +390,9 @@ static int wilc_sdio_write_reg(struct wilc *wilc, u32 addr, u32 data)
 		cmd.address = WILC_SDIO_FBR_DATA_REG;
 		cmd.block_mode = 0;
 		cmd.increment = 1;
-		cmd.count = 4;
+		cmd.count = sizeof(u32);
 		cmd.buffer = (u8 *)&data;
+		cmd.use_global_buf = true;
 		cmd.block_size = sdio_priv->block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
 		if (ret)
@@ -406,6 +430,7 @@ static int wilc_sdio_write(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	nblk = size / block_size;
 	nleft = size % block_size;
 
+	cmd.use_global_buf = false;
 	if (nblk > 0) {
 		cmd.block_mode = 1;
 		cmd.increment = 1;
@@ -484,8 +509,9 @@ static int wilc_sdio_read_reg(struct wilc *wilc, u32 addr, u32 *data)
 		cmd.address = WILC_SDIO_FBR_DATA_REG;
 		cmd.block_mode = 0;
 		cmd.increment = 1;
-		cmd.count = 4;
+		cmd.count = sizeof(u32);
 		cmd.buffer = (u8 *)data;
+		cmd.use_global_buf = true;
 
 		cmd.block_size = sdio_priv->block_size;
 		ret = wilc_sdio_cmd53(wilc, &cmd);
@@ -527,6 +553,7 @@ static int wilc_sdio_read(struct wilc *wilc, u32 addr, u8 *buf, u32 size)
 	nblk = size / block_size;
 	nleft = size % block_size;
 
+	cmd.use_global_buf = false;
 	if (nblk > 0) {
 		cmd.block_mode = 1;
 		cmd.increment = 1;
diff --git a/drivers/net/wireless/microchip/wilc1000/wlan.c b/drivers/net/wireless/microchip/wilc1000/wlan.c
index 48441f0389ca1..0c8a571486d25 100644
--- a/drivers/net/wireless/microchip/wilc1000/wlan.c
+++ b/drivers/net/wireless/microchip/wilc1000/wlan.c
@@ -714,7 +714,7 @@ int wilc_wlan_handle_txq(struct wilc *wilc, u32 *txq_count)
 	int ret = 0;
 	int counter;
 	int timeout;
-	u32 vmm_table[WILC_VMM_TBL_SIZE];
+	u32 *vmm_table = wilc->vmm_table;
 	u8 ac_pkt_num_to_chip[NQUEUES] = {0, 0, 0, 0};
 	const struct wilc_hif_func *func;
 	int srcu_idx;
@@ -1251,6 +1251,8 @@ void wilc_wlan_cleanup(struct net_device *dev)
 	while ((rqe = wilc_wlan_rxq_remove(wilc)))
 		kfree(rqe);
 
+	kfree(wilc->vmm_table);
+	wilc->vmm_table = NULL;
 	kfree(wilc->rx_buffer);
 	wilc->rx_buffer = NULL;
 	kfree(wilc->tx_buffer);
@@ -1485,6 +1487,14 @@ int wilc_wlan_init(struct net_device *dev)
 		goto fail;
 	}
 
+	if (!wilc->vmm_table)
+		wilc->vmm_table = kzalloc(WILC_VMM_TBL_SIZE, GFP_KERNEL);
+
+	if (!wilc->vmm_table) {
+		ret = -ENOBUFS;
+		goto fail;
+	}
+
 	if (!wilc->tx_buffer)
 		wilc->tx_buffer = kmalloc(WILC_TX_BUFF_SIZE, GFP_KERNEL);
 
@@ -1509,7 +1519,8 @@ int wilc_wlan_init(struct net_device *dev)
 	return 0;
 
 fail:
-
+	kfree(wilc->vmm_table);
+	wilc->vmm_table = NULL;
 	kfree(wilc->rx_buffer);
 	wilc->rx_buffer = NULL;
 	kfree(wilc->tx_buffer);
-- 
2.35.1



