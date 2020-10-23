Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 333D9296FAC
	for <lists+stable@lfdr.de>; Fri, 23 Oct 2020 14:48:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S464043AbgJWMsS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 23 Oct 2020 08:48:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S464042AbgJWMsR (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 23 Oct 2020 08:48:17 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC36FC0613CE;
        Fri, 23 Oct 2020 05:48:17 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id z33so751970qth.8;
        Fri, 23 Oct 2020 05:48:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kN9kvxiNVibBZTgq0gJlnAcXQlAi8tvlS3bLfxZ/9Tg=;
        b=iSruePsCDOSSSek8VmIdWIecZPJdKPQB8neXqqeC0RcF1jNjM1uQe/LYOBgrDFst7v
         k5UG8O4FaKJKN9Jq7EVBEvVG38rRjFCJ0J9xaAdZQOgCfmryI2Wd16uQFD0JYjAMiMJu
         CLyQuSW+UJkXQHG1gsguO4sAuTUi3XRwEV12KQoirWZaDJ/vLsEJOMp6pFA4Gs9aUFd9
         M0y2qhI+FNmAKp7i1dp/JeSaZCd3FL9V/ZfYFAFI92YyaCSGP/RwUfQ1Q3bK4eVm3YI0
         vfdYpbi9wIB3/huwm73ZW8Bgs96cH65iOqmbHKOXWsl5iVXPCoFrbSQUH6fbHfz7jInJ
         3LbQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=kN9kvxiNVibBZTgq0gJlnAcXQlAi8tvlS3bLfxZ/9Tg=;
        b=It3EAbpb11/EDzS/2hw2x2GRi3w3rj59MNT/msyR0IdxkcV4arhPJCALZuMRUHO//g
         sitRyy3eKCNdU5SJc7dyDWQW7MFXHQSsMHscSOIDvlS/LMC/RmJI94yZx5xjZWWstWGp
         TdqMgZzGjWO/KzTg7+CctCl96rVTW3OuDYz3LZgqA7UsNQc2RXI6xRLApTjKKw+8EaFd
         CAaXJEtMpaXoSFC8GcnVdkvDh85zPBqfXhnCXOoyQOaaljdrBoJvjnAstQWWhFOhHsjl
         sOGoJNEBvOQXKJOfew8ibr9y7M0y7Cq+ZgWiKqCWTblkYzuny4RPGbDMN1nkS6UQtkOl
         0Vnw==
X-Gm-Message-State: AOAM533N266A3kV2RYNlrhyO/C0W7kTClidGdVBLR6bQqvL7+zC0a4fN
        m0PUiyC5aI+AxmQI6eEFwg8=
X-Google-Smtp-Source: ABdhPJwss66nnNh/TIoNtNpkFq5ijx+SQxOSU4m66935MInf9uh/+db78AydLcYVToxU309qomK8BQ==
X-Received: by 2002:ac8:5bc2:: with SMTP id b2mr1951485qtb.284.1603457296761;
        Fri, 23 Oct 2020 05:48:16 -0700 (PDT)
Received: from pm2-ws13.praxislan02.com ([2001:470:8:67e:ba27:ebff:fee8:ce27])
        by smtp.gmail.com with ESMTPSA id q188sm626586qka.56.2020.10.23.05.48.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 23 Oct 2020 05:48:16 -0700 (PDT)
From:   Jason Andryuk <jandryuk@gmail.com>
To:     Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc:     Jason Andryuk <jandryuk@gmail.com>, stable@vger.kernel.org,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] i915: Add QUIRK_EDP_CHANNEL_EQ for Dell 7200 2-in-1
Date:   Fri, 23 Oct 2020 08:48:04 -0400
Message-Id: <20201023124804.11457-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We're seeing channel equalization "fail" consistently coming out of DPMS
on the eDP of a Dell Latitude 7200 2-in-1.  When the display tries to
come out of DPMS, it briefly flashes on before going dark.  This repeats
once per second, and the system is unusable.  ssh-ing into the system,
it also seems to be sluggish when in this state.  You have to reboot to
get the display back.

In intel_dp_link_training_channel_equalization, lane 0 can get to state
0x7 by the 3rd pattern, but lane 1 never gets further than 0x1.
[drm] ln0_1:0x0 ln2_3:0x0 align:0x0 sink:0x0 adj_req0_1:0x0 adj_req2_3:0x0
[drm] ln0_1:0x11 ln2_3:0x0 align:0x80 sink:0x0 adj_req0_1:0x44 adj_req2_3:0x0
[drm] ln0_1:0x11 ln2_3:0x0 align:0x80 sink:0x0 adj_req0_1:0x88 adj_req2_3:0x0
[drm] ln0_1:0x71 ln2_3:0x0 align:0x80 sink:0x0 adj_req0_1:0x84 adj_req2_3:0x0
[drm] ln0_1:0x71 ln2_3:0x0 align:0x0 sink:0x0 adj_req0_1:0x84 adj_req2_3:0x0
[drm] ln0_1:0x71 ln2_3:0x0 align:0x0 sink:0x0 adj_req0_1:0x84 adj_req2_3:0x0

