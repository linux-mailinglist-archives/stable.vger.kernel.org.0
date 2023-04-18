Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5A8C76E6225
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 14:30:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231584AbjDRMag (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 08:30:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42132 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231561AbjDRMae (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 08:30:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E599D30A
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 05:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A68FC631E1
        for <stable@vger.kernel.org>; Tue, 18 Apr 2023 12:30:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86EBC4339C;
        Tue, 18 Apr 2023 12:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1681821006;
        bh=B604FszNC+RxHkGb9PSTNcGBJIcOkzituZf/IDB0U/Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bNFQbFI5j3OpNehj8R5iDSByjV2q9ofhxoCxDK0UfHIuMc7MkI1BmHZQjIEI1oiw0
         RpqwZPDpWwc8ZXtb791yTPkC0T0iwI7GRWpUj5x/tXAC/38/Gz5uiJiC5jMxahM/vO
         WUTmtLAQ5ONZ613amrY65P+14GEReU3vzEod66iI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Stable@vger.kernel.org,
        Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 55/92] mtd: rawnand: meson: fix bitmask for length in command word
Date:   Tue, 18 Apr 2023 14:21:30 +0200
Message-Id: <20230418120306.780640923@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120304.658273364@linuxfoundation.org>
References: <20230418120304.658273364@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arseniy Krasnov <avkrasnov@sberdevices.ru>

commit 93942b70461574ca7fc3d91494ca89b16a4c64c7 upstream.

Valid mask is 0x3FFF, without this patch the following problems were
found:

1) [    0.938914] Could not find a valid ONFI parameter page, trying
                  bit-wise majority to recover it
   [    0.947384] ONFI parameter recovery failed, aborting

2) Read with disabled ECC mode was broken.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/3794ffbf-dfea-e96f-1f97-fe235b005e19@sberdevices.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/meson_nand.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -276,7 +276,7 @@ static void meson_nfc_cmd_access(struct
 
 	if (raw) {
 		len = mtd->writesize + mtd->oobsize;
-		cmd = (len & GENMASK(5, 0)) | scrambler | DMA_DIR(dir);
+		cmd = (len & GENMASK(13, 0)) | scrambler | DMA_DIR(dir);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 		return;
 	}
@@ -540,7 +540,7 @@ static int meson_nfc_read_buf(struct nan
 	if (ret)
 		goto out;
 
-	cmd = NFC_CMD_N2M | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_N2M | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);
@@ -564,7 +564,7 @@ static int meson_nfc_write_buf(struct na
 	if (ret)
 		return ret;
 
-	cmd = NFC_CMD_M2N | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_M2N | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);


