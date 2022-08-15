Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 472C55947F0
	for <lists+stable@lfdr.de>; Tue, 16 Aug 2022 02:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245458AbiHOXR2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Aug 2022 19:17:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353456AbiHOXQe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 15 Aug 2022 19:16:34 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AAD37CB7E;
        Mon, 15 Aug 2022 13:03:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 9E75BCE12C5;
        Mon, 15 Aug 2022 20:03:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94A8BC433C1;
        Mon, 15 Aug 2022 20:03:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660593796;
        bh=BUqfmJppzrrDjgVL8ArtUJH4QAhxvWr+02ifyMxp61o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oI06dbogt1cmK4XcxyCGzNXwLxqsfm66f+OdeW14rhF0s4raAAqjwHMmFxOd0O82v
         9Gj64LwhnctNGoCG4iAdTXhuona2THX71Eu0gPC9pL/FRyRhUCjnfYHIE3Be/QCiaf
         OLSop5zIzRRUr9lZJcmLrw8aC4yF4hItjhzISZqE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xin Ji <xji@analogixsemi.com>,
        Chen-Yu Tsai <wenst@chromium.org>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 0309/1157] drm/bridge: anx7625: Use DPI bus type
Date:   Mon, 15 Aug 2022 19:54:25 +0200
Message-Id: <20220815180452.024856616@linuxfoundation.org>
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

From: Xin Ji <xji@analogixsemi.com>

[ Upstream commit a77c2af0994e24ee36c7ffb6dc852770bdf06fb1 ]

As V4L2_FWNODE_BUS_TYPE_PARALLEL not properly descript for DPI
interface, this patch use new defined V4L2_FWNODE_BUS_TYPE_DPI for it.

Fixes: fd0310b6fe7d ("drm/bridge: anx7625: add MIPI DPI input feature")
Signed-off-by: Xin Ji <xji@analogixsemi.com>
Tested-by: Chen-Yu Tsai <wenst@chromium.org>
Acked-by: Robert Foss <robert.foss@linaro.org>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20220422084720.959271-4-xji@analogixsemi.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/bridge/analogix/anx7625.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/bridge/analogix/anx7625.c b/drivers/gpu/drm/bridge/analogix/anx7625.c
index 53a5da6c49dd..01f46d9189c1 100644
--- a/drivers/gpu/drm/bridge/analogix/anx7625.c
+++ b/drivers/gpu/drm/bridge/analogix/anx7625.c
@@ -1623,14 +1623,14 @@ static int anx7625_parse_dt(struct device *dev,
 
 	anx7625_get_swing_setting(dev, pdata);
 
-	pdata->is_dpi = 1; /* default dpi mode */
+	pdata->is_dpi = 0; /* default dsi mode */
 	pdata->mipi_host_node = of_graph_get_remote_node(np, 0, 0);
 	if (!pdata->mipi_host_node) {
 		DRM_DEV_ERROR(dev, "fail to get internal panel.\n");
 		return -ENODEV;
 	}
 
-	bus_type = V4L2_FWNODE_BUS_TYPE_PARALLEL;
+	bus_type = 0;
 	mipi_lanes = MAX_LANES_SUPPORT;
 	ep0 = of_graph_get_endpoint_by_regs(np, 0, 0);
 	if (ep0) {
@@ -1640,8 +1640,8 @@ static int anx7625_parse_dt(struct device *dev,
 		mipi_lanes = of_property_count_u32_elems(ep0, "data-lanes");
 	}
 
-	if (bus_type == V4L2_FWNODE_BUS_TYPE_PARALLEL) /* bus type is Parallel(DSI) */
-		pdata->is_dpi = 0;
+	if (bus_type == V4L2_FWNODE_BUS_TYPE_DPI) /* bus type is DPI */
+		pdata->is_dpi = 1;
 
 	pdata->mipi_lanes = mipi_lanes;
 	if (pdata->mipi_lanes > MAX_LANES_SUPPORT || pdata->mipi_lanes <= 0)
-- 
2.35.1



