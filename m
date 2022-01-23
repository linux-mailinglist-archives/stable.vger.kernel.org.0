Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8C00C4971DE
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:09:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbiAWOJl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:09:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233169AbiAWOJl (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:09:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03600C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:09:41 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9707660C7D
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:09:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 757A2C340E2;
        Sun, 23 Jan 2022 14:09:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642946980;
        bh=RJo0lCTHLJyaNTpIPHZg3o4hfy085vngdsuSB1Mdl6g=;
        h=Subject:To:Cc:From:Date:From;
        b=qxpcasQVyfnx6E0zNvk9B3R5n+ekQOAD4hc+CvsFKNVdGUZbAcRcwANlGCUJ4A5Yq
         dlSM35coCap588rzfo0BHk+8nffC3dSiDzI19INVVAgBJiHhJTwxqnA4BRPFdsCyG0
         scyVKfTwCOOVgRsWL9LvlBRtM1qy4xicF/7fUtdY=
Subject: FAILED: patch "[PATCH] mtd: rawnand: davinci: Rewrite function description" failed to apply to 5.4-stable tree
To:     paul@crapouillou.net, miquel.raynal@bootlin.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:09:37 +0100
Message-ID: <164294697725316@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0697f8441faad552fbeb02d74454b5e7bcc956a2 Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sat, 16 Oct 2021 14:22:26 +0100
Subject: [PATCH] mtd: rawnand: davinci: Rewrite function description

The original comment that describes the function
nand_davinci_read_page_hwecc_oob_first() is very obscure and it is hard
to understand what it is for.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-3-paul@crapouillou.net

diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index 2e6a0c1671be..fe2511cdcae3 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -372,17 +372,15 @@ static int nand_davinci_correct_4bit(struct nand_chip *chip, u_char *data,
 }
 
 /**
- * nand_read_page_hwecc_oob_first - hw ecc, read oob first
+ * nand_davinci_read_page_hwecc_oob_first - Hardware ECC page read with ECC
+ *                                          data read from OOB area
  * @chip: nand chip info structure
  * @buf: buffer to store read data
  * @oob_required: caller requires OOB data read to chip->oob_poi
  * @page: page number to read
  *
- * Hardware ECC for large page chips, require OOB to be read first. For this
- * ECC mode, the write_page method is re-used from ECC_HW. These methods
- * read/write ECC from the OOB area, unlike the ECC_HW_SYNDROME support with
- * multiple ECC steps, follows the "infix ECC" scheme and reads/writes ECC from
- * the data area, by overwriting the NAND manufacturer bad block markings.
+ * Hardware ECC for large page chips, which requires the ECC data to be
+ * extracted from the OOB before the actual data is read.
  */
 static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 						  uint8_t *buf,

