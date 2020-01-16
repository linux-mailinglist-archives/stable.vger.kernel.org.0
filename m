Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E3A213FDDB
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:30:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403761AbgAPXaA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:30:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:36236 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403757AbgAPX36 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:29:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ECF962072E;
        Thu, 16 Jan 2020 23:29:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217398;
        bh=0hx9zLr1soFZ6KCFtZjRXev2DOjnQHSiFK1xACajxcM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N/XjpTKW4ho6n0bQmBMYoDChc1WPakROkdeRXLYsTtbsmKzfp2a6ZjEzRL8Uc7M+x
         c9sXxBXkQHVpZS70/D4gF32b3ZrSElT5CrkxSkhz5dSGP1k2cGVyUv1ktiGM5L/njg
         HZFg66YXzGLer4XsXpb4yXmq4ZtmKhbmtB1v3GQc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 4.19 67/84] mtd: spi-nor: fix silent truncation in spi_nor_read_raw()
Date:   Fri, 17 Jan 2020 00:18:41 +0100
Message-Id: <20200116231721.474170258@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231713.087649517@linuxfoundation.org>
References: <20200116231713.087649517@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit 3d63ee5deb466fd66ed6ffb164a87ce36425cf36 upstream.

spi_nor_read_raw() assigns the result of 'ssize_t spi_nor_read_data()'
to the 'int ret' variable, while 'ssize_t' is a 64-bit type and *int*
is a 32-bit type on the 64-bit machines. This silent truncation isn't
really valid, so fix up the variable's type.

Fixes: f384b352cbf0 ("mtd: spi-nor: parse Serial Flash Discoverable Parameters (SFDP) tables")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/spi-nor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -1523,7 +1523,7 @@ static int macronix_quad_enable(struct s
  */
 static int write_sr_cr(struct spi_nor *nor, u8 *sr_cr)
 {
-	int ret;
+	ssize_t ret;
 
 	write_enable(nor);
 


