Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46AF64999B9
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455974AbiAXVhA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:37:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1390872AbiAXVM6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:12:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76C86C06E001;
        Mon, 24 Jan 2022 12:10:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F2A8B8119E;
        Mon, 24 Jan 2022 20:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D574C340E7;
        Mon, 24 Jan 2022 20:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055022;
        bh=iC3yFsiXLxji/n8wtnpCQ/0JmVUjZqt5fHAV9bJWQ+Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QTlOta8NVYNDXdd6nveGwKO7Y9SgxTDv3u52ooSDWEtypOe0jgPFcIAriaFAgIizK
         zwf5uNtada/A2IixJJR65WAVYLmI+4+06MWqX09zGWYSYFonWoS9CfJLMBhOyYmTQG
         vpPPGV+hMfCEU1s31T9Sev3EKqfOw8a1nDr050as=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Cercueil <paul@crapouillou.net>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 016/846] mtd: rawnand: davinci: Dont calculate ECC when reading page
Date:   Mon, 24 Jan 2022 19:32:13 +0100
Message-Id: <20220124184101.470672588@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
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


