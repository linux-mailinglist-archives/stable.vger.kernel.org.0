Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 710B437872A
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbhEJLOO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:14:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:45204 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236120AbhEJLHi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:07:38 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2C52D6192B;
        Mon, 10 May 2021 10:58:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644303;
        bh=cuoSuEF7QQQP50SnRr8fVZGAFuy6hJxGAwVgruYM05w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=06kYKuT5Hmq8Xj3ku04L2xFmjkXpUU2UhIp/Wm6vbiN3H/jqvrLYBmYwtQPZjnZAu
         yOnblmBt4ezNO4DW10wzir2VYRY+mJu68IG9Ezdwuiz0n6706hJiz7DIJH+iSqKSIL
         uI6JNdc3n0PtOU8QhRcunJOD8o5wNcVSHRInfIV0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Alexander Lobakin <alobakin@pm.me>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.12 027/384] mtd: spinand: core: add missing MODULE_DEVICE_TABLE()
Date:   Mon, 10 May 2021 12:16:56 +0200
Message-Id: <20210510102015.763183709@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexander Lobakin <alobakin@pm.me>

commit 25fefc88c71f47db0466570335e3f75f10952e7a upstream.

The module misses MODULE_DEVICE_TABLE() for both SPI and OF ID tables
and thus never autoloads on ID matches.
Add the missing declarations.
Present since day-0 of spinand framework introduction.

Fixes: 7529df465248 ("mtd: nand: Add core infrastructure to support SPI NANDs")
Cc: stable@vger.kernel.org # 4.19+
Signed-off-by: Alexander Lobakin <alobakin@pm.me>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20210323173714.317884-1-alobakin@pm.me
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/spi/core.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/mtd/nand/spi/core.c
+++ b/drivers/mtd/nand/spi/core.c
@@ -1263,12 +1263,14 @@ static const struct spi_device_id spinan
 	{ .name = "spi-nand" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(spi, spinand_ids);
 
 #ifdef CONFIG_OF
 static const struct of_device_id spinand_of_ids[] = {
 	{ .compatible = "spi-nand" },
 	{ /* sentinel */ },
 };
+MODULE_DEVICE_TABLE(of, spinand_of_ids);
 #endif
 
 static struct spi_mem_driver spinand_drv = {


