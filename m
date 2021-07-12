Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A47F3C5595
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:55:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231795AbhGLILG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:11:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:56556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1353749AbhGLICu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:02:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0272F61D09;
        Mon, 12 Jul 2021 07:57:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626076640;
        bh=/B1RIRLSt4RjsDEo3xrgyfXm9+IGRlzknx9Yfryjoyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TNxgnsfNiYUd3uj4Fcmiok0EqxieodPtYXR3eJbTuZsoLDBlwWC/qTv4fX6SNfAge
         coSzNUmqUNMqDzuh9LKIVPuwXFdWmZ5MPH3DoqWmT6nYlm3c5WGkwOQwTFKE9pc8Oz
         s/OA50QYQsZSyC4+tGd+7Qdlo8A/KkmQTmfZyqVQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Michael Walle <michael@walle.cc>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 703/800] mtd: spi-nor: otp: fix access to security registers in 4 byte mode
Date:   Mon, 12 Jul 2021 08:12:06 +0200
Message-Id: <20210712061041.571554128@linuxfoundation.org>
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

[ Upstream commit b97b1a769849beb6b40b740817b06f1a50e1c589 ]

The security registers either take a 3 byte or a 4 byte address offset,
depending on the address mode of the flash. Thus just leave the
nor->addr_width as is.

Fixes: cad3193fe9d1 ("mtd: spi-nor: implement OTP support for Winbond and similar flashes")
Signed-off-by: Michael Walle <michael@walle.cc>
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Pratyush Yadav <p.yadav@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/otp.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/mtd/spi-nor/otp.c b/drivers/mtd/spi-nor/otp.c
index fcf38d260345..5c51a2c9be61 100644
--- a/drivers/mtd/spi-nor/otp.c
+++ b/drivers/mtd/spi-nor/otp.c
@@ -40,7 +40,6 @@ int spi_nor_otp_read_secr(struct spi_nor *nor, loff_t addr, size_t len, u8 *buf)
 	rdesc = nor->dirmap.rdesc;
 
 	nor->read_opcode = SPINOR_OP_RSECR;
-	nor->addr_width = 3;
 	nor->read_dummy = 8;
 	nor->read_proto = SNOR_PROTO_1_1_1;
 	nor->dirmap.rdesc = NULL;
@@ -84,7 +83,6 @@ int spi_nor_otp_write_secr(struct spi_nor *nor, loff_t addr, size_t len,
 	wdesc = nor->dirmap.wdesc;
 
 	nor->program_opcode = SPINOR_OP_PSECR;
-	nor->addr_width = 3;
 	nor->write_proto = SNOR_PROTO_1_1_1;
 	nor->dirmap.wdesc = NULL;
 
-- 
2.30.2



