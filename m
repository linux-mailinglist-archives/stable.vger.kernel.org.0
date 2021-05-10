Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA30037858E
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:28:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235383AbhEJLAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:00:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:52158 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234402AbhEJK4U (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 06:56:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1486661995;
        Mon, 10 May 2021 10:45:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620643548;
        bh=hQcUcGgIXcYuIh6tlF9KlkyfZzEOTbA9/nIS2zC+DXA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w5Yt2/knp3kLH/civY6yHdtIiWJgBiKn5uH+IBiMzLnU40nOb7kID1NQNaYVyLT77
         Y/zAc0A75Gbr4hoYpeStabTd3X5NzSsMJhwaGiECsEs6C6jWEX+n01Wjux9RB02kAd
         lYD0f5m20aLV198wo5LVVc8VYHxSdB/4TdDqZ3/w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tudor Ambarus <tudor.ambarus@microchip.com>,
        Pratyush Yadav <p.yadav@ti.com>
Subject: [PATCH 5.11 024/342] Revert "mtd: spi-nor: macronix: Add support for mx25l51245g"
Date:   Mon, 10 May 2021 12:16:54 +0200
Message-Id: <20210510102010.902207070@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102010.096403571@linuxfoundation.org>
References: <20210510102010.096403571@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tudor Ambarus <tudor.ambarus@microchip.com>

commit 46094049a49be777f12a9589798f7c70b90cd03f upstream.

This reverts commit 04b8edad262eec0d153005973dfbdd83423c0dcb.

mx25l51245g and mx66l51235l have the same flash ID. The flash
detection returns the first entry in the flash_info array that
matches the flash ID that was read, thus for the 0xc2201a ID,
mx25l51245g was always hit, introducing a regression for
mx66l51235l.

If one wants to differentiate the flash names, a better fix would be
to differentiate between the two at run-time, depending on SFDP,
and choose the correct name from a list of flash names, depending on
the SFDP differentiator.

Fixes: 04b8edad262e ("mtd: spi-nor: macronix: Add support for mx25l51245g")
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Acked-by: Pratyush Yadav <p.yadav@ti.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20210402082031.19055-2-tudor.ambarus@microchip.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/macronix.c |    3 ---
 1 file changed, 3 deletions(-)

--- a/drivers/mtd/spi-nor/macronix.c
+++ b/drivers/mtd/spi-nor/macronix.c
@@ -73,9 +73,6 @@ static const struct flash_info macronix_
 			      SECT_4K | SPI_NOR_DUAL_READ |
 			      SPI_NOR_QUAD_READ) },
 	{ "mx25l25655e", INFO(0xc22619, 0, 64 * 1024, 512, 0) },
-	{ "mx25l51245g", INFO(0xc2201a, 0, 64 * 1024, 1024,
-			      SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
-			      SPI_NOR_4B_OPCODES) },
 	{ "mx66l51235l", INFO(0xc2201a, 0, 64 * 1024, 1024,
 			      SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ |
 			      SPI_NOR_4B_OPCODES) },


