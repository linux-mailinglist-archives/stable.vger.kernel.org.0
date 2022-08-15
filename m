Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E187859422B
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349320AbiHOVpP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 17:45:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48304 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349333AbiHOVnO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 17:43:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1EE6C57BE;
        Mon, 15 Aug 2022 12:29:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0F6C1B810C6;
        Mon, 15 Aug 2022 19:29:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5750FC433C1;
        Mon, 15 Aug 2022 19:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660591780;
        bh=jOFUmOin2soedTIGfZkBJaD3YTlBujDsu4f/pQUr+Tk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eiHFntFVpbyz75+bJnwn85mFWMkPYz57/oAuh83gIMV5kfaq2Uh30W2+9BcWlQwAm
         D4i9D6/2B9byTbUDUStGo9BjfGaYapdedPzHIo1r/3wzpIH7XgJdywVDL8/Vyd1zDZ
         k8eVhF+XIom6eAqDfj/XWYlwv7CVev8qvyVcakYY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
        Jacky Bai <ping.bai@nxp.com>, Abel Vesa <abel.vesa@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0680/1095] clk: imx: clk-fracn-gppll: correct rdiv
Date:   Mon, 15 Aug 2022 20:01:19 +0200
Message-Id: <20220815180457.505796844@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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



