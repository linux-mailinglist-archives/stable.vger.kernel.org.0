Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D20E21AC31F
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 15:39:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2897670AbgDPNiN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 09:38:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2897667AbgDPNiL (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:38:11 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F01F520732;
        Thu, 16 Apr 2020 13:38:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044291;
        bh=g9v6h6SXtblq+7AJbJQ450xlCwd+w7sxbEg9I5Os8I4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1cG2aSEjPxN9KLZOHDapzD+NOmgf1rmJijrFBez/rU5IXRUa9DyHQmFZqzZehxU2+
         mheQlBPAHryzrrhV9oCS6TeQFY/rJWGGch+V9runzLQ8E1d4jyrDmdTkqQn7l6us9F
         BG3IDxGqJbtfuarmWnSY22cWvIgu1EyaVWiTrYbQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Piotr Sroka <piotrs@cadence.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.5 156/257] mtd: rawnand: cadence: change bad block marker size
Date:   Thu, 16 Apr 2020 15:23:27 +0200
Message-Id: <20200416131346.055219849@linuxfoundation.org>
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

commit 9bf1903bed7a2e84f5a8deedb38f7e0ac5e8bfc6 upstream.

Increase bad block marker size from one byte to two bytes.
Bad block marker is handled by skip bytes feature of HPNFC.
Controller expects this value to be an even number.

Fixes: ec4ba01e894d ("mtd: rawnand: Add new Cadence NAND driver to MTD subsystem")
Cc: stable@vger.kernel.org
Signed-off-by: Piotr Sroka <piotrs@cadence.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/1581328530-29966-3-git-send-email-piotrs@cadence.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/cadence-nand-controller.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/mtd/nand/raw/cadence-nand-controller.c
+++ b/drivers/mtd/nand/raw/cadence-nand-controller.c
@@ -2603,12 +2603,9 @@ int cadence_nand_attach_chip(struct nand
 	chip->options |= NAND_NO_SUBPAGE_WRITE;
 
 	cdns_chip->bbm_offs = chip->badblockpos;
-	if (chip->options & NAND_BUSWIDTH_16) {
-		cdns_chip->bbm_offs &= ~0x01;
-		cdns_chip->bbm_len = 2;
-	} else {
-		cdns_chip->bbm_len = 1;
-	}
+	cdns_chip->bbm_offs &= ~0x01;
+	/* this value should be even number */
+	cdns_chip->bbm_len = 2;
 
 	ret = nand_ecc_choose_conf(chip,
 				   &cdns_ctrl->ecc_caps,


