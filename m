Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7797A6215F0
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:17:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234777AbiKHORH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:17:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235312AbiKHOQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8ACA686B1
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BAB3B81ADB
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BBD5EC433C1;
        Tue,  8 Nov 2022 14:16:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667917012;
        bh=Sf+Isdmaz4wNPMy+mjteBnKRs51dNS6rUmgxRvq3QyU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=K2Z9Et+zus5PFrX9pP1BZ3Em+oGhZGoq0SA/RNwRYRzJV6I0X+uHYd9jk5Xm/huwJ
         8FXpT3RTmmej7bxWhoKBHEIMv6KShwb0iHvZEdhOvoZjVjcMV8q7IGCrz1BgyZg/Ot
         atBQbZQBEB2XyJPVhcOuJfolPWfE7pOW8GZApkPw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Brian Norris <briannorris@chromium.org>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.0 190/197] drm/rockchip: dsi: Clean up usage_mode when failing to attach
Date:   Tue,  8 Nov 2022 14:40:28 +0100
Message-Id: <20221108133403.510963310@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Brian Norris <briannorris@chromium.org>

commit 0be67e0556e469c57100ffe3c90df90abc796f3b upstream.

If we fail to attach the first time (especially: EPROBE_DEFER), we fail
to clean up 'usage_mode', and thus will fail to attach on any subsequent
attempts, with "dsi controller already in use".

Re-set to DW_DSI_USAGE_IDLE on attach failure.

This is especially common to hit when enabling asynchronous probe on a
duel-DSI system (such as RK3399 Gru/Scarlet), such that we're more
likely to fail dw_mipi_dsi_rockchip_find_second() the first time.

Fixes: 71f68fe7f121 ("drm/rockchip: dsi: add ability to work as a phy instead of full dsi")
Cc: <stable@vger.kernel.org>
Signed-off-by: Brian Norris <briannorris@chromium.org>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20221019170255.1.Ia68dfb27b835d31d22bfe23812baf366ee1c6eac@changeid
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c |   16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
+++ b/drivers/gpu/drm/rockchip/dw-mipi-dsi-rockchip.c
@@ -1031,23 +1031,31 @@ static int dw_mipi_dsi_rockchip_host_att
 	if (ret) {
 		DRM_DEV_ERROR(dsi->dev, "Failed to register component: %d\n",
 					ret);
-		return ret;
+		goto out;
 	}
 
 	second = dw_mipi_dsi_rockchip_find_second(dsi);
-	if (IS_ERR(second))
-		return PTR_ERR(second);
+	if (IS_ERR(second)) {
+		ret = PTR_ERR(second);
+		goto out;
+	}
 	if (second) {
 		ret = component_add(second, &dw_mipi_dsi_rockchip_ops);
 		if (ret) {
 			DRM_DEV_ERROR(second,
 				      "Failed to register component: %d\n",
 				      ret);
-			return ret;
+			goto out;
 		}
 	}
 
 	return 0;
+
+out:
+	mutex_lock(&dsi->usage_mutex);
+	dsi->usage_mode = DW_DSI_USAGE_IDLE;
+	mutex_unlock(&dsi->usage_mutex);
+	return ret;
 }
 
 static int dw_mipi_dsi_rockchip_host_detach(void *priv_data,


