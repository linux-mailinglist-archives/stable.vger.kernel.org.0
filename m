Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC9A22691D
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:24:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729154AbgGTQDA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:03:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:37110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729108AbgGTQDA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:03:00 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3769F20672;
        Mon, 20 Jul 2020 16:02:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260979;
        bh=86ZTvRqVkuIPwMg8KZAObwjs1LiqfTJe/5fYcaD8pck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pSHq+iSKMJsMC/uaM8MzEoThUaARmXsIEwxHLcXHFtWyGoMSdkJ9vdPkCsLgvU2CK
         7bqeEp1mvGFqEe2nbA384UsKNeP4GtYv9XbewioExRr+x/XZJiz1/7kJYR5YvscCD/
         mMR1UwJukvpbYFSdEfZL/sidKlV7yaAnZNvo6cDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= 
        <noltari@gmail.com>, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 135/215] mtd: rawnand: brcmnand: correctly verify erased pages
Date:   Mon, 20 Jul 2020 17:36:57 +0200
Message-Id: <20200720152826.614656757@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152820.122442056@linuxfoundation.org>
References: <20200720152820.122442056@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Álvaro Fernández Rojas <noltari@gmail.com>

commit dcb351c03f2fa6a599de1061b174167e03ee312b upstream.

The current code checks that the whole OOB area is erased.
This is a problem when JFFS2 cleanmarkers are added to the OOB, since it will
fail due to the usable OOB bytes not being 0xff.
Correct this by only checking that data and ECC bytes aren't 0xff.

Fixes: 02b88eea9f9c ("mtd: brcmnand: Add check for erased page bitflips")
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200512082451.771212-1-noltari@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/brcmnand/brcmnand.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -1790,28 +1790,31 @@ static int brcmnand_read_by_pio(struct m
 static int brcmstb_nand_verify_erased_page(struct mtd_info *mtd,
 		  struct nand_chip *chip, void *buf, u64 addr)
 {
-	int i, sas;
-	void *oob = chip->oob_poi;
+	struct mtd_oob_region ecc;
+	int i;
 	int bitflips = 0;
 	int page = addr >> chip->page_shift;
 	int ret;
+	void *ecc_bytes;
 	void *ecc_chunk;
 
 	if (!buf)
 		buf = nand_get_data_buf(chip);
 
-	sas = mtd->oobsize / chip->ecc.steps;
-
 	/* read without ecc for verification */
 	ret = chip->ecc.read_page_raw(chip, buf, true, page);
 	if (ret)
 		return ret;
 
-	for (i = 0; i < chip->ecc.steps; i++, oob += sas) {
+	for (i = 0; i < chip->ecc.steps; i++) {
 		ecc_chunk = buf + chip->ecc.size * i;
-		ret = nand_check_erased_ecc_chunk(ecc_chunk,
-						  chip->ecc.size,
-						  oob, sas, NULL, 0,
+
+		mtd_ooblayout_ecc(mtd, i, &ecc);
+		ecc_bytes = chip->oob_poi + ecc.offset;
+
+		ret = nand_check_erased_ecc_chunk(ecc_chunk, chip->ecc.size,
+						  ecc_bytes, ecc.length,
+						  NULL, 0,
 						  chip->ecc.strength);
 		if (ret < 0)
 			return ret;


