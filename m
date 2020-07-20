Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4AAA5226554
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:53:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731424AbgGTPwz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:52:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:51174 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731404AbgGTPwz (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:52:55 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 246FE2065E;
        Mon, 20 Jul 2020 15:52:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260374;
        bh=crJYIvivXNC90Eok6L3CAdfejlbjG3R3FNRn61Sp718=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uvvgyrYm8hy92+kONm9fpkkY2JGgYxu0JLe96jgl/J4pAMafxGni0R2vtp026gZd1
         NgeFyh+5tkfHmxt726bTPIVIEA7XXb9A8p4aWEctqDVIbLgLKqeBHNZcAL2KFLuJPf
         K8gj0Hf7Bu6unKiTOFQuETy9wm0d0OJGEI7JTVzc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 080/133] mtd: rawnand: oxnas: Release all devices in the _remove() path
Date:   Mon, 20 Jul 2020 17:37:07 +0200
Message-Id: <20200720152807.570110342@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 0a5f45e57e35d0840bedb816974ce2e63406cd8b upstream.

oxnans_nand_remove() should release all MTD devices and clean all NAND
devices, not only the first one registered.

Fixes: 668592492409 ("mtd: nand: Add OX820 NAND Support")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-39-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/oxnas_nand.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/oxnas_nand.c
+++ b/drivers/mtd/nand/raw/oxnas_nand.c
@@ -184,9 +184,13 @@ err_clk_unprepare:
 static int oxnas_nand_remove(struct platform_device *pdev)
 {
 	struct oxnas_nand_ctrl *oxnas = platform_get_drvdata(pdev);
+	struct nand_chip *chip;
+	int i;
 
-	if (oxnas->chips[0])
-		nand_release(oxnas->chips[0]);
+	for (i = 0; i < oxnas->nchips; i++) {
+		chip = oxnas->chips[i];
+		nand_release(chip);
+	}
 
 	clk_disable_unprepare(oxnas->clk);
 


