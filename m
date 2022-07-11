Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB60856FB90
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:32:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiGKJcR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:32:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232682AbiGKJbh (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:31:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8EA2C74DF0;
        Mon, 11 Jul 2022 02:17:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2D7F5B80D2C;
        Mon, 11 Jul 2022 09:17:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89A83C341CB;
        Mon, 11 Jul 2022 09:17:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531032;
        bh=mlI1Uud6q9h62IR3vOayBWgTsVubl46hJHtd1vn7oWI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAIL7HEO1c83jT0NM+3MBtSUp7GrRZCLIAH9X88sh8ggn4cbkj7JyfQmz71b8JE22
         HZ27jKGjQFM5fpsKjJtgPQSE2mBD3qQ2TgJZQ79XxhlD/gFwvbByZYGnxRtthVRaOb
         98EK3oOkybzphEefeWWwvQutQfwP5kYWWTkdhS9E=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 071/112] ARM: at91: pm: use proper compatibles for sam9x60s rtc and rtt
Date:   Mon, 11 Jul 2022 11:07:11 +0200
Message-Id: <20220711090551.588383999@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090549.543317027@linuxfoundation.org>
References: <20220711090549.543317027@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Claudiu Beznea <claudiu.beznea@microchip.com>

[ Upstream commit 641522665dbb25ce117c78746df1aad8b58c80e5 ]

Use proper compatible strings for SAM9X60's RTC and RTT IPs. These are
necessary for configuring wakeup sources for ULP1 PM mode.

Fixes: eaedc0d379da ("ARM: at91: pm: add ULP1 support for SAM9X60")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220523092421.317345-3-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 0da13a7afa31..464b7dea5bbe 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -157,12 +157,12 @@ static const struct of_device_id sama5d2_ws_ids[] = {
 };
 
 static const struct of_device_id sam9x60_ws_ids[] = {
-	{ .compatible = "atmel,at91sam9x5-rtc",		.data = &ws_info[1] },
+	{ .compatible = "microchip,sam9x60-rtc",	.data = &ws_info[1] },
 	{ .compatible = "atmel,at91rm9200-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
 	{ .compatible = "atmel,at91sam9g45-ehci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ehci",			.data = &ws_info[2] },
-	{ .compatible = "atmel,at91sam9260-rtt",	.data = &ws_info[4] },
+	{ .compatible = "microchip,sam9x60-rtt",	.data = &ws_info[4] },
 	{ .compatible = "cdns,sam9x60-macb",		.data = &ws_info[5] },
 	{ /* sentinel */ }
 };
-- 
2.35.1



