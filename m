Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9746BB26C
	for <lists+stable@lfdr.de>; Wed, 15 Mar 2023 13:36:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232698AbjCOMgK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Mar 2023 08:36:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232699AbjCOMfw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Mar 2023 08:35:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D5123B3D8
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 05:34:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D352BB81DF9
        for <stable@vger.kernel.org>; Wed, 15 Mar 2023 12:34:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4620EC433D2;
        Wed, 15 Mar 2023 12:34:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678883653;
        bh=jw+jXFWLCteO0ajxlewBx8owfsVx0ByGf2WRTKrDtgs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wmbX23u8CkMGt+jNwsCxr5TldRjmBOG6szaxIrTz5glvlPwXfvM19jBvubM7MnGlM
         ua8cQ/pA+y8xWwoUfIOlCyejb44HN6bDSKIq0VnRYSGFTYcDn9ITH0MSu60EIvJxg0
         yevsoROxXrmXdEUHZ4yUWykIl7Bs9pEYl18GJOOk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Animesh Manna <animesh.manna@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 049/143] drm/i915: Introduce intel_panel_init_alloc()
Date:   Wed, 15 Mar 2023 13:12:15 +0100
Message-Id: <20230315115742.009958721@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit f70f8153e3642337b444fbc0c64d546a46bbcd62 ]

Introduce a place where we can initialize connector->panel
after it's been allocated. We already have a intel_panel_init()
so had to get creative with the name and came up with
intel_panel_init_alloc().

Cc: Animesh Manna <animesh.manna@intel.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221125173156.31689-2-ville.syrjala@linux.intel.com
Stable-dep-of: 14e591a1930c ("drm/i915: Populate encoder->devdata for DSI on icl+")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_connector.c | 2 +-
 drivers/gpu/drm/i915/display/intel_panel.c     | 7 +++++++
 drivers/gpu/drm/i915/display/intel_panel.h     | 1 +
 3 files changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_connector.c b/drivers/gpu/drm/i915/display/intel_connector.c
index 6d5cbeb8df4da..8bb296f3d6252 100644
--- a/drivers/gpu/drm/i915/display/intel_connector.c
+++ b/drivers/gpu/drm/i915/display/intel_connector.c
@@ -54,7 +54,7 @@ int intel_connector_init(struct intel_connector *connector)
 	__drm_atomic_helper_connector_reset(&connector->base,
 					    &conn_state->base);
 
-	INIT_LIST_HEAD(&connector->panel.fixed_modes);
+	intel_panel_init_alloc(connector);
 
 	return 0;
 }
diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index f72f4646c0d70..8bd7af99cd2b9 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -648,6 +648,13 @@ intel_panel_mode_valid(struct intel_connector *connector,
 	return MODE_OK;
 }
 
+void intel_panel_init_alloc(struct intel_connector *connector)
+{
+	struct intel_panel *panel = &connector->panel;
+
+	INIT_LIST_HEAD(&panel->fixed_modes);
+}
+
 int intel_panel_init(struct intel_connector *connector)
 {
 	struct intel_panel *panel = &connector->panel;
diff --git a/drivers/gpu/drm/i915/display/intel_panel.h b/drivers/gpu/drm/i915/display/intel_panel.h
index 5c5b5b7f95b6c..4b51e1c51da62 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.h
+++ b/drivers/gpu/drm/i915/display/intel_panel.h
@@ -18,6 +18,7 @@ struct intel_connector;
 struct intel_crtc_state;
 struct intel_encoder;
 
+void intel_panel_init_alloc(struct intel_connector *connector);
 int intel_panel_init(struct intel_connector *connector);
 void intel_panel_fini(struct intel_connector *connector);
 enum drm_connector_status
-- 
2.39.2



