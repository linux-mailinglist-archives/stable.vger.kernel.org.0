Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 557683599E4
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232087AbhDIJyk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:54:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:42026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231127AbhDIJyk (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:54:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0853B6115C;
        Fri,  9 Apr 2021 09:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962067;
        bh=2eiwOaLlAuhRoMnmZ4CyBWhZz2Xv2fBc6KriTPESZl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CZMG1G9aC/J35EQK4Rb+EElst1VnrgB1LolRW5BCI4dpqG+vUSCmvrbMt+md5bPiq
         6uCrCT00L03un2d+39E3zKSRkCrQ/Q7zy9M5iruvM7ajYcEaIoeWyy1JtHCo2d7b8Z
         xLcWy9deG04ytJmGSwr8TkpzESmeMNoiE+RLW/8s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 10/20] mtd: rawnand: tmio: Fix the probe error path
Date:   Fri,  9 Apr 2021 11:53:16 +0200
Message-Id: <20210409095300.274884239@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210409095259.957388690@linuxfoundation.org>
References: <20210409095259.957388690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 75e9a330a9bd48f97a55a08000236084fe3dae56 upstream

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no real Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense even if this commit is not
introducing any bug.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-57-miquel.raynal@bootlin.com
[sudip: manual backport to old file]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/tmio_nand.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/tmio_nand.c
+++ b/drivers/mtd/nand/tmio_nand.c
@@ -445,7 +445,7 @@ static int tmio_probe(struct platform_de
 	if (!retval)
 		return retval;
 
-	nand_release(mtd);
+	nand_cleanup(nand_chip);
 
 err_irq:
 	tmio_hw_stop(dev, tmio);


