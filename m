Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F014D56FA22
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:13:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiGKJNh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:13:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231414AbiGKJNE (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:13:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D38232E9D8;
        Mon, 11 Jul 2022 02:09:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 66239B80E5E;
        Mon, 11 Jul 2022 09:09:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0D61C34115;
        Mon, 11 Jul 2022 09:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530575;
        bh=xq8HCtW37IJxYLJS4TXRzEzTYs1HB5K7at8Nguj+mgY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWOEoEaStpFIq9rj9Otfcp6P4NWsnmxuZIJrWazxS9+IOMnKoncecNkibQ4andFuF
         Aws1iww4jRKbAXYS/HY67J1RBNLf6oHcOvLLQeBY38ZMIyu8nyWPMapK/EzT9IAHmE
         5rtq2J2Hi7m/w5X3EZjBihE4K4DHGjm1v2EFIwLY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 18/31] ARM: at91: pm: use proper compatible for sama5d2s rtc
Date:   Mon, 11 Jul 2022 11:06:57 +0200
Message-Id: <20220711090538.386364976@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090537.841305347@linuxfoundation.org>
References: <20220711090537.841305347@linuxfoundation.org>
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
index 21bfe9b6e16a..3ba0c6c560d8 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -95,7 +95,7 @@ static const struct wakeup_source_info ws_info[] = {
 
 static const struct of_device_id sama5d2_ws_ids[] = {
 	{ .compatible = "atmel,sama5d2-gem",		.data = &ws_info[0] },
-	{ .compatible = "atmel,at91rm9200-rtc",		.data = &ws_info[1] },
+	{ .compatible = "atmel,sama5d2-rtc",		.data = &ws_info[1] },
 	{ .compatible = "atmel,sama5d3-udc",		.data = &ws_info[2] },
 	{ .compatible = "atmel,at91rm9200-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
-- 
2.35.1



