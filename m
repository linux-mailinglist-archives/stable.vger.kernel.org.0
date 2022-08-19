Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6CDFE59A094
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 18:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351440AbiHSQJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351439AbiHSQHg (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:07:36 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 962C710E7BE;
        Fri, 19 Aug 2022 08:56:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2A0FEB8280D;
        Fri, 19 Aug 2022 15:56:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8565DC433C1;
        Fri, 19 Aug 2022 15:56:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660924575;
        bh=ATgyo/LWK2OG7s1FSFXr6Qu5zEGCSakxq14VWmNyffM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BA4bj3GhFjN54ig3OyYtoDEE3H4Cj3QaAqrob0n94MNn2LrOEyl65RqOdlsd5LX+d
         8KeWqtPnVGTyoVAWzN2+tznF5yjNAE1cIFvvPSUpy6NmzgWLtCY5FoFL8ARsjfkjOe
         dlr4PBtsmJbHZBTEvwBHtivOVVHVtUB5RBZqsPVk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jiasheng Jiang <jiasheng@iscas.ac.cn>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sam Ravnborg <sam@ravnborg.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 184/545] drm: bridge: adv7511: Add check for mipi_dsi_driver_register
Date:   Fri, 19 Aug 2022 17:39:14 +0200
Message-Id: <20220819153837.599216276@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
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
index 8bac392cab79..430c5e8f0388 100644
--- a/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
+++ b/drivers/gpu/drm/bridge/adv7511/adv7511_drv.c
@@ -1381,10 +1381,21 @@ static struct i2c_driver adv7511_driver = {
 
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



