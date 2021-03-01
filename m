Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3203B3291B5
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:32:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243309AbhCAUbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:31:11 -0500
Received: from mail.kernel.org ([198.145.29.99]:47580 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236935AbhCAUY1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:24:27 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19CBE65172;
        Mon,  1 Mar 2021 18:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614621971;
        bh=65GW4H/Q+9EHQGoseskGyaODz5rKTvUIg3l47cZf63g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k+KqRjZfg9BwtiSYDOlyDxKOYYIxoil4dQq/gb4GFcqXLPRXVgdj1ljGiUvMdczDA
         6RC0TQ114qdsj7XpRTH6CNRomXPtwoGj5KC2Mw4sdEeneeYzjMZL/QKbO+/HXXs/2n
         A9Eb04DladwV56CLbZ0r+GfTgo9pSD5nyTUtN84o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.11 693/775] mtd: spi-nor: sfdp: Fix last erase region marking
Date:   Mon,  1 Mar 2021 17:14:21 +0100
Message-Id: <20210301161235.633268323@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>

commit 9166f4af32db74e1544a2149aef231ff24515ea3 upstream.

The place of spi_nor_region_mark_end() must be moved, because 'i' is
re-used for the index of erase[].

Fixes: b038e8e3be72 ("mtd: spi-nor: parse SFDP Sector Map Parameter Table")
Cc: stable@vger.kernel.org
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
[ta: Add Fixes tag and Cc to stable]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/02ce8d84b7989ebee33382f6494df53778dd508e.1601612872.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sfdp.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mtd/spi-nor/sfdp.c
+++ b/drivers/mtd/spi-nor/sfdp.c
@@ -858,6 +858,7 @@ spi_nor_init_non_uniform_erase_map(struc
 		offset = (region[i].offset & ~SNOR_ERASE_FLAGS_MASK) +
 			 region[i].size;
 	}
+	spi_nor_region_mark_end(&region[i - 1]);
 
 	save_uniform_erase_type = map->uniform_erase_type;
 	map->uniform_erase_type = spi_nor_sort_erase_mask(map,
@@ -881,8 +882,6 @@ spi_nor_init_non_uniform_erase_map(struc
 		if (!(regions_erase_type & BIT(erase[i].idx)))
 			spi_nor_set_erase_type(&erase[i], 0, 0xFF);
 
-	spi_nor_region_mark_end(&region[i - 1]);
-
 	return 0;
 }
 


