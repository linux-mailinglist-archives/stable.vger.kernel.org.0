Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 823E613FE47
	for <lists+stable@lfdr.de>; Fri, 17 Jan 2020 00:35:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389072AbgAPXdl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 18:33:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:44328 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404407AbgAPXdk (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 18:33:40 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6271E2087E;
        Thu, 16 Jan 2020 23:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579217619;
        bh=gVbEkf4yq5vJTw4E2HU3ReKS20++66X8C4lqXwTVBZ4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/i4wPskJao7RG5U4kRaM4RGq09HNZ7oo1jDTjYsrh6vQpoXGhWbN0YYs1+fPFLzJ
         hQYpKcAavk70MZ9WAxU48iaO48v3An1RSfG3lVp0MbKsbSyw7bpWKV3fdcP2VIDqxw
         JDIjVQOOpewaHtR8/BAODiHV2GrvZqn/1gH9CE1E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 4.14 56/71] mtd: spi-nor: fix silent truncation in spi_nor_read()
Date:   Fri, 17 Jan 2020 00:18:54 +0100
Message-Id: <20200116231717.270112184@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200116231709.377772748@linuxfoundation.org>
References: <20200116231709.377772748@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>

commit a719a75a7761e4139dd099330d9fe3589d844f9b upstream.

spi_nor_read() assigns the result of 'ssize_t spi_nor_read_data()'
to the 'int ret' variable, while 'ssize_t' is a 64-bit type and *int*
is a 32-bit type on the 64-bit machines. This silent truncation isn't
really valid, so fix up the variable's type.

Fixes: 59451e1233bd ("mtd: spi-nor: change return value of read/write")
Signed-off-by: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/spi-nor.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -1216,7 +1216,7 @@ static int spi_nor_read(struct mtd_info
 			size_t *retlen, u_char *buf)
 {
 	struct spi_nor *nor = mtd_to_spi_nor(mtd);
-	int ret;
+	ssize_t ret;
 
 	dev_dbg(nor->dev, "from 0x%08x, len %zd\n", (u32)from, len);
 


