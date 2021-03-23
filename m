Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6A90346685
	for <lists+stable@lfdr.de>; Tue, 23 Mar 2021 18:38:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbhCWRhg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Mar 2021 13:37:36 -0400
Received: from mail-40136.protonmail.ch ([185.70.40.136]:62116 "EHLO
        mail-40136.protonmail.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230310AbhCWRh1 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Mar 2021 13:37:27 -0400
Date:   Tue, 23 Mar 2021 17:37:19 +0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pm.me; s=protonmail;
        t=1616521045; bh=B76jZ93shqjUOUQEXOsghNFmKmbiN4UEo8ixi177UoA=;
        h=Date:To:From:Cc:Reply-To:Subject:From;
        b=XygTCk2L+LU5D4FsgMrA/7EH7eqjNqqfnnAceMgTGvAvic+o8zNuuiUHbrrl05uEZ
         VgG/kaqtVhJkyScYcgjmkuXv0QX4x8LUHro1MoZMUMV0X7Eaav8TzU/6e6bLGi5gAR
         eNxGVUDiSJsAneAjka7gPkqztAdxGAXTmdFKEwbmsno8dsmsLaYO4OotH0/SvP4yis
         H8ftHLGMQH40O8P88PNF0wVbD7vlYFTZMwMrvv1/Gm8mc6v4GuSYKIHoRsKfd33P3x
         +LGxwD11CWjLiLCJvZ+4e1S/cjqlvzHRIL8f/6WlqU4SriImQnwPEDSC3HYj7cLxFm
         rDFO73qqbWPCw==
To:     Miquel Raynal <miquel.raynal@bootlin.com>
From:   Alexander Lobakin <alobakin@pm.me>
Cc:     Richard Weinberger <richard@nod.at>,
        Vignesh Raghavendra <vigneshr@ti.com>,
        Boris Brezillon <boris.brezillon@collabora.com>,
        Alexander Lobakin <alobakin@pm.me>,
        linux-mtd@lists.infradead.org, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org
Reply-To: Alexander Lobakin <alobakin@pm.me>
Subject: [PATCH v2 mtd/fixes] mtd: spinand: core: add missing MODULE_DEVICE_TABLE()
Message-ID: <20210323173714.317884-1-alobakin@pm.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.2 required=10.0 tests=ALL_TRUSTED,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF shortcircuit=no
        autolearn=disabled version=3.4.4
X-Spam-Checker-Version: SpamAssassin 3.4.4 (2020-01-24) on
        mailout.protonmail.ch
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The module misses MODULE_DEVICE_TABLE() for both SPI and OF ID tables
and thus never autoloads on ID matches.
Add the missing declarations.
Present since day-0 of spinand framework introduction.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NAN=
Ds")
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
---
 drivers/mtd/nand/spi/core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/nand/spi/core.c b/drivers/mtd/nand/spi/core.c
index 61d932c1b718..17f63f95f4a2 100644
--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1263,12 +1263,14 @@ static const struct spi_device_id spinand_ids[] =3D=
 {
 =09{ .name =3D "spi-nand" },
 =09{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(spi, spinand_ids);

 #ifdef CONFIG_OF
 static const struct of_device_id spinand_of_ids[] =3D {
 =09{ .compatible =3D "spi-nand" },
 =09{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, spinand_of_ids);
 #endif

 static struct spi_mem_driver spinand_drv =3D {
--
2.31.0


