Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D7E1F4512C3
	for <lists+stable@lfdr.de>; Mon, 15 Nov 2021 20:41:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347343AbhKOTjq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 14:39:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:44602 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245009AbhKOTSV (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 14:18:21 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 938896343A;
        Mon, 15 Nov 2021 18:26:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1637000815;
        bh=f5sBHD256VAoyIEQDueybkX0f1CgCHoWj5BiHd5mBBY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ii/01UpOoKtrHWK4NCzqv2Aoj1BHS4jklMhM2hSTOLlS7p9ESz8o9USQnNqao1Vno
         kZULpV8Q4aSi506wGwH73dLQP8BO2MLKPBILMXDBEM9j0rAilBr79Xjxii8pZYFo0r
         Mn5OZJfrBPEpHHaMh7Khrzq/qwbNIU06XeOsrJWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Anatolij Gustschin <agust@denx.de>,
        Vinod Koul <vkoul@kernel.org>
Subject: [PATCH 5.14 802/849] dmaengine: bestcomm: fix system boot lockups
Date:   Mon, 15 Nov 2021 18:04:45 +0100
Message-Id: <20211115165447.366730941@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Anatolij Gustschin <agust@denx.de>

commit adec566b05288f2787a1f88dbaf77ed8b0c644fa upstream.

memset() and memcpy() on an MMIO region like here results in a
lockup at startup on mpc5200 platform (since this first happens
during probing of the ATA and Ethernet drivers). Use memset_io()
and memcpy_toio() instead.

Fixes: 2f9ea1bde0d1 ("bestcomm: core bestcomm support for Freescale MPC5200")
Cc: stable@vger.kernel.org # v5.14+
Signed-off-by: Anatolij Gustschin <agust@denx.de>
Link: https://lore.kernel.org/r/20211014094012.21286-1-agust@denx.de
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/dma/bestcomm/ata.c      |    2 +-
 drivers/dma/bestcomm/bestcomm.c |   22 +++++++++++-----------
 drivers/dma/bestcomm/fec.c      |    4 ++--
 drivers/dma/bestcomm/gen_bd.c   |    4 ++--
 4 files changed, 16 insertions(+), 16 deletions(-)

--- a/drivers/dma/bestcomm/ata.c
+++ b/drivers/dma/bestcomm/ata.c
@@ -133,7 +133,7 @@ void bcom_ata_reset_bd(struct bcom_task
 	struct bcom_ata_var *var;
 
 	/* Reset all BD */
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	tsk->index = 0;
 	tsk->outdex = 0;
--- a/drivers/dma/bestcomm/bestcomm.c
+++ b/drivers/dma/bestcomm/bestcomm.c
@@ -95,7 +95,7 @@ bcom_task_alloc(int bd_count, int bd_siz
 		tsk->bd = bcom_sram_alloc(bd_count * bd_size, 4, &tsk->bd_pa);
 		if (!tsk->bd)
 			goto error;
-		memset(tsk->bd, 0x00, bd_count * bd_size);
+		memset_io(tsk->bd, 0x00, bd_count * bd_size);
 
 		tsk->num_bd = bd_count;
 		tsk->bd_size = bd_size;
@@ -186,16 +186,16 @@ bcom_load_image(int task, u32 *task_imag
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
--- a/drivers/dma/bestcomm/gen_bd.c
+++ b/drivers/dma/bestcomm/gen_bd.c
@@ -142,7 +142,7 @@ bcom_gen_bd_rx_reset(struct bcom_task *t
 	tsk->index = 0;
 	tsk->outdex = 0;
 
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	/* Configure some stuff */
 	bcom_set_task_pragma(tsk->tasknum, BCOM_GEN_RX_BD_PRAGMA);
@@ -226,7 +226,7 @@ bcom_gen_bd_tx_reset(struct bcom_task *t
 	tsk->index = 0;
 	tsk->outdex = 0;
 
-	memset(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
+	memset_io(tsk->bd, 0x00, tsk->num_bd * tsk->bd_size);
 
 	/* Configure some stuff */
 	bcom_set_task_pragma(tsk->tasknum, BCOM_GEN_TX_BD_PRAGMA);


