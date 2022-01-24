Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9472A4995F3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:14:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354104AbiAXU5p (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:57:45 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:50404 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1442156AbiAXUxg (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:53:36 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4B189B81063;
        Mon, 24 Jan 2022 20:53:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7BD50C340E5;
        Mon, 24 Jan 2022 20:53:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057611;
        bh=w6SHKE6jX4ZUVWOWECRb9u1Z6a+zZf7mElpRsXhmPcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ASNIidu52vwgs6zqTt0Q9oKlnCTBoAPyEjnr9wXoy7ZODrHEje1/17FYdlUvLF0Gb
         1JaONlACoGVSMqBj5WmoiqT+Wv/OlRQbX4bcBbt8bCHsHQoBt4TxoEYSijYkFILZQa
         yeVYm2yc8UecSSDCaZ0gqAT+Z1vJw1gKEUwfclUc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.16 0022/1039] mtd: rawnand: ingenic: JZ4740 needs oob_first read page function
Date:   Mon, 24 Jan 2022 19:30:11 +0100
Message-Id: <20220124184125.880752344@linuxfoundation.org>
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

commit 0171480007d64f663aae9226303f1b1e4621229e upstream.

The ECC engine on the JZ4740 SoC requires the ECC data to be read before
the page; using the default page reading function does not work. Indeed,
the old JZ4740 NAND driver (removed in 5.4) did use the 'OOB first' flag
that existed back then.

Use the newly created nand_read_page_hwecc_oob_first() to address this
issue.

This issue was not found when the new ingenic-nand driver was developed,
most likely because the Device Tree used had the nand-ecc-mode set to
"hw_oob_first", which seems to not be supported anymore.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-5-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
+++ b/drivers/mtd/nand/raw/ingenic/ingenic_nand_drv.c
@@ -32,6 +32,7 @@ struct jz_soc_info {
 	unsigned long addr_offset;
 	unsigned long cmd_offset;
 	const struct mtd_ooblayout_ops *oob_layout;
+	bool oob_first;
 };
 
 struct ingenic_nand_cs {
@@ -240,6 +241,9 @@ static int ingenic_nand_attach_chip(stru
 	if (chip->bbt_options & NAND_BBT_USE_FLASH)
 		chip->bbt_options |= NAND_BBT_NO_OOB;
 
+	if (nfc->soc_info->oob_first)
+		chip->ecc.read_page = nand_read_page_hwecc_oob_first;
+
 	/* For legacy reasons we use a different layout on the qi,lb60 board. */
 	if (of_machine_is_compatible("qi,lb60"))
 		mtd_set_ooblayout(mtd, &qi_lb60_ooblayout_ops);
@@ -534,6 +538,7 @@ static const struct jz_soc_info jz4740_s
 	.data_offset = 0x00000000,
 	.cmd_offset = 0x00008000,
 	.addr_offset = 0x00010000,
+	.oob_first = true,
 };
 
 static const struct jz_soc_info jz4725b_soc_info = {


