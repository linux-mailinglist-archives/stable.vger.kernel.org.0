Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B5A475E9C
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245506AbhLORXW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245359AbhLORXF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41AE2C061757;
        Wed, 15 Dec 2021 09:23:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D624D619EE;
        Wed, 15 Dec 2021 17:23:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BADE8C36AE0;
        Wed, 15 Dec 2021 17:23:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588984;
        bh=P+3qdBDj1wVMgNK7WHDx9rReUfcs29bW9Xb2Ey9LUaA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WbF+mW3sG65W8RBFKHTWtDEU7+R4na44lhEH1hHDO7J1q5OCcL5Pap5UY5x9KqBu8
         0mnxp7YJlQOxCTORC0O0V+c9PD3LifyP6AhBlXg0IPWcAWtHD+Tvsn+qkiNGsqEQ9z
         mKUCqg9rpFLHVP57l6tBHBEftIIHKqJcCuv6pzro=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin Botka <martin.botka@somainline.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Stephen Boyd <sboyd@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 09/42] clk: qcom: sm6125-gcc: Swap ops of ice and apps on sdcc1
Date:   Wed, 15 Dec 2021 18:20:50 +0100
Message-Id: <20211215172026.958058206@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin Botka <martin.botka@somainline.org>

[ Upstream commit e53f2086856c16ccab80fd0ac012baa1ae88af73 ]

Without this change eMMC runs at overclocked freq.
Swap the ops to not OC the eMMC.

Signed-off-by: Martin Botka <martin.botka@somainline.org>
Link: https://lore.kernel.org/r/20211130212015.25232-1-martin.botka@somainline.org
Reviewed-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Fixes: 4b8d6ae57cdf ("clk: qcom: Add SM6125 (TRINKET) GCC driver")
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-sm6125.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/qcom/gcc-sm6125.c b/drivers/clk/qcom/gcc-sm6125.c
index 543cfab7561f9..431b55bb0d2f7 100644
--- a/drivers/clk/qcom/gcc-sm6125.c
+++ b/drivers/clk/qcom/gcc-sm6125.c
@@ -1121,7 +1121,7 @@ static struct clk_rcg2 gcc_sdcc1_apps_clk_src = {
 		.name = "gcc_sdcc1_apps_clk_src",
 		.parent_data = gcc_parent_data_1,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_1),
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
@@ -1143,7 +1143,7 @@ static struct clk_rcg2 gcc_sdcc1_ice_core_clk_src = {
 		.name = "gcc_sdcc1_ice_core_clk_src",
 		.parent_data = gcc_parent_data_0,
 		.num_parents = ARRAY_SIZE(gcc_parent_data_0),
-		.ops = &clk_rcg2_floor_ops,
+		.ops = &clk_rcg2_ops,
 	},
 };
 
-- 
2.33.0



