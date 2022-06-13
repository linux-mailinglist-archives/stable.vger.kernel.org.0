Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E09EF548C94
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:13:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378948AbiFMNqS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:46:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40996 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379716AbiFMNo5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:44:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58F8760F9;
        Mon, 13 Jun 2022 04:32:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D738FB80EA7;
        Mon, 13 Jun 2022 11:32:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24349C36B0C;
        Mon, 13 Jun 2022 11:32:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119950;
        bh=bA3XZbwpyv4CQAVMx82J1EfXcxqBdnROVcJ6m/OszZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2QwM6Du1kajAeA4oT8iesbe9N+iqnnGiPOM+ogfIBOdfY46xHG4Mh/jouTNakYSQ
         f7PkU1fIeI6pyMN+lGKo+gQxe4/zUtOz2hWamsHmfmpiMU/3uiihd61eLwk917ANPG
         iR+Y9YUDKGLENHqlgRpsoM/Dx41SAOeWryrfI5Rs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Marek Vasut <marex@denx.de>,
        Jonas Karlman <jonas@kwiboo.se>,
        Laurent Pinchart <Laurent.pinchart@ideasonboard.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Maxime Ripard <maxime@cerno.tech>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sam Ravnborg <sam@ravnborg.org>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 177/339] drm/bridge: ti-sn65dsi83: Handle dsi_lanes == 0 as invalid
Date:   Mon, 13 Jun 2022 12:10:02 +0200
Message-Id: <20220613094932.043629961@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit edbc7960bef7fd71ef1e44d0df15b864784b14c8 ]

Handle empty data-lanes = < >; property, which translates to
dsi_lanes = 0 as invalid.

Fixes: ceb515ba29ba6 ("drm/bridge: ti-sn65dsi83: Add TI SN65DSI83 and SN65DSI84 driver")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Andrzej Hajda <andrzej.hajda@intel.com>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220518233844.248504-1-marex@denx.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/ti-sn65dsi83.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/bridge/ti-sn65dsi83.c b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
index 19daaddd29a4..3d58110465fe 100644
--- a/drivers/gpu/drm/bridge/ti-sn65dsi83.c
+++ b/drivers/gpu/drm/bridge/ti-sn65dsi83.c
@@ -573,7 +573,7 @@ static int sn65dsi83_parse_dt(struct sn65dsi83 *ctx, enum sn65dsi83_model model)
 	ctx->host_node = of_graph_get_remote_port_parent(endpoint);
 	of_node_put(endpoint);
 
-	if (ctx->dsi_lanes < 0 || ctx->dsi_lanes > 4) {
+	if (ctx->dsi_lanes <= 0 || ctx->dsi_lanes > 4) {
 		ret = -EINVAL;
 		goto err_put_node;
 	}
-- 
2.35.1



