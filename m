Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3376F59D903
	for <lists+stable@lfdr.de>; Tue, 23 Aug 2022 12:05:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241345AbiHWJrB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Aug 2022 05:47:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352177AbiHWJqB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 23 Aug 2022 05:46:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136992CE16;
        Tue, 23 Aug 2022 01:43:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DADB661485;
        Tue, 23 Aug 2022 08:43:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB6BC433D6;
        Tue, 23 Aug 2022 08:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661244190;
        bh=FnF15LZwNDPxhljz7cmUOV0fzoKOxDGUuWynoWR/aTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2mjt2gxKGOYDEGBKCnyboElcNdJIpHxdsICEZNd3KRvp2Wmo5ZMssnW4/i55M/+8
         DzyKxhDf3JveabyneIFRKqzn15fa1LFf1wy/iOSFDqObDnuv6xa85TBuCAa+NIwf4W
         6F2yETregWS+uZkkTSPr51T3DPaPY8dXpwLB0dwM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 065/229] drm: bridge: adv7511: Add check for mipi_dsi_driver_register
Date:   Tue, 23 Aug 2022 10:23:46 +0200
Message-Id: <20220823080056.049597945@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220823080053.202747790@linuxfoundation.org>
References: <20220823080053.202747790@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiasheng Jiang <jiasheng@iscas.ac.cn>

[ Upstream commit 831463667b5f4f1e5bce9c3b94e9e794d2bc8923 ]

As mipi_dsi_driver_register could return error if fails,
it should be better to check the return value and return error
if fails.
Moreover, if i2c_add_driver fails,  mipi_dsi_driver_register
should be reverted.

Fixes: 1e4d58cd7f88 ("drm/bridge: adv7533: Create a MIPI DSI device")
Signed-off-by: Jiasheng Jiang <jiasheng@iscas.ac.cn>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220602103401.2980938-1-jiasheng@iscas.ac.cn
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/adv7511/adv7511_drv.c | 17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
index 3c94d838863e..f5195d9841f8 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1213,10 +1213,21 @@ static struct i2c_driver adv7511_driver = {
 
 static int __init adv7511_init(void)
 {
-	if (IS_ENABLED(CONFIG_DRM_MIPI_DSI))
-		mipi_dsi_driver_register(&adv7533_dsi_driver);
+	int ret;
+
+	if (IS_ENABLED(CONFIG_DRM_MIPI_DSI)) {
+		ret = mipi_dsi_driver_register(&adv7533_dsi_driver);
+		if (ret)
+			return ret;
+	}
 
-	return i2c_add_driver(&adv7511_driver);
+	ret = i2c_add_driver(&adv7511_driver);
+	if (ret) {
+		if (IS_ENABLED(CONFIG_DRM_MIPI_DSI))
+			mipi_dsi_driver_unregister(&adv7533_dsi_driver);
+	}
+
+	return ret;
 }
 module_init(adv7511_init);
 
-- 
2.35.1



