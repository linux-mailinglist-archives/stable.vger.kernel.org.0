Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 155D62264E4
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:49:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730970AbgGTPtG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:49:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:44986 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730950AbgGTPtE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:49:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F29172065E;
        Mon, 20 Jul 2020 15:49:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260144;
        bh=ku0H3nGm57QQGb45T2GBTCMR67dnBUJ2UBBuo0ehwSA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yV13brUJ3nEB7G//7zH9CebVp93YMoxLuxI0GNHzZnVAyFxRrZ8J1n+06UUIqQEq6
         HWqUCIeti6ynJhfTxZq12mlCpoQEE6UeBL9EAsPaXNvpAdKMEnp7RhrQJImnVXbckO
         PilmGBO5Bn/i6cU0hmIjjPD87T5fW4RYft4DdhUA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.14 092/125] mtd: rawnand: oxnas: Unregister all devices on error
Date:   Mon, 20 Jul 2020 17:37:11 +0200
Message-Id: <20200720152807.464303992@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152802.929969555@linuxfoundation.org>
References: <20200720152802.929969555@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit b60391eb17b2956ff2fc4c348e5a464da21ff9cb upstream.

On error, the oxnas probe path just frees the device which failed and
aborts the probe, leaving unreleased resources.

Fix this situation by calling mtd_device_unregister()/nand_cleanup()
on these.

Fixes: 668592492409 ("mtd: nand: Add OX820 NAND Support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-38-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/oxnas_nand.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/mtd/nand/oxnas_nand.c
+++ b/drivers/mtd/nand/oxnas_nand.c
@@ -89,6 +89,7 @@ static int oxnas_nand_probe(struct platf
 	struct resource *res;
 	int count = 0;
 	int err = 0;
+	int i;
 
 	/* Allocate memory for the device structure (and zero it) */
 	oxnas = devm_kzalloc(&pdev->dev, sizeof(*oxnas),
@@ -168,6 +169,13 @@ err_cleanup_nand:
 	nand_cleanup(chip);
 err_release_child:
 	of_node_put(nand_np);
+
+	for (i = 0; i < oxnas->nchips; i++) {
+		chip = oxnas->chips[i];
+		WARN_ON(mtd_device_unregister(nand_to_mtd(chip)));
+		nand_cleanup(chip);
+	}
+
 err_clk_unprepare:
 	clk_disable_unprepare(oxnas->clk);
 	return err;


