Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 566DA3C55A6
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232658AbhGLIL2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:55108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353841AbhGLIDC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:03:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 826CE61D0B;
        Mon, 12 Jul 2021 07:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076666;
        bh=KPHrZ9ww3lJkGpMednQHili0mbC2nigYJEPPavNzF8M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EktdVFLK8PMmDYI5KZalVKoI0YzQ7wKGg1Tr9uv0ppBSdMgjOo1k/hjNp5iqiPvIW
         p8I6SToOIoh6cKpcskrZo04m6L4JswKTlxBX7iH9Id5N/9VcpwSQp2wWhXe97VoIyd
         6Cq2ovvNtpX5j5fv+ACOikoRJWH1uvyLwwsgIOxQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 704/800] mtd: spi-nor: otp: return -EROFS if region is read-only
Date:   Mon, 12 Jul 2021 08:12:07 +0200
Message-Id: <20210712061041.672900696@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michael Walle <michael@walle.cc>

[ Upstream commit 388161ca45c911f566b71716bce5ff0119fb5522 ]

SPI NOR flashes will just ignore program commands if the OTP region is
locked. Thus, a user might not notice that the intended write didn't end
up in the flash. Return -EROFS to the user in this case. From what I can
tell, chips/cfi_cmdset_0001.c also return this error code.

One could optimize spi_nor_mtd_otp_range_is_locked() to read the status
register only once and not for every OTP region, but for that we would
need some more invasive changes. Given that this is
one-time-programmable memory and the normal access mode is reading, we
just live with the small overhead.

By moving the code around a bit, we can just check the length before
calling spi_nor_mtd_otp_range_is_locked() and avoid an underflow there
if a len is 0. This way we don't need to take the lock either. We also
skip the "*retlen = 0" assignment, mtdcore already takes care of that
for us.

Fixes: 069089acf88b ("mtd: spi-nor: add OTP support")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/otp.c | 41 ++++++++++++++++++++++++++++++++++++---
 1 file changed, 38 insertions(+), 3 deletions(-)

diff --git a/drivers/mtd/spi-nor/otp.c b/drivers/mtd/spi-nor/otp.c
index 5c51a2c9be61..d8e68120a4b1 100644
--- a/drivers/mtd/spi-nor/otp.c
+++ b/drivers/mtd/spi-nor/otp.c
@@ -238,6 +238,29 @@ out:
 	return ret;
 }
 
+static int spi_nor_mtd_otp_range_is_locked(struct spi_nor *nor, loff_t ofs,
+					   size_t len)
+{
+	const struct spi_nor_otp_ops *ops = nor->params->otp.ops;
+	unsigned int region;
+	int locked;
+
+	/*
+	 * If any of the affected OTP regions are locked the entire range is
+	 * considered locked.
+	 */
+	for (region = spi_nor_otp_offset_to_region(nor, ofs);
+	     region <= spi_nor_otp_offset_to_region(nor, ofs + len - 1);
+	     region++) {
+		locked = ops->is_locked(nor, region);
+		/* take the branch it is locked or in case of an error */
+		if (locked)
+			return locked;
+	}
+
+	return 0;
+}
+
 static int spi_nor_mtd_otp_read_write(struct mtd_info *mtd, loff_t ofs,
 				      size_t total_len, size_t *retlen,
 				      const u8 *buf, bool is_write)
@@ -253,14 +276,26 @@ static int spi_nor_mtd_otp_read_write(struct mtd_info *mtd, loff_t ofs,
 	if (ofs < 0 || ofs >= spi_nor_otp_size(nor))
 		return 0;
 
+	/* don't access beyond the end */
+	total_len = min_t(size_t, total_len, spi_nor_otp_size(nor) - ofs);
+
+	if (!total_len)
+		return 0;
+
 	ret = spi_nor_lock_and_prep(nor);
 	if (ret)
 		return ret;
 
-	/* don't access beyond the end */
-	total_len = min_t(size_t, total_len, spi_nor_otp_size(nor) - ofs);
+	if (is_write) {
+		ret = spi_nor_mtd_otp_range_is_locked(nor, ofs, total_len);
+		if (ret < 0) {
+			goto out;
+		} else if (ret) {
+			ret = -EROFS;
+			goto out;
+		}
+	}
 
-	*retlen = 0;
 	while (total_len) {
 		/*
 		 * The OTP regions are mapped into a contiguous area starting
-- 
2.30.2



