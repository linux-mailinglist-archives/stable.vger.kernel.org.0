Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E87A49966E
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:18:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1359791AbiAXVDz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:03:55 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:46816 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241281AbiAXU5h (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 15:57:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DDA94612E9;
        Mon, 24 Jan 2022 20:57:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B2763C340E8;
        Mon, 24 Jan 2022 20:57:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643057856;
        bh=RFhbMtU9WWHcwmOOT93T6numiDfaJre4ODtUp/i8QeU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AwFvmi2hJ/qrIGIZg+LAq5torC0PZsrJXfeE2QC/PU4JCTKRnrhkXh5PMjQ+A7N/p
         pMnpLwTB1jQOyM+svNQhZVF1nKSlVvND/OgmEyFiJAxhwVWv0CYuB6vQNOshLlqany
         3pEAJ+mxzoA8Q6ojT0l7Xu2T/1RFn+frVREMChj8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Marek Vasut <marex@denx.de>, Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0102/1039] drm/bridge: sn65dsi83: Fix bridge removal
Date:   Mon, 24 Jan 2022 19:31:31 +0100
Message-Id: <20220124184128.591074711@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Maxime Ripard <maxime@cerno.tech>

[ Upstream commit c05f1a4e2c4b8a217b448828c4e59fb47454dc75 ]

Commit 24417d5b0c00 ("drm/bridge: ti-sn65dsi83: Implement .detach
callback") moved the unregistration of the bridge DSI device and bridge
itself to the detach callback.

While this is correct for the DSI device detach and unregistration, the
bridge is added in the driver probe, and should thus be removed as part
of its remove callback.

Acked-by: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Marek Vasut <marex@denx.de>
Fixes: 24417d5b0c00 ("drm/bridge: ti-sn65dsi83: Implement .detach callback")
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Link: https://patchwork.freedesktop.org/patch/msgid/20211025151536.1048186-14-maxime@cerno.tech
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index ba1160ec6d6e8..07917681782d2 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -297,7 +297,6 @@ static void sn65dsi83_detach(struct drm_bridge *bridge)
 
 	mipi_dsi_detach(ctx->dsi);
 	mipi_dsi_device_unregister(ctx->dsi);
-	drm_bridge_remove(&ctx->bridge);
 	ctx->dsi = NULL;
 }
 
@@ -711,6 +710,7 @@ static int sn65dsi83_remove(struct i2c_client *client)
 {
 	struct sn65dsi83 *ctx = i2c_get_clientdata(client);
 
+	drm_bridge_remove(&ctx->bridge);
 	of_node_put(ctx->host_node);
 
 	return 0;
-- 
2.34.1



