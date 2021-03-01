Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 584773289E2
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:09:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238916AbhCASHS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:07:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:54154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238375AbhCASBa (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:01:30 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B44D564FA9;
        Mon,  1 Mar 2021 17:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619886;
        bh=zF7Mv0g8+z9G3lMcychRTDDldeHpPJRD+qAUOK9sxeM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UGP3Zte4nbDdpi/FtLjiqrrOa48Vo5UYwjMB/orPmzYdWjoiy/Oy5xQiZSThhlPft
         gYS0BU56sX5M8FS/SjunhGW4YqIPKwKfOSYwjTwbg6enUm0ZkYXULGxXbkTSVNypXp
         AwtsNb1Lkwxm4xsN0WIlRh2cLdeF+Rspl/vrTiGU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.10 589/663] mtd: spi-nor: sfdp: Fix wrong erase type bitmask for overlaid region
Date:   Mon,  1 Mar 2021 17:13:57 +0100
Message-Id: <20210301161211.004452613@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161141.760350206@linuxfoundation.org>
References: <20210301161141.760350206@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

commit abdf5a5ef9652bad4d58058bc22ddf23543ba3e1 upstream.

At the time spi_nor_region_check_overlay() is called, the erase types are
sorted in ascending order of erase size. The 'erase_type' should be masked
with 'BIT(erase[i].idx)' instead of 'BIT(i)'.

Fixes: b038e8e3be72 ("mtd: spi-nor: parse SFDP Sector Map Parameter Table")
Cc: stable@vger.kernel.org
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
[ta: Add Fixes tag and Cc to stable]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/fd90c40d5b626a1319a78fc2bcee79a8871d4d57.1601612872.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sfdp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -760,7 +760,7 @@ spi_nor_region_check_overlay(struct spi_
 	int i;
 
 	for (i = 0; i < SNOR_ERASE_TYPE_MAX; i++) {
-		if (!(erase_type & BIT(i)))
+		if (!(erase[i].size && erase_type & BIT(erase[i].idx)))
 			continue;
 		if (region->size & erase[i].size_mask) {
 			spi_nor_region_mark_overlay(region);


