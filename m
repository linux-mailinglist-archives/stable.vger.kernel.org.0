Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0648D6ECE83
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:33:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232450AbjDXNdU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232304AbjDXNc6 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:32:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB83C7DAC
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:32:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 56CFF6235A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DCBEC433D2;
        Mon, 24 Apr 2023 13:31:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343119;
        bh=H32sTgX9vqAPxCmefmZDXQ3k5KLYCVqgbjxNg/JxO/c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Oysg+KoNdNvm+UXZW39JGwlkwGEUnNHGXKpg5ktKZVi+aiX/4iPPZ6qqN2ViCA7qP
         Cg27FtJEEl7eQXC7bqqZHLRSP5iQobI7sgfmGQA3nOG24OMv4v+TyLCaEc+ek91yob
         qyfweOqOonS9vq57DgLyEUkprR4IFY/Qrsg/vgTw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Sascha Hauer <s.hauer@pengutronix.de>,
        Heiko Stuebner <heiko@sntech.de>
Subject: [PATCH 6.2 084/110] drm/rockchip: vop2: Use regcache_sync() to fix suspend/resume
Date:   Mon, 24 Apr 2023 15:17:46 +0200
Message-Id: <20230424131139.637110466@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131136.142490414@linuxfoundation.org>
References: <20230424131136.142490414@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Hauer <s.hauer@pengutronix.de>

commit b63a553e8f5aa6574eeb535a551817a93c426d8c upstream.

afa965a45e01 ("drm/rockchip: vop2: fix suspend/resume") uses
regmap_reinit_cache() to fix the suspend/resume issue with the VOP2
driver. During discussion it came up that we should rather use
regcache_sync() instead. As the original patch is already applied
fix this up in this follow-up patch.

Fixes: afa965a45e01 ("drm/rockchip: vop2: fix suspend/resume")
Cc: stable@vger.kernel.org
Signed-off-by: Sascha Hauer <s.hauer@pengutronix.de>
Signed-off-by: Heiko Stuebner <heiko@sntech.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20230417123747.2179695-1-s.hauer@pengutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/rockchip/rockchip_drm_vop2.c |   10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
+++ b/drivers/gpu/drm/rockchip/rockchip_drm_vop2.c
@@ -216,8 +216,6 @@ struct vop2 {
 	struct vop2_win win[];
 };
 
-static const struct regmap_config vop2_regmap_config;
-
 static struct vop2_video_port *to_vop2_video_port(struct drm_crtc *crtc)
 {
 	return container_of(crtc, struct vop2_video_port, crtc);
@@ -842,11 +840,7 @@ static void vop2_enable(struct vop2 *vop
 		return;
 	}
 
-	ret = regmap_reinit_cache(vop2->map, &vop2_regmap_config);
-	if (ret) {
-		drm_err(vop2->drm, "failed to reinit cache: %d\n", ret);
-		return;
-	}
+	regcache_sync(vop2->map);
 
 	if (vop2->data->soc_id == 3566)
 		vop2_writel(vop2, RK3568_OTP_WIN_EN, 1);
@@ -876,6 +870,8 @@ static void vop2_disable(struct vop2 *vo
 
 	pm_runtime_put_sync(vop2->dev);
 
+	regcache_mark_dirty(vop2->map);
+
 	clk_disable_unprepare(vop2->aclk);
 	clk_disable_unprepare(vop2->hclk);
 }


