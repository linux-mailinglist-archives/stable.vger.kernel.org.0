Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B4BF328BA4
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:40:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240256AbhCASiW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:38:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:44648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237476AbhCASb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:31:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 10CB96510D;
        Mon,  1 Mar 2021 17:02:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618158;
        bh=T8tyNsn96MNCt78RD6PSFNikoYo/TvmfW7dUjEei1ts=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eyz0NaS5b6LVWBKRMP50la1T7nHkJnVOwRKWmsEz0ONmEY17ZeccGYvZBlOJlqSH9
         hHka3S3dlZh+XkJJ9Pd10tgyEcf0cw4j0/BfPwn8hiE50c5B1H5lBw0zSLcc8AJ6io
         ZYPslJx2zQWRud6fd2bcuscBRDQPpSwTD5TGkLXs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.4 297/340] mtd: spi-nor: core: Fix erase type discovery for overlaid region
Date:   Mon,  1 Mar 2021 17:14:01 +0100
Message-Id: <20210301161102.917074542@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161048.294656001@linuxfoundation.org>
References: <20210301161048.294656001@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

commit 969b276718de37dfe66fce3a5633f611e8cd58fd upstream.

In case of overlaid regions in which their biggest erase size command
overpasses in size the region's size, only the non-overlaid portion of
the sector gets erased. For example, if a Sector Erase command is applied
to a 256-kB range that is overlaid by 4-kB sectors, the overlaid 4-kB
sectors are not affected by the erase.
For overlaid regions, 'region->size' is assigned to 'cmd->size' later in
spi_nor_init_erase_cmd(), so 'erase->size' can be greater than 'len'.

Fixes: 5390a8df769e ("mtd: spi-nor: add support to non-uniform SFDP SPI NOR flash memories")
Cc: stable@vger.kernel.org
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
[ta: Update commit description, add Fixes tag and Cc to stable]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/fa5d8b944a5cca488ac54ba37c95e775ac2deb34.1601612872.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/spi-nor.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -1011,14 +1011,15 @@ spi_nor_find_best_erase_type(const struc
 
 		erase = &map->erase_type[i];
 
+		/* Alignment is not mandatory for overlaid regions */
+		if (region->offset & SNOR_OVERLAID_REGION &&
+		    region->size <= len)
+			return erase;
+
 		/* Don't erase more than what the user has asked for. */
 		if (erase->size > len)
 			continue;
 
-		/* Alignment is not mandatory for overlaid regions */
-		if (region->offset & SNOR_OVERLAID_REGION)
-			return erase;
-
 		spi_nor_div_by_erase_size(erase, addr, &rem);
 		if (rem)
 			continue;


