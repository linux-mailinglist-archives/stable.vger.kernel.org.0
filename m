Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D3F54F30C3
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 14:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350185AbiDEJ4H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 05:56:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238451AbiDEJQG (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:16:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 081D4972A1;
        Tue,  5 Apr 2022 02:01:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 984F461562;
        Tue,  5 Apr 2022 09:01:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F03C385A3;
        Tue,  5 Apr 2022 09:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649149292;
        bh=hgwv3Bsh45tJ1pWCJ/OiWav3TISg2Dhm7A/oWtm79mM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S5ujDD/jHHn49JLU88rp16swnLpJo7NESgT9SKYcTk4+mz6aSGk+BbLZS1u34P7zv
         xYpunkQwd57dT6vzY8+jPfrajaudV9VSIPjRwmKVoWUhVHdrDsHxSkh3CYxyanoew+
         3rNjRwKRmtCaYpoRhjK8B12nYr2PPdkHBhhBo/s8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Buchwalder <buchwalder@posteo.de>,
        Robert Marko <robimarko@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0662/1017] clk: qcom: ipq8074: Use floor ops for SDCC1 clock
Date:   Tue,  5 Apr 2022 09:26:15 +0200
Message-Id: <20220405070413.933080407@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070354.155796697@linuxfoundation.org>
References: <20220405070354.155796697@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dirk Buchwalder <buchwalder@posteo.de>

[ Upstream commit b77d8306d84f83d1da68028a68c91da9c867b6f6 ]

Use floor ops on SDCC1 APPS clock in order to round down selected clock
frequency and avoid overclocking SD/eMMC cards.

For example, currently HS200 cards were failling tuning as they were
actually being clocked at 384MHz instead of 192MHz.
This caused some boards to disable 1.8V I/O and force the eMMC into the
standard HS mode (50MHz) and that appeared to work despite the eMMC being
overclocked to 96Mhz in that case.

There was a previous commit to use floor ops on SDCC clocks, but it looks
to have only covered SDCC2 clock.

Fixes: 9607f6224b39 ("clk: qcom: ipq8074: add PCIE, USB and SDCC clocks")

Signed-off-by: Dirk Buchwalder <buchwalder@posteo.de>
Signed-off-by: Robert Marko <robimarko@gmail.com>
Reviewed-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220210173100.505128-1-robimarko@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/gcc-ipq8074.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/clk/qcom/gcc-ipq8074.c b/drivers/clk/qcom/gcc-ipq8074.c
index b09d99343e09..541016db3c4b 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -1074,7 +1074,7 @@ static struct clk_rcg2 sdcc1_apps_clk_src = {
 		.name = "sdcc1_apps_clk_src",
 		.parent_names = gcc_xo_gpll0_gpll2_gpll0_out_main_div2,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
-- 
2.34.1



