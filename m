Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E574594D64
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 03:34:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344764AbiHPBEU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 21:04:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348613AbiHPBCT (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 21:02:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78CD2BA9C3;
        Mon, 15 Aug 2022 13:50:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB5236103F;
        Mon, 15 Aug 2022 20:50:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA4F2C433D7;
        Mon, 15 Aug 2022 20:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660596626;
        bh=AjhUCMvw3Djg5sxJuPyH8xLqMY0x5dcD4IG5ow8tdvg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=viKG7/Zii5XM6dE4atX+U376OAQEi4W/A11TnjjYUluePkwy41G+oFbTGvQe9xlGk
         yQa3FnrxnBXYmozwJOXMuK9wr/V61dT6V4G39DlRem/UrtgdE49fl5aHsKjGxMunGV
         WowmzLrGbfNr2ZVDgu5J96JQWvlkD3Dk2XyWF5Qc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Robert Foss <robert.foss@linaro.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: [PATCH 5.19 1139/1157] Revert "drm/bridge: anx7625: Use DPI bus type"
Date:   Mon, 15 Aug 2022 20:08:15 +0200
Message-Id: <20220815180526.020681384@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220815180439.416659447@linuxfoundation.org>
References: <20220815180439.416659447@linuxfoundation.org>
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

From: Robert Foss <robert.foss@linaro.org>

commit 61922beba36adea8702fe8069b309c806f6608af upstream.

This reverts commit a77c2af0994e24ee36c7ffb6dc852770bdf06fb1.

This patch depends on the patches just aplied to the media tree, and will
not build without them, which leaves drm-misc-next in a broken state.
Let's revert the two latter patches until rc1 has been branched,
and rc1 has been backmerged into drm-misc-next.

Signed-off-by: Robert Foss <robert.foss@linaro.org>
Acked-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20220523161520.354687-1-robert.foss@linaro.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1623,14 +1623,14 @@ static int anx7625_parse_dt(struct devic
 
 	anx7625_get_swing_setting(dev, pdata);
 
-	pdata->is_dpi = 0; /* default dsi mode */
+	pdata->is_dpi = 1; /* default dpi mode */
 	pdata->mipi_host_node = of_graph_get_remote_node(np, 0, 0);
 	if (!pdata->mipi_host_node) {
 		DRM_DEV_ERROR(dev, "fail to get internal panel.\n");
 		return -ENODEV;
 	}
 
-	bus_type = 0;
+	bus_type = V4L2_FWNODE_BUS_TYPE_PARALLEL;
 	mipi_lanes = MAX_LANES_SUPPORT;
 	ep0 = of_graph_get_endpoint_by_regs(np, 0, 0);
 	if (ep0) {
@@ -1640,8 +1640,8 @@ static int anx7625_parse_dt(struct devic
 		mipi_lanes = of_property_count_u32_elems(ep0, "data-lanes");
 	}
 
-	if (bus_type == V4L2_FWNODE_BUS_TYPE_DPI) /* bus type is DPI */
-		pdata->is_dpi = 1;
+	if (bus_type == V4L2_FWNODE_BUS_TYPE_PARALLEL) /* bus type is Parallel(DSI) */
+		pdata->is_dpi = 0;
 
 	pdata->mipi_lanes = mipi_lanes;
 	if (pdata->mipi_lanes > MAX_LANES_SUPPORT || pdata->mipi_lanes <= 0)


