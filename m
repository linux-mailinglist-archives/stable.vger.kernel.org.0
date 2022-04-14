Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3399501261
	for <lists+stable@lfdr.de>; Thu, 14 Apr 2022 17:08:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345668AbiDNNx7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Apr 2022 09:53:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344942AbiDNNo4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Apr 2022 09:44:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 433F920BD0;
        Thu, 14 Apr 2022 06:40:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D4ACCB8296A;
        Thu, 14 Apr 2022 13:40:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 230CCC385A5;
        Thu, 14 Apr 2022 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649943648;
        bh=JNSG1rIavWuc32cfnqIlfwykyPVOl3m3sKZGU3GSBw4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aYcHsEu91R+sFGkYyAN50XRblrZKlQYP1MKssh1nOjxwoHYt3mmSnE7CmYWvNxwwN
         kPpNR1EGHsLK0VTtsEPcTKlBTSZFKQPM8Xi80SdQtffuget+UzWROljHblUZI9ufJE
         ZZYcrNr5xRSvKIXczDitajCFUxXOuhv1yG0iJOj4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dirk Buchwalder <buchwalder@posteo.de>,
        Robert Marko <robimarko@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 232/475] clk: qcom: ipq8074: Use floor ops for SDCC1 clock
Date:   Thu, 14 Apr 2022 15:10:17 +0200
Message-Id: <20220414110901.614985022@linuxfoundation.org>
X-Mailer: git-send-email 2.35.2
In-Reply-To: <20220414110855.141582785@linuxfoundation.org>
References: <20220414110855.141582785@linuxfoundation.org>
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
index e01f5f591d1e..de48ba7eba3a 100644
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



