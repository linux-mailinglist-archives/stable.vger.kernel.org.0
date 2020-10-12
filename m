Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C7528C131
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 21:10:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730927AbgJLTCt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 15:02:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:52100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730855AbgJLTCr (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 15:02:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195EC208B8;
        Mon, 12 Oct 2020 19:02:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602529367;
        bh=QkXWm29UpJ9d+OpzSznNbEi0x37isxAZEbbDPaxmB58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=N1xP70aK+0Fvsq9AlB7faCcsM9e0jxM/y+LTCIiU+SPydBPFSFhm7zDTlX+hTs69/
         KacxXIsrSf6VB6WiqHus2hqg57YMm+Ga7kr32aQH7N3IQSbeBbyJaiPeLijhNPaAU0
         yxAjvGxH+9PqmFxUat/LfdVXrIvn6fhw0bqK7XHo=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vadim Pasternak <vadimp@nvidia.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 5.8 05/24] platform/x86: mlx-platform: Fix extended topology configuration for power supply units
Date:   Mon, 12 Oct 2020 15:02:20 -0400
Message-Id: <20201012190239.3279198-5-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20201012190239.3279198-1-sashal@kernel.org>
References: <20201012190239.3279198-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit 2b06a1c889ca33d550675db4b0ca91e1b4dd9873 ]

Fix topology configuration for power supply units in structure
'mlxplat_mlxcpld_ext_pwr_items_data', due to hardware change.

Note: no need to backport the fix, since there is no such hardware yet
(equipped with four power) at the filed.

Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/mlx-platform.c | 18 +++++++++++++-----
 1 file changed, 13 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/mlx-platform.c b/drivers/platform/x86/mlx-platform.c
index c27548fd386ac..0443632faed9f 100644
--- a/drivers/platform/x86/mlx-platform.c
+++ b/drivers/platform/x86/mlx-platform.c
@@ -163,7 +163,6 @@
 #define MLXPLAT_CPLD_NR_NONE			-1
 #define MLXPLAT_CPLD_PSU_DEFAULT_NR		10
 #define MLXPLAT_CPLD_PSU_MSNXXXX_NR		4
-#define MLXPLAT_CPLD_PSU_MSNXXXX_NR2		3
 #define MLXPLAT_CPLD_FAN1_DEFAULT_NR		11
 #define MLXPLAT_CPLD_FAN2_DEFAULT_NR		12
 #define MLXPLAT_CPLD_FAN3_DEFAULT_NR		13
@@ -337,6 +336,15 @@ static struct i2c_board_info mlxplat_mlxcpld_pwr[] = {
 	},
 };
 
+static struct i2c_board_info mlxplat_mlxcpld_ext_pwr[] = {
+	{
+		I2C_BOARD_INFO("dps460", 0x5b),
+	},
+	{
+		I2C_BOARD_INFO("dps460", 0x5a),
+	},
+};
+
 static struct i2c_board_info mlxplat_mlxcpld_fan[] = {
 	{
 		I2C_BOARD_INFO("24c32", 0x50),
@@ -911,15 +919,15 @@ static struct mlxreg_core_data mlxplat_mlxcpld_ext_pwr_items_data[] = {
 		.label = "pwr3",
 		.reg = MLXPLAT_CPLD_LPC_REG_PWR_OFFSET,
 		.mask = BIT(2),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_pwr[0],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR2,
+		.hpdev.brdinfo = &mlxplat_mlxcpld_ext_pwr[0],
+		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
 	},
 	{
 		.label = "pwr4",
 		.reg = MLXPLAT_CPLD_LPC_REG_PWR_OFFSET,
 		.mask = BIT(3),
-		.hpdev.brdinfo = &mlxplat_mlxcpld_pwr[1],
-		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR2,
+		.hpdev.brdinfo = &mlxplat_mlxcpld_ext_pwr[1],
+		.hpdev.nr = MLXPLAT_CPLD_PSU_MSNXXXX_NR,
 	},
 };
 
-- 
2.25.1

