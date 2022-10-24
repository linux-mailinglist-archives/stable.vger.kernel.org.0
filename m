Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88A4160B23E
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 18:44:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234406AbiJXQoY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 12:44:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234819AbiJXQn4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 12:43:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39ADF72857;
        Mon, 24 Oct 2022 08:30:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 04555B81135;
        Mon, 24 Oct 2022 12:08:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5016CC433C1;
        Mon, 24 Oct 2022 12:08:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613329;
        bh=34rtLmGZAXqTGiRi43XeZcJKLD8da60agJA5dgZICh0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qiSpsSRi30TFG0i29SmA1l8bPYMGWP9G791VZBqQOanoLmjPpwx7Nx1XT5bVMY2Vk
         eLpFISmBDQouXeTbjrqloNrvn4SmCNJ2upokAlRRMWuyCh71J4tig/SNWbWgoKzTzF
         WAtP4QnoFlycitzKaf0cMW+ihTyd7QPGvTCxTZFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 088/255] drm: bridge: adv7511: fix CEC power down control register offset
Date:   Mon, 24 Oct 2022 13:29:58 +0200
Message-Id: <20221024113005.440362867@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alvin Šipraga <alsi@bang-olufsen.dk>

[ Upstream commit 1d22b6033ea113a4c3850dfa2c0770885c81aec8 ]

The ADV7511_REG_CEC_CTRL = 0xE2 register is part of the main register
map - not the CEC register map. As such, we shouldn't apply an offset to
the register address. Doing so will cause us to address a bogus register
for chips with a CEC register map offset (e.g. ADV7533).

Fixes: 3b1b975003e4 ("drm: adv7511/33: add HDMI CEC support")
Signed-off-by: Alvin Šipraga <alsi@bang-olufsen.dk>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220612144854.2223873-2-alvin@pqrs.dk
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511.h     | 5 +----
 drivers/gpu/drm/bridge/adv7511/adv7511_cec.c | 4 ++--
 2 files changed, 3 insertions(+), 6 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511.h b/drivers/gpu/drm/bridge/adv7511/adv7511.h
index 52b2adfdc877..90a721226231 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -384,10 +384,7 @@ void adv7511_cec_irq_process(struct adv7511 *adv7511, unsigned int irq1);
 #else
 static inline int adv7511_cec_init(struct device *dev, struct adv7511 *adv7511)
 {
-	unsigned int offset = adv7511->type == ADV7533 ?
-						ADV7533_REG_CEC_OFFSET : 0;
-
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset,
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL,
 		     ADV7511_CEC_CTRL_POWER_DOWN);
 	return 0;
 }
diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
index a20a45c0b353..ddd1305b82b2 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_cec.c
@@ -316,7 +316,7 @@ int adv7511_cec_init(struct device *dev, struct adv7511 *adv7511)
 		goto err_cec_alloc;
 	}
 
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset, 0);
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL, 0);
 	/* cec soft reset */
 	regmap_write(adv7511->regmap_cec,
 		     ADV7511_REG_CEC_SOFT_RESET + offset, 0x01);
@@ -343,7 +343,7 @@ int adv7511_cec_init(struct device *dev, struct adv7511 *adv7511)
 	dev_info(dev, "Initializing CEC failed with error %d, disabling CEC\n",
 		 ret);
 err_cec_parse_dt:
-	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL + offset,
+	regmap_write(adv7511->regmap, ADV7511_REG_CEC_CTRL,
 		     ADV7511_CEC_CTRL_POWER_DOWN);
 	return ret == -EPROBE_DEFER ? ret : 0;
 }
-- 
2.35.1



