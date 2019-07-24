Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99D8473B78
	for <lists+stable@lfdr.de>; Wed, 24 Jul 2019 22:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405203AbfGXUAT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Jul 2019 16:00:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:48274 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405214AbfGXUAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Jul 2019 16:00:18 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 513AD20665;
        Wed, 24 Jul 2019 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563998417;
        bh=D9Xy9ELjVkCMMIaEPWXKuGZXGNIfDbXEWHcUZVfISjI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v3b1V2eIMnN4J6wrMxnzARIYEUy9QM1ZKIkIR0UL9kYK4yaYm3kiGotCaa899FvJh
         8z76riT7VWdUw0evs1I5NxxSdcyPWwd7+qAW2OIEwJlVYbrcZHvJA+ogR+zA2jEUXB
         WFAYNCG+cE0JX6wKroNczfpwk2bUhfjQKdaIQJ6w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Weixiong Liao <liaoweixiong@allwinnertech.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Frieder Schrempf <frieder.schrempf@kontron.de>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.1 359/371] mtd: spinand: read returns badly if the last page has bitflips
Date:   Wed, 24 Jul 2019 21:21:51 +0200
Message-Id: <20190724191751.089513441@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190724191724.382593077@linuxfoundation.org>
References: <20190724191724.382593077@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: liaoweixiong <liaoweixiong@allwinnertech.com>

commit b83408b580eccf8d2797cd6cb9ae42c2a28656a7 upstream.

In case of the last page containing bitflips (ret > 0),
spinand_mtd_read() will return that number of bitflips for the last
page while it should instead return max_bitflips like it does when the
last page read returns with 0.

Signed-off-by: Weixiong Liao <liaoweixiong@allwinnertech.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Reviewed-by: Frieder Schrempf <frieder.schrempf@kontron.de>
Cc: stable@vger.kernel.org
Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/spi/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -572,12 +572,12 @@ static int spinand_mtd_read(struct mtd_i
 		if (ret == -EBADMSG) {
 			ecc_failed = true;
 			mtd->ecc_stats.failed++;
-			ret = 0;
 		} else {
 			mtd->ecc_stats.corrected += ret;
 			max_bitflips = max_t(unsigned int, max_bitflips, ret);
 		}
 
+		ret = 0;
 		ops->retlen += iter.req.datalen;
 		ops->oobretlen += iter.req.ooblen;
 	}


