Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89835595055
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 06:41:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231387AbiHPEkR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Aug 2022 00:40:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42634 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230418AbiHPEjs (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 16 Aug 2022 00:39:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E524CE318;
        Mon, 15 Aug 2022 13:31:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F1C6061089;
        Mon, 15 Aug 2022 20:31:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC084C433D6;
        Mon, 15 Aug 2022 20:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660595476;
        bh=TC7u+XgfGfTMxPRPSERVYjV9ZDYG1QScUUBzh6/c8fc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SKYi74NJz6AUXhZ27XChGtm1wHEO42PxtkkmimrJVeoLS3VENp1EPE1uFecoO/hWR
         qHxtKIdgZtZI39k0qcDXRBZ7+9TrAjR7jp8HOZd6ZcnONCDsA9l8sCW82OvfbbHKEH
         1tg5xWyhGdiUp39H6xbUKyf6WdEayY9HMn2jdgK8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0759/1157] clk: qcom: camcc-sdm845: Fix topology around titan_top power domain
Date:   Mon, 15 Aug 2022 20:01:55 +0200
Message-Id: <20220815180509.854462441@linuxfoundation.org>
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 103dd2338bbff567bce7acd00fc5a09c806b38ec ]

On SDM845 two found VFE GDSC power domains shall not be operated, if
titan top is turned off, thus the former power domains will be set as
subdomains by a GDSC registration routine.

Fixes: 78412c262004 ("clk: qcom: Add camera clock controller driver for SDM845")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220519214133.1728979-2-vladimir.zapolskiy@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sdm845.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/qcom/camcc-sdm845.c b/drivers/clk/qcom/camcc-sdm845.c
index be3f95326965..27d44188a7ab 100644
--- a/drivers/clk/qcom/camcc-sdm845.c
+++ b/drivers/clk/qcom/camcc-sdm845.c
@@ -1534,6 +1534,8 @@ static struct clk_branch cam_cc_sys_tmr_clk = {
 	},
 };
 
+static struct gdsc titan_top_gdsc;
+
 static struct gdsc bps_gdsc = {
 	.gdscr = 0x6004,
 	.pd = {
@@ -1567,6 +1569,7 @@ static struct gdsc ife_0_gdsc = {
 		.name = "ife_0_gdsc",
 	},
 	.flags = POLL_CFG_GDSCR,
+	.parent = &titan_top_gdsc.pd,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
@@ -1576,6 +1579,7 @@ static struct gdsc ife_1_gdsc = {
 		.name = "ife_1_gdsc",
 	},
 	.flags = POLL_CFG_GDSCR,
+	.parent = &titan_top_gdsc.pd,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.35.1



