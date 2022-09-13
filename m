Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6548F5B705F
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:32:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233893AbiIMOaN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:30:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234110AbiIMO3P (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:29:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1376269F7B;
        Tue, 13 Sep 2022 07:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD331614D3;
        Tue, 13 Sep 2022 14:18:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29BFC433B5;
        Tue, 13 Sep 2022 14:18:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078710;
        bh=jdQJzVCzjLUTb3ZpmMeyFG8CG9PEmt2WyOOQ37iFBTY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y2hrCpHHV5L/kOt67Up9LO12mClC8D5pPLkBxcfbrCOHt5S/2vcVIp9bTa45iUXoH
         l/dZSQjUWeDkG+BEnpH1ulXjuK8GLxElRHTy5FiIRCKuIAg1qf6SnJK6Cuv5WrjtEA
         wDP70Tl1Y62XvlNgWDb7tCxIrZa6Dn4sqZn6J3kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 053/121] soc: imx: gpcv2: Assert reset before ungating clock
Date:   Tue, 13 Sep 2022 16:04:04 +0200
Message-Id: <20220913140359.635650807@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit df88005bd81b80c944d185554e264a4b0f993c37 ]

In case the power domain clock are ungated before the reset is asserted,
the system might freeze completely. This is likely due to a device is an
undefined state being attached to bus, which sporadically leads to a bus
hang. Assert the reset before the clock are enabled to assure the device
is in defined state before being attached to bus.

Fixes: fe58c887fb8ca ("soc: imx: gpcv2: add support for optional resets")
Signed-off-by: Marek Vasut <marex@denx.de>
Reviewed-by: Fabio Estevam <festevam@denx.de>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/imx/gpcv2.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/imx/gpcv2.c b/drivers/soc/imx/gpcv2.c
index b4aa28420f2a8..4dc3a3f73511e 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -237,6 +237,8 @@ static int imx_pgc_power_up(struct generic_pm_domain *genpd)
 		}
 	}
 
+	reset_control_assert(domain->reset);
+
 	/* Enable reset clocks for all devices in the domain */
 	ret = clk_bulk_prepare_enable(domain->num_clks, domain->clks);
 	if (ret) {
@@ -244,7 +246,8 @@ static int imx_pgc_power_up(struct generic_pm_domain *genpd)
 		goto out_regulator_disable;
 	}
 
-	reset_control_assert(domain->reset);
+	/* delays for reset to propagate */
+	udelay(5);
 
 	if (domain->bits.pxx) {
 		/* request the domain to power up */
-- 
2.35.1



