Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 663C340ED8B
	for <lists+stable@lfdr.de>; Fri, 17 Sep 2021 00:52:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241297AbhIPWx5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 18:53:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:39478 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241276AbhIPWx5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 18:53:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 83BCF611CA;
        Thu, 16 Sep 2021 22:52:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631832756;
        bh=qpV5znjV3wJfX6/pMYW3i3FIPdKrsfGHXQP0EVz8wSs=;
        h=From:To:Cc:Subject:Date:From;
        b=Cw4IBSDePFx49L2Fz6fTgWPUJ4plkBw0Mco/dQN2mUiA1ZOxVFt7j07hxnKlDQGt1
         kTyen0CSLk4uRLjVIAkpAHTQBk03pJ9zPU3EjLWFT2qKHZGb4xxba8ZSRtSs7UVR47
         8ZKX5I5AeLnZ8lYSDlCjYydn/IX+tgP29mKkdmLGmeKNZDTrk2LBSEMDLnXhe8ZCrm
         DvUV6JotBd1STna/hZyWrSXDFE6pw0S9eq4yZwsVjYpWK3sKPpLSiA9c2ihY3Xj2Ax
         dAi4TEFCsMReXRpdE/5KMW0D22OIeksmZHky/qC0xRjz9Aba1wrlma99HCD7IkLQtX
         +GFT4ahhKUq2g==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     sboyd@kernel.org
Cc:     dinguyen@kernel.org, mturquette@baylibre.com,
        linux-clk@vger.kernel.org, stable@vger.kernel.org
Subject: [PATCHv2] clk: socfpga: agilex: fix duplicate s2f_user0_clk
Date:   Thu, 16 Sep 2021 17:51:26 -0500
Message-Id: <20210916225126.1427700-1-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Remove the duplicate s2f_user0_clk and the unused s2f_usr0_mux define.

Fixes: f817c132db67 ("clk: socfpga: agilex: fix up s2f_user0_clk
representation")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/clk/socfpga/clk-agilex.c | 9 ---------
 1 file changed, 9 deletions(-)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 242e94c0cf8a..bf8cd928c228 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -165,13 +165,6 @@ static const struct clk_parent_data mpu_mux[] = {
 	  .name = "boot_clk", },
 };
 
-static const struct clk_parent_data s2f_usr0_mux[] = {
-	{ .fw_name = "f2s-free-clk",
-	  .name = "f2s-free-clk", },
-	{ .fw_name = "boot_clk",
-	  .name = "boot_clk", },
-};
-
 static const struct clk_parent_data emac_mux[] = {
 	{ .fw_name = "emaca_free_clk",
 	  .name = "emaca_free_clk", },
@@ -312,8 +305,6 @@ static const struct stratix10_gate_clock agilex_gate_clks[] = {
 	  4, 0x44, 28, 1, 0, 0, 0},
 	{ AGILEX_CS_TIMER_CLK, "cs_timer_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
 	  5, 0, 0, 0, 0x30, 1, 0},
-	{ AGILEX_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_usr0_mux, ARRAY_SIZE(s2f_usr0_mux), 0, 0x24,
-	  6, 0, 0, 0, 0, 0, 0},
 	{ AGILEX_EMAC0_CLK, "emac0_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,
 	  0, 0, 0, 0, 0x94, 26, 0},
 	{ AGILEX_EMAC1_CLK, "emac1_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,
-- 
2.25.1

