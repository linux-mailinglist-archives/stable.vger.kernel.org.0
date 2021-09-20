Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 82E5B41261D
	for <lists+stable@lfdr.de>; Mon, 20 Sep 2021 20:52:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354569AbhITSxb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Sep 2021 14:53:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:37308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1385534AbhITSue (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Sep 2021 14:50:34 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7FAC361503;
        Mon, 20 Sep 2021 17:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632159305;
        bh=0x2De22Szmsl8Wa6aJUPQ0rUXTWgSLDA/cNGXPNVDSU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yRWQJJW2Cw/MuSNMzsVrRFsdDRc+P4WnlsPblj95PQ1vxqdyLT1TxZByw97OhcmLV
         wlu0jhTY8WrjMT3Ga3BOfoYSpRubs+YkehYbe2BG/TyE+C8xFgnbn6BBs8Vj07xmr8
         mla1eqbEVvbhjcJROa+hPJBovlg6HgIYNM9PIoZs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 138/168] mtd: rawnand: cafe: Fix a resource leak in the error handling path of cafe_nand_probe()
Date:   Mon, 20 Sep 2021 18:44:36 +0200
Message-Id: <20210920163926.194334077@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210920163921.633181900@linuxfoundation.org>
References: <20210920163921.633181900@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 6b430c7595e4eb95fae8fb54adc3c3ce002e75ae ]

A successful 'init_rs_non_canonical()' call should be balanced by a
corresponding 'free_rs()' call in the error handling path of the probe, as
already done in the remove function.

Update the error handling path accordingly.

Fixes: 8c61b7a7f4d4 ("[MTD] [NAND] Use rslib for CAFÉ ECC")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/fd313d3fb787458bcc73189e349f481133a2cdc9.1629532640.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/cafe_nand.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/cafe_nand.c b/drivers/mtd/nand/raw/cafe_nand.c
index d0e8ffd55c22..9dbf031716a6 100644
--- a/drivers/mtd/nand/raw/cafe_nand.c
+++ b/drivers/mtd/nand/raw/cafe_nand.c
@@ -751,7 +751,7 @@ static int cafe_nand_probe(struct pci_dev *pdev,
 			  "CAFE NAND", mtd);
 	if (err) {
 		dev_warn(&pdev->dev, "Could not register IRQ %d\n", pdev->irq);
-		goto out_ior;
+		goto out_free_rs;
 	}
 
 	/* Disable master reset, enable NAND clock */
@@ -795,6 +795,8 @@ static int cafe_nand_probe(struct pci_dev *pdev,
 	/* Disable NAND IRQ in global IRQ mask register */
 	cafe_writel(cafe, ~1 & cafe_readl(cafe, GLOBAL_IRQ_MASK), GLOBAL_IRQ_MASK);
 	free_irq(pdev->irq, mtd);
+ out_free_rs:
+	free_rs(cafe->rs);
  out_ior:
 	pci_iounmap(pdev, cafe->mmio);
  out_free_mtd:
-- 
2.30.2



