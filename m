Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 03AFC5AAFC0
	for <lists+stable@lfdr.de>; Fri,  2 Sep 2022 14:44:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237195AbiIBMo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Sep 2022 08:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236453AbiIBMmx (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Sep 2022 08:42:53 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84672E097B;
        Fri,  2 Sep 2022 05:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 964B4B82ACA;
        Fri,  2 Sep 2022 12:31:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94D5CC433B5;
        Fri,  2 Sep 2022 12:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662121889;
        bh=Yf0GyPVtGLFY7mUBC87iG8NI72I00Kg6i/hzhR2+838=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DyRNAILHuuJREQxD6u6QcMV1oqa7TFjgAFLPsCmLW+NfHCR/6kfPxiukBcjSg1dUL
         z0oTfnEexVDazK9527d0jRyDRH0xHkLVUj/Uv9Ga8vmidsIRSh63RUf9Yp9sHCNDEj
         SruqKX4SBsVZaViD+NR99HHoV+6aBFnM17BfGurY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Randy Dunlap <rdunlap@infradead.org>,
        Maxime Ripard <maxime@cerno.tech>
Subject: [PATCH 5.15 02/73] drm/bridge: Add stubs for devm_drm_of_get_bridge when OF is disabled
Date:   Fri,  2 Sep 2022 14:18:26 +0200
Message-Id: <20220902121404.517094115@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220902121404.435662285@linuxfoundation.org>
References: <20220902121404.435662285@linuxfoundation.org>
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

From: Maxime Ripard <maxime@cerno.tech>

commit 59050d783848d9b62e9d8fb6ce0cd00771c2bf87 upstream.

If CONFIG_OF is disabled, devm_drm_of_get_bridge won't be compiled in
and drivers using that function will fail to build.

Add an inline stub so that we can still build-test those cases.

Reported-by: Randy Dunlap <rdunlap@infradead.org>
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Acked-by: Randy Dunlap <rdunlap@infradead.org> # build-tested
Link: https://patchwork.freedesktop.org/patch/msgid/20210928181333.1176840-1-maxime@cerno.tech
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/drm_bridge.h |   13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

--- a/include/drm/drm_bridge.h
+++ b/include/drm/drm_bridge.h
@@ -911,9 +911,20 @@ struct drm_bridge *devm_drm_panel_bridge
 struct drm_bridge *devm_drm_panel_bridge_add_typed(struct device *dev,
 						   struct drm_panel *panel,
 						   u32 connector_type);
+struct drm_connector *drm_panel_bridge_connector(struct drm_bridge *bridge);
+#endif
+
+#if defined(CONFIG_OF) && defined(CONFIG_DRM_PANEL_BRIDGE)
 struct drm_bridge *devm_drm_of_get_bridge(struct device *dev, struct device_node *node,
 					  u32 port, u32 endpoint);
-struct drm_connector *drm_panel_bridge_connector(struct drm_bridge *bridge);
+#else
+static inline struct drm_bridge *devm_drm_of_get_bridge(struct device *dev,
+							struct device_node *node,
+							u32 port,
+							u32 endpoint)
+{
+	return ERR_PTR(-ENODEV);
+}
 #endif
 
 #endif


