Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9DDDE3291EA
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 21:36:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238585AbhCAUgU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 15:36:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:48310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240281AbhCAU0z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 15:26:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1978D65413;
        Mon,  1 Mar 2021 18:06:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614622016;
        bh=CMmtLrMKBUjulMGzE1Q8tpVlLB8zO+8Bmaac/0MrXZo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MHsZ5gUtMToehNFGDkwSgqi6bey5fTf/iqFmgj5olz3PK+C+mJWG7nmqTzFsHOARt
         dDUhowoJsc7D6c4qap2xJHgVHBT98xfzVwIW1j89l2xgL68F+gyYWrxGPuDMxq6jcR
         PB2cq9VmhTz5tH7VArXFC82RgGq6uo4yBp2gSvc8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.11 696/775] mtd: spi-nor: core: Add erase size check for erase command initialization
Date:   Mon,  1 Mar 2021 17:14:24 +0100
Message-Id: <20210301161235.774780738@linuxfoundation.org>
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
@@ -1516,6 +1516,7 @@ static int spi_nor_init_erase_cmd_list(s
 			goto destroy_erase_cmd_list;
 
 		if (prev_erase != erase ||
+		    erase->size != cmd->size ||
 		    region->offset & SNOR_OVERLAID_REGION) {
 			cmd = spi_nor_init_erase_cmd(region, erase);
 			if (IS_ERR(cmd)) {


