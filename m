Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AE3F106E7D
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:09:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730756AbfKVLJJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 06:09:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:57664 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729219AbfKVLD2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 06:03:28 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D0C29207DD;
        Fri, 22 Nov 2019 11:03:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420608;
        bh=RCjXUI6866u57JwmTNcRqya4SFDlPhHwx59HYYacEfk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NUhJtTl9a52yMDZgjTT/qXT2I+HxlbQJYJHJcMi13MeHY1GZ76emTjXRa+WssYTM9
         UC8OHV+KhUBNoaAFeuq3vtr07Xfqw47DovT5zQRyppyDIx9cPG+uBgn64VbyYRreJq
         qVZj2BKZAksvVbFbVQkpnDQiX0m1dvkyc/Z0vDWc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yogesh Gaur <yogeshnarayan.gaur@nxp.com>,
        Boris Brezillon <boris.brezillon@bootlin.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 163/220] mtd: devices: m25p80: Make sure WRITE_EN is issued before each write
Date:   Fri, 22 Nov 2019 11:28:48 +0100
Message-Id: <20191122100924.480680302@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yogesh Gaur <yogeshnarayan.gaur@nxp.com>

[ Upstream commit 3baa8ec88c2feb902328e59a4dcf0f0aaab7d2ff ]

Some SPI controllers can't write nor->page_size bytes in a single step
because their TX FIFO is too small, but when that happens we should
make sure a WRITE_EN command before each write access and READ_SR command
after each write access is issued.

The core is already taking care of that, so all we have to do here is
return the actual number of bytes that were written during the
spi_mem_exec_op() operation.

Signed-off-by: Yogesh Gaur <yogeshnarayan.gaur@nxp.com>
Signed-off-by: Boris Brezillon <boris.brezillon@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/devices/m25p80.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/mtd/devices/m25p80.c b/drivers/mtd/devices/m25p80.c
index 270d3c9580c51..c4a1d04b8c800 100644
--- a/drivers/mtd/devices/m25p80.c
+++ b/drivers/mtd/devices/m25p80.c
@@ -90,7 +90,6 @@ static ssize_t m25p80_write(struct spi_nor *nor, loff_t to, size_t len,
 				   SPI_MEM_OP_ADDR(nor->addr_width, to, 1),
 				   SPI_MEM_OP_NO_DUMMY,
 				   SPI_MEM_OP_DATA_OUT(len, buf, 1));
-	size_t remaining = len;
 	int ret;
 
 	/* get transfer protocols. */
@@ -101,22 +100,16 @@ static ssize_t m25p80_write(struct spi_nor *nor, loff_t to, size_t len,
 	if (nor->program_opcode == SPINOR_OP_AAI_WP && nor->sst_write_second)
 		op.addr.nbytes = 0;
 
-	while (remaining) {
-		op.data.nbytes = remaining < UINT_MAX ? remaining : UINT_MAX;
-		ret = spi_mem_adjust_op_size(flash->spimem, &op);
-		if (ret)
-			return ret;
-
-		ret = spi_mem_exec_op(flash->spimem, &op);
-		if (ret)
-			return ret;
+	ret = spi_mem_adjust_op_size(flash->spimem, &op);
+	if (ret)
+		return ret;
+	op.data.nbytes = len < op.data.nbytes ? len : op.data.nbytes;
 
-		op.addr.val += op.data.nbytes;
-		remaining -= op.data.nbytes;
-		op.data.buf.out += op.data.nbytes;
-	}
+	ret = spi_mem_exec_op(flash->spimem, &op);
+	if (ret)
+		return ret;
 
-	return len;
+	return op.data.nbytes;
 }
 
 /*
-- 
2.20.1



