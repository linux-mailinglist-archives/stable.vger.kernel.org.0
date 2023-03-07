Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 15E956AEA5C
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:33:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231429AbjCGRdM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:33:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33230 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231723AbjCGRcr (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:32:47 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D4FFB3928B
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:28:25 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BD35B819AD
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:28:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C050C4339B;
        Tue,  7 Mar 2023 17:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678210103;
        bh=WfQ7r0w/KnryXcWI7dSv+Ty99XRnc49kqWfFyXjDJyg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KhMGjkyWLZRQwcRGQfq0FLj3OJQz/Kpg2Q6L732WcswtJ5Kno/1wrRDhnLrb3WUk1
         YvNHupU1/RSGO22Bw5j3aUHFobnXFu13XhU2tWsPOdMsL74vOhuQW/SRBN9zbQfhRG
         xLJS4XUZi8665kr1U74ae2NZvoVony+WuGnOyl04=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Steffen Aschbacher <steffen.aschbacher@stihl.de>,
        Alexandru Ardelean <alex@shruggie.ro>,
        Mark Brown <broonie@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0434/1001] ASoC: tlv320adcx140: fix ti,gpio-config DT property init
Date:   Tue,  7 Mar 2023 17:53:26 +0100
Message-Id: <20230307170040.194062504@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
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



