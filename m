Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A2E3A2E39CC
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:29:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389792AbgL1N2V (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:28:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:56888 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389832AbgL1N2E (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:28:04 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3FDA322583;
        Mon, 28 Dec 2020 13:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162043;
        bh=hPfss7ITlAlcJ4amQ7Rzj5DQlapOMkc9UQVJeaPc5WM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=as+ssF3RQuuksVlTQIEyiFf75o8ZA5evMT43Yr9FhwonL0vn3WOI3hl/VFda5q3WI
         vOk6Exda5Yv7EH/Uvtwxlej+UpBA9ngex6/5vARMwsU7izen5gqqOyap3Vaja3GjhG
         Zy73JvQ5IbXm6s5GClkw+li3yXkE6ol2O0gJ8+m8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 169/346] platform/x86: mlx-platform: Remove PSU EEPROM from MSN274x platform configuration
Date:   Mon, 28 Dec 2020 13:48:08 +0100
Message-Id: <20201228124927.962973932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124919.745526410@linuxfoundation.org>
References: <20201228124919.745526410@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 912b341585e302ee44fc5a2733f7bcf505e2c86f ]

Remove PSU EEPROM configuration for systems class equipped with
Mellanox chip Spectrum and ATOM CPU - system types MSN274x. Till now
all the systems from this class used few types of power units, all
equipped with EEPROM device with address space two bytes. Thus, all
these devices have been handled by EEPROM driver "24c02".

There is a new requirement is to support power unit replacement by "off
the shelf" device, matching electrical required parameters. Such device
can be equipped with different EEPROM type, which could be one byte
address space addressing or even could be not equipped with EEPROM.
In such case "24c02" will not work.

Fixes: ef08e14a3 ("platform/x86: mlx-platform: Add support for new msn274x system type")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20201125101056.174708-3-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 62c749180bb78..850c719de68d4 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -420,15 +420,13 @@ static struct mlxreg_core_data mlxplat_mlxcpld_msn274x_psu_items_data[] = {
 		.label = "psu1",
 		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
 		.mask = BIT(0),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[0],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
+		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
 	},
 	{
 		.label = "psu2",
 		.reg = MLXPLAT_CPLD_LPC_REG_PSU_OFFSET,
 		.mask = BIT(1),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_psu[1],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
+		.hpdev.nr = MLXPLAT_CPLD_NR_NONE,
 	},
 };
 
-- 
2.27.0



