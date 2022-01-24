Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9EF549936C
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 21:34:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383859AbiAXUdq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 15:33:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1382154AbiAXUZQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:25:16 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A07C07E303;
        Mon, 24 Jan 2022 11:41:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 201F5B81229;
        Mon, 24 Jan 2022 19:41:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E93C340E5;
        Mon, 24 Jan 2022 19:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643053268;
        bh=iC3yFsiXLxji/n8wtnpCQ/0JmVUjZqt5fHAV9bJWQ+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DfJwQRwJTcgrSMFt6CGi68c7sGMAsfO9d3WM1xd1vIySWaFLhFT9QJLj85kbAxreU
         g6/6Rn0O4Xkg63MRSXkRWoPNn5d/ZWoH4N45QYwrNxq3hL1TPPtTYCbCJNBxiC+Sai
         riLz20tPtut4/uxIoShBvoeqQgBgnMkIbFGyoPS8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 011/563] mtd: rawnand: davinci: Dont calculate ECC when reading page
Date:   Mon, 24 Jan 2022 19:36:16 +0100
Message-Id: <20220124184024.803953330@linuxfoundation.org>
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

commit 71e89591502d737c10db2bd4d8fcfaa352552afb upstream.

The function nand_davinci_read_page_hwecc_oob_first() does read the ECC
data from the OOB area. Therefore it does not need to calculate the ECC
as it is already available.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-1-paul@crapouillou.net
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/davinci_nand.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -394,7 +394,6 @@ static int nand_davinci_read_page_hwecc_
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_code = chip->ecc.code_buf;
-	uint8_t *ecc_calc = chip->ecc.calc_buf;
 	unsigned int max_bitflips = 0;
 
 	/* Read the OOB area first */
@@ -420,8 +419,6 @@ static int nand_davinci_read_page_hwecc_
 		if (ret)
 			return ret;
 
-		chip->ecc.calculate(chip, p, &ecc_calc[i]);
-
 		stat = chip->ecc.correct(chip, p, &ecc_code[i], NULL);
 		if (stat == -EBADMSG &&
 		    (chip->ecc.options & NAND_ECC_GENERIC_ERASED_CHECK)) {


