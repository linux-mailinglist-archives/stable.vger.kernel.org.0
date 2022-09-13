Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA2F5B7022
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:24:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232538AbiIMOU3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:20:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233470AbiIMOTH (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:19:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C47D5F9AA;
        Tue, 13 Sep 2022 07:13:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6D43614C3;
        Tue, 13 Sep 2022 14:12:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC70FC433C1;
        Tue, 13 Sep 2022 14:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078351;
        bh=Sx5FLx/0TNQK4xSChupZ8AgyNTyWLefkXDgs+Z1QN9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hCA/hI36MTutkezqEhl1JqmbpWGD/kwyH6UNJiR8wrR5vnLSZFbT/aTacOMacucPk
         Cz8PBT+tmWySpT7L/05wtbpD9lTDp1HR/GPHgQF2jmrG7dgnWrt8e+u/bRQEu1qMso
         a56Y5lOQHWuByCpjZBPeD6NddnUKBLH3y+ydlwNQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Fabio Estevam <festevam@denx.de>,
        Lucas Stach <l.stach@pengutronix.de>,
        Shawn Guo <shawnguo@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 079/192] soc: imx: gpcv2: Assert reset before ungating clock
Date:   Tue, 13 Sep 2022 16:03:05 +0200
Message-Id: <20220913140413.898707485@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140410.043243217@linuxfoundation.org>
References: <20220913140410.043243217@linuxfoundation.org>
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
index 85aa86e1338af..5a3809f6a698f 100644
--- a/drivers/soc/imx/gpcv2.c
+++ b/drivers/soc/imx/gpcv2.c
@@ -333,6 +333,8 @@ static int imx_pgc_power_up(struct generic_pm_domain *genpd)
 		}
 	}
 
+	reset_control_assert(domain->reset);
+
 	/* Enable reset clocks for all devices in the domain */
 	ret = clk_bulk_prepare_enable(domain->num_clks, domain->clks);
 	if (ret) {
@@ -340,7 +342,8 @@ static int imx_pgc_power_up(struct generic_pm_domain *genpd)
 		goto out_regulator_disable;
 	}
 
-	reset_control_assert(domain->reset);
+	/* delays for reset to propagate */
+	udelay(5);
 
 	if (domain->bits.pxx) {
 		/* request the domain to power up */
-- 
2.35.1



