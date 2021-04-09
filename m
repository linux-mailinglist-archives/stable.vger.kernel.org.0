Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B29CC3599E8
	for <lists+stable@lfdr.de>; Fri,  9 Apr 2021 11:54:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232796AbhDIJyq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 9 Apr 2021 05:54:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:42178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232813AbhDIJyp (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 9 Apr 2021 05:54:45 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0DE76115B;
        Fri,  9 Apr 2021 09:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617962072;
        bh=1hcmPV7M7pj+OmYX4U8CBCcpTLcE8MXBAC5Zii/IDIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vej9WMZ0h8PxIdNDU0KpreZJ3pdYplW9Ru/B4pxv/5CtH0KMIepkGOXdwF8PI42mE
         Z5VSaBV2kA45Uo0qv2RypqJj8MZGuI18SPgfD+GrqHDe1eGzxkuuB00St3xcHs+n/U
         +45zGAz5X4mothCK3ZPMIV9rmsocjx9wNyuoXnoQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Subject: [PATCH 4.4 12/20] mtd: rawnand: sharpsl: Fix the probe error path
Date:   Fri,  9 Apr 2021 11:53:18 +0200
Message-Id: <20210409095300.346284263@linuxfoundation.org>
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

commit 0f44b3275b3798ccb97a2f51ac85871c30d6fbbc upstream

nand_release() is supposed be called after MTD device registration.
Here, only nand_scan() happened, so use nand_cleanup() instead.

There is no Fixes tag applying here as the use of nand_release()
in this driver predates by far the introduction of nand_cleanup() in
commit d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
which makes this change possible. However, pointing this commit as the
culprit for backporting purposes makes sense.

Fixes: d44154f969a4 ("mtd: nand: Provide nand_cleanup() function to free NAND related resources")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-mtd/20200519130035.1883-49-miquel.raynal@bootlin.com
[sudip: manual backport to old file]
Signed-off-by: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/sharpsl.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/sharpsl.c
+++ b/drivers/mtd/nand/sharpsl.c
@@ -189,7 +189,7 @@ static int sharpsl_nand_probe(struct pla
 	return 0;
 
 err_add:
-	nand_release(&sharpsl->mtd);
+	nand_cleanup(this);
 
 err_scan:
 	iounmap(sharpsl->io);


