Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CCD729B221
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:38:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1761178AbgJ0OiR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:38:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:37458 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1761171AbgJ0OiR (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:38:17 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82340206B2;
        Tue, 27 Oct 2020 14:38:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603809496;
        bh=D3jTTlZaVz/u1aERzfJinTMt1ISxWss0iqvmyuqNW08=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TaAio7oSw3kjOu67eF1FCDNOrcvYGKDimVBJH8UPPtLhYO8WSxF8gh+xgkKFhlkFh
         g0YHkTNzMcmBhiNGvVBTqAsYDXaDj2riqsIJMEaxpmnetugi1rCvoS4A2fUjZqcJNZ
         vw7/ie07oSHfsl6GHv9gxALxrh33HKY+2VvCfqv4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 186/408] platform/x86: mlx-platform: Remove PSU EEPROM configuration
Date:   Tue, 27 Oct 2020 14:52:04 +0100
Message-Id: <20201027135503.714767020@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135455.027547757@linuxfoundation.org>
References: <20201027135455.027547757@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit c071afcea6ecf24a3c119f25ce9f71ffd55b5dc2 ]

Remove PSU EEPROM configuration for systems class equipped with
Mellanox chip Spectrume-2. Till now all the systems from this class
used few types of power units, all equipped with EEPROM device with
address space two bytes. Thus, all these devices have been handled by
EEPROM driver "24c32".
There is a new requirement is to support power unit replacement by "off
the shelf" device, matching electrical required parameters. Such device
could be equipped with different EEPROM type, which could be one byte
address space addressing or even could be not equipped with EEPROM.
In such case "24c32" will not work.

Fixes: 1bd42d94ccab ("platform/x86: mlx-platform: Add support for new 200G IB and Ethernet systems")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20200923172053.26296-2-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 15 ++-------------
 1 file changed, 2 insertions(+), 13 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 8fe51e43f1bc1..59b5b7eebb05a 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -243,15 +243,6 @@ static struct i2c_board_info mlxplat_mlxcpld_psu[] = {
 	},
 };
 
-static struct i2c_board_info mlxplat_mlxcpld_ng_psu[] = {
-	{
-		I2C_BOARD_INFO("24c32", 0x51),
-	},
-	{
-		I2C_BOARD_INFO("24c32", 0x50),
-	},
-};
-
 static struct i2c_board_info mlxplat_mlxcpld_pwr[] = {
 	{
 		I2C_BOARD_INFO("dps460", 0x59),
@@ -611,15 +602,13 @@ static struct mlxreg_core_data mlxplat_mlxcpld_default_ng_psu_items_data[] = {
 		.label = "psu1",
 		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
 		.mask = BIT(0),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_ng_psu[0],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
+		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
 	},
 	{
 		.label = "psu2",
 		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
 		.mask = BIT(1),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_ng_psu[1],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
+		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
 	},
 };
 
-- 
2.25.1



