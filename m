Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED8AB60A561
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 14:23:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233593AbiJXMXo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 08:23:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233233AbiJXMWn (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:22:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DACA63E7;
        Mon, 24 Oct 2022 04:59:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3D8FA61280;
        Mon, 24 Oct 2022 11:58:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F296C433D7;
        Mon, 24 Oct 2022 11:58:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666612719;
        bh=KqhLPw44/U/3UiBEYNT1QjNxtDA8eRK5sbZocUnIHaw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCHAcMRHctbUPZQgVpIlNhrRvQATvyIZ3ubqyD47m2vaNfLJ+cScZIMYFqVj9q3Jg
         I/45KplujBZIcJbS07n0TSd3PVrafZc2mPUzZVSsoC3pDirbZEOTCm3YCrUsi6GEVH
         VionEYxRL9zM4+4k9JHE+8c7O/2xfe4TDAhHxJZ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Alvin=20=C5=A0ipraga?= <alsi@bang-olufsen.dk>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 094/229] drm: bridge: adv7511: fix CEC power down control register offset
Date:   Mon, 24 Oct 2022 13:30:13 +0200
Message-Id: <20221024113002.087392095@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024112959.085534368@linuxfoundation.org>
References: <20221024112959.085534368@linuxfoundation.org>
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
index 73d8ccb97742..d214865c2459 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511.h
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511.h
@@ -383,10 +383,7 @@ void adv7511_cec_irq_process(struct adv7511 *adv7511, unsigned int irq1);
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



