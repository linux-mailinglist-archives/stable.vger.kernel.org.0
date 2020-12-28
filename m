Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 139AA2E4076
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:53:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgL1OwS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:52:18 -0500
Received: from mail.kernel.org ([198.145.29.99]:53992 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502012AbgL1OSu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:18:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 628FF2063A;
        Mon, 28 Dec 2020 14:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165089;
        bh=I7KN9RE/rgQ73uafjBQeSk8pFjgBk+T0c0TxwLU0UL8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QFwtVvq2C0w+87cW08UDH7Ts1Kx5xruE0g3GvKgMqz3FnLy2C1yrDYR/kriiyYPC+
         Is7tUI6GuCnpmbwJ6/7JoF6tavbKxxaVObff5LAjhrV3Nj3TiHfgkK4QfvBVC/8rqv
         xiXshS/CA481sB9ltKlqfHE+Tw0y6oeK4fvTW4ok=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Douglas Anderson <dianders@chromium.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 406/717] clk: qcom: gcc-sc7180: Use floor ops for sdcc clks
Date:   Mon, 28 Dec 2020 13:46:44 +0100
Message-Id: <20201228125040.440530127@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 6d37a8d192830267e6b10a6d57ae28d2e89097e7 ]

I would repeat the same commit message that was in commit 5e4b7e82d497
("clk: qcom: gcc-sdm845: Use floor ops for sdcc clks") but it seems
silly to do so when you could just go read that commit.

NOTE: this is actually extra terrible because we're missing the 50 MHz
rate in the table (see the next patch AKA ("clk: qcom: gcc-sc7180: Add
50 MHz clock rate for SDC2")).  That means then when you run an older
SD card it'll try to clock it at 100 MHz when it's only specced to run
at 50 MHz max.  As you can probably guess that doesn't work super
well.

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Fixes: 17269568f726 ("clk: qcom: Add Global Clock controller (GCC) driver for SC7180")
Link: https://lore.kernel.org/r/20201210102234.1.I096779f219625148900fc984dd0084ed1ba87c7f@changeid
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sc7180.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sc7180.c b/drivers/clk/qcom/gcc-sc7180.c
index 68d8f7aaf64e1..b080739ab0c33 100644
--- a/drivers/clk/qcom/gcc-sc7180.c
+++ b/drivers/clk/qcom/gcc-sc7180.c
@@ -642,7 +642,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.name = "gcc_sdcc1_ice_core_clk_src",
 		.parent_data = gcc_parent_data_0,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
@@ -666,7 +666,7 @@ static struct clk_rcg2 gcc_sdcc2_apps_clk_src = {
 		.name = "gcc_sdcc2_apps_clk_src",
 		.parent_data = gcc_parent_data_5,
 		.num_parents = 5,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
-- 
2.27.0



