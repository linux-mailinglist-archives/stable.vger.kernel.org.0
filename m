Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 46B2E2010DF
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:36:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391574AbgFSPfS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:35:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:35862 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404878AbgFSPbt (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:31:49 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 215BD20734;
        Fri, 19 Jun 2020 15:31:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580708;
        bh=KGIYyD5rD/ejMxLwxaiYeAQS/wlR+d0LwFY6X29p1oE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G1DxCpK/0/TCURlQj/9ixw9WaXpzGjEW8SwP7as/RV36/fh9TJBntlxf3ucAZ+b7x
         eEYX7mb8YiPuZc/Mwm9lgOAWNH/CEM2U6ByTDu0YG6+HzkVtb8AyQNgsO/QQPKD+US
         SjgO+Xe+HH4uEkcIcoggZ2WvF8DxInVJcurYEm3o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miquel Raynal <miquel.raynal@bootlin.com>,
        Boris Brezillon <boris.brezillon@collabora.com>
Subject: [PATCH 5.7 353/376] mtd: rawnand: onfi: Fix redundancy detection check
Date:   Fri, 19 Jun 2020 16:34:31 +0200
Message-Id: <20200619141727.029919949@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 1d5d08ee9b28cff907326b4ad5a2463fd2808be1 upstream.

During ONFI detection, the CRC derived from the parameter page and the
CRC supposed to be at the end of the parameter page are compared. If
they do not match, the second then the third copies of the page are
tried.

The current implementation compares the newly derived CRC with the CRC
contained in the first page only. So if this particular CRC area has
been corrupted, then the detection will fail for a wrong reason.

Fix this issue by checking the derived CRC against the right one.

Fixes: 39138c1f4a31 ("mtd: rawnand: use bit-wise majority to recover the ONFI param page")
Cc: stable@vger.kernel.org
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Link: https://lore.kernel.org/linux-mtd/20200428094302.14624-4-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/nand_onfi.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/nand/raw/nand_onfi.c
+++ b/drivers/mtd/nand/raw/nand_onfi.c
@@ -173,7 +173,7 @@ int nand_onfi_detect(struct nand_chip *c
 		}
 
 		if (onfi_crc16(ONFI_CRC_BASE, (u8 *)&p[i], 254) ==
-				le16_to_cpu(p->crc)) {
+		    le16_to_cpu(p[i].crc)) {
 			if (i)
 				memcpy(p, &p[i], sizeof(*p));
 			break;


