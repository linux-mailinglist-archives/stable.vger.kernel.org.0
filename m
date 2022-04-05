Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D4DF4F2CF0
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 13:34:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242243AbiDEJgb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:36:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236306AbiDEJAX (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:00:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BB19227B0B;
        Tue,  5 Apr 2022 01:53:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 64D61B81A0C;
        Tue,  5 Apr 2022 08:53:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB89AC385A0;
        Tue,  5 Apr 2022 08:53:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649148816;
        bh=lV6EBOGewZHCd5VMUrW8PRk5eQIcU0mARBrrtRPH+v0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rQUoFoulTvw/Laf66qf9ngHZA7u3ijAF4auSkpkC/Mr3RPKrt2ly6i1zPnZcanKGS
         dn1dJVRx19NI8Q5IvICgjAd9z4REUL4K2FU8QGn8UZpjHpQ++ZwuXr2KzEgAHrBZx7
         4RCL6bWX+k/OjkYABPmXL+/uvYeUM8isgubo2KDA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Claudiu Manoil <claudiu.manoil@nxp.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Po Liu <po.liu@nxp.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0491/1017] net:enetc: allocate CBD ring data memory using DMA coherent methods
Date:   Tue,  5 Apr 2022 09:23:24 +0200
Message-Id: <20220405070408.874371613@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
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

From: Po Liu <po.liu@nxp.com>

[ Upstream commit b3a723dbc94a6e38f67669d03b521edd766ad895 ]

To replace the dma_map_single() stream DMA mapping with DMA coherent
method dma_alloc_coherent() which is more simple.

dma_map_single() found by Tim Gardner not proper. Suggested by Claudiu
Manoil and Jakub Kicinski to use dma_alloc_coherent(). Discussion at:

https://lore.kernel.org/netdev/AM9PR04MB8397F300DECD3C44D2EBD07796BD9@AM9PR04MB8397.eurprd04.prod.outlook.com/t/

Fixes: 888ae5a3952ba ("net: enetc: add tc flower psfp offload driver")
cc: Claudiu Manoil <claudiu.manoil@nxp.com>
Reported-by: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Po Liu <po.liu@nxp.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/freescale/enetc/enetc_qos.c  | 128 +++++++++---------
 1 file changed, 64 insertions(+), 64 deletions(-)

diff --git a/drivers/net/ethernet/freescale/enetc/enetc_qos.c b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
index 0536d2c76fbc..d779dde522c8 100644
--- a/drivers/net/ethernet/freescale/enetc/enetc_qos.c
+++ b/drivers/net/ethernet/freescale/enetc/enetc_qos.c
@@ -45,6 +45,7 @@ void enetc_sched_speed_set(struct enetc_ndev_priv *priv, int speed)
 		      | pspeed);
 }
 
+#define ENETC_QOS_ALIGN	64
 static int enetc_setup_taprio(struct net_device *ndev,
 			      struct tc_taprio_qopt_offload *admin_conf)
 {
@@ -52,10 +53,11 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct tgs_gcl_conf *gcl_config;
 	struct tgs_gcl_data *gcl_data;
+	dma_addr_t dma, dma_align;
 	struct gce *gce;
-	dma_addr_t dma;
 	u16 data_size;
 	u16 gcl_len;
+	void *tmp;
 	u32 tge;
 	int err;
 	int i;
@@ -82,9 +84,16 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	gcl_config = &cbd.gcl_conf;
 
 	data_size = struct_size(gcl_data, entry, gcl_len);
-	gcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!gcl_data)
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of taprio gate list failed!\n");
 		return -ENOMEM;
+	}
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	gcl_data = (struct tgs_gcl_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
 	gce = (struct gce *)(gcl_data + 1);
 
@@ -110,16 +119,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 	cbd.length = cpu_to_le16(data_size);
 	cbd.status_flags = 0;
 
-	dma = dma_map_single(&priv->si->pdev->dev, gcl_data,
-			     data_size, DMA_TO_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		kfree(gcl_data);
-		return -ENOMEM;
-	}
-
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 	cbd.cls = BDCR_CMD_PORT_GCL;
 	cbd.status_flags = 0;
 
@@ -132,8 +133,8 @@ static int enetc_setup_taprio(struct net_device *ndev,
 			 ENETC_QBV_PTGCR_OFFSET,
 			 tge & (~ENETC_QBV_TGE));
 
-	dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_TO_DEVICE);
-	kfree(gcl_data);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
 
 	return err;
 }
@@ -463,8 +464,9 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	struct enetc_cbd cbd = {.cmd = 0};
 	struct streamid_data *si_data;
 	struct streamid_conf *si_conf;
+	dma_addr_t dma, dma_align;
 	u16 data_size;
-	dma_addr_t dma;
+	void *tmp;
 	int port;
 	int err;
 
@@ -485,21 +487,20 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 	cbd.status_flags = 0;
 
 	data_size = sizeof(struct streamid_data);
