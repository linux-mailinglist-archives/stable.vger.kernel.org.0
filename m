Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45FF014F58
	for <lists+stable@lfdr.de>; Mon,  6 May 2019 17:10:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbfEFOeU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 6 May 2019 10:34:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:53914 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726547AbfEFOeU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 6 May 2019 10:34:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD6C021019;
        Mon,  6 May 2019 14:34:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557153259;
        bh=eqIMyI2to114pYMDTN8IOgOzj1heKa0eEbStpxGTRpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ox1fIonzaf3O7yY8wWsRhJ48jPxJrrginBkF34nsX8P3GeApYb4wQOz6jRNLJPBv+
         ll4tc6sP6SpQACVUQWhyptuAoya5agNWs7XSAaGsE7E7WOoneNb7IFj10lYXUZFYLh
         EeMDmJrLlEWxsBkohvvra6/Cb9uonFV50GwxkM8o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Daniel Mack <daniel@zonque.org>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Richard Weinberger <richard@nod.at>
Subject: [PATCH 5.0 006/122] mtd: rawnand: marvell: Clean the controller state before each operation
Date:   Mon,  6 May 2019 16:31:04 +0200
Message-Id: <20190506143055.288319220@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190506143054.670334917@linuxfoundation.org>
References: <20190506143054.670334917@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 9a8f612ca0d6a436e6471c9bed516d34a2cc626f upstream.

Since the migration of the driver to stop using the legacy
->select_chip() hook, there is nothing deselecting the target anymore,
thus the selection is not forced at the next access. Ensure the ND_RUN
bit and the interrupts are always in a clean state.

Cc: Daniel Mack <daniel@zonque.org>
Cc: stable@vger.kernel.org
Fixes: b25251414f6e00 ("mtd: rawnand: marvell: Stop implementing ->select_chip()")
Suggested-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Daniel Mack <daniel@zonque.org>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/marvell_nand.c |   12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -722,12 +722,6 @@ static void marvell_nfc_select_target(st
 	struct marvell_nfc *nfc = to_marvell_nfc(chip->controller);
 	u32 ndcr_generic;
 
-	if (chip == nfc->selected_chip && die_nr == marvell_nand->selected_die)
-		return;
-
-	writel_relaxed(marvell_nand->ndtr0, nfc->regs + NDTR0);
-	writel_relaxed(marvell_nand->ndtr1, nfc->regs + NDTR1);
-
 	/*
 	 * Reset the NDCR register to a clean state for this particular chip,
 	 * also clear ND_RUN bit.
@@ -739,6 +733,12 @@ static void marvell_nfc_select_target(st
 	/* Also reset the interrupt status register */
 	marvell_nfc_clear_int(nfc, NDCR_ALL_INT);
 
+	if (chip == nfc->selected_chip && die_nr == marvell_nand->selected_die)
+		return;
+
+	writel_relaxed(marvell_nand->ndtr0, nfc->regs + NDTR0);
+	writel_relaxed(marvell_nand->ndtr1, nfc->regs + NDTR1);
+
 	nfc->selected_chip = chip;
 	marvell_nand->selected_die = die_nr;
 }


