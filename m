Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB6EE54190F
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:19:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352843AbiFGVTK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:19:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380742AbiFGVQz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:16:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC1EB8A064;
        Tue,  7 Jun 2022 11:57:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 481676159D;
        Tue,  7 Jun 2022 18:57:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B2BCC385A2;
        Tue,  7 Jun 2022 18:57:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654628229;
        bh=27T+o5aDnrnyaKXC7K+l9XYzuMzC06GKuuJNvAXwJ1I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bpRYPUF2ExLBgXHNzAJ0pplxkGNS1c8fvkZ+9KWgPT5iQWcdX6pP85Il6hJhN3Co3
         0i9fp2dFgZQJqrTAVgH7H4ms48Vc0uaXibyS0d9aUTsFeUoEkm2OFQ8WGv/eO0dmju
         k9mpY5JzU6cW/pZj7DHU9mPK6VDZcdvIzLNiKFqg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nikita Yushchenko <nikita.yoush@cogentembedded.com>,
        Paul Cercueil <paul@crapouillou.net>,
        Kieran Bingham <kieran.bingham+renesas@ideasonboard.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 254/879] drm/bridge_connector: enable HPD by default if supported
Date:   Tue,  7 Jun 2022 18:56:12 +0200
Message-Id: <20220607165010.222466946@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
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
index 60923cdfe8e1..6b3dad03d77d 100644
--- a/drivers/gpu/drm/drm_bridge_connector.c
+++ b/drivers/gpu/drm/drm_bridge_connector.c
@@ -384,8 +384,10 @@ struct drm_connector *drm_bridge_connector_init(struct drm_device *drm,
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