-	si_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!si_data)
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of stream identify failed!\n");
 		return -ENOMEM;
-	cbd.length = cpu_to_le16(data_size);
-
-	dma = dma_map_single(&priv->si->pdev->dev, si_data,
-			     data_size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		err = -ENOMEM;
-		goto out;
 	}
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	si_data = (struct streamid_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.length = cpu_to_le16(data_size);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 	eth_broadcast_addr(si_data->dmac);
 	si_data->vid_vidm_tg = (ENETC_CBDR_SID_VID_MASK
 			       + ((0x3 << 14) | ENETC_CBDR_SID_VIDM));
@@ -539,8 +540,8 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	cbd.length = cpu_to_le16(data_size);
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	/* VIDM default to be 1.
 	 * VID Match. If set (b1) then the VID must match, otherwise
@@ -561,10 +562,8 @@ static int enetc_streamid_hw_set(struct enetc_ndev_priv *priv,
 
 	err = enetc_send_cmd(priv->si, &cbd);
 out:
-	if (!dma_mapping_error(&priv->si->pdev->dev, dma))
-		dma_unmap_single(&priv->si->pdev->dev, dma, data_size, DMA_FROM_DEVICE);
-
-	kfree(si_data);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
 
 	return err;
 }
@@ -633,8 +632,9 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 {
 	struct enetc_cbd cbd = { .cmd = 2 };
 	struct sfi_counter_data *data_buf;
-	dma_addr_t dma;
+	dma_addr_t dma, dma_align;
 	u16 data_size;
+	void *tmp;
 	int err;
 
 	cbd.index = cpu_to_le16((u16)index);
@@ -643,19 +643,19 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 	cbd.status_flags = 0;
 
 	data_size = sizeof(struct sfi_counter_data);
-	data_buf = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!data_buf)
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of stream counter failed!\n");
 		return -ENOMEM;
-
-	dma = dma_map_single(&priv->si->pdev->dev, data_buf,
-			     data_size, DMA_FROM_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		err = -ENOMEM;
-		goto exit;
 	}
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	data_buf = (struct sfi_counter_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
+
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	cbd.length = cpu_to_le16(data_size);
 
@@ -684,7 +684,9 @@ static int enetc_streamcounter_hw_get(struct enetc_ndev_priv *priv,
 				data_buf->flow_meter_dropl;
 
 exit:
-	kfree(data_buf);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
+
 	return err;
 }
 
@@ -723,9 +725,10 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	struct sgcl_conf *sgcl_config;
 	struct sgcl_data *sgcl_data;
 	struct sgce *sgce;
-	dma_addr_t dma;
+	dma_addr_t dma, dma_align;
 	u16 data_size;
 	int err, i;
+	void *tmp;
 	u64 now;
 
 	cbd.index = cpu_to_le16(sgi->index);
@@ -772,24 +775,20 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	sgcl_config->acl_len = (sgi->num_entries - 1) & 0x3;
 
 	data_size = struct_size(sgcl_data, sgcl, sgi->num_entries);
-
-	sgcl_data = kzalloc(data_size, __GFP_DMA | GFP_KERNEL);
-	if (!sgcl_data)
-		return -ENOMEM;
-
-	cbd.length = cpu_to_le16(data_size);
-
-	dma = dma_map_single(&priv->si->pdev->dev,
-			     sgcl_data, data_size,
-			     DMA_FROM_DEVICE);
-	if (dma_mapping_error(&priv->si->pdev->dev, dma)) {
-		netdev_err(priv->si->ndev, "DMA mapping failed!\n");
-		kfree(sgcl_data);
+	tmp = dma_alloc_coherent(&priv->si->pdev->dev,
+				 data_size + ENETC_QOS_ALIGN,
+				 &dma, GFP_KERNEL);
+	if (!tmp) {
+		dev_err(&priv->si->pdev->dev,
+			"DMA mapping of stream counter failed!\n");
 		return -ENOMEM;
 	}
+	dma_align = ALIGN(dma, ENETC_QOS_ALIGN);
+	sgcl_data = (struct sgcl_data *)PTR_ALIGN(tmp, ENETC_QOS_ALIGN);
 
-	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma));
-	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma));
+	cbd.length = cpu_to_le16(data_size);
+	cbd.addr[0] = cpu_to_le32(lower_32_bits(dma_align));
+	cbd.addr[1] = cpu_to_le32(upper_32_bits(dma_align));
 
 	sgce = &sgcl_data->sgcl[0];
 
@@ -844,7 +843,8 @@ static int enetc_streamgate_hw_set(struct enetc_ndev_priv *priv,
 	err = enetc_send_cmd(priv->si, &cbd);
 
 exit:
-	kfree(sgcl_data);
+	dma_free_coherent(&priv->si->pdev->dev, data_size + ENETC_QOS_ALIGN,
+			  tmp, dma);
 
 	return err;
 }
-- 
2.34.1



