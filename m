Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B3A6AEF4E
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 19:22:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232641AbjCGSWt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 13:22:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCGSW0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 13:22:26 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D67647428
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 10:16:27 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CE2CB61522
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 18:16:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A8D3C433EF;
        Tue,  7 Mar 2023 18:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678212986;
        bh=WfQ7r0w/KnryXcWI7dSv+Ty99XRnc49kqWfFyXjDJyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hUpBLeXWxE+b3SlnLlQb3vmOH9wGffEfD1ECqprY20Jf4WDAl4nFVmB6Mh+coo8rN
         gNXiuy2K35WAzQSp8Y84n2mSWibfnz5mxwsvZF7V2PTtQWAFZCzRExKdzywhzAhAan
         pHMStW0mEVRGArzbIQpdkIIK+59ftlcWcNEXBKSQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Steffen Aschbacher <steffen.aschbacher@stihl.de>,
        Alexandru Ardelean <alex@shruggie.ro>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 361/885] ASoC: tlv320adcx140: fix ti,gpio-config DT property init
Date:   Tue,  7 Mar 2023 17:54:55 +0100
Message-Id: <20230307170017.960504729@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Steffen Aschbacher <steffen.aschbacher@stihl.de>

[ Upstream commit 771725efe5e2e5396dd9d1220437e5f9d6b9ca9d ]

When the 'ti,gpio-config' property is not defined, the
device_property_count_u32() will return an error, rather than zero.

The current check, only handles a return value of zero, which assumes that
the property is defined and has nothing defined.

This change extends the check to also check for an error case (most likely
to be hit by the case that the 'ti,gpio-config' is not defined).

In case that the 'ti,gpio-config' and the returned 'gpio_count' is not
correct, there is a 'if (gpio_count != ADCX140_NUM_GPIO_CFGS)' check, a few
lines lower that will return -EINVAL.
This means that someone tried to define 'ti,gpio-config', but with the
wrong number of GPIOs.

Fixes: d5214321498a ("ASoC: tlv320adcx140: Add support for configuring GPIO pin")
Signed-off-by: Steffen Aschbacher <steffen.aschbacher@stihl.de>
Signed-off-by: Alexandru Ardelean <alex@shruggie.ro>
Link: https://lore.kernel.org/r/20230213073805.14640-1-alex@shruggie.ro
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/tlv320adcx140.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/tlv320adcx140.c b/sound/soc/codecs/tlv320adcx140.c
index 91a22d9279158..530f321d08e9c 100644
--- a/sound/soc/codecs/tlv320adcx140.c
+++ b/sound/soc/codecs/tlv320adcx140.c
@@ -925,7 +925,7 @@ static int adcx140_configure_gpio(struct adcx140_priv *adcx140)
 
 	gpio_count = device_property_count_u32(adcx140->dev,
 			"ti,gpio-config");
-	if (gpio_count == 0)
+	if (gpio_count <= 0)
 		return 0;
 
 	if (gpio_count != ADCX140_NUM_GPIO_CFGS)
-- 
2.39.2



