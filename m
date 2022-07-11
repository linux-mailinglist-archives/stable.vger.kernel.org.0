Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCD7856FAC6
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231944AbiGKJVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:21:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231779AbiGKJVH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:21:07 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D9162B272;
        Mon, 11 Jul 2022 02:12:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 25A9B61188;
        Mon, 11 Jul 2022 09:12:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BA33C34115;
        Mon, 11 Jul 2022 09:12:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657530773;
        bh=5q/ing+ZFjHHIXvmreVU/uaobiUDzeN2y1kR0B3z56w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CKMjjVFYLECO0FOKddIFWSecOEnvpB8xIJ0I1nQyvJ+3yVMrSzlV8ED2CfpUEK7pG
         JURSyjs3u2TF2jXYeVKZnVYdcx/zmpbKun1onqDLWRCsdZ2wSdicW2JVYRRdrcd/71
         olHnV/cubWPuZs3q66NDhsc+5geqHgUdjX1EM7ZM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 34/55] ARM: at91: pm: use proper compatible for sama5d2s rtc
Date:   Mon, 11 Jul 2022 11:07:22 +0200
Message-Id: <20220711090542.767387434@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090541.764895984@linuxfoundation.org>
References: <20220711090541.764895984@linuxfoundation.org>
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
index 3f015cb6ec2b..6a68ff0466e0 100644
--- a/arch/arm/mach-at91/pm.c
+++ b/arch/arm/mach-at91/pm.c
@@ -104,7 +104,7 @@ static const struct wakeup_source_info ws_info[] = {
 
 static const struct of_device_id sama5d2_ws_ids[] = {
 	{ .compatible = "atmel,sama5d2-gem",		.data = &ws_info[0] },
-	{ .compatible = "atmel,at91rm9200-rtc",		.data = &ws_info[1] },
+	{ .compatible = "atmel,sama5d2-rtc",		.data = &ws_info[1] },
 	{ .compatible = "atmel,sama5d3-udc",		.data = &ws_info[2] },
 	{ .compatible = "atmel,at91rm9200-ohci",	.data = &ws_info[2] },
 	{ .compatible = "usb-ohci",			.data = &ws_info[2] },
-- 
2.35.1



