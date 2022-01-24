Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A83E1499371
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355430AbiAXUdz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382294AbiAXUZZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:25:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 833ACC07E30E;
        Mon, 24 Jan 2022 11:41:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B5EFB8121A;
        Mon, 24 Jan 2022 19:41:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 711EDC340E5;
        Mon, 24 Jan 2022 19:41:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053275;
        bh=+UqKwQ35sgQOM9w62WCDHOz/u6Y8TNzdLyjcPKVz5Ac=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ei+an6+S5xCdwhGVinUoVmViDVUflm7KmNrjJQq4n7vlqxHCiQip9Tfm5Ot/1xCtP
         9M3UOa85URiEWFQy36iwX4N4EWuOPZoXku2JEh8awUylRjgV0faCEmhX3hrcXl+3vB
         gazGFAuhrX9I3atpWh8Q5eu3bh67ZUVglMVv3Tv8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 013/563] mtd: rawnand: davinci: Rewrite function description
Date:   Mon, 24 Jan 2022 19:36:18 +0100
Message-Id: <20220124184024.874787464@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184024.407936072@linuxfoundation.org>
References: <20220124184024.407936072@linuxfoundation.org>
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


