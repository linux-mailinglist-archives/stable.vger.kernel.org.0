Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B0E8C594B51
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:23:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351190AbiHPAOh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 20:14:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357175AbiHPANI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 20:13:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 693F1176DD6;
        Mon, 15 Aug 2022 13:30:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 02C5C61072;
        Mon, 15 Aug 2022 20:30:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1CF8C433C1;
        Mon, 15 Aug 2022 20:29:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595400;
        bh=jOFUmOin2soedTIGfZkBJaD3YTlBujDsu4f/pQUr+Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0srCvjuLGND4SrbucdoFdXvmpHYyGJjxDQM0ADUaWun0c1NucNsApZ30uZa9aBBAS
         A/vdbIsDBgOSz8x23lD6w3Bg7RaAmhwkW7gd5xHtZ1FrH8VhGJwnaZAf/oLXSwT1bf
         K45ESl2IF/WIFmZ5srdRqkaIh7UzG7pXXCam7Gvs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>, Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0725/1157] clk: imx: clk-fracn-gppll: correct rdiv
Date:   Mon, 15 Aug 2022 20:01:21 +0200
Message-Id: <20220815180508.485164181@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

[ Upstream commit f300cb7fccf69ba1835b983c76d70deb818ad194 ]

According to Reference Manual:
 000b - Divide by 1
 001b - Divide by 1
 010b - Divide by 2
 011b - Divide by 3
 100b - Divide by 4
 101b - Divide by 5
 110b - Divide by 6
 111b - Divide by 7

So only need increase rdiv by 1 when the register value is 0.

Fixes: 1b26cb8a77a4 ("clk: imx: support fracn gppll")
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Reviewed-by: Jacky Bai <ping.bai@nxp.com>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/20220609132902.3504651-7-peng.fan@oss.nxp.com
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-fracn-gppll.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/imx/clk-fracn-gppll.c b/drivers/clk/imx/clk-fracn-gppll.c
index cb06b0045e9e..025b73229cdd 100644
--- a/drivers/clk/imx/clk-fracn-gppll.c
+++ b/drivers/clk/imx/clk-fracn-gppll.c
@@ -149,7 +149,8 @@ static unsigned long clk_fracn_gppll_recalc_rate(struct clk_hw *hw, unsigned lon
 	if (rate)
 		return (unsigned long)rate;
 
-	rdiv = rdiv + 1;
+	if (!rdiv)
+		rdiv = rdiv + 1;
 
 	switch (odiv) {
 	case 0:
-- 
2.35.1



