Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E7623200F5A
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:22:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392207AbgFSPQi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:16:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:47248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391927AbgFSPQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:16:37 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EFA9721582;
        Fri, 19 Jun 2020 15:16:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592579796;
        bh=8s7unfe+GuuuqKiQwBF2A355/C9ArBFhCefUl/pMFy0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UOcZCRrlc6VDgAx/ezph/z8AXzBZmxpZIi+gkeT+2un/nRU8zBtgvyqVJfK9lO1V+
         KOfUa2RXowVWXhwUttvPFxrZ/Nywg7q6Q7Y4XAkL1H5C1E2M5+pmUTk0M3aqWXznLF
         iprSZV0zZBqhQbcMERmHC/YewsF4ZbttdFZj6Tyc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 252/261] mtd: rawnand: pasemi: Fix the probe error path
Date:   Fri, 19 Jun 2020 16:34:23 +0200
Message-Id: <20200619141701.951193560@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141649.878808811@linuxfoundation.org>
References: <20200619141649.878808811@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit f51466901c07e6930435d30b02a21f0841174f61 upstream.

nand_cleanup() is supposed to be called on error after a successful
call to nand_scan() to free all NAND resources.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible, hence pointing it as the commit to
fix for backporting purposes, even if this commit is not introducing
any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-41-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/pasemi_nand.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/pasemi_nand.c
+++ b/drivers/mtd/nand/raw/pasemi_nand.c
@@ -146,7 +146,7 @@ static int pasemi_nand_probe(struct plat
 	if (mtd_device_register(pasemi_nand_mtd, NULL, 0)) {
 		dev_err(dev, "Unable to register MTD device\n");
 		err = -ENODEV;
-		goto out_lpc;
+		goto out_cleanup_nand;
 	}
 
 	dev_info(dev, "PA Semi NAND flash at %pR, control at I/O %x\n", &res,
@@ -154,6 +154,8 @@ static int pasemi_nand_probe(struct plat
 
 	return 0;
 
+ out_cleanup_nand:
+	nand_cleanup(chip);
  out_lpc:
 	release_region(lpcctl, 4);
  out_ior:


