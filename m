Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 613D51AC31E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897650AbgDPNiM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:38:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50586 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897651AbgDPNiJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:38:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7326921BE5;
        Thu, 16 Apr 2020 13:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044288;
        bh=1W5KIwf4IEZ/S6UWBR0GAJ66klrhUvvnU62RubpXa4Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cGmXZODKtsYuFzVEUaK/2ppN+Oxot06WimN4rSJwuFbknERLojcYrjufN7HypER8Y
         3z+EsV0kmjWtG3Uw2olL7V2Cr0opjGB6OT+wx2UkpoIzVYxye0FxiXGJxa03UHF74I
         kzmw1u7TgPvg3HlDgBHNAVikSuz2l4oyDmVsk/oY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Sroka <piotrs@cadence.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.5 155/257] mtd: rawnand: cadence: fix the calculation of the avaialble OOB size
Date:   Thu, 16 Apr 2020 15:23:26 +0200
Message-Id: <20200416131345.945130591@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131325.891903893@linuxfoundation.org>
References: <20200416131325.891903893@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Piotr Sroka <piotrs@cadence.com>

commit e4578af0354176ff6b4ae78b9998b4f479f7c31c upstream.

The value of cdns_chip->sector_count is not known at the moment
of the derivation of ecc_size, leading to a zero value. Fix
this by assigning ecc_size later in the code.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Sroka <piotrs@cadence.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1581328530-29966-2-git-send-email-piotrs@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2585,7 +2585,7 @@ int cadence_nand_attach_chip(struct nand
 {
 	struct cdns_nand_ctrl *cdns_ctrl = to_cdns_nand_ctrl(chip->controller);
 	struct cdns_nand_chip *cdns_chip = to_cdns_nand_chip(chip);
-	u32 ecc_size = cdns_chip->sector_count * chip->ecc.bytes;
+	u32 ecc_size;
 	struct mtd_info *mtd = nand_to_mtd(chip);
 	u32 max_oob_data_size;
 	int ret;
@@ -2625,6 +2625,7 @@ int cadence_nand_attach_chip(struct nand
 	/* Error correction configuration. */
 	cdns_chip->sector_size = chip->ecc.size;
 	cdns_chip->sector_count = mtd->writesize / cdns_chip->sector_size;
+	ecc_size = cdns_chip->sector_count * chip->ecc.bytes;
 
 	cdns_chip->avail_oob_size = mtd->oobsize - ecc_size;
 