Narrow fast vs. wide slow is not an option because the max clock is
270000 and the 1920x1280 resolution requires 2x270000.
[drm] DP link computation with lane count min/max 1/2 270000/270000 bpp
min/max 18/24 pixel clock 164250KHz

The display is functional even though lane 1 is in state 0x1, so just
return success for channel equalization on eDP.

Introduce QUIRK_EDP_CHANNEL_EQ and match the DMI for a Dell Latitude
7200 2-in-1.  This quirk allows channel equalization to succeed even
though it failed.

Workaround for https://gitlab.freedesktop.org/drm/intel/-/issues/1378

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Cc: <stable@vger.kernel.org>
---
 .../drm/i915/display/intel_dp_link_training.c |  7 +++++
 drivers/gpu/drm/i915/display/intel_quirks.c   | 30 +++++++++++++++++++
 drivers/gpu/drm/i915/i915_drv.h               |  1 +
 3 files changed, 38 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index a23ed7290843..2dd441a94fda 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -375,6 +375,13 @@ intel_dp_link_training_channel_equalization(struct intel_dp *intel_dp)
 
 	intel_dp_set_idle_link_train(intel_dp);
 
+	if (channel_eq == false &&
+	    intel_dp_is_edp(intel_dp) &&
+	    i915->quirks & QUIRK_EDP_CHANNEL_EQ) {
+		DRM_NOTE("Forcing channel_eq success for eDP\n");
+		channel_eq = true;
+	}
+
 	return channel_eq;
 
 }
diff --git a/drivers/gpu/drm/i915/display/intel_quirks.c b/drivers/gpu/drm/i915/display/intel_quirks.c
index 46beb155d835..b45b23680321 100644
--- a/drivers/gpu/drm/i915/display/intel_quirks.c
+++ b/drivers/gpu/drm/i915/display/intel_quirks.c
@@ -53,6 +53,17 @@ static void quirk_increase_ddi_disabled_time(struct drm_i915_private *i915)
 	drm_info(&i915->drm, "Applying Increase DDI Disabled quirk\n");
 }
 
+/*
+ * Some machines (Dell Latitude 7200 2-in-1) fail channel equalization
+ * on their eDP when it is actually usable.  This lets channel_eq
+ * report success.
+ */
+static void quirk_edp_channel_eq(struct drm_i915_private *i915)
+{
+	i915->quirks |= QUIRK_EDP_CHANNEL_EQ;
+	drm_info(&i915->drm, "applying eDP channel_eq quirk\n");
+}
+
 struct intel_quirk {
 	int device;
 	int subsystem_vendor;
@@ -72,6 +83,12 @@ static int intel_dmi_reverse_brightness(const struct dmi_system_id *id)
 	return 1;
 }
 
+static int intel_dmi_edp_channel_eq(const struct dmi_system_id *id)
+{
+	DRM_INFO("eDP channel_eq workaround on %s\n", id->ident);
+	return 1;
+}
+
 static const struct intel_dmi_quirk intel_dmi_quirks[] = {
 	{
 		.dmi_id_list = &(const struct dmi_system_id[]) {
@@ -96,6 +113,19 @@ static const struct intel_dmi_quirk intel_dmi_quirks[] = {
 		},
 		.hook = quirk_invert_brightness,
 	},
+	{
+		.dmi_id_list = &(const struct dmi_system_id[]) {
+			{
+				.callback = intel_dmi_edp_channel_eq,
+				.ident = "Dell Latitude 7200 2-in-1",
+				.matches = {DMI_MATCH(DMI_SYS_VENDOR, "Dell Inc."),
+					    DMI_MATCH(DMI_PRODUCT_NAME, "Latitude 7200 2-in-1"),
+				},
+			},
+			{ }  /* terminating entry */
+		},
+		.hook = quirk_edp_channel_eq,
+	},
 };
 
 static struct intel_quirk intel_quirks[] = {
diff --git a/drivers/gpu/drm/i915/i915_drv.h b/drivers/gpu/drm/i915/i915_drv.h
index e4f7f6518945..fc32ea7380b7 100644
--- a/drivers/gpu/drm/i915/i915_drv.h
+++ b/drivers/gpu/drm/i915/i915_drv.h
@@ -525,6 +525,7 @@ struct i915_psr {
 #define QUIRK_PIN_SWIZZLED_PAGES (1<<5)
 #define QUIRK_INCREASE_T12_DELAY (1<<6)
 #define QUIRK_INCREASE_DDI_DISABLED_TIME (1<<7)
+#define QUIRK_EDP_CHANNEL_EQ (1<<8)
 
 struct intel_fbdev;
 struct intel_fbc_work;
-- 
2.26.2

