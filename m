Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0A2C22061CD
	for <lists+stable@lfdr.de>; Tue, 23 Jun 2020 23:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391367AbgFWUur (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Jun 2020 16:50:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392640AbgFWUsi (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Jun 2020 16:48:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 558902098B;
        Tue, 23 Jun 2020 20:48:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592945318;
        bh=3PAE0rb8umTgiVnbizPCTpcvNcF8NBTtTzgHjp8hxiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C8UJrRoTw/PCFF205zc76Sd8njwp+rDBAB7U3XoWMFAqfLT7uUNfagt9/bqNrB8U2
         2nZhvbWN8wCcGzzyHoGJxmUfi8nXPEmQVCVhCpkRLyZoyJg16Fvyq4GKT6+Ks0wZyM
         dfx0B8jjUYBfdvwGD+Q5E9FnGSegCE1BHXmX+W/Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Nishka Dasgupta <nishkadg.linux@gmail.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 124/136] mtd: rawnand: oxnas: Add of_node_put()
Date:   Tue, 23 Jun 2020 21:59:40 +0200
Message-Id: <20200623195310.017515738@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200623195303.601828702@linuxfoundation.org>
References: <20200623195303.601828702@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nishka Dasgupta <nishkadg.linux@gmail.com>

[ Upstream commit c436f68beeb20f2f92937677db1d9069b0dd2a3d ]

Each iteration of for_each_child_of_node puts the previous node, but in
the case of a goto from the middle of the loop, there is no put, thus
causing a memory leak. Hence add an of_node_put under a new goto to put
the node at a loop exit.
Issue found with Coccinelle.

Signed-off-by: Nishka Dasgupta <nishkadg.linux@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/oxnas_nand.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/nand/oxnas_nand.c b/drivers/mtd/nand/oxnas_nand.c
index ff58999887388..7f0ba28f8a007 100644
--- a/drivers/mtd/nand/oxnas_nand.c
+++ b/drivers/mtd/nand/oxnas_nand.c
@@ -123,7 +123,7 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 				    GFP_KERNEL);
 		if (!chip) {
 			err = -ENOMEM;
-			goto err_clk_unprepare;
+			goto err_release_child;
 		}
 
 		chip->controller = &oxnas->base;
@@ -144,12 +144,12 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 		/* Scan to find existence of the device */
 		err = nand_scan(mtd, 1);
 		if (err)
-			goto err_clk_unprepare;
+			goto err_release_child;
 
 		err = mtd_device_register(mtd, NULL, 0);
 		if (err) {
 			nand_release(chip);
-			goto err_clk_unprepare;
+			goto err_release_child;
 		}
 
 		oxnas->chips[nchips] = chip;
@@ -166,6 +166,8 @@ static int oxnas_nand_probe(struct platform_device *pdev)
 
 	return 0;
 
+err_release_child:
+	of_node_put(nand_np);
 err_clk_unprepare:
 	clk_disable_unprepare(oxnas->clk);
 	return err;
-- 
2.25.1



