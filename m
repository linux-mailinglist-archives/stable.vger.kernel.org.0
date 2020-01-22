Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5E164145539
	for <lists+stable@lfdr.de>; Wed, 22 Jan 2020 14:20:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729332AbgAVNUB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Jan 2020 08:20:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:36026 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729849AbgAVNT5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Jan 2020 08:19:57 -0500
Received: from localhost (unknown [84.241.205.26])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6436A2467E;
        Wed, 22 Jan 2020 13:19:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579699197;
        bh=KjfjgbCTqX+0P7kzgRGtTQuph1RQP1dgmSW8J+6GUXk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dEIHI6kr58asRz5alAVHwrgewcyunWz/JMhdSwpWfjsDZniyI4u6r3eXN0mCwFJEZ
         26NI5IoN3OF7FYWDZH+Kqs+qmtbg+6AmyagEqeNmWeWT12WNsg6W7Czqo+veIr4H0w
         Ics6BHBjPShIliWMuWTKLUB6XYJWnNQc3mNhLWBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vignesh Raghavendra <vigneshr@ti.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.4 069/222] mtd: spi-nor: Fix selection of 4-byte addressing opcodes on Spansion
Date:   Wed, 22 Jan 2020 10:27:35 +0100
Message-Id: <20200122092838.664472744@linuxfoundation.org>
X-Mailer: git-send-email 2.25.0
In-Reply-To: <20200122092833.339495161@linuxfoundation.org>
References: <20200122092833.339495161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vignesh Raghavendra <vigneshr@ti.com>

commit 440b6d50254bdbd84c2a665c7f53ec69dd741a4f upstream.

mtd->size is still unassigned when running spansion_post_sfdp_fixups()
hook, therefore use nor->params.size to determine the size of flash device.

This makes sure that 4-byte addressing opcodes are used on Spansion
flashes that are larger than 16MiB and don't have SFDP 4BAIT table
populated.

Fixes: 92094ebc385e ("mtd: spi-nor: Add spansion_post_sfdp_fixups()")
Signed-off-by: Vignesh Raghavendra <vigneshr@ti.com>
Reviewed-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/mtd/spi-nor/spi-nor.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -4544,9 +4544,7 @@ static void spi_nor_info_init_params(str
 
 static void spansion_post_sfdp_fixups(struct spi_nor *nor)
 {
-	struct mtd_info *mtd = &nor->mtd;
-
-	if (mtd->size <= SZ_16M)
+	if (nor->params.size <= SZ_16M)
 		return;
 
 	nor->flags |= SNOR_F_4B_OPCODES;


