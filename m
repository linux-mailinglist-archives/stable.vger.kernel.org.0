Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD6C2E40B8
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2439541AbgL1O4a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:56:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:51980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2441249AbgL1OQr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:16:47 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 673AD229C5;
        Mon, 28 Dec 2020 14:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609164967;
        bh=U2wwaEzDWBIk2SyEdeQYW9xWQFkmzgDyOBRrc9IR9MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ssqlJRFz3orNR0i84hy3Tjgu3QGkiUoW6fD9kHVrfVTaT+68ILXYkbgQ9Nd4W98Ak
         nJi7ziZmXZBQTd1Q3Fb1dmTfYllpEzxrfN/8dMpkm2ZBQk+dP8+e54phyZLlXUSinq
         T2tzzpyE/p1TjKwmh4n18dhCm6UVkZLnR+517/Rw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 362/717] platform/x86: mlx-platform: Fix item counter assignment for MSN2700/ComEx system
Date:   Mon, 28 Dec 2020 13:46:00 +0100
Message-Id: <20201228125038.357285184@linuxfoundation.org>
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

[ Upstream commit cf791774a16caf87b0e4c0c55b82979bad0b6c01 ]

Fix array names to match assignments for data items and data items
counter in 'mlxplat_mlxcpld_comex_items' structure for:
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

Fixes: bdd6e155e0d6 ("platform/x86: mlx-platform: Add support for new system type")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20201207174745.22889-3-vadimp@nvidia.com
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 902424e06180c..be8cb880de596 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -504,7 +504,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_comex_items[] = {
 		.aggr_mask = MLXPLAT_CPLD_AGGR_MASK_CARRIER,
 		.reg = MLXPLAT_CPLD_LPC_REG_PWR_OFFSET,
 		.mask = MLXPLAT_CPLD_PWR_MASK,
-		.count = ARRAY_SIZE(mlxplat_mlxcpld_pwr),
+		.count = ARRAY_SIZE(mlxplat_mlxcpld_default_pwr_items_data),
 		.inversed = 0,
 		.health = false,
 	},
@@ -513,7 +513,7 @@ static struct mlxreg_core_item mlxplat_mlxcpld_comex_items[] = {
 		.aggr_mask = MLXPLAT_CPLD_AGGR_MASK_CARRIER,
 		.reg = MLXPLAT_CPLD_LPC_REG_FAN_OFFSET,
 		.mask = MLXPLAT_CPLD_FAN_MASK,
-		.count = ARRAY_SIZE(mlxplat_mlxcpld_fan),
+		.count = ARRAY_SIZE(mlxplat_mlxcpld_default_fan_items_data),
 		.inversed = 1,
 		.health = false,
 	},
-- 
2.27.0



