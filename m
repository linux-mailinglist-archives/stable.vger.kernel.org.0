Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BBF74BCF3F
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 16:07:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241457AbiBTO7v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 09:59:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239217AbiBTO7u (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 09:59:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C11923BED
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 06:59:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28123B80D4A
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 14:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E5EEC340E8;
        Sun, 20 Feb 2022 14:59:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1645369165;
        bh=Qt4wXCQgPuP6XPZ3ZPOikREZK+5aEj4CLqCTJrmWg50=;
        h=Subject:To:Cc:From:Date:From;
        b=yKM1n4am7kr8VRMbbRajrcyjgEYmGQeeAhLM8X17YB3WZuAguCMa4y1IwVQygXVvB
         GNh60MOab29jLPI75b3iZODXrJSS7MDEHRvKLGVg9/ed50ZBzVlrX3xzL/Zi2AfnT8
         S66i+P7Uwz4dFCsvQu3cV8tVNlL/0d8mKOqXkhi4=
Subject: FAILED: patch "[PATCH] mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status" failed to apply to 4.9-stable tree
To:     dregan@mail.com, f.fainelli@gmail.com, miquel.raynal@bootlin.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 20 Feb 2022 15:59:15 +0100
Message-ID: <1645369155162154@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 36415a7964711822e63695ea67fede63979054d9 Mon Sep 17 00:00:00 2001
From: david regan <dregan@mail.com>
Date: Wed, 26 Jan 2022 23:43:44 +0100
Subject: [PATCH] mtd: rawnand: brcmnand: Fixed incorrect sub-page ECC status

The brcmnand driver contains a bug in which if a page (example 2k byte)
is read from the parallel/ONFI NAND and within that page a subpage (512
byte) has correctable errors which is followed by a subpage with
uncorrectable errors, the page read will return the wrong status of
correctable (as opposed to the actual status of uncorrectable.)

The bug is in function brcmnand_read_by_pio where there is a check for
uncorrectable bits which will be preempted if a previous status for
correctable bits is detected.

The fix is to stop checking for bad bits only if we already have a bad
bits status.

Fixes: 27c5b17cd1b1 ("mtd: nand: add NAND driver "library" for Broadcom STB NAND controller")
Signed-off-by: david regan <dregan@mail.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/trinity-478e0c09-9134-40e8-8f8c-31c371225eda-1643237024774@3c-app-mailcom-lxa02

diff --git a/drivers/mtd/nand/raw/brcmnand/brcmnand.c b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
index f75929783b94..aee78f5f4f15 100644
--- a/drivers/mtd/nand/raw/brcmnand/brcmnand.c
+++ b/drivers/mtd/nand/raw/brcmnand/brcmnand.c
@@ -2106,7 +2106,7 @@ static int brcmnand_read_by_pio(struct mtd_info *mtd, struct nand_chip *chip,
 					mtd->oobsize / trans,
 					host->hwcfg.sector_size_1k);
 
-		if (!ret) {
+		if (ret != -EBADMSG) {
 			*err_addr = brcmnand_get_uncorrecc_addr(ctrl);
 
 			if (*err_addr)

