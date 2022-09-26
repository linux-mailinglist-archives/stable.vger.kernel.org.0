Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C27545EA3CA
	for <lists+stable@lfdr.de>; Mon, 26 Sep 2022 13:33:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238041AbiIZLdD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 07:33:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237978AbiIZLcQ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 07:32:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F13D4D4E5;
        Mon, 26 Sep 2022 03:42:49 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D0C0AB80760;
        Mon, 26 Sep 2022 10:42:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DBDDC433D6;
        Mon, 26 Sep 2022 10:42:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1664188967;
        bh=pjyeZDQTVBOZdHRAGowF2lpTQHt4ee9V19vOWpiWexI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pfyx43LvSGfiBWaymTSKatxCvNdekurRBpV0CiKByHc3+gJrjn5JghVVoMurtNTqf
         ck9UQyCExg/WXL5DVx9raC9s0DKJGENH/UYMi9iRu1H9Mo0CYqCVKi6HlgmNCgqQG9
         xFGd29rnQkbGF5d14YF33DrJBtTwoV2/3qZ7Xb8c=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 003/207] drm/i915/bios: Split parse_driver_features() into two parts
Date:   Mon, 26 Sep 2022 12:09:52 +0200
Message-Id: <20220926100806.663960091@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220926100806.522017616@linuxfoundation.org>
References: <20220926100806.522017616@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit c3fbcf60bc74b630967f291f47f0d9d0de6fcea7 ]

We use the "driver features" block for two different kinds
of data: global data, and per panel data. Split the function
into two parts along that line so that we can start doing the
parsing in two different locations.

Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220510104242.6099-11-ville.syrjala@linux.intel.com
Stable-dep-of: 607f41768a1e ("drm/i915/dsi: filter invalid backlight and CABC ports")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_bios.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_bios.c b/drivers/gpu/drm/i915/display/intel_bios.c
index 91caf4523b34..5ceabc380808 100644
--- a/drivers/gpu/drm/i915/display/intel_bios.c
+++ b/drivers/gpu/drm/i915/display/intel_bios.c
@@ -1188,6 +1188,16 @@ parse_driver_features(struct drm_i915_private *i915)
 		    driver->lvds_config != BDB_DRIVER_FEATURE_INT_SDVO_LVDS)
 			i915->vbt.int_lvds_support = 0;
 	}
+}
+
+static void
+parse_panel_driver_features(struct drm_i915_private *i915)
+{
+	const struct bdb_driver_features *driver;
+
+	driver = find_section(i915, BDB_DRIVER_FEATURES);
+	if (!driver)
+		return;
 
 	if (i915->vbt.version < 228) {
 		drm_dbg_kms(&i915->drm, "DRRS State Enabled:%d\n",
@@ -2965,6 +2975,7 @@ void intel_bios_init(struct drm_i915_private *i915)
 	parse_lfp_backlight(i915);
 	parse_sdvo_panel_data(i915);
 	parse_driver_features(i915);
+	parse_panel_driver_features(i915);
 	parse_power_conservation_features(i915);
 	parse_edp(i915);
 	parse_psr(i915);
-- 
2.35.1



