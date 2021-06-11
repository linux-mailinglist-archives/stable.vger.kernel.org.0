Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 623B83A39EF
	for <lists+stable@lfdr.de>; Fri, 11 Jun 2021 04:52:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbhFKCyM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Jun 2021 22:54:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:59976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230377AbhFKCyK (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Jun 2021 22:54:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E97F3613AD;
        Fri, 11 Jun 2021 02:52:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623379933;
        bh=59jTKDd7ZSj3rNi7RsjYNYbC3xlNX6mgPhdtLcnQv1Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=myDT6VBSB2UO6xYpz6zFUPtzTUI2LuqjOOGUQamxMSc5tiMzN/KKVXGrtTrXfeu1v
         mLb8KvUkACjARHmOfnyV2jYeY/0egHKX/4AukRw9N0bnLRfCAlk0EIcdE0AhFWQRdH
         sW1i3I/HT3HpmveSmYuzBI5QIClvAnR8puJSguRpw4FrFNsj+qAyJ2mcLk3jP1OUCs
         RFuYbR83QxN6Mf5rDHL9hwiHxFYz2bC9fGdbrsz8ZGQ0B8WUUe4Xfb2gRLHtWDlvaN
         ZWpsHriI9a2xewpsD2qv5XXE0UqXhgLC0yEhJHJrOaGwprpQU30grThfPa7wCUcFsB
         keS37R/sxMNQQ==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org
Subject: [PATCHv3 2/4] clk: agilex/stratix10: fix bypass representation
Date:   Thu, 10 Jun 2021 21:51:59 -0500
Message-Id: <20210611025201.118799-2-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210611025201.118799-1-dinguyen@kernel.org>
References: <20210611025201.118799-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Each of these clocks(s2f_usr0/1, sdmmc_clk, gpio_db, emac_ptp,
emac0/1/2) have a bypass setting that can use the boot_clk. The
previous representation was not correct.

Fix the representation.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
v3: no change
v2: add linux-stable to cc
---
 drivers/clk/socfpga/clk-agilex.c | 57 ++++++++++++++++++++++++++------
 drivers/clk/socfpga/clk-s10.c    | 55 ++++++++++++++++++++++++------
 2 files changed, 91 insertions(+), 21 deletions(-)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 5b8131542218..edfa87d0cd76 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -186,6 +186,41 @@ static const struct clk_parent_data noc_mux[] = {
 	  .name = "boot_clk", },
 };
 
