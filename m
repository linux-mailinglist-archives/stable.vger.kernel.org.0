Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B312E3B75
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 14:51:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406317AbgL1NuX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 08:50:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:51712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406314AbgL1NuW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:50:22 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id C882720715;
        Mon, 28 Dec 2020 13:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609163407;
        bh=3kH8G1S0zb0Zmt4rApJclmEE26nhfudDk2YtEQm9L5M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=s9uhXhFsOaMYeQOpoepuUyqR+taaphaTt8HDWnZWFa1Q+756goB7L/r0w/nepmHCW
         zyVX/hI3bh9a69W64dF9HSZXKIpY7x9eGx5iwCtjGHW6ZQ2wTjVxsxGx/lKcvIDHRx
         Os8m0x6ZQ+GU4MWhdkZP52oQbY6VKH+MXrb2Ct8w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 244/453] platform/x86: mlx-platform: Fix item counter assignment for MSN2700, MSN24xx systems
Date:   Mon, 28 Dec 2020 13:48:00 +0100
Message-Id: <20201228124948.966635631@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228124937.240114599@linuxfoundation.org>
References: <20201228124937.240114599@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit ba4939f1dd46dde08c2f9b9d7ac86ed3ea7ead86 ]

Fix array names to match assignments for data items and data items
counter in 'mlxplat_mlxcpld_default_items' structure for:
	.data = mlxplat_mlxcpld_default_pwr_items_data,
	.count = ARRAY_SIZE(mlxplat_mlxcpld_pwr),
and
	.data = mlxplat_mlxcpld_default_fan_items_data,
	.count = ARRAY_SIZE(mlxplat_mlxcpld_fan),

Replace:
- 'mlxplat_mlxcpld_pwr' by 'mlxplat_mlxcpld_default_pwr_items_data' for
   ARRAY_SIZE() calculation.
- 'mlxplat_mlxcpld_fan' by 'mlxplat_mlxcpld_default_fan_items_data'
   for ARRAY_SIZE() calculation.

Fixes: c6acad68eb2d ("platform/mellanox: mlxreg-hotplug: Modify to use a regmap interface")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20201207174745.22889-2-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 4b3d94c4a939a..acb094ddf8e61 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -355,7 +355,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_default_items[] = {
 		.aggr_mask = MLXPLAT_CPLD_AGGR_PWR_MASK_DEF,
 		.reg = MLXPLAT_CPLD_LPC_REG_PWR_OFFSET,
 		.mask = MLXPLAT_CPLD_PWR_MASK,
-		.count = ARRAY_SIZE(mlxplat_mlxcpld_pwr),
+		.count = ARRAY_SIZE(mlxplat_mlxcpld_default_pwr_items_data),
 		.inversed = 0,
 		.health = false,
 	},
@@ -364,7 +364,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_default_items[] = {
 		.aggr_mask = MLXPLAT_CPLD_AGGR_FAN_MASK_DEF,
 		.reg = MLXPLAT_CPLD_LPC_REG_FAN_OFFSET,
 		.mask = MLXPLAT_CPLD_FAN_MASK,
-		.count = ARRAY_SIZE(mlxplat_mlxcpld_fan),
+		.count = ARRAY_SIZE(mlxplat_mlxcpld_default_fan_items_data),
 		.inversed = 1,
 		.health = false,
 	},
-- 
2.27.0



