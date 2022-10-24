Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7BFC60A72F
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234321AbiJXMsO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:48:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234821AbiJXMpt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:45:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0478E72B69;
        Mon, 24 Oct 2022 05:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A791612B9;
        Mon, 24 Oct 2022 12:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29FEC433D6;
        Mon, 24 Oct 2022 12:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613419;
        bh=K4roTK2fnCmQiAynGRZx39W2zSKfyzroDBihQQeCMlI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yZzPnFNb92nf3wnacW9NdCuaCcSK3gl0K0lZJ/Wyz2ttwT2YGBGhB+ReAPpzdCXs5
         2GGhVQZNs/X9btCnIfAg3ZYNXPvLQUH+humpZ3O0gOrrh5of88RX4xqRLgg939lc6a
         S2Rze9fAbmuD1s8sTnKveSxnVY1nBwHR+3Yh7nVc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sebastian Reichel <sre@kernel.org>,
        Jack Wang <jinpu.wang@ionos.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 130/255] HSI: omap_ssi_port: Fix dma_map_sg error check
Date:   Mon, 24 Oct 2022 13:30:40 +0200
Message-Id: <20221024113006.898391348@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Wang <jinpu.wang@ionos.com>

[ Upstream commit 551e325bbd3fb8b5a686ac1e6cf76e5641461cf2 ]

dma_map_sg return 0 on error, in case of error return -EIO
to caller.

Cc: Sebastian Reichel <sre@kernel.org>
Cc: linux-kernel@vger.kernel.org (open list)
Fixes: b209e047bc74 ("HSI: Introduce OMAP SSI driver")
Signed-off-by: Jack Wang <jinpu.wang@ionos.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hsi/controllers/omap_ssi_port.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/hsi/controllers/omap_ssi_port.c b/drivers/hsi/controllers/omap_ssi_port.c
index a0cb5be246e1..b9495b720f1b 100644
--- a/drivers/hsi/controllers/omap_ssi_port.c
+++ b/drivers/hsi/controllers/omap_ssi_port.c
@@ -230,10 +230,10 @@ static int ssi_start_dma(struct hsi_msg *msg, int lch)
 	if (msg->ttype == HSI_MSG_READ) {
 		err = dma_map_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents,
 							DMA_FROM_DEVICE);
-		if (err < 0) {
+		if (!err) {
 			dev_dbg(&ssi->device, "DMA map SG failed !\n");
 			pm_runtime_put_autosuspend(omap_port->pdev);
-			return err;
+			return -EIO;
 		}
 		csdp = SSI_DST_BURST_4x32_BIT | SSI_DST_MEMORY_PORT |
 			SSI_SRC_SINGLE_ACCESS0 | SSI_SRC_PERIPHERAL_PORT |
@@ -247,10 +247,10 @@ static int ssi_start_dma(struct hsi_msg *msg, int lch)
 	} else {
 		err = dma_map_sg(&ssi->device, msg->sgt.sgl, msg->sgt.nents,
 							DMA_TO_DEVICE);
-		if (err < 0) {
+		if (!err) {
 			dev_dbg(&ssi->device, "DMA map SG failed !\n");
 			pm_runtime_put_autosuspend(omap_port->pdev);
-			return err;
+			return -EIO;
 		}
 		csdp = SSI_SRC_BURST_4x32_BIT | SSI_SRC_MEMORY_PORT |
 			SSI_DST_SINGLE_ACCESS0 | SSI_DST_PERIPHERAL_PORT |
-- 
2.35.1



