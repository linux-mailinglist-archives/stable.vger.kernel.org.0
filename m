Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 216CF40E177
	for <lists+stable@lfdr.de>; Thu, 16 Sep 2021 18:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240978AbhIPQao (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Sep 2021 12:30:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:38434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239405AbhIPQ15 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Sep 2021 12:27:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E1A3F61353;
        Thu, 16 Sep 2021 16:17:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631809075;
        bh=szLksIY6Ch1woieb4w6JYLrB6BgT+cHFbmRaknwToZQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qxOk2sU2qtrCCD9phZEdmUe+KJCY/mh6lQ9D5KJ92e25Z8DlrmnmXbo6scydG++xC
         QYIPKYfWr8042FdvNnzDU+VNVkXJCnvF6swSD/4n31FCJlcK0MeJT6xZ94y4G6QDdI
         G4jBgzHReORpZBs5RlWCQ51PmVaafw7aHdtFRfDU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kris Chaplin <kris.chaplin@intel.com>,
        Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.13 021/380] clk: socfpga: agilex: fix up s2f_user0_clk representation
Date:   Thu, 16 Sep 2021 17:56:18 +0200
Message-Id: <20210916155804.693326418@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210916155803.966362085@linuxfoundation.org>
References: <20210916155803.966362085@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit f817c132db679d492d96c60993fa2f2c67ab18d0 upstream.

Correct the s2f_user0_mux clock representation.

Fixes: 80c6b7a0894f ("clk: socfpga: agilex: add clock driver for the Agilex platform")
Cc: stable@vger.kernel.org
Signed-off-by: Kris Chaplin <kris.chaplin@intel.com>
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210713144621.605140-2-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/socfpga/clk-agilex.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -195,6 +195,13 @@ static const struct clk_parent_data sdmm
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
@@ -319,6 +326,8 @@ static const struct stratix10_gate_clock
 	  4, 0x98, 0, 16, 0x88, 3, 0},
 	{ AGILEX_SDMMC_CLK, "sdmmc_clk", NULL, sdmmc_mux, ARRAY_SIZE(sdmmc_mux), 0, 0x7C,
 	  5, 0, 0, 0, 0x88, 4, 4},
+	{ AGILEX_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_user0_mux, ARRAY_SIZE(s2f_user0_mux), 0, 0x24,
+	  6, 0, 0, 0, 0x30, 2, 0},
 	{ AGILEX_S2F_USER1_CLK, "s2f_user1_clk", NULL, s2f_user1_mux, ARRAY_SIZE(s2f_user1_mux), 0, 0x7C,
 	  6, 0, 0, 0, 0x88, 5, 0},
 	{ AGILEX_PSI_REF_CLK, "psi_ref_clk", NULL, psi_mux, ARRAY_SIZE(psi_mux), 0, 0x7C,


