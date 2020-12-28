Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E94932E4151
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 16:06:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439200AbgL1OLQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:11:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:45568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2439203AbgL1OLA (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:11:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CBA41206E5;
        Mon, 28 Dec 2020 14:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164619;
        bh=cq7DSZK3KBuJ9cpk6CNdkYc5Fqv8Fq7RRPU/l227hIY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=amEzUK/yn2k3HoyE3YXNwbGsO4088dYJcvih8rTBABHOR6C3QOAFZOAeOBlLnyx7W
         6mUKUWTuSCfheaklC8fU+bWdm/yX1mjuZdlwUQJh+rcJhkXTckmpuC1T6vRmhszMbq
         QOLgRfUKRef71IB5d7M+5hf3unUWVz2w4Ry7DS+w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 211/717] platform/x86: mlx-platform: Remove PSU EEPROM from default platform configuration
Date:   Mon, 28 Dec 2020 13:43:29 +0100
Message-Id: <20201228125031.083697471@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 2bf5046bdb649908df8bcc0a012c56eee931a9af ]

Remove PSU EEPROM configuration for systems class equipped with
Mellanox chip Spectrum and Celeron CPU - system types MSN2700, MSN2100.
Till now all the systems from this class used few types of power units,
all equipped with EEPROM device with address space two bytes. Thus, all
these devices have been handled by EEPROM driver "24c02".

There is a new requirement is to support power unit replacement by "off
the shelf" device, matching electrical required parameters. Such device
can be equipped with different EEPROM type, which could be one byte
address space addressing or even could be not equipped with EEPROM.
In such case "24c02" will not work.

Fixes: c6acad68e ("platform/mellanox: mlxreg-hotplug: Modify to use a regmap interface")
Fixes: ba814fdd0 ("platform/x86: mlx-platform: Use defines for bus assignment")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20201125101056.174708-2-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 986ad3dda1c10..623e7f737d4ab 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -383,15 +383,13 @@ static struct mlxreg_core_data mlxplat_mlxcpld_default_psu_items_data[] = {
 		.label = "psu1",
 		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
 		.mask = BIT(0),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[0],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_DEFAULT_NR,
+		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
 	},
 	{
 		.label = "psu2",
 		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
 		.mask = BIT(1),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[1],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_DEFAULT_NR,
+		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
 	},
 };
 
-- 
2.27.0



