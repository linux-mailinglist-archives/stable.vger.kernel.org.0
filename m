Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 48218226AA4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731408AbgGTPwt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:52:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:51116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730614AbgGTPwt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:52:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B6632064B;
        Mon, 20 Jul 2020 15:52:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260368;
        bh=cAFuMYMSI+hC05opE2iqvyvBHqjp9gab63WrRRX/0w4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4CYwaUctCBpWAOBNhVYC0CtivYSvEOoe5w+1lOjSbBcunLVTBRjBFz9ZdQilbNVB
         lFtzNSPzNo1K7YidRlmoJEFBX00CmPcKqv5B3+MnhYPZZvRdV2qTf1UzouzblOHK7y
         7GxQAwWkZt9avWs1FA4zsICvXYxoVKV5nJNAODW8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 078/133] mtd: rawnand: oxnas: Keep track of registered devices
Date:   Mon, 20 Jul 2020 17:37:05 +0200
Message-Id: <20200720152807.473463028@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 383fc3f613e7eac9f2e3c13b6f9fb8c1f39cb9d5 upstream.

All initialized and registered devices should be listed somewhere so
that we can unregister/free them in the _remove() path.

This patch is not a fix per-se but is needed to apply three other
fixes coming right after, explaining the Fixes/Cc: stable tags.

Fixes: 668592492409 ("mtd: nand: Add OX820 NAND Support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-36-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/oxnas_nand.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/raw/oxnas_nand.c
+++ b/drivers/mtd/nand/raw/oxnas_nand.c
@@ -36,6 +36,7 @@ struct oxnas_nand_ctrl {
 	void __iomem *io_base;
 	struct clk *clk;
 	struct nand_chip *chips[OXNAS_NAND_MAX_CHIPS];
+	unsigned int nchips;
 };
 
 static uint8_t oxnas_nand_read_byte(struct mtd_info *mtd)
@@ -86,7 +87,6 @@ static int oxnas_nand_probe(struct platf
 	struct nand_chip *chip;
 	struct mtd_info *mtd;
 	struct resource *res;
-	int nchips = 0;
 	int count = 0;
 	int err = 0;
 
@@ -150,12 +150,12 @@ static int oxnas_nand_probe(struct platf
 		if (err)
 			goto err_cleanup_nand;
 
-		oxnas->chips[nchips] = chip;
-		++nchips;
+		oxnas->chips[oxnas->nchips] = chip;
+		++oxnas->nchips;
 	}
 
 	/* Exit if no chips found */
-	if (!nchips) {
+	if (!oxnas->nchips) {
 		err = -ENODEV;
 		goto err_clk_unprepare;
 	}


