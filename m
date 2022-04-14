Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B8C850143A
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:25:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244395AbiDNNeC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:34:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245123AbiDNN2f (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:28:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17238A9948;
        Thu, 14 Apr 2022 06:21:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A15D5618C4;
        Thu, 14 Apr 2022 13:21:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD362C385A1;
        Thu, 14 Apr 2022 13:21:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649942505;
        bh=2emTBnf1uuGoa0a4EPhs8gmI6znVRvgX5bYen/w9dnc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XOIMgv754KfPLy7vrjg4tqmRU0mXo6g1mGTAB29eF05t5pg9S87usiJeSbcHI6PWj
         8I/1fFhm6sQuMnI1aokK7fmSA5ol9KhZGkMSmJmyQ3ViKUtjW9Q51OkCZP7TaUoF5A
         TFnl+NWYd5UD0VO337JxkdsQhAOIlEVsidkMZb0s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Buchwalder <buchwalder@posteo.de>,
        Robert Marko <robimarko@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 161/338] clk: qcom: ipq8074: Use floor ops for SDCC1 clock
Date:   Thu, 14 Apr 2022 15:11:04 +0200
Message-Id: <20220414110843.482937134@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110838.883074566@linuxfoundation.org>
References: <20220414110838.883074566@linuxfoundation.org>
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
index 505c6263141d..708c486a6e96 100644
--- a/drivers/clk/qcom/gcc-ipq8074.c
+++ b/drivers/clk/qcom/gcc-ipq8074.c
@@ -1082,7 +1082,7 @@ static struct clk_rcg2 sdcc1_apps_clk_src = {
 		.name = "sdcc1_apps_clk_src",
 		.parent_names = gcc_xo_gpll0_gpll2_gpll0_out_main_div2,
 		.num_parents = 4,
-		.ops = &clk_rcg2_ops,
+		.ops = &clk_rcg2_floor_ops,
 	},
 };
 
-- 
2.34.1



