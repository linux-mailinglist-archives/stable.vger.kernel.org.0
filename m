Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 126914971DA
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236680AbiAWOIT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:08:19 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:58616 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236683AbiAWOIP (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:08:15 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6430960C78
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:08:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25936C340E2;
        Sun, 23 Jan 2022 14:08:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642946894;
        bh=HGQ4qsSbigxxKJTJbOubDrcQzdsbZMCrCiDrA1HiT0A=;
        h=Subject:To:Cc:From:Date:From;
        b=Maa2C6aQpv5qX7vm/PgU+ZnGCz2P7SWpN0YbLAFoAe8zYS3ssjUEjjwNS0do/iL5z
         u8E+ELwDkZBX7B+TvACn3GV3hKrEVrufwQiNF7KaY1HOA+JdUC2OhEE83EQjGEtexh
         FbVSC9WnZcblYVpYcBxdmSzfBcEYgJXVM5Zl/eeU=
Subject: FAILED: patch "[PATCH] mtd: rawnand: davinci: Don't calculate ECC when reading page" failed to apply to 5.4-stable tree
To:     paul@crapouillou.net, miquel.raynal@bootlin.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:07:47 +0100
Message-ID: <164294686714650@kroah.com>
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

From 71e89591502d737c10db2bd4d8fcfaa352552afb Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sat, 16 Oct 2021 14:22:24 +0100
Subject: [PATCH] mtd: rawnand: davinci: Don't calculate ECC when reading page

The function nand_davinci_read_page_hwecc_oob_first() does read the ECC
data from the OOB area. Therefore it does not need to calculate the ECC
as it is already available.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-1-paul@crapouillou.net

diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index 118da9944e3b..89de24d3bb7a 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -394,7 +394,6 @@ static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 	int eccsteps = chip->ecc.steps;
 	uint8_t *p = buf;
 	uint8_t *ecc_code = chip->ecc.code_buf;
-	uint8_t *ecc_calc = chip->ecc.calc_buf;
 	unsigned int max_bitflips = 0;
 
 	/* Read the OOB area first */
@@ -420,8 +419,6 @@ static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 		if (ret)
 			return ret;
 
-		chip->ecc.calculate(chip, p, &ecc_calc[i]);
-
 		stat = chip->ecc.correct(chip, p, &ecc_code[i], NULL);
 		if (stat == -EBADMSG &&
 		    (chip->ecc.options & NAND_ECC_GENERIC_ERASED_CHECK)) {

