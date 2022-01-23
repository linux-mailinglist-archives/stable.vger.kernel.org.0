Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D467B4971DB
	for <lists+stable@lfdr.de>; Sun, 23 Jan 2022 15:08:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236681AbiAWOIU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Jan 2022 09:08:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236677AbiAWOIU (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Jan 2022 09:08:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D27C06173B
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 06:08:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2B12DB80CE1
        for <stable@vger.kernel.org>; Sun, 23 Jan 2022 14:08:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B502C340E5;
        Sun, 23 Jan 2022 14:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1642946897;
        bh=0PUMjQ/GIj7nzUhmifKz9fSMD0dSlozgYwymeCPjlM0=;
        h=Subject:To:Cc:From:Date:From;
        b=GKXIidHTti62JUX6lIMmd0OyB7Wqpho2q3QyoE0mpj5q3s54LPFFXENdvO6eByAao
         XsrbTRkEqXQRZ3NxzpKCImSbZhqkKE7X07j/Eg+wbWPGY+ij7I5N3JaiRXVygBcz/6
         0YJbE30wAgnnZ04J/XHl75ukZ7FCCPsrVngAVipQ=
Subject: FAILED: patch "[PATCH] mtd: rawnand: davinci: Avoid duplicated page read" failed to apply to 5.4-stable tree
To:     paul@crapouillou.net, miquel.raynal@bootlin.com,
        stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 23 Jan 2022 15:08:08 +0100
Message-ID: <164294688823150@kroah.com>
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

From 9c9d709965385de5a99f84b14bd5860e1541729e Mon Sep 17 00:00:00 2001
From: Paul Cercueil <paul@crapouillou.net>
Date: Sat, 16 Oct 2021 14:22:25 +0100
Subject: [PATCH] mtd: rawnand: davinci: Avoid duplicated page read

The function nand_davinci_read_page_hwecc_oob_first() first reads the
OOB data, extracts the ECC information, programs the ECC hardware before
reading the actual data in a loop.

Right after the OOB data was read, it called nand_read_page_op() to
reset the read cursor to the beginning of the page. This caused the
first page to be read twice: in that call, and later in the loop.

Address that issue by changing the call to nand_read_page_op() to
nand_change_read_column_op(), which will only reset the read cursor.

Cc: <stable@vger.kernel.org> # v5.2
Fixes: a0ac778eb82c ("mtd: rawnand: ingenic: Add support for the JZ4740")
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20211016132228.40254-2-paul@crapouillou.net

diff --git a/drivers/mtd/nand/raw/davinci_nand.c b/drivers/mtd/nand/raw/davinci_nand.c
index 89de24d3bb7a..2e6a0c1671be 100644
--- a/drivers/mtd/nand/raw/davinci_nand.c
+++ b/drivers/mtd/nand/raw/davinci_nand.c
@@ -401,7 +401,8 @@ static int nand_davinci_read_page_hwecc_oob_first(struct nand_chip *chip,
 	if (ret)
 		return ret;
 
-	ret = nand_read_page_op(chip, page, 0, NULL, 0);
+	/* Move read cursor to start of page */
+	ret = nand_change_read_column_op(chip, 0, NULL, 0, false);
 	if (ret)
 		return ret;
 

