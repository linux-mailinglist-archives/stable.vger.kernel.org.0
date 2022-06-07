Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF125540996
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236589AbiFGSLi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:11:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349707AbiFGSIy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:08:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FDA6972D;
        Tue,  7 Jun 2022 10:48:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 517F1B81F38;
        Tue,  7 Jun 2022 17:47:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3F46C385A5;
        Tue,  7 Jun 2022 17:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654624057;
        bh=hUvwyKVOQbDpGx6Hckq8zm0lWzn9AMXQ9SVC87nl7bE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0gWkCqU5Um48BwYXzVmVsLWteNu3Q3T9mByvHHna7AgatVXgKHoyDZSOk0Oe2+KT3
         GraDzJ+L3rgLw+fWMcbKKA3P3uY2iL9iWn6f3v+wCHy986JFSmDF+GVkiLDC8Myy22
         Eum7B3q3/nH23AbNymS8wjCYNo7JLBMnWFIojSjg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lucas Stach <l.stach@pengutronix.de>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 190/667] drm/bridge: adv7511: clean up CEC adapter when probe fails
Date:   Tue,  7 Jun 2022 18:57:35 +0200
Message-Id: <20220607164940.501449023@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164934.766888869@linuxfoundation.org>
References: <20220607164934.766888869@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lucas Stach <l.stach@pengutronix.de>

[ Upstream commit 7ed2b0dabf7a22874cb30f8878df239ef638eb53 ]

When the probe routine fails we also need to clean up the
CEC adapter registered in adv7511_cec_init().

Fixes: 3b1b975003e4 ("drm: adv7511/33: add HDMI CEC support")
Signed-off-by: Lucas Stach <l.stach@pengutronix.de>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220321104705.2804423-1-l.stach@pengutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index c02f3ec60b04..8c2025584f1b 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1306,6 +1306,7 @@ static int adv7511_probe(struct i2c_client *i2c, const struct i2c_device_id *id)
 	return 0;
 
 err_unregister_cec:
+	cec_unregister_adapter(adv7511->cec_adap);
 	i2c_unregister_device(adv7511->i2c_cec);
 	clk_disable_unprepare(adv7511->cec_clk);
 err_i2c_unregister_packet:
-- 
2.35.1



