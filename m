Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 820DA528FDA
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:43:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346336AbiEPUEL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:04:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351060AbiEPUB5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CCDE4757C;
        Mon, 16 May 2022 12:57:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0977C60EC4;
        Mon, 16 May 2022 19:57:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 19BD4C34100;
        Mon, 16 May 2022 19:57:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652731066;
        bh=I2eZm7HX5itsONxv7rc4LaVSnE80gzkI7KWWDSxNPnk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2sSwCjlL3tPxpkD2TgRJ+CaFaDa4VMhHrEjzxx88tsErU57be9XUXL7lL/sPL2I4Q
         uYNfo/glhopr9V+diM0orBrNCYAOXA9QEV4ZrI+apsOMI0phPLUAJD6CJfVPxROz1h
         +bIjOnf64cvxICNc32r3OuiK0u8kXA3U/NWBiHko=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hui Tang <tanghui20@huawei.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 041/114] drm/vc4: hdmi: Fix build error for implicit function declaration
Date:   Mon, 16 May 2022 21:36:15 +0200
Message-Id: <20220516193626.674038302@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Tang <tanghui20@huawei.com>

[ Upstream commit 6fed53de560768bde6d701a7c79c253b45b259e3 ]

drivers/gpu/drm/vc4/vc4_hdmi.c: In function ‘vc4_hdmi_connector_detect’:
drivers/gpu/drm/vc4/vc4_hdmi.c:228:7: error: implicit declaration of function ‘gpiod_get_value_cansleep’; did you mean ‘gpio_get_value_cansleep’? [-Werror=implicit-function-declaration]
   if (gpiod_get_value_cansleep(vc4_hdmi->hpd_gpio))
       ^~~~~~~~~~~~~~~~~~~~~~~~
       gpio_get_value_cansleep
  CC [M]  drivers/gpu/drm/vc4/vc4_validate.o
  CC [M]  drivers/gpu/drm/vc4/vc4_v3d.o
  CC [M]  drivers/gpu/drm/vc4/vc4_validate_shaders.o
  CC [M]  drivers/gpu/drm/vc4/vc4_debugfs.o
drivers/gpu/drm/vc4/vc4_hdmi.c: In function ‘vc4_hdmi_bind’:
drivers/gpu/drm/vc4/vc4_hdmi.c:2883:23: error: implicit declaration of function ‘devm_gpiod_get_optional’; did you mean ‘devm_clk_get_optional’? [-Werror=implicit-function-declaration]
  vc4_hdmi->hpd_gpio = devm_gpiod_get_optional(dev, "hpd", GPIOD_IN);
                       ^~~~~~~~~~~~~~~~~~~~~~~
                       devm_clk_get_optional
drivers/gpu/drm/vc4/vc4_hdmi.c:2883:59: error: ‘GPIOD_IN’ undeclared (first use in this function); did you mean ‘GPIOF_IN’?
  vc4_hdmi->hpd_gpio = devm_gpiod_get_optional(dev, "hpd", GPIOD_IN);
                                                           ^~~~~~~~
                                                           GPIOF_IN
drivers/gpu/drm/vc4/vc4_hdmi.c:2883:59: note: each undeclared identifier is reported only once for each function it appears in
cc1: all warnings being treated as errors

Fixes: 6800234ceee0 ("drm/vc4: hdmi: Convert to gpiod")
Signed-off-by: Hui Tang <tanghui20@huawei.com>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20220510135148.247719-1-tanghui20@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/vc4_hdmi.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/vc4/vc4_hdmi.c b/drivers/gpu/drm/vc4/vc4_hdmi.c
index 3a1626f261e5..3f651364ed7a 100644
--- a/drivers/gpu/drm/vc4/vc4_hdmi.c
+++ b/drivers/gpu/drm/vc4/vc4_hdmi.c
@@ -38,6 +38,7 @@
 #include <drm/drm_scdc_helper.h>
 #include <linux/clk.h>
 #include <linux/component.h>
+#include <linux/gpio/consumer.h>
 #include <linux/i2c.h>
 #include <linux/of_address.h>
 #include <linux/of_gpio.h>
-- 
2.35.1



