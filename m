Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3BE1B3D8F
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:16:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729746AbgDVKQJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:16:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728991AbgDVKQE (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:16:04 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 522BB2076B;
        Wed, 22 Apr 2020 10:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550563;
        bh=rN77u9di2Y6qyoYMJ8b4n4AnqILjg7jKJJKhKYC1iLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2rn+xSbYk4pWcp8KtlQ4gibHETiMDBR0YyXzCZgpefy9Sy1SVg7Pv1RNujQDCCGUL
         0OVPrXo/BVvS0RGJhM/GguKa2Qpm+yn2UPtfGsm3h5nKVkRsUbwueCGiRGnBpOYR2K
         mvTDFDqrNMHWKqqB4mQXwt99T0jZy0MnG/9/hhIE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 60/64] mtd: spinand: Explicitly use MTD_OPS_RAW to write the bad block marker to OOB
Date:   Wed, 22 Apr 2020 11:57:44 +0200
Message-Id: <20200422095024.043028142@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095008.799686511@linuxfoundation.org>
References: <20200422095008.799686511@linuxfoundation.org>
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
@@ -670,6 +670,7 @@ static int spinand_markbad(struct nand_d
 		.ooboffs = 0,
 		.ooblen = sizeof(marker),
 		.oobbuf.out = marker,
+		.mode = MTD_OPS_RAW,
 	};
 	int ret;
 