+static const struct clk_parent_data sdmmc_mux[] = {
+	{ .fw_name = "sdmmc_free_clk",
+	  .name = "sdmmc_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data s2f_user1_mux[] = {
+	{ .fw_name = "s2f_user1_free_clk",
+	  .name = "s2f_user1_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data psi_mux[] = {
+	{ .fw_name = "psi_ref_free_clk",
+	  .name = "psi_ref_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data gpio_db_mux[] = {
+	{ .fw_name = "gpio_db_free_clk",
+	  .name = "gpio_db_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data emac_ptp_mux[] = {
+	{ .fw_name = "emac_ptp_free_clk",
+	  .name = "emac_ptp_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
 /* clocks in AO (always on) controller */
 static const struct stratix10_pll_clock agilex_pll_clks[] = {
 	{ AGILEX_BOOT_CLK, "boot_clk", boot_mux, ARRAY_SIZE(boot_mux), 0,
@@ -234,7 +269,7 @@ static const struct stratix10_perip_cnt_clock agilex_main_perip_cnt_clks[] = {
 	{ AGILEX_GPIO_DB_FREE_CLK, "gpio_db_free_clk", NULL, gpio_db_free_mux,
 	  ARRAY_SIZE(gpio_db_free_mux), 0, 0xE0, 0, 0x88, 3},
 	{ AGILEX_SDMMC_FREE_CLK, "sdmmc_free_clk", NULL, sdmmc_free_mux,
-	  ARRAY_SIZE(sdmmc_free_mux), 0, 0xE4, 0, 0x88, 4},
+	  ARRAY_SIZE(sdmmc_free_mux), 0, 0xE4, 0, 0, 0},
 	{ AGILEX_S2F_USER0_FREE_CLK, "s2f_user0_free_clk", NULL, s2f_usr0_free_mux,
 	  ARRAY_SIZE(s2f_usr0_free_mux), 0, 0xE8, 0, 0, 0},
 	{ AGILEX_S2F_USER1_FREE_CLK, "s2f_user1_free_clk", NULL, s2f_usr1_free_mux,
@@ -276,16 +311,16 @@ static const struct stratix10_gate_clock agilex_gate_clks[] = {
 	  1, 0, 0, 0, 0x94, 27, 0},
 	{ AGILEX_EMAC2_CLK, "emac2_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,
 	  2, 0, 0, 0, 0x94, 28, 0},
-	{ AGILEX_EMAC_PTP_CLK, "emac_ptp_clk", "emac_ptp_free_clk", NULL, 1, 0, 0x7C,
-	  3, 0, 0, 0, 0, 0, 0},
-	{ AGILEX_GPIO_DB_CLK, "gpio_db_clk", "gpio_db_free_clk", NULL, 1, 0, 0x7C,
-	  4, 0x98, 0, 16, 0, 0, 0},
-	{ AGILEX_SDMMC_CLK, "sdmmc_clk", "sdmmc_free_clk", NULL, 1, 0, 0x7C,
-	  5, 0, 0, 0, 0, 0, 4},
-	{ AGILEX_S2F_USER1_CLK, "s2f_user1_clk", "s2f_user1_free_clk", NULL, 1, 0, 0x7C,
-	  6, 0, 0, 0, 0, 0, 0},
-	{ AGILEX_PSI_REF_CLK, "psi_ref_clk", "psi_ref_free_clk", NULL, 1, 0, 0x7C,
-	  7, 0, 0, 0, 0, 0, 0},
+	{ AGILEX_EMAC_PTP_CLK, "emac_ptp_clk", NULL, emac_ptp_mux, ARRAY_SIZE(emac_ptp_mux), 0, 0x7C,
+	  3, 0, 0, 0, 0x88, 2, 0},
+	{ AGILEX_GPIO_DB_CLK, "gpio_db_clk", NULL, gpio_db_mux, ARRAY_SIZE(gpio_db_mux), 0, 0x7C,
+	  4, 0x98, 0, 16, 0x88, 3, 0},
+	{ AGILEX_SDMMC_CLK, "sdmmc_clk", NULL, sdmmc_mux, ARRAY_SIZE(sdmmc_mux), 0, 0x7C,
+	  5, 0, 0, 0, 0x88, 4, 4},
+	{ AGILEX_S2F_USER1_CLK, "s2f_user1_clk", NULL, s2f_user1_mux, ARRAY_SIZE(s2f_user1_mux), 0, 0x7C,
+	  6, 0, 0, 0, 0x88, 5, 0},
+	{ AGILEX_PSI_REF_CLK, "psi_ref_clk", NULL, psi_mux, ARRAY_SIZE(psi_mux), 0, 0x7C,
+	  7, 0, 0, 0, 0x88, 6, 0},
 	{ AGILEX_USB_CLK, "usb_clk", "l4_mp_clk", NULL, 1, 0, 0x7C,
 	  8, 0, 0, 0, 0, 0, 0},
 	{ AGILEX_SPI_M_CLK, "spi_m_clk", "l4_mp_clk", NULL, 1, 0, 0x7C,
diff --git a/drivers/clk/socfpga/clk-s10.c b/drivers/clk/socfpga/clk-s10.c
index 0199cffe4d77..b532d51faaee 100644
--- a/drivers/clk/socfpga/clk-s10.c
+++ b/drivers/clk/socfpga/clk-s10.c
@@ -144,6 +144,41 @@ static const struct clk_parent_data mpu_free_mux[] = {
 	  .name = "f2s-free-clk", },
 };
 
+static const struct clk_parent_data sdmmc_mux[] = {
+	{ .fw_name = "sdmmc_free_clk",
+	  .name = "sdmmc_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data s2f_user1_mux[] = {
+	{ .fw_name = "s2f_user1_free_clk",
+	  .name = "s2f_user1_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data psi_mux[] = {
+	{ .fw_name = "psi_ref_free_clk",
+	  .name = "psi_ref_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data gpio_db_mux[] = {
+	{ .fw_name = "gpio_db_free_clk",
+	  .name = "gpio_db_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
+static const struct clk_parent_data emac_ptp_mux[] = {
+	{ .fw_name = "emac_ptp_free_clk",
+	  .name = "emac_ptp_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
 /* clocks in AO (always on) controller */
 static const struct stratix10_pll_clock s10_pll_clks[] = {
 	{ STRATIX10_BOOT_CLK, "boot_clk", boot_mux, ARRAY_SIZE(boot_mux), 0,
@@ -247,16 +282,16 @@ static const struct stratix10_gate_clock s10_gate_clks[] = {
 	  1, 0, 0, 0, 0xDC, 27, 0},
 	{ STRATIX10_EMAC2_CLK, "emac2_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0xA4,
 	  2, 0, 0, 0, 0xDC, 28, 0},
-	{ STRATIX10_EMAC_PTP_CLK, "emac_ptp_clk", "emac_ptp_free_clk", NULL, 1, 0, 0xA4,
-	  3, 0, 0, 0, 0, 0, 0},
-	{ STRATIX10_GPIO_DB_CLK, "gpio_db_clk", "gpio_db_free_clk", NULL, 1, 0, 0xA4,
-	  4, 0xE0, 0, 16, 0, 0, 0},
-	{ STRATIX10_SDMMC_CLK, "sdmmc_clk", "sdmmc_free_clk", NULL, 1, 0, 0xA4,
-	  5, 0, 0, 0, 0, 0, 4},
-	{ STRATIX10_S2F_USER1_CLK, "s2f_user1_clk", "s2f_user1_free_clk", NULL, 1, 0, 0xA4,
-	  6, 0, 0, 0, 0, 0, 0},
-	{ STRATIX10_PSI_REF_CLK, "psi_ref_clk", "psi_ref_free_clk", NULL, 1, 0, 0xA4,
-	  7, 0, 0, 0, 0, 0, 0},
+	{ STRATIX10_EMAC_PTP_CLK, "emac_ptp_clk", NULL, emac_ptp_mux, ARRAY_SIZE(emac_ptp_mux), 0, 0xA4,
+	  3, 0, 0, 0, 0xB0, 2, 0},
+	{ STRATIX10_GPIO_DB_CLK, "gpio_db_clk", NULL, gpio_db_mux, ARRAY_SIZE(gpio_db_mux), 0, 0xA4,
+	  4, 0xE0, 0, 16, 0xB0, 3, 0},
+	{ STRATIX10_SDMMC_CLK, "sdmmc_clk", NULL, sdmmc_mux, ARRAY_SIZE(sdmmc_mux), 0, 0xA4,
+	  5, 0, 0, 0, 0xB0, 4, 4},
+	{ STRATIX10_S2F_USER1_CLK, "s2f_user1_clk", NULL, s2f_user1_mux, ARRAY_SIZE(s2f_user1_mux), 0, 0xA4,
+	  6, 0, 0, 0, 0xB0, 5, 0},
+	{ STRATIX10_PSI_REF_CLK, "psi_ref_clk", NULL, psi_mux, ARRAY_SIZE(psi_mux), 0, 0xA4,
+	  7, 0, 0, 0, 0xB0, 6, 0},
 	{ STRATIX10_USB_CLK, "usb_clk", "l4_mp_clk", NULL, 1, 0, 0xA4,
 	  8, 0, 0, 0, 0, 0, 0},
 	{ STRATIX10_SPI_M_CLK, "spi_m_clk", "l4_mp_clk", NULL, 1, 0, 0xA4,
-- 
2.25.1

