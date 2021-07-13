Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D95413C7292
	for <lists+stable@lfdr.de>; Tue, 13 Jul 2021 16:46:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236899AbhGMOtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Jul 2021 10:49:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:58618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236883AbhGMOtW (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Jul 2021 10:49:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 464CB6128E;
        Tue, 13 Jul 2021 14:46:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626187592;
        bh=aa1+k78QvBo+kDqvKs85sZ5WgLyQUoGB37e2UYiiUJc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ve77FGGqpAuHYBYkAY2cL2EaZqmLMoEWaMUYx+dxwjH2mE0Gf1tPe7BdLjlpDAXmG
         1PnjplooqRs7/wQos/89QfdLk9N4zYpTDS9cFBkY0vBxCyQ6dh9vrGvBokTZiVG9Jn
         iAhxK8Fe3n6QmBrfJaZidk1s4Bbjg8zolZdI/l+PZlh1PqrhKLEeILyZhg+RqyFkwZ
         WIKjd2Eq1G3qDMPc/+Ua8WKeRB9/MIZ6iiXQu32nEKA0Jz7AtgCnnh1A+CQCJ5sis+
         9toXmjKVRmfRm/Qz7JxdBcDFZS3xPbVFzCsTsRorYv8qazbaITl28/FykxoGnqxA5o
         E4w87AQL1WhwA==
From:   Dinh Nguyen <dinguyen@kernel.org>
To:     linux-clk@vger.kernel.org
Cc:     dinguyen@kernel.org, sboyd@kernel.org, mturquette@baylibre.com,
        stable@vger.kernel.org, Kris Chaplin <kris.chaplin@intel.com>
Subject: [PATCH 2/3] clk: socfpga: agilex: fix up s2f_user0_clk representation
Date:   Tue, 13 Jul 2021 09:46:20 -0500
Message-Id: <20210713144621.605140-2-dinguyen@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20210713144621.605140-1-dinguyen@kernel.org>
References: <20210713144621.605140-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Correct the s2f_user0_mux clock representation.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Kris Chaplin <kris.chaplin@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
---
 drivers/clk/socfpga/clk-agilex.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/clk/socfpga/clk-agilex.c b/drivers/clk/socfpga/clk-agilex.c
index 9dffe9ba0e74..7baaa16dea7b 100644
--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -195,6 +195,13 @@ static const struct clk_parent_data sdmmc_mux[] = {
 	  .name = "boot_clk", },
 };
 
+static const struct clk_parent_data s2f_user0_mux[] = {
+	{ .fw_name = "s2f_user0_free_clk",
+	  .name = "s2f_user0_free_clk", },
+	{ .fw_name = "boot_clk",
+	  .name = "boot_clk", },
+};
+
 static const struct clk_parent_data s2f_user1_mux[] = {
 	{ .fw_name = "s2f_user1_free_clk",
 	  .name = "s2f_user1_free_clk", },
@@ -319,6 +326,8 @@ static const struct stratix10_gate_clock agilex_gate_clks[] = {
 	  4, 0x98, 0, 16, 0x88, 3, 0},
 	{ AGILEX_SDMMC_CLK, "sdmmc_clk", NULL, sdmmc_mux, ARRAY_SIZE(sdmmc_mux), 0, 0x7C,
 	  5, 0, 0, 0, 0x88, 4, 4},
+	{ AGILEX_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_user0_mux, ARRAY_SIZE(s2f_user0_mux), 0, 0x24,
+	  6, 0, 0, 0, 0x30, 2, 0},
 	{ AGILEX_S2F_USER1_CLK, "s2f_user1_clk", NULL, s2f_user1_mux, ARRAY_SIZE(s2f_user1_mux), 0, 0x7C,
 	  6, 0, 0, 0, 0x88, 5, 0},
 	{ AGILEX_PSI_REF_CLK, "psi_ref_clk", NULL, psi_mux, ARRAY_SIZE(psi_mux), 0, 0x7C,
-- 
2.25.1

