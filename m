Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A29A24F3843
	for <lists+stable@lfdr.de>; Tue,  5 Apr 2022 16:32:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376480AbiDELWO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Apr 2022 07:22:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349455AbiDEJtx (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Apr 2022 05:49:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BE3E627B;
        Tue,  5 Apr 2022 02:46:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA956B81B76;
        Tue,  5 Apr 2022 09:46:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3733FC385A2;
        Tue,  5 Apr 2022 09:46:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649151983;
        bh=3Yd5Mu6SsAllpJGL4JsS8KR3YEFLwzpdFT0ECOPKAYU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rv8S2D7ypcgpjk/zqEB660hHl0FLUcp3VyIKZLz7Cos39Hh5PHR375C8g8C2RO/aJ
         Zm+fcBoyaQgJI83QwVRHyV6O7gD91znj7+x9+Zvu73CMm6FmReopBf53y4hqJfyEFy
         81G9DyDo5cVIEbGyGTHbH3Ua2ggJWwQyURQjMBEs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Codrin Ciubotariu <codrin.ciubotariu@microchip.com>,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 611/913] clk: at91: sama7g5: fix parents of PDMCs GCLK
Date:   Tue,  5 Apr 2022 09:27:53 +0200
Message-Id: <20220405070358.156350707@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220405070339.801210740@linuxfoundation.org>
References: <20220405070339.801210740@linuxfoundation.org>
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

From: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>

[ Upstream commit 1a944729d8635fa59638f24e8727d5ccaa0c8c19 ]

Audio PLL can be used as parent by the GCLKs of PDMCs.

Fixes: cb783bbbcf54 ("clk: at91: sama7g5: add clock support for sama7g5")
Signed-off-by: Codrin Ciubotariu <codrin.ciubotariu@microchip.com>
Reviewed-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>
Link: https://lore.kernel.org/r/20220304182616.1920392-1-codrin.ciubotariu@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/at91/sama7g5.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/clk/at91/sama7g5.c b/drivers/clk/at91/sama7g5.c
index 019e712f90d6..9eed97a299d0 100644
--- a/drivers/clk/at91/sama7g5.c
+++ b/drivers/clk/at91/sama7g5.c
@@ -687,16 +687,16 @@ static const struct {
 	{ .n  = "pdmc0_gclk",
 	  .id = 68,
 	  .r = { .max = 50000000  },
-	  .pp = { "syspll_divpmcck", "baudpll_divpmcck", },
-	  .pp_mux_table = { 5, 8, },
+	  .pp = { "syspll_divpmcck", "audiopll_divpmcck", },
+	  .pp_mux_table = { 5, 9, },
 	  .pp_count = 2,
 	  .pp_chg_id = INT_MIN, },
 
 	{ .n  = "pdmc1_gclk",
 	  .id = 69,
 	  .r = { .max = 50000000, },
-	  .pp = { "syspll_divpmcck", "baudpll_divpmcck", },
-	  .pp_mux_table = { 5, 8, },
+	  .pp = { "syspll_divpmcck", "audiopll_divpmcck", },
+	  .pp_mux_table = { 5, 9, },
 	  .pp_count = 2,
 	  .pp_chg_id = INT_MIN, },
 
-- 
2.34.1



