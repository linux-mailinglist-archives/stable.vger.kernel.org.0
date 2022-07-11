Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BE9756FB8D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232683AbiGKJcP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:32:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232677AbiGKJbf (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:31:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 143F574DDD;
        Mon, 11 Jul 2022 02:17:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 83C2DB80DB7;
        Mon, 11 Jul 2022 09:17:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5DD6C34115;
        Mon, 11 Jul 2022 09:17:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531030;
        bh=IScW0LFMmcTStFPx2URycrFLwFhfPk+cUhNi93H2wMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bnFeZpc7kD3FfA717v8R3QJC0V3yvUhfJeoHN01iHLPWOgQ0uFmBRKDsetsznL0DV
         TkDFEbl3X3G0TiL7LmPM611AIZBMSqa/569AkzGUfs4yhEIS+FquXNUkvaH9aDYtXU
         lzN9V+vrZT6gl33MNeblRbncyvac3RXan/gSyT1Y=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 070/112] ARM: at91: pm: use proper compatible for sama5d2s rtc
Date:   Mon, 11 Jul 2022 11:07:10 +0200
Message-Id: <20220711090551.560301623@linuxfoundation.org>
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

[ Upstream commit ddc980da8043779119acaca106c6d9b445c9b65b ]

Use proper compatible strings for SAMA5D2's RTC IPs. This is necessary
for configuring wakeup sources for ULP1 PM mode.

Fixes: d7484f5c6b3b ("ARM: at91: pm: configure wakeup sources for ULP1 mode")
Signed-off-by: Claudiu Beznea <claudiu.beznea@microchip.com>
Link: https://lore.kernel.org/r/20220523092421.317345-2-claudiu.beznea@microchip.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/mach-at91/pm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arm/mach-at91/pm.c b/arch/arm/mach-at91/pm.c
index 0fd609e26615..0da13a7afa31 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -146,7 +146,7 @@ static const struct wakeup_source_info ws_info[] = {
 
 static const struct of_device_id sama5d2_ws_ids[] = {
 	{ .compatible = "atmel,sama5d2-gem",		.data = &ws_info[0] },
-	{ .compatible = "atmel,at91rm9200-rtc",		.data = &ws_info[1] },
+	{ .compatible = "atmel,sama5d2-rtc",		.data = &ws_info[1] },
 	{ .compatible = "atmel,sama5d3-udc",		.data = &ws_info[2] },
 	{ .compatible = "atmel,at91rm9200-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
-- 
2.35.1



