Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 13D31106663
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 07:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727239AbfKVGaP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 01:30:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:53828 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbfKVFtj (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 00:49:39 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5F38C20715;
        Fri, 22 Nov 2019 05:49:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574401779;
        bh=tARb7IUQzWDNhor9rc0lAJgN2m/nyWKUzM+57eoL5dY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=inKg0wlWPKuCxdJ5ee63XGH5bdYu5C92DbVA00XacdewiAElQFYtx/UK7c+1qILkw
         lTzRMRL96PZB0zs9Ljj568Ik3RuKiIc2KmvWzJyj0k4KJy9IW+qzrHEcYXAssR/g4v
         /Ip9rMBENpbprk2v4MwpCzbmXYiTp2k7Y9MDUU0A=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Pasternak <vadimp@mellanox.com>,
        Darren Hart <dvhart@infradead.org>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 028/219] platform/x86: mlx-platform: Fix LED configuration
Date:   Fri, 22 Nov 2019 00:46:00 -0500
Message-Id: <20191122054911.1750-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191122054911.1750-1-sashal@kernel.org>
References: <20191122054911.1750-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@mellanox.com>

[ Upstream commit 440f343df1996302d9a3904647ff11b689bf27bc ]

Exchange LED configuration between msn201x and next generation systems
types.

Bug was introduced when LED driver activation was added to mlx-platform.
LED configuration for the three new system MQMB7, MSN37, MSN34 was
assigned to MSN21 and vice versa. This bug affects MSN21 only and
likely requires backport to v4.19.

Fixes: 1189456b1cce ("platform/x86: mlx-platform: Add LED platform driver activation")
Signed-off-by: Vadim Pasternak <vadimp@mellanox.com>
Signed-off-by: Darren Hart (VMware) <dvhart@infradead.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index 742a0c2179256..ab1aedd72d340 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -1421,7 +1421,7 @@ static int __init mlxplat_dmi_msn201x_matched(const struct dmi_system_id *dmi)
 	mlxplat_hotplug = &mlxplat_mlxcpld_msn201x_data;
 	mlxplat_hotplug->deferred_nr =
 		mlxplat_default_channels[i - 1][MLXPLAT_CPLD_GRP_CHNL_NUM - 1];
-	mlxplat_led = &mlxplat_default_ng_led_data;
+	mlxplat_led = &mlxplat_msn21xx_led_data;
 	mlxplat_regs_io = &mlxplat_msn21xx_regs_io_data;
 
 	return 1;
@@ -1439,7 +1439,7 @@ static int __init mlxplat_dmi_qmb7xx_matched(const struct dmi_system_id *dmi)
 	mlxplat_hotplug = &mlxplat_mlxcpld_default_ng_data;
 	mlxplat_hotplug->deferred_nr =
 		mlxplat_msn21xx_channels[MLXPLAT_CPLD_GRP_CHNL_NUM - 1];
-	mlxplat_led = &mlxplat_msn21xx_led_data;
+	mlxplat_led = &mlxplat_default_ng_led_data;
 	mlxplat_fan = &mlxplat_default_fan_data;
 
 	return 1;
-- 
2.20.1

