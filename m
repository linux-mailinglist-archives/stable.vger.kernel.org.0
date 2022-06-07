Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B969F5412AC
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 21:54:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356279AbiFGTyV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 15:54:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358365AbiFGTwZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 15:52:25 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5794FCEB89;
        Tue,  7 Jun 2022 11:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 84A50CE2428;
        Tue,  7 Jun 2022 18:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90F19C385A2;
        Tue,  7 Jun 2022 18:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654626010;
        bh=NCtpBLNwBQo5LnWRjTwnh9ne8DWfF2A34nsadgQaqzc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=y6U84lfhOzukSH63rP5eKL9o8w1rfVudQNueGRAbtpPjZuthZF7spM3uPkTdvxHg7
         Qi8En+C26kIuIrsRK0a17DI+zdLRFFF4jPPOjDORM4YVGeNfGouEWwnhKPZ32Achzr
         FpSY0h9Y/X4w/YwEX0kFasSOeaZslIxiIdkyYeRw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 226/772] drm/bridge_connector: enable HPD by default if supported
Date:   Tue,  7 Jun 2022 18:56:58 +0200
Message-Id: <20220607164955.692410263@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164948.980838585@linuxfoundation.org>
References: <20220607164948.980838585@linuxfoundation.org>
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

From: Nikita Yushchenko <nikita.yoush@cogentembedded.com>

[ Upstream commit 09077bc3116581f4d1cb961ec359ad56586e370b ]

Hotplug events reported by bridge drivers over drm_bridge_hpd_notify()
get ignored unless somebody calls drm_bridge_hpd_enable(). When the
connector for the bridge is bridge_connector, such a call is done from
drm_bridge_connector_enable_hpd().

However drm_bridge_connector_enable_hpd() is never called on init paths,
documentation suggests that it is intended for suspend/resume paths.

In result, once encoders are switched to bridge_connector,
bridge-detected HPD stops working.

This patch adds a call to that API on init path.

This fixes HDMI HPD with rcar-du + adv7513 case when adv7513 reports HPD
events via interrupts.

Fixes: c24110a8fd09 ("drm: rcar-du: Use drm_bridge_connector_init() helper")
Signed-off-by: Nikita Yushchenko <nikita.yoush@cogentembedded.com>
Signed-off-by: Paul Cercueil <paul@crapouillou.net>
Tested-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211225063151.2110878-1-nikita.yoush@cogentembedded.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge_connector.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/drm_bridge_connector.c b/drivers/gpu/drm/drm_bridge_connector.c
index 791379816837..4f20137ef21d 100644
--- a/drivers/gpu/drm/drm_bridge_connector.c
+++ b/drivers/gpu/drm/drm_bridge_connector.c
@@ -369,8 +369,10 @@ struct drm_connector *drm_bridge_connector_init(struct drm_device *drm,
 				    connector_type, ddc);
 	drm_connector_helper_add(connector, &drm_bridge_connector_helper_funcs);
 
-	if (bridge_connector->bridge_hpd)
+	if (bridge_connector->bridge_hpd) {
 		connector->polled = DRM_CONNECTOR_POLL_HPD;
+		drm_bridge_connector_enable_hpd(connector);
+	}
 	else if (bridge_connector->bridge_detect)
 		connector->polled = DRM_CONNECTOR_POLL_CONNECT
 				  | DRM_CONNECTOR_POLL_DISCONNECT;
-- 
2.35.1



