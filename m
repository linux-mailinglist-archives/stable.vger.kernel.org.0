Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40C102E64EE
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:55:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390299AbgL1Ngq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:36:46 -0500
Received: from mail.kernel.org ([198.145.29.99]:36744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390757AbgL1Ngp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:36:45 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B5B0B208B3;
        Mon, 28 Dec 2020 13:36:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162590;
        bh=L9b+n1hCMZtqDIVFQ/pZDCvENED2Cxb2QKO1Mlgv+Gs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JGEW5unHfLPVB89ad7KOkA5hKq1QvXCxwk/I6p1rwS006iFxMUOmPeykCikJRKIsV
         BLGJJ5YKAA2unY7e2edvw7ljmQyjbsAxWU7PK4Jc/mj+DFU66y7urc+fhs0yCf3jGO
         nK42Vv8W39GpQOOnE20FT2gCqGRi+YgCML/RuyBE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 4.19 323/346] mtd: spinand: Fix OOB read
Date:   Mon, 28 Dec 2020 13:50:42 +0100
Message-Id: <20201228124935.397724080@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 868cbe2a6dcee451bd8f87cbbb2a73cf463b57e5 upstream.

So far OOB have never been used in SPI-NAND, add the missing memcpy to
make it work properly.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20201001102014.20100-6-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/spi/core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -378,6 +378,10 @@ static int spinand_write_to_cache_op(str
 		}
 	}
 
+	if (req->ooblen)
+		memcpy(req->oobbuf.in, spinand->oobbuf + req->ooboffs,
+		       req->ooblen);
+
 	return 0;
 }
 


