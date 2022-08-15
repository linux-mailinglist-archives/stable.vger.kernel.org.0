Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D394F59410C
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 23:49:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346115AbiHOUys (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346180AbiHOUyG (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:54:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49391A8966;
        Mon, 15 Aug 2022 12:10:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8A6AE60ACE;
        Mon, 15 Aug 2022 19:10:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91718C433C1;
        Mon, 15 Aug 2022 19:10:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660590648;
        bh=N836QlaP8EZTDQ0E+HF1nAvtsij5ua2T/dw7TqgbLH4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GqLDgwQC9AdglK0AhRfAmYBdGeBuXC4ZgkzHOEzK0tsiZKVVxTa1MB1Z8cJWtJw6D
         B5Zmq9+WMxNB/HWaSaIxN4f9wCc55xB83oXbNVYEF+iWdXBNot26iycXd8c9qwtAJy
         fPO4fWWahLAE0ke2z3aoO8iuLDKSno1kAdxvTwDg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Miaoqian Lin <linmq006@gmail.com>,
        Martin Blumenstingl <martin.blumenstingl@googlemail.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 0325/1095] drm/meson: encoder_hdmi: Fix refcount leak in meson_encoder_hdmi_init
Date:   Mon, 15 Aug 2022 19:55:24 +0200
Message-Id: <20220815180443.235697319@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180429.240518113@linuxfoundation.org>
References: <20220815180429.240518113@linuxfoundation.org>
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

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit d82a5a4aae9d0203234737caed1bf470aa317568 ]

of_graph_get_remote_node() returns remote device nodepointer with
refcount incremented, we should use of_node_put() on it when done.
Add missing of_node_put() to avoid refcount leak.

Fixes: e67f6037ae1b ("drm/meson: split out encoder from meson_dw_hdmi")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Reviewed-by: Martin Blumenstingl <martin.blumenstingl@googlemail.com>
Signed-off-by: Neil Armstrong <narmstrong@baylibre.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220601033927.47814-3-linmq006@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/meson/meson_encoder_hdmi.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/meson/meson_encoder_hdmi.c b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
index de87f02cd388..a7692584487c 100644
--- a/drivers/gpu/drm/meson/meson_encoder_hdmi.c
+++ b/drivers/gpu/drm/meson/meson_encoder_hdmi.c
@@ -365,7 +365,8 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 	meson_encoder_hdmi->next_bridge = of_drm_find_bridge(remote);
 	if (!meson_encoder_hdmi->next_bridge) {
 		dev_err(priv->dev, "Failed to find HDMI transceiver bridge\n");
-		return -EPROBE_DEFER;
+		ret = -EPROBE_DEFER;
+		goto err_put_node;
 	}
 
 	/* HDMI Encoder Bridge */
@@ -383,7 +384,7 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 				      DRM_MODE_ENCODER_TMDS);
 	if (ret) {
 		dev_err(priv->dev, "Failed to init HDMI encoder: %d\n", ret);
-		return ret;
+		goto err_put_node;
 	}
 
 	meson_encoder_hdmi->encoder.possible_crtcs = BIT(0);
@@ -393,7 +394,7 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 				DRM_BRIDGE_ATTACH_NO_CONNECTOR);
 	if (ret) {
 		dev_err(priv->dev, "Failed to attach bridge: %d\n", ret);
-		return ret;
+		goto err_put_node;
 	}
 
 	/* Initialize & attach Bridge Connector */
@@ -401,7 +402,8 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 							&meson_encoder_hdmi->encoder);
 	if (IS_ERR(meson_encoder_hdmi->connector)) {
 		dev_err(priv->dev, "Unable to create HDMI bridge connector\n");
-		return PTR_ERR(meson_encoder_hdmi->connector);
+		ret = PTR_ERR(meson_encoder_hdmi->connector);
+		goto err_put_node;
 	}
 	drm_connector_attach_encoder(meson_encoder_hdmi->connector,
 				     &meson_encoder_hdmi->encoder);
@@ -428,6 +430,7 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 	meson_encoder_hdmi->connector->ycbcr_420_allowed = true;
 
 	pdev = of_find_device_by_node(remote);
+	of_node_put(remote);
 	if (pdev) {
 		struct cec_connector_info conn_info;
 		struct cec_notifier *notifier;
@@ -446,4 +449,8 @@ int meson_encoder_hdmi_init(struct meson_drm *priv)
 	dev_dbg(priv->dev, "HDMI encoder initialized\n");
 
 	return 0;
+
+err_put_node:
+	of_node_put(remote);
+	return ret;
 }
-- 
2.35.1



