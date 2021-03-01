Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69465328EB0
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 20:37:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242075AbhCATfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 14:35:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:48622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241868AbhCAT3c (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 14:29:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E9EB865117;
        Mon,  1 Mar 2021 17:02:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614618162;
        bh=yv59YK0MU3bddQE2/wQZe3fCczpjUleI6fPV3ndRG2A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wMDTS51eAvSXd6NM/bgV0Z8OgKj5OybPv/E3+GYMDjbgbtyhVZqnoyGYScMqsapk8
         wD0IEwQJmq4rtJRT0jS8eePMmbG2WQEjR3vthRqfhRIdEBkR0O2/Q1715+sqDG60Pd
         0wkMCcAddg1sIrrh+vcKy0mUAMo0I3GyTHXHjHXY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Takahiro Kuwano <Takahiro.Kuwano@infineon.com>,
        Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 5.4 298/340] mtd: spi-nor: core: Add erase size check for erase command initialization
Date:   Mon,  1 Mar 2021 17:14:02 +0100
Message-Id: <20210301161102.968745552@linuxfoundation.org>
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
 drivers/mtd/spi-nor/spi-nor.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/mtd/spi-nor/spi-nor.c
+++ b/drivers/mtd/spi-nor/spi-nor.c
@@ -1153,6 +1153,7 @@ static int spi_nor_init_erase_cmd_list(s
 			goto destroy_erase_cmd_list;
 
 		if (prev_erase != erase ||
+		    erase->size != cmd->size ||
 		    region->offset & SNOR_OVERLAID_REGION) {
 			cmd = spi_nor_init_erase_cmd(region, erase);
 			if (IS_ERR(cmd)) {


