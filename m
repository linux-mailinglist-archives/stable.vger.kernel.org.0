Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4FAE59386F
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 21:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245588AbiHOTSv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 15:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344764AbiHOTR0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 15:17:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FF625508D;
        Mon, 15 Aug 2022 11:38:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7D93161135;
        Mon, 15 Aug 2022 18:38:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EA01C433D6;
        Mon, 15 Aug 2022 18:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660588725;
        bh=Ykk3jmbFM3PJt62sxcizrmy6rHAzlSYX/3dokANt3sM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pGcvSHxeC++8hJW4OX92m7u80PA0coMnm71gsrfNgRUl2nI22bPGwez1RSkdN+qvH
         ZY2fm8kKhUeiPgJBWPUbmVlpcYjNu5YWUT8DeePQYOG+n6A26VnsUo/BcBNFw0fQd0
         uUe5JHvSFsRLCSW3Cv+mXDMR7hVumwLc4LCrrCps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
        Robert Foss <robert.foss@linaro.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 455/779] clk: qcom: camcc-sm8250: Fix topology around titan_top power domain
Date:   Mon, 15 Aug 2022 20:01:39 +0200
Message-Id: <20220815180356.727742293@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

[ Upstream commit f8acf01a6a4f84baf05181e24bd48def4ba23f5b ]

On SM8250 two found VFE GDSC power domains shall not be operated, if
titan top is turned off, thus the former power domains will be set as
subdomains by a GDSC registration routine.

Fixes: 5d66ca79b58c ("clk: qcom: Add camera clock controller driver for SM8250")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
Link: https://lore.kernel.org/r/20220519214133.1728979-3-vladimir.zapolskiy@linaro.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/qcom/camcc-sm8250.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/clk/qcom/camcc-sm8250.c b/drivers/clk/qcom/camcc-sm8250.c
index ae4e9774f36e..9b32c56a5bc5 100644
--- a/drivers/clk/qcom/camcc-sm8250.c
+++ b/drivers/clk/qcom/camcc-sm8250.c
@@ -2205,6 +2205,8 @@ static struct clk_branch cam_cc_sleep_clk = {
 	},
 };
 
+static struct gdsc titan_top_gdsc;
+
 static struct gdsc bps_gdsc = {
 	.gdscr = 0x7004,
 	.pd = {
@@ -2238,6 +2240,7 @@ static struct gdsc ife_0_gdsc = {
 		.name = "ife_0_gdsc",
 	},
 	.flags = POLL_CFG_GDSCR,
+	.parent = &titan_top_gdsc.pd,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
@@ -2247,6 +2250,7 @@ static struct gdsc ife_1_gdsc = {
 		.name = "ife_1_gdsc",
 	},
 	.flags = POLL_CFG_GDSCR,
+	.parent = &titan_top_gdsc.pd,
 	.pwrsts = PWRSTS_OFF_ON,
 };
 
-- 
2.35.1



