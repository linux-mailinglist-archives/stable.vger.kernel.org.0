Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABAAE5C0318
	for <lists+stable@lfdr.de>; Wed, 21 Sep 2022 18:00:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232022AbiIUQAi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 21 Sep 2022 12:00:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232431AbiIUP7d (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 21 Sep 2022 11:59:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45F44A1D6F;
        Wed, 21 Sep 2022 08:52:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8B0396315C;
        Wed, 21 Sep 2022 15:51:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93E1EC433C1;
        Wed, 21 Sep 2022 15:51:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663775509;
        bh=yPUPiQoNWFLDwM2i3TTxlHtzSPCh64pobur0xKampMU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uyjy6IW5gFp81DHkMRcuque7e0LuPIVma6JCEomrmaFjOi7X1OB4Dq9zeLQXjOoxR
         2vkuNf3Zs+TcrvedyuZ5UYC3GKb3Xl0mHPMLSpoZsW1FIGiWpMsnFNrZ1PQGjC5Qyp
         ruTdrXML55QOWAN8kzTrueUaSHjHHu5elnAIBNSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anatolij Gustschin <agust@denx.de>,
        Vinod Koul <vkoul@kernel.org>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 06/39] dmaengine: bestcomm: fix system boot lockups
Date:   Wed, 21 Sep 2022 17:46:11 +0200
Message-Id: <20220921153645.932984913@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220921153645.663680057@linuxfoundation.org>
References: <20220921153645.663680057@linuxfoundation.org>
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

From: Anatolij Gustschin <agust@denx.de>

[ Upstream commit adec566b05288f2787a1f88dbaf77ed8b0c644fa ]

memset() and memcpy() on an MMIO region like here results in a
lockup at startup on mpc5200 platform (since this first happens
during probing of the ATA and Ethernet drivers). Use memset_io()
and memcpy_toio() instead.

Fixes: 2f9ea1bde0d1 ("bestcomm: core bestcomm support for Freescale MPC5200")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Link: https://lore.kernel.org/r/20211014094012.21286-1-agust@denx.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/bestcomm/ata.c      |  2 +-
 drivers/dma/bestcomm/bestcomm.c | 22 +++++++++++-----------
 drivers/dma/bestcomm/fec.c      |  4 ++--
 drivers/dma/bestcomm/gen_bd.c   |  4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/dma/bestcomm/ata.c b/drivers/dma/bestcomm/ata.c
index 2fd87f83cf90..e169f18da551 100644
--- a/drivers/dma/bestcomm/ata.c
+++ b/drivers/dma/bestcomm/ata.c
@@ -133,7 +133,7 @@ void bcom_ata_reset_bd(struct bcom_task *tsk)
 	struct bcom_ata_var *var;
 
 	/* Reset all BD */
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	tsk->index = 0;
 	tsk->outdex = 0;
diff --git a/drivers/dma/bestcomm/bestcomm.c b/drivers/dma/bestcomm/bestcomm.c
index d91cbbe7a48f..8c42e5ca00a9 100644
--- a/drivers/dma/bestcomm/bestcomm.c
+++ b/drivers/dma/bestcomm/bestcomm.c
@@ -95,7 +95,7 @@ bcom_task_alloc(int bd_count, int bd_size, int priv_size)
 		tsk->bd = bcom_sram_alloc(bd_count * bd_size, 4, &tsk->bd_pa);
 		if (!tsk->bd)
 			goto error;
-		memset(tsk->bd, 0x00, bd_count * bd_size);
+		memset_io(tsk->bd, 0x00, bd_count * bd_size);
 
 		tsk->num_bd = bd_count;
 		tsk->bd_size = bd_size;
@@ -186,16 +186,16 @@ bcom_load_image(int task, u32 *task_image)
 	inc = bcom_task_inc(task);
 
 	/* Clear & copy */
