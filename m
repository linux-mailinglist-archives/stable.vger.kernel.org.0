Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19B606B43D7
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:18:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232034AbjCJOSp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:18:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232026AbjCJOSR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:18:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1BEA119F86
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:16:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 222F1B822B1
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:16:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D99CC4339E;
        Fri, 10 Mar 2023 14:16:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678457815;
        bh=soEhcfaTjSO10CnrPchrIkT+gxivah+YgRmHIN9+IVs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A93sma50U8wsjIDcmrKaQhYFBrOuqMX4y9V9Eq7VDApPGwUTFZtECt6FJzQM4CotQ
         AS504eA2dM6QfK28N5Ic+F8E8cdxM75jx1GoqPu7mdEHtAo3Y44jR2JUnIXz2s1xdd
         Q9C9FA83jhHrHAxPP28mcIsS2YXxq8x2QLRUxj60=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Stefan Agner <stefan@agner.ch>,
        Sebastian Reichel <sebastian.reichel@collabora.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 068/252] drm: Clarify definition of the DRM_BUS_FLAG_(PIXDATA|SYNC)_* macros
Date:   Fri, 10 Mar 2023 14:37:18 +0100
Message-Id: <20230310133720.888500543@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133718.803482157@linuxfoundation.org>
References: <20230310133718.803482157@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

[ Upstream commit a792fa0e21876c9cbae7cc170083016299153051 ]

The DRM_BUS_FLAG_PIXDATA_POSEDGE and DRM_BUS_FLAG_PIXDATA_NEGEDGE macros
and their DRM_BUS_FLAG_SYNC_* counterparts define on which pixel clock
edge data and sync signals are driven. They are however used in some
drivers to define on which pixel clock edge data and sync signals are
sampled, which should usually (but not always) be the opposite edge of
the driving edge. This creates confusion.

Create four new macros for both PIXDATA and SYNC that explicitly state
the driving and sampling edge in their name to remove the confusion. The
driving macros are defined as the opposite of the sampling macros to
made code simpler based on the assumption that the driving and sampling
edges are opposite.

Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Acked-by: Linus Walleij <linus.walleij@linaro.org>
Reviewed-by: Stefan Agner <stefan@agner.ch>
Tested-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Tomi Valkeinen <tomi.valkeinen@ti.com>
Stable-dep-of: 0870d86eac8a ("drm/vc4: dpi: Fix format mapping for RGB565")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/drm_connector.h | 36 ++++++++++++++++++++++++++++++++----
 1 file changed, 32 insertions(+), 4 deletions(-)

diff --git a/include/drm/drm_connector.h b/include/drm/drm_connector.h
index e5f641cdab5a4..f9f85a466cb8a 100644
--- a/include/drm/drm_connector.h
+++ b/include/drm/drm_connector.h
@@ -329,19 +329,47 @@ struct drm_display_info {
 
 #define DRM_BUS_FLAG_DE_LOW		(1<<0)
 #define DRM_BUS_FLAG_DE_HIGH		(1<<1)
-/* drive data on pos. edge */
+
+/*
+ * Don't use those two flags directly, use the DRM_BUS_FLAG_PIXDATA_DRIVE_*
+ * and DRM_BUS_FLAG_PIXDATA_SAMPLE_* variants to qualify the flags explicitly.
+ * The DRM_BUS_FLAG_PIXDATA_SAMPLE_* flags are defined as the opposite of the
+ * DRM_BUS_FLAG_PIXDATA_DRIVE_* flags to make code simpler, as signals are
+ * usually to be sampled on the opposite edge of the driving edge.
+ */
 #define DRM_BUS_FLAG_PIXDATA_POSEDGE	(1<<2)
-/* drive data on neg. edge */
 #define DRM_BUS_FLAG_PIXDATA_NEGEDGE	(1<<3)
+
+/* Drive data on rising edge */
+#define DRM_BUS_FLAG_PIXDATA_DRIVE_POSEDGE	DRM_BUS_FLAG_PIXDATA_POSEDGE
+/* Drive data on falling edge */
+#define DRM_BUS_FLAG_PIXDATA_DRIVE_NEGEDGE	DRM_BUS_FLAG_PIXDATA_NEGEDGE
+/* Sample data on rising edge */
+#define DRM_BUS_FLAG_PIXDATA_SAMPLE_POSEDGE	DRM_BUS_FLAG_PIXDATA_NEGEDGE
+/* Sample data on falling edge */
+#define DRM_BUS_FLAG_PIXDATA_SAMPLE_NEGEDGE	DRM_BUS_FLAG_PIXDATA_POSEDGE
+
 /* data is transmitted MSB to LSB on the bus */
 #define DRM_BUS_FLAG_DATA_MSB_TO_LSB	(1<<4)
 /* data is transmitted LSB to MSB on the bus */
 #define DRM_BUS_FLAG_DATA_LSB_TO_MSB	(1<<5)
-/* drive sync on pos. edge */
+
+/*
+ * Similarly to the DRM_BUS_FLAG_PIXDATA_* flags, don't use these two flags
+ * directly, use one of the DRM_BUS_FLAG_SYNC_(DRIVE|SAMPLE)_* instead.
+ */
 #define DRM_BUS_FLAG_SYNC_POSEDGE	(1<<6)
-/* drive sync on neg. edge */
 #define DRM_BUS_FLAG_SYNC_NEGEDGE	(1<<7)
 
+/* Drive sync on rising edge */
+#define DRM_BUS_FLAG_SYNC_DRIVE_POSEDGE		DRM_BUS_FLAG_SYNC_POSEDGE
+/* Drive sync on falling edge */
+#define DRM_BUS_FLAG_SYNC_DRIVE_NEGEDGE		DRM_BUS_FLAG_SYNC_NEGEDGE
+/* Sample sync on rising edge */
+#define DRM_BUS_FLAG_SYNC_SAMPLE_POSEDGE	DRM_BUS_FLAG_SYNC_NEGEDGE
+/* Sample sync on falling edge */
+#define DRM_BUS_FLAG_SYNC_SAMPLE_NEGEDGE	DRM_BUS_FLAG_SYNC_POSEDGE
+
 	/**
 	 * @bus_flags: Additional information (like pixel signal polarity) for
 	 * the pixel data on the bus, using DRM_BUS_FLAGS\_ defines.
-- 
2.39.2



