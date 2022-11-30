Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D9F363DF43
	for <lists+stable@lfdr.de>; Wed, 30 Nov 2022 19:45:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231359AbiK3SpX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Nov 2022 13:45:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbiK3SpF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Nov 2022 13:45:05 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 656B391C1A;
        Wed, 30 Nov 2022 10:45:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E845361D72;
        Wed, 30 Nov 2022 18:45:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04B25C433C1;
        Wed, 30 Nov 2022 18:45:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669833903;
        bh=GIJWSieNXzkCReUUZPkRm/WaoB3VR46Y23qWuAXLJC4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ejVaeRJ9MP0Rutu4hsRycjP+lEq8fkvNq+QYivwFiCOUwWgp17JYmWzKW/1olSHNd
         2ai0KxnPFFTrpjE8ttOBEsd7uRJ62mMHh6FY6nthlKgcGDsmzEWEXu69b25JcgiVy3
         fpO70o4LO2a2jVXOTguSUlooC5cKV1x36N/sn8X0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, phone-devel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 049/289] power: supply: ab8500: Defer thermal zone probe
Date:   Wed, 30 Nov 2022 19:20:34 +0100
Message-Id: <20221130180545.241177022@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Walleij <linus.walleij@linaro.org>

[ Upstream commit 767e684367e4759d9855b184045b7a9d6b19acd2 ]

The call thermal_zone_get_zone_by_name() used to return the
thermal zone right away, but recent refactorings in the
thermal core has changed this so the thermal zone used by
the battery is probed later, and the call returns -ENODEV.

This was always quite fragile. If we get -ENODEV, then
return a -EPROBE_DEFER and try again later.

Cc: phone-devel@vger.kernel.org
Fixes: 2b0e7ac0841b ("power: supply: ab8500: Integrate thermal zone")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_btemp.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/power/supply/ab8500_btemp.c b/drivers/power/supply/ab8500_btemp.c
index 863fabe05bdc..307ee6f71042 100644
--- a/drivers/power/supply/ab8500_btemp.c
+++ b/drivers/power/supply/ab8500_btemp.c
@@ -725,7 +725,14 @@ static int ab8500_btemp_probe(struct platform_device *pdev)
 	/* Get thermal zone and ADC */
 	di->tz = thermal_zone_get_zone_by_name("battery-thermal");
 	if (IS_ERR(di->tz)) {
-		return dev_err_probe(dev, PTR_ERR(di->tz),
+		ret = PTR_ERR(di->tz);
+		/*
+		 * This usually just means we are probing before the thermal
+		 * zone, so just defer.
+		 */
+		if (ret == -ENODEV)
+			ret = -EPROBE_DEFER;
+		return dev_err_probe(dev, ret,
 				     "failed to get battery thermal zone\n");
 	}
 	di->bat_ctrl = devm_iio_channel_get(dev, "bat_ctrl");
-- 
2.35.1



