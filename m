Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263932E658A
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 17:03:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390503AbgL1QCm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 11:02:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:58384 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390209AbgL1N3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 08:29:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3D68322AAA;
        Mon, 28 Dec 2020 13:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609162179;
        bh=v2j1NgCtxry56d7xIUjlsxc1o//7prUvdw6+0kbhgtw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AfLQJaQ0lf4bfOTj6q1r7Nnt8d558hE6zDUznxdGnwN5QWwaGsp59l61p3hl0Y/vR
         WBZQ9HMi4h7ilinM51vK3LZAtcZ5OzfbO2KxfQFvi88+htmSRVx9OdWjJJfsgL5Emr
         eoJG8W5pyaS6RT5ep5rHzfWUqeTLntbAjkVO0D4I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 213/346] platform/x86: mlx-platform: Fix item counter assignment for MSN2700, MSN24xx systems
Date:   Mon, 28 Dec 2020 13:48:52 +0100
Message-Id: <20201228124930.084876385@linuxfoundation.org>
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
index 850c719de68d4..39f2c0428a046 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -333,7 +333,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_default_items[] = {
 		.aggr_mask = MLXPLAT_CPLD_AGGR_PWR_MASK_DEF,
 		.reg = MLXPLAT_CPLD_LPC_REG_PWR_OFFSET,
 		.mask = MLXPLAT_CPLD_PWR_MASK,
-		.count = ARRAY_SIZE(mlxplat_mlxcpld_pwr),
+		.count = ARRAY_SIZE(mlxplat_mlxcpld_default_pwr_items_data),
 		.inversed = 0,
 		.health = false,
 	},
@@ -342,7 +342,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_default_items[] = {
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



