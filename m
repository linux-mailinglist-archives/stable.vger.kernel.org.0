Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ECF47431D7D
	for <lists+stable@lfdr.de>; Mon, 18 Oct 2021 15:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233848AbhJRNwB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Oct 2021 09:52:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:50498 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233913AbhJRNuE (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Oct 2021 09:50:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AD88661372;
        Mon, 18 Oct 2021 13:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1634564262;
        bh=TGd4R4fke0CbmrxFp1v9G1VKwwsv78pOKjAsmXTOQDg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GUP1gwNB+CHjU044f7GUH7GVNQwyOT08Zi4Gvf0IdOKttBD5DgFXu5c0maGYaft2B
         HfllafQ51WOs9ctShNs9siqcMmwxTVzG6MQ+RlIyp50dmKffT/yd8rZnsUgD/gQiht
         f3tZTuJV07fkcL+wEgjmpRuvR8qU7xLGQsMG/HwQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dinh Nguyen <dinguyen@kernel.org>,
        Stephen Boyd <sboyd@kernel.org>
Subject: [PATCH 5.14 022/151] clk: socfpga: agilex: fix duplicate s2f_user0_clk
Date:   Mon, 18 Oct 2021 15:23:21 +0200
Message-Id: <20211018132341.398773864@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211018132340.682786018@linuxfoundation.org>
References: <20211018132340.682786018@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dinh Nguyen <dinguyen@kernel.org>

commit 09540fa337196be20e9f0241652364f09275d374 upstream.

Remove the duplicate s2f_user0_clk and the unused s2f_usr0_mux define.

Fixes: f817c132db67 ("clk: socfpga: agilex: fix up s2f_user0_clk representation")
Cc: stable@vger.kernel.org
Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
Link: https://lore.kernel.org/r/20210916225126.1427700-1-dinguyen@kernel.org
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/clk/socfpga/clk-agilex.c |    9 ---------
 1 file changed, 9 deletions(-)

--- a/drivers/clk/socfpga/clk-agilex.c
+++ b/drivers/clk/socfpga/clk-agilex.c
@@ -165,13 +165,6 @@ static const struct clk_parent_data mpu_
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
@@ -312,8 +305,6 @@ static const struct stratix10_gate_clock
 	  4, 0x44, 28, 1, 0, 0, 0},
 	{ AGILEX_CS_TIMER_CLK, "cs_timer_clk", NULL, noc_mux, ARRAY_SIZE(noc_mux), 0, 0x24,
 	  5, 0, 0, 0, 0x30, 1, 0},
-	{ AGILEX_S2F_USER0_CLK, "s2f_user0_clk", NULL, s2f_usr0_mux, ARRAY_SIZE(s2f_usr0_mux), 0, 0x24,
-	  6, 0, 0, 0, 0, 0, 0},
 	{ AGILEX_EMAC0_CLK, "emac0_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,
 	  0, 0, 0, 0, 0x94, 26, 0},
 	{ AGILEX_EMAC1_CLK, "emac1_clk", NULL, emac_mux, ARRAY_SIZE(emac_mux), 0, 0x7C,


