Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 612275316B9
	for <lists+stable@lfdr.de>; Mon, 23 May 2022 22:52:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241620AbiEWRdu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 May 2022 13:33:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242379AbiEWRc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 23 May 2022 13:32:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACB4D72E1A;
        Mon, 23 May 2022 10:27:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7772660AB8;
        Mon, 23 May 2022 17:27:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 806E4C385AA;
        Mon, 23 May 2022 17:27:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1653326831;
        bh=7y2CQznIYaNLnJfzqbrtnBIEIajSKZwOQDySGCkC2mA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g2SOlOHaAsz4Y0GT5+n/UfFWTr8aXZB010Jkx8UXG3wGFK0OUb7hVYWD+lsHcLGHn
         mBoC3d9KyQWi5CMgmmQuwkK6PRSoslimOMaOnmgtAo5uBDzHxSe24F+/ft6tUAB3Yy
         AcvngXc0y51LcinLmQODbDvVhrxL0SyKzMm4a1wc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 073/158] pinctrl: ocelot: Fix for lan966x alt mode
Date:   Mon, 23 May 2022 19:03:50 +0200
Message-Id: <20220523165843.050863028@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220523165830.581652127@linuxfoundation.org>
References: <20220523165830.581652127@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit d3683eeb9d2b4aa5256f830721655ef2ee97e324 ]

For lan966x, the GPIO 35 has the wrong function for alternate mode 2.
The mode is not none but is PTP sync.

Fixes: 531d6ab36571c2 ("pinctrl: ocelot: Extend support for lan966x")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Kavyasree Kotagiri <kavyasree.kotagiri@microchip.com>
Link: https://lore.kernel.org/r/20220413192918.3777234-1-horatiu.vultur@microchip.com
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/pinctrl-ocelot.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/pinctrl/pinctrl-ocelot.c b/drivers/pinctrl/pinctrl-ocelot.c
index 370459243007..61e3844cddbf 100644
--- a/drivers/pinctrl/pinctrl-ocelot.c
+++ b/drivers/pinctrl/pinctrl-ocelot.c
@@ -129,6 +129,7 @@ enum {
 	FUNC_PTP1,
 	FUNC_PTP2,
 	FUNC_PTP3,
+	FUNC_PTPSYNC_0,
 	FUNC_PTPSYNC_1,
 	FUNC_PTPSYNC_2,
 	FUNC_PTPSYNC_3,
@@ -252,6 +253,7 @@ static const char *const ocelot_function_names[] = {
 	[FUNC_PTP1]		= "ptp1",
 	[FUNC_PTP2]		= "ptp2",
 	[FUNC_PTP3]		= "ptp3",
+	[FUNC_PTPSYNC_0]	= "ptpsync_0",
 	[FUNC_PTPSYNC_1]	= "ptpsync_1",
 	[FUNC_PTPSYNC_2]	= "ptpsync_2",
 	[FUNC_PTPSYNC_3]	= "ptpsync_3",
@@ -891,7 +893,7 @@ LAN966X_P(31,   GPIO,   FC3_c,     CAN1,      NONE,   OB_TRG,   RECO_b,      NON
 LAN966X_P(32,   GPIO,   FC3_c,     NONE,   SGPIO_a,     NONE,  MIIM_Sa,      NONE,        R);
 LAN966X_P(33,   GPIO,   FC1_b,     NONE,   SGPIO_a,     NONE,  MIIM_Sa,    MIIM_b,        R);
 LAN966X_P(34,   GPIO,   FC1_b,     NONE,   SGPIO_a,     NONE,  MIIM_Sa,    MIIM_b,        R);
-LAN966X_P(35,   GPIO,   FC1_b,     NONE,   SGPIO_a,   CAN0_b,     NONE,      NONE,        R);
+LAN966X_P(35,   GPIO,   FC1_b,  PTPSYNC_0, SGPIO_a,   CAN0_b,     NONE,      NONE,        R);
 LAN966X_P(36,   GPIO,    NONE,  PTPSYNC_1,    NONE,   CAN0_b,     NONE,      NONE,        R);
 LAN966X_P(37,   GPIO, FC_SHRD0, PTPSYNC_2, TWI_SLC_GATE_AD, NONE, NONE,      NONE,        R);
 LAN966X_P(38,   GPIO,    NONE,  PTPSYNC_3,    NONE,     NONE,     NONE,      NONE,        R);
-- 
2.35.1



