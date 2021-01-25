Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 04CCA304AE6
	for <lists+stable@lfdr.de>; Tue, 26 Jan 2021 22:04:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729063AbhAZEys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Jan 2021 23:54:48 -0500
Received: from mail.kernel.org ([198.145.29.99]:35490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730623AbhAYSsU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 25 Jan 2021 13:48:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9A5E22063A;
        Mon, 25 Jan 2021 18:47:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611600458;
        bh=SWdUp8m48Ssve6TgiEByGDU9cHwY12YeKlAIdamLr/I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rhFfNd6PygHiLakCP/GfZt61mARbXC4Uv4WCKvb3s9gZ7+uxU58v8JwpHP+03z49P
         1zKYr5zYPB6My4T3gQ+nZLpRrRV6OyCJtSmEAvcHgHxTFQbgZ9CzxORj82W1zRLNKc
         OukpIWtKS8xF9ztKNf2gDuPvkgCgLGAYQYIqLPHo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, kernel test robot <oliver.sang@intel.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.10 003/199] mtd: rawnand: nandsim: Fix the logic when selecting Hamming soft ECC engine
Date:   Mon, 25 Jan 2021 19:37:05 +0100
Message-Id: <20210125183216.397456757@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210125183216.245315437@linuxfoundation.org>
References: <20210125183216.245315437@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 3c97be6982e689d7b2430187a11f8c78e573abdb upstream.

I have been fooled by the logic picking the right ECC engine which is
spread across two functions: *init_module() and *_attach(). I thought
this driver was not impacted by the recent changes around the ECC
engines DT parsing logic but in fact it is.

Reported-by: kernel test robot <oliver.sang@intel.com>
Fixes: d7157ff49a5b ("mtd: rawnand: Use the ECC framework user input parsing bits")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210104093057.31178-1-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/nandsim.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/mtd/nand/raw/nandsim.c
+++ b/drivers/mtd/nand/raw/nandsim.c
@@ -2211,6 +2211,9 @@ static int ns_attach_chip(struct nand_ch
 {
 	unsigned int eccsteps, eccbytes;
 
+	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
+	chip->ecc.algo = bch ? NAND_ECC_ALGO_BCH : NAND_ECC_ALGO_HAMMING;
+
 	if (!bch)
 		return 0;
 
@@ -2234,8 +2237,6 @@ static int ns_attach_chip(struct nand_ch
 		return -EINVAL;
 	}
 
-	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
-	chip->ecc.algo = NAND_ECC_ALGO_BCH;
 	chip->ecc.size = 512;
 	chip->ecc.strength = bch;
 	chip->ecc.bytes = eccbytes;
@@ -2274,8 +2275,6 @@ static int __init ns_init_module(void)
 	nsmtd       = nand_to_mtd(chip);
 	nand_set_controller_data(chip, (void *)ns);
 
-	chip->ecc.engine_type = NAND_ECC_ENGINE_TYPE_SOFT;
-	chip->ecc.algo   = NAND_ECC_ALGO_HAMMING;
 	/* The NAND_SKIP_BBTSCAN option is necessary for 'overridesize' */
 	/* and 'badblocks' parameters to work */
 	chip->options   |= NAND_SKIP_BBTSCAN;


