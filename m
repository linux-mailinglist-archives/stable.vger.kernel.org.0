Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6C513593D8A
	for <lists+stable@lfdr.de>; Mon, 15 Aug 2022 22:40:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232661AbiHOUD7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 16:03:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344447AbiHOUDH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 16:03:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95C4B7D793;
        Mon, 15 Aug 2022 11:54:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9FF6DB810A5;
        Mon, 15 Aug 2022 18:54:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9FF6C433C1;
        Mon, 15 Aug 2022 18:54:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660589645;
        bh=MezgPMKIrRoCLy1vw1mfpOkaaDTLL/QVc33MHS2Qw4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQk2OtTc48bVVtKB22m2abV7/WebA6acXid06RoVWs8WFxxQW+AYTKLw4Al5wR1LL
         QrA00C/9TjSqEQMDD8SUYIHqsC6nyYImzLzXv31E6Y9Kz90RDQRyIgEV43RqEboUdh
         W4tvBvYC8wvsDozTXM1+eHzOSTfhPsg6GphbnF9o=
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
        Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH 5.15 767/779] drm/bridge: tc358767: Fix (e)DP bridge endpoint parsing in dedicated function
Date:   Mon, 15 Aug 2022 20:06:51 +0200
Message-Id: <20220815180410.180744819@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180337.130757997@linuxfoundation.org>
References: <20220815180337.130757997@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

commit 9030a9e571b3ba250d3d450a98310e3c74ecaff4 upstream.

Per toshiba,tc358767.yaml DT binding document, port@2 the output (e)DP
port is optional. In case this port is not described in DT, the bridge
driver operates in DPI-to-DP mode. The drm_of_find_panel_or_bridge()
call in tc_probe_edp_bridge_endpoint() returns -ENODEV in case port@2
is not present in DT and this specific return value is incorrectly
propagated outside of tc_probe_edp_bridge_endpoint() function. All
other error values must be propagated and are propagated correctly.

Return 0 in case the port@2 is missing instead, that reinstates the
original behavior before the commit this patch fixes.

Fixes: 8478095a8c4b ("drm/bridge: tc358767: Move (e)DP bridge endpoint parsing into dedicated function")
Signed-off-by: Marek Vasut <marex@denx.de>
Cc: Jonas Karlman <jonas@kwiboo.se>
Cc: Laurent Pinchart <Laurent.pinchart@ideasonboard.com>
Cc: Lucas Stach <l.stach@pengutronix.de>
Cc: Marek Vasut <marex@denx.de>
Cc: Maxime Ripard <maxime@cerno.tech>
Cc: Neil Armstrong <narmstrong@baylibre.com>
Cc: Robert Foss <robert.foss@linaro.org>
Cc: Sam Ravnborg <sam@ravnborg.org>
Reviewed-by: Lucas Stach <l.stach@pengutronix.de>
Link: https://patchwork.freedesktop.org/patch/msgid/20220428213132.447890-1-marex@denx.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/tc358767.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/bridge/tc358767.c
+++ b/drivers/gpu/drm/bridge/tc358767.c
@@ -1573,7 +1573,7 @@ static int tc_probe_edp_bridge_endpoint(
 		tc->bridge.type = DRM_MODE_CONNECTOR_DisplayPort;
 	}
 
-	return ret;
+	return 0;
 }
 
 static int tc_probe(struct i2c_client *client, const struct i2c_device_id *id)