-	memset(var, 0x00, BCOM_VAR_SIZE);
-	memset(inc, 0x00, BCOM_INC_SIZE);
+	memset_io(var, 0x00, BCOM_VAR_SIZE);
+	memset_io(inc, 0x00, BCOM_INC_SIZE);
 
 	desc_src = (u32 *)(hdr + 1);
 	var_src = desc_src + hdr->desc_size;
 	inc_src = var_src + hdr->var_size;
 
-	memcpy(desc, desc_src, hdr->desc_size * sizeof(u32));
-	memcpy(var + hdr->first_var, var_src, hdr->var_size * sizeof(u32));
-	memcpy(inc, inc_src, hdr->inc_size * sizeof(u32));
+	memcpy_toio(desc, desc_src, hdr->desc_size * sizeof(u32));
+	memcpy_toio(var + hdr->first_var, var_src, hdr->var_size * sizeof(u32));
+	memcpy_toio(inc, inc_src, hdr->inc_size * sizeof(u32));
 
 	return 0;
 }
@@ -302,13 +302,13 @@ static int bcom_engine_init(void)
 		return -ENOMEM;
 	}
 
-	memset(bcom_eng->tdt, 0x00, tdt_size);
-	memset(bcom_eng->ctx, 0x00, ctx_size);
-	memset(bcom_eng->var, 0x00, var_size);
-	memset(bcom_eng->fdt, 0x00, fdt_size);
+	memset_io(bcom_eng->tdt, 0x00, tdt_size);
+	memset_io(bcom_eng->ctx, 0x00, ctx_size);
+	memset_io(bcom_eng->var, 0x00, var_size);
+	memset_io(bcom_eng->fdt, 0x00, fdt_size);
 
 	/* Copy the FDT for the EU#3 */
-	memcpy(&bcom_eng->fdt[48], fdt_ops, sizeof(fdt_ops));
+	memcpy_toio(&bcom_eng->fdt[48], fdt_ops, sizeof(fdt_ops));
 
 	/* Initialize Task base structure */
 	for (task=0; task<BCOM_MAX_TASKS; task++)
diff --git a/drivers/dma/bestcomm/fec.c b/drivers/dma/bestcomm/fec.c
index 7f1fb1c999e4..d203618ac11f 100644
--- a/drivers/dma/bestcomm/fec.c
+++ b/drivers/dma/bestcomm/fec.c
@@ -140,7 +140,7 @@ bcom_fec_rx_reset(struct bcom_task *tsk)
 	tsk->index = 0;
 	tsk->outdex = 0;
 
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	/* Configure some stuff */
 	bcom_set_task_pragma(tsk->tasknum, BCOM_FEC_RX_BD_PRAGMA);
@@ -241,7 +241,7 @@ bcom_fec_tx_reset(struct bcom_task *tsk)
 	tsk->index = 0;
 	tsk->outdex = 0;
 
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	/* Configure some stuff */
 	bcom_set_task_pragma(tsk->tasknum, BCOM_FEC_TX_BD_PRAGMA);
diff --git a/drivers/dma/bestcomm/gen_bd.c b/drivers/dma/bestcomm/gen_bd.c
index 906ddba6a6f5..8a24a5cbc263 100644
--- a/drivers/dma/bestcomm/gen_bd.c
+++ b/drivers/dma/bestcomm/gen_bd.c
@@ -142,7 +142,7 @@ bcom_gen_bd_rx_reset(struct bcom_task *tsk)
 	tsk->index = 0;
 	tsk->outdex = 0;
 
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	/* Configure some stuff */
 	bcom_set_task_pragma(tsk->tasknum, BCOM_GEN_RX_BD_PRAGMA);
@@ -226,7 +226,7 @@ bcom_gen_bd_tx_reset(struct bcom_task *tsk)
 	tsk->index = 0;
 	tsk->outdex = 0;
 
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	/* Configure some stuff */
 	bcom_set_task_pragma(tsk->tasknum, BCOM_GEN_TX_BD_PRAGMA);
-- 
2.35.1



