Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 296D21AC8E5
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:17:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2395035AbgDPPQK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:16:10 -0400
Received: from mail.kernel.org ([198.145.29.99]:35836 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441622AbgDPNuC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:50:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4809721927;
        Thu, 16 Apr 2020 13:49:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587044972;
        bh=shd0LP0Bg8wGz6s3YwEhALAbANLNDLZwnav84oEtfjo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P1fUF88whAGy5wp6zMpfCTe5D6FcZovIUws5LM1ZmwusnBVVedGX2ZKohZK4R2N+o
         Eoy5kuWZdpjfxhKXmUOfRJbTTwS16UueuKjmkmSEykdhABxqrMnFP8qUVREHSaS6di
         VTgnUfbUQ+RWKCdSQ8ouUuL1H/jipOwxnRtqiWAc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 136/232] mtd: spinand: Do not erase the block before writing a bad block marker
Date:   Thu, 16 Apr 2020 15:23:50 +0200
Message-Id: <20200416131331.970575378@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit b645ad39d56846618704e463b24bb994c9585c7f upstream.

Currently when marking a block, we use spinand_erase_op() to erase
the block before writing the marker to the OOB area. Doing so without
waiting for the operation to finish can lead to the marking failing
silently and no bad block marker being written to the flash.

In fact we don't need to do an erase at all before writing the BBM.
The ECC is disabled for raw accesses to the OOB data and we don't
need to work around any issues with chips reporting ECC errors as it
is known to be the case for raw NAND.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200218100432.32433-4-frieder.schrempf@kontron.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/spi/core.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -612,7 +612,6 @@ static int spinand_markbad(struct nand_d
 	};
 	int ret;
 
-	/* Erase block before marking it bad. */
 	ret = spinand_select_target(spinand, pos->target);
 	if (ret)
 		return ret;
@@ -621,8 +620,6 @@ static int spinand_markbad(struct nand_d
 	if (ret)
 		return ret;
 
-	spinand_erase_op(spinand, pos);
-
 	return spinand_write_page(spinand, &req);
 }
 


