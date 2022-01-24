Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E9D9349960E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:16:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351621AbiAXU6s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:58:48 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:51530 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442764AbiAXUzL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:55:11 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0056B80CCF;
        Mon, 24 Jan 2022 20:55:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A9F4C340E5;
        Mon, 24 Jan 2022 20:55:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057708;
        bh=+UqKwQ35sgQOM9w62WCDHOz/u6Y8TNzdLyjcPKVz5Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LIP4acmLVJBnSoPHNAtwRuYdylaULmXCstLBo3y5rkUbC4N7in2aYZzIWrhuUe3dA
         45bCYnAETWgoEQazHy+dFdqQP2ZmlGdRMIc/+MzC9lNtR0AE+Raus/F+q7KmXm9Mi5
         UZxWdRlAhA8HxIbchmHC3N5qnC5i2OvpOXK2Pmo8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.16 0020/1039] mtd: rawnand: davinci: Rewrite function description
Date:   Mon, 24 Jan 2022 19:30:09 +0100
Message-Id: <20220124184125.820352097@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Cercueil <paul@crapouillou.net>

commit 0697f8441faad552fbeb02d74454b5e7bcc956a2 upstream.

The original comment that describes the function
nand_davinci_read_page_hwecc_oob_first() is very obscure and it is hard
to understand what it is for.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-3-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/davinci_nand.c |   10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -372,17 +372,15 @@ correct:
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


