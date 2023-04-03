Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4427B6D4A6E
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234028AbjDCOq7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:46:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234029AbjDCOqn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:46:43 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A687280C2
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:46:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 269CECE0947
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:46:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEF57C433D2;
        Mon,  3 Apr 2023 14:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533158;
        bh=ABnhbDGWfBt8mGRuIKSsDNSpVJaBjaFkHFq+dTO2OC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wvnPjiKX9wIjytSdiNn7uByWaxJgYwvfInD0qr3vh7ZcVWHuBds2x+Aa5Ct3f1hhU
         3xC6oD6Q4hppN7IedsUQSomJ+pVPgDlfqkG5Nj1LLbqmV7DXmvnX/OtL1lfIV3G9Me
         FLtNdkGpzOu6/6iuJ2OTB7EisWqnkgy0pTdcnn9Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Neil Armstrong <neil.armstrong@linaro.org>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 076/187] mtd: rawnand: meson: invalidate cache on polling ECC bit
Date:   Mon,  3 Apr 2023 16:08:41 +0200
Message-Id: <20230403140418.453982698@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
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

From: Arseniy Krasnov <avkrasnov@sberdevices.ru>

[ Upstream commit e732e39ed9929c05fd219035bc9653ba4100d4fa ]

'info_buf' memory is cached and driver polls ECC bit in it. This bit
is set by the NAND controller. If 'usleep_range()' returns before device
sets this bit, 'info_buf' will be cached and driver won't see update of
this bit and will loop forever.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Reviewed-by: Neil Armstrong <neil.armstrong@linaro.org>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/d4ef0bd6-816e-f6fa-9385-f05f775f0ae2@sberdevices.ru
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/meson_nand.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/meson_nand.c b/drivers/mtd/nand/raw/meson_nand.c
index 30e326adabfc1..a28574c009003 100644
--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -176,6 +176,7 @@ struct meson_nfc {
 
 	dma_addr_t daddr;
 	dma_addr_t iaddr;
+	u32 info_bytes;
 
 	unsigned long assigned_cs;
 };
@@ -503,6 +504,7 @@ static int meson_nfc_dma_buffer_setup(struct nand_chip *nand, void *databuf,
 					 nfc->daddr, datalen, dir);
 			return ret;
 		}
+		nfc->info_bytes = infolen;
 		cmd = GENCMDIADDRL(NFC_CMD_AIL, nfc->iaddr);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
@@ -520,8 +522,10 @@ static void meson_nfc_dma_buffer_release(struct nand_chip *nand,
 	struct meson_nfc *nfc = nand_get_controller_data(nand);
 
 	dma_unmap_single(nfc->dev, nfc->daddr, datalen, dir);
-	if (infolen)
+	if (infolen) {
 		dma_unmap_single(nfc->dev, nfc->iaddr, infolen, dir);
+		nfc->info_bytes = 0;
+	}
 }
 
 static int meson_nfc_read_buf(struct nand_chip *nand, u8 *buf, int len)
@@ -710,6 +714,8 @@ static void meson_nfc_check_ecc_pages_valid(struct meson_nfc *nfc,
 		usleep_range(10, 15);
 		/* info is updated by nfc dma engine*/
 		smp_rmb();
+		dma_sync_single_for_cpu(nfc->dev, nfc->iaddr, nfc->info_bytes,
+					DMA_FROM_DEVICE);
 		ret = *info & ECC_COMPLETE;
 	} while (!ret);
 }
-- 
2.39.2



