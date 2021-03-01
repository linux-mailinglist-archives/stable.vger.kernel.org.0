Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27BD3328D4D
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:11:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241132AbhCATIS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:08:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:37268 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239515AbhCATEO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:04:14 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 19AF164FA7;
        Mon,  1 Mar 2021 17:31:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614619900;
        bh=sSlT3c14wnGE1MMEKnrwI48vDPotCsFFTsXPuVfWcvk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9zTFPOCk81La9Emqz1f/+mZod45wP2HegRcQvBi1FzcSFQIW4iqB6CnJymu+Zhk7
         XZkSG5h/R5a8FSBnckEZuPiryIL8XmtV6Zw44EBBTn8vIiZT+h+rghHRkBZ7zHLHVC
         oAYntAUDMGC7f8LP1PqV804upH4EXRQTdhwI1AVo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.10 591/663] mtd: spi-nor: core: Add erase size check for erase command initialization
Date:   Mon,  1 Mar 2021 17:13:59 +0100
Message-Id: <20210301161211.106523425@linuxfoundation.org>
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

commit 58fa22f68fcaff20ce4d08a6adffa64f65ccd37d upstream.

Even if erase type is same as previous region, erase size can be different
if the previous region is overlaid region. Since 'region->size' is assigned
to 'cmd->size' for overlaid region, comparing 'erase->size' and 'cmd->size'
can detect previous overlaid region.

Fixes: 5390a8df769e ("mtd: spi-nor: add support to non-uniform SFDP SPI NOR flash memories")
Cc: stable@vger.kernel.org
Signed-off-by: Takahiro Kuwano <Takahiro.Kuwano@infineon.com>
[ta: Add Fixes tag and Cc to stable]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Link: https://lore.kernel.org/r/13d47e8d8991b8a7fd8cc7b9e2a5319c56df35cc.1601612872.git.Takahiro.Kuwano@infineon.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1364,6 +1364,7 @@ static int spi_nor_init_erase_cmd_list(s
 			goto destroy_erase_cmd_list;
 
 		if (prev_erase != erase ||
+		    erase->size != cmd->size ||
 		    region->offset & SNOR_OVERLAID_REGION) {
 			cmd = spi_nor_init_erase_cmd(region, erase);
 			if (IS_ERR(cmd)) {


