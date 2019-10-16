Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 579E5D9E91
	for <lists+stable@lfdr.de>; Thu, 17 Oct 2019 00:04:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2438603AbfJPV7m (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 16 Oct 2019 17:59:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54776 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732431AbfJPV7m (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 16 Oct 2019 17:59:42 -0400
Received: from localhost (unknown [192.55.54.58])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 62B0C21D7A;
        Wed, 16 Oct 2019 21:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571263181;
        bh=3lrQe4z5hzvnlvvJeQs1bswWpYlhTIQI5HZNYEmx3bA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=znxnjtxnMqV5Gh1Yjy82JeOqEG7hrUU4fwQqWv9KNltQh259TIY1d+MjvHzLowmLL
         uMBcfb/mgano8YFHVaUqy6Py/PGT34MP5PtN6FIZv7/rKA5JCGnb0QhkmbgbKl17GO
         MJnbGGkY4LGhJk4+fpeLAhbpDjISh854PeOgp7Vg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Paul Burton <paul.burton@mips.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.3 108/112] mtd: rawnand: au1550nd: Fix au_read_buf16() prototype
Date:   Wed, 16 Oct 2019 14:51:40 -0700
Message-Id: <20191016214907.273789010@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191016214844.038848564@linuxfoundation.org>
References: <20191016214844.038848564@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul Burton <paul.burton@mips.com>

commit df8fed831cbcdce7b283b2d9c1aadadcf8940d05 upstream.

Commit 7e534323c416 ("mtd: rawnand: Pass a nand_chip object to
chip->read_xxx() hooks") modified the prototype of the struct nand_chip
read_buf function pointer. In the au1550nd driver we have 2
implementations of read_buf. The previously mentioned commit modified
the au_read_buf() implementation to match the function pointer, but not
au_read_buf16(). This results in a compiler warning for MIPS
db1xxx_defconfig builds:

  drivers/mtd/nand/raw/au1550nd.c:443:57:
    warning: pointer type mismatch in conditional expression

Fix this by updating the prototype of au_read_buf16() to take a struct
nand_chip pointer as its first argument, as is expected after commit
7e534323c416 ("mtd: rawnand: Pass a nand_chip object to chip->read_xxx()
hooks").

Note that this shouldn't have caused any functional issues at runtime,
since the offset of the struct mtd_info within struct nand_chip is 0
making mtd_to_nand() effectively a type-cast.

Signed-off-by: Paul Burton <paul.burton@mips.com>
Fixes: 7e534323c416 ("mtd: rawnand: Pass a nand_chip object to chip->read_xxx() hooks")
Cc: stable@vger.kernel.org # v4.20+
Reviewed-by: Boris Brezillon <boris.brezillon@collabora.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/nand/raw/au1550nd.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/au1550nd.c
+++ b/drivers/mtd/nand/raw/au1550nd.c
@@ -134,16 +134,15 @@ static void au_write_buf16(struct nand_c
 
 /**
  * au_read_buf16 -  read chip data into buffer
- * @mtd:	MTD device structure
+ * @this:	NAND chip object
  * @buf:	buffer to store date
  * @len:	number of bytes to read
  *
  * read function for 16bit buswidth
  */
-static void au_read_buf16(struct mtd_info *mtd, u_char *buf, int len)
+static void au_read_buf16(struct nand_chip *this, u_char *buf, int len)
 {
 	int i;
-	struct nand_chip *this = mtd_to_nand(mtd);
 	u16 *p = (u16 *) buf;
 	len >>= 1;
 


