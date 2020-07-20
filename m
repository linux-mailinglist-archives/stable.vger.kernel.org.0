Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D366922676E
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:11:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732946AbgGTQLj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 12:11:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:50764 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387810AbgGTQLi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 12:11:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 42E0B2064B;
        Mon, 20 Jul 2020 16:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595261497;
        bh=i+3+PryJpfOp9qSe/SEHL8B1V+B5vk4u0MIU9vb2jN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m0i19Q2y07m7l8Uu6Fowh8pRJB8qH53g/1xTA6cCHHiHbXHSVOdY7lM7b3ecAKQTg
         9+xj+ThQd340UPndz3YbJNC09HNLZHNl0BXq1fPJdX+anV+6+/N9Ji8WKqzpATPlVB
         JrW4o7V1snhTbGasd6lgXjBSC7F8+CtCWmccQoUg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.7 136/244] mtd: rawnand: marvell: Fix probe error path
Date:   Mon, 20 Jul 2020 17:36:47 +0200
Message-Id: <20200720152832.315497627@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152825.863040590@linuxfoundation.org>
References: <20200720152825.863040590@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit c525b7af96714f72e316c70781570a4a3e1c2856 upstream.

Ensure all chips are deregistered and cleaned in case of error during
the probe.

Fixes: 02f26ecf8c77 ("mtd: nand: add reworked Marvell NAND controller driver")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-mtd/20200424164501.26719-5-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/marvell_nand.c |   23 ++++++++++++++---------
 1 file changed, 14 insertions(+), 9 deletions(-)

--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -2673,6 +2673,16 @@ static int marvell_nand_chip_init(struct
 	return 0;
 }
 
+static void marvell_nand_chips_cleanup(struct marvell_nfc *nfc)
+{
+	struct marvell_nand_chip *entry, *temp;
+
+	list_for_each_entry_safe(entry, temp, &nfc->chips, node) {
+		nand_release(&entry->chip);
+		list_del(&entry->node);
+	}
+}
+
 static int marvell_nand_chips_init(struct device *dev, struct marvell_nfc *nfc)
 {
 	struct device_node *np = dev->of_node;
@@ -2707,21 +2717,16 @@ static int marvell_nand_chips_init(struc
 		ret = marvell_nand_chip_init(dev, nfc, nand_np);
 		if (ret) {
 			of_node_put(nand_np);
-			return ret;
+			goto cleanup_chips;
 		}
 	}
 
 	return 0;
-}
 
-static void marvell_nand_chips_cleanup(struct marvell_nfc *nfc)
-{
-	struct marvell_nand_chip *entry, *temp;
+cleanup_chips:
+	marvell_nand_chips_cleanup(nfc);
 
-	list_for_each_entry_safe(entry, temp, &nfc->chips, node) {
-		nand_release(&entry->chip);
-		list_del(&entry->node);
-	}
+	return ret;
 }
 
 static int marvell_nfc_init_dma(struct marvell_nfc *nfc)


