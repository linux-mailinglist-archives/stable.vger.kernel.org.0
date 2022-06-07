Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05840541328
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354564AbiFGT4P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:56:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354507AbiFGTxj (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:53:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08ED463515;
        Tue,  7 Jun 2022 11:23:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7888BB82368;
        Tue,  7 Jun 2022 18:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A05C385A2;
        Tue,  7 Jun 2022 18:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626202;
        bh=+tuo2CRgp+QVPGwPvewXtMmsI8rHSTGcq5AMWNkynzk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XW1e3QZbLw0GIqmXS2Sz7R44CpHRhmgjsiZrqAKTMeMz8ItEv3xiZ/aZ2QrqRhnU1
         EhX+j6Dds+p9DMVyPqXXRpHYRvST5sahpl4OMXfvnehYVOji8nN7tNuiFY8bwEuOPt
         JH3PsqkimvU7aCx0/pgmkofGbKFXXbuXCkwGf3Oo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 291/772] mtdblock: warn if opened on NAND
Date:   Tue,  7 Jun 2022 18:58:03 +0200
Message-Id: <20220607164957.599847200@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Bjørn Mork <bjorn@mork.no>

[ Upstream commit 96a3295c351da82d7af99b2fc004a3cf9f4716a9 ]

Warning on every translated mtd partition results in excessive log noise
if this driver is loaded:

  nand: device found, Manufacturer ID: 0xc2, Chip ID: 0xf1
  nand: Macronix MX30LF1G18AC
  nand: 128 MiB, SLC, erase size: 128 KiB, page size: 2048, OOB size: 64
  mt7621-nand 1e003000.nand: ECC strength adjusted to 4 bits
  read_bbt: found bbt at block 1023
  10 fixed-partitions partitions found on MTD device mt7621-nand
  Creating 10 MTD partitions on "mt7621-nand":
  0x000000000000-0x000000080000 : "Bootloader"
  mtdblock: MTD device 'Bootloader' is NAND, please consider using UBI block devices instead.
  0x000000080000-0x000000100000 : "Config"
  mtdblock: MTD device 'Config' is NAND, please consider using UBI block devices instead.
  0x000000100000-0x000000140000 : "Factory"
  mtdblock: MTD device 'Factory' is NAND, please consider using UBI block devices instead.
  0x000000140000-0x000002000000 : "Kernel"
  mtdblock: MTD device 'Kernel' is NAND, please consider using UBI block devices instead.
  0x000000540000-0x000002000000 : "ubi"
  mtdblock: MTD device 'ubi' is NAND, please consider using UBI block devices instead.
  0x000002140000-0x000004000000 : "Kernel2"
  mtdblock: MTD device 'Kernel2' is NAND, please consider using UBI block devices instead.
  0x000004000000-0x000004100000 : "wwan"
  mtdblock: MTD device 'wwan' is NAND, please consider using UBI block devices instead.
  0x000004100000-0x000005100000 : "data"
  mtdblock: MTD device 'data' is NAND, please consider using UBI block devices instead.
  0x000005100000-0x000005200000 : "rom-d"
  mtdblock: MTD device 'rom-d' is NAND, please consider using UBI block devices instead.
  0x000005200000-0x000005280000 : "reserve"
  mtdblock: MTD device 'reserve' is NAND, please consider using UBI block devices instead.
  mtk_soc_eth 1e100000.ethernet eth0: mediatek frame engine at 0xbe100000, irq 21

This is more likely to annoy than to help users of embedded distros where
this driver is enabled by default.  Making the blockdevs available does
not imply that they are in use, and warning about bootloader partitions
or other devices which obviously never will be mounted is more confusing
than helpful.

Move the warning to open(), where it will be of more use - actually warning
anyone who mounts a file system on NAND using mtdblock.

Fixes: e07403a8c6be ("mtdblock: Warn if added for a NAND device")
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Reviewed-by: Ezequiel Garcia <ezequiel@vanguardiasur.com.ar>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220328161108.87757-1-bjorn@mork.no
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdblock.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtdblock.c b/drivers/mtd/mtdblock.c
index 03e3de3a5d79..1e94e7d10b8b 100644
--- a/drivers/mtd/mtdblock.c
+++ b/drivers/mtd/mtdblock.c
@@ -257,6 +257,10 @@ static int mtdblock_open(struct mtd_blktrans_dev *mbd)
 		return 0;
 	}
 
+	if (mtd_type_is_nand(mbd->mtd))
+		pr_warn("%s: MTD device '%s' is NAND, please consider using UBI block devices instead.\n",
+			mbd->tr->name, mbd->mtd->name);
+
 	/* OK, it's not open. Create cache info for it */
 	mtdblk->count = 1;
 	mutex_init(&mtdblk->cache_mutex);
@@ -322,10 +326,6 @@ static void mtdblock_add_mtd(struct mtd_blktrans_ops *tr, struct mtd_info *mtd)
 	if (!(mtd->flags & MTD_WRITEABLE))
 		dev->mbd.readonly = 1;
 
-	if (mtd_type_is_nand(mtd))
-		pr_warn("%s: MTD device '%s' is NAND, please consider using UBI block devices instead.\n",
-			tr->name, mtd->name);
-
 	if (add_mtd_blktrans_dev(&dev->mbd))
 		kfree(dev);
 }
-- 
2.35.1



