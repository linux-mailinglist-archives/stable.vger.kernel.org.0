Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06D5F1B3E76
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:28:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730922AbgDVK2k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:28:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:36806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730456AbgDVK1j (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:27:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9C66A2071E;
        Wed, 22 Apr 2020 10:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587551259;
        bh=z8g8OdfadhKw32Sk4wBRsKxWdO7/BnY8Qy81U8Uxue4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEQ7+2p2ETXBY7zdvAyarxhNGiFHeLAtQG6rkbkFlwJdNX/xwXHm9jaRx774AalP0
         7NTX4FFFDPs4m+WJ8y08gHqK64Nz2Kl84/vnfEatjhSQVoz66D7PDJU+Ah/A7U/lO/
         NFbnDS126CHRbGvjUPiZ5Lx0SvHKrPo6EjZTynlI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.6 158/166] mtd: spinand: Explicitly use MTD_OPS_RAW to write the bad block marker to OOB
Date:   Wed, 22 Apr 2020 11:58:05 +0200
Message-Id: <20200422095105.394799716@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Frieder Schrempf <frieder.schrempf@kontron.de>

commit 621a7b780bd8b7054647d53d5071961f2c9e0873 upstream.

When writing the bad block marker to the OOB area the access mode
should be set to MTD_OPS_RAW as it is done for reading the marker.
Currently this only works because req.mode is initialized to
MTD_OPS_PLACE_OOB (0) and spinand_write_to_cache_op() checks for
req.mode != MTD_OPS_AUTO_OOB.

Fix this by explicitly setting req.mode to MTD_OPS_RAW.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Signed-off-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20200218100432.32433-3-frieder.schrempf@kontron.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/spi/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -609,6 +609,7 @@ static int spinand_markbad(struct nand_d
 		.ooboffs = 0,
 		.ooblen = sizeof(marker),
 		.oobbuf.out = marker,
+		.mode = MTD_OPS_RAW,
 	};
 	int ret;
 


