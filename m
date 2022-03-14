Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DF8B4D842F
	for <lists+stable@lfdr.de>; Mon, 14 Mar 2022 13:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241621AbiCNMXP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Mar 2022 08:23:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242012AbiCNMSl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Mar 2022 08:18:41 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49662443E9;
        Mon, 14 Mar 2022 05:13:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 10A46CE1265;
        Mon, 14 Mar 2022 12:13:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6663C340ED;
        Mon, 14 Mar 2022 12:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1647260000;
        bh=2osQh5Mv6c02RSD7GTzF2a5+tH2zIHPFwlTTaqHCw1c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bfqnbksix3iwkhfXaqEZMCSObEEPGiL8ccJFy8772ZtFSo5RIpdLaCeld0hjKtmR+
         l8dFvM5rxTyp3humV4S5ZRh5X+kOz+xk+tdRx6qaozMqHZDMUnCJcL2PMj8mNwLP3M
         e84V4duRMKuHCCCEEFQSd7Xb2Yxq/JLqntnPjY9g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lyude Paul <lyude@redhat.com>,
        Mihai Harpau <mharpau@gmail.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 029/121] drm/i915/psr: Set "SF Partial Frame Enable" also on full update
Date:   Mon, 14 Mar 2022 12:53:32 +0100
Message-Id: <20220314112744.943328011@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220314112744.120491875@linuxfoundation.org>
References: <20220314112744.120491875@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 804f468853179b9b58af05c153c411931aa5b310 ]

Currently we are observing occasional screen flickering when
PSR2 selective fetch is enabled. More specifically glitch seems
to happen on full frame update when cursor moves to coords
x = -1 or y = -1.

According to Bspec SF Single full frame should not be set if
SF Partial Frame Enable is not set. This happened to be true for
ADLP as PSR2_MAN_TRK_CTL_ENABLE is always set and for ADL_P it's
actually "SF Partial Frame Enable" (Bit 31).

Setting "SF Partial Frame Enable" bit also on full update seems to
fix screen flickering.

Also make code more clear by setting PSR2_MAN_TRK_CTL_ENABLE
only if not on ADL_P. Bit 31 has different meaning in ADL_P.

Bspec: 49274

v2: Fix Mihai Harpau email address
v3: Modify commit message and remove unnecessary comment

Tested-by: Lyude Paul <lyude@redhat.com>
Fixes: 7f6002e58025 ("drm/i915/display: Enable PSR2 selective fetch by default")
Reported-by: Lyude Paul <lyude@redhat.com>
Cc: Mihai Harpau <mharpau@gmail.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Bugzilla: https://gitlab.freedesktop.org/drm/intel/-/issues/5077
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220225070228.855138-1-jouni.hogander@intel.com
(cherry picked from commit 8d5516d18b323cf7274d1cf5fe76f4a691f879c6)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 16 ++++++++++++++--
 drivers/gpu/drm/i915/i915_reg.h          |  1 +
 2 files changed, 15 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index 7a205fd5023b..3ba8b717e176 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -1400,6 +1400,13 @@ static inline u32 man_trk_ctl_single_full_frame_bit_get(struct drm_i915_private
 	       PSR2_MAN_TRK_CTL_SF_SINGLE_FULL_FRAME;
 }
 
+static inline u32 man_trk_ctl_partial_frame_bit_get(struct drm_i915_private *dev_priv)
+{
+	return IS_ALDERLAKE_P(dev_priv) ?
+	       ADLP_PSR2_MAN_TRK_CTL_SF_PARTIAL_FRAME_UPDATE :
+	       PSR2_MAN_TRK_CTL_SF_PARTIAL_FRAME_UPDATE;
+}
+
 static void psr_force_hw_tracking_exit(struct intel_dp *intel_dp)
 {
 	struct drm_i915_private *dev_priv = dp_to_i915(intel_dp);
@@ -1495,7 +1502,13 @@ static void psr2_man_trk_ctl_calc(struct intel_crtc_state *crtc_state,
 {
 	struct intel_crtc *crtc = to_intel_crtc(crtc_state->uapi.crtc);
 	struct drm_i915_private *dev_priv = to_i915(crtc->base.dev);
-	u32 val = PSR2_MAN_TRK_CTL_ENABLE;
+	u32 val = 0;
+
+	if (!IS_ALDERLAKE_P(dev_priv))
+		val = PSR2_MAN_TRK_CTL_ENABLE;
+
+	/* SF partial frame enable has to be set even on full update */
+	val |= man_trk_ctl_partial_frame_bit_get(dev_priv);
 
 	if (full_update) {
 		/*
@@ -1515,7 +1528,6 @@ static void psr2_man_trk_ctl_calc(struct intel_crtc_state *crtc_state,
 	} else {
 		drm_WARN_ON(crtc_state->uapi.crtc->dev, clip->y1 % 4 || clip->y2 % 4);
 
-		val |= PSR2_MAN_TRK_CTL_SF_PARTIAL_FRAME_UPDATE;
 		val |= PSR2_MAN_TRK_CTL_SU_REGION_START_ADDR(clip->y1 / 4 + 1);
 		val |= PSR2_MAN_TRK_CTL_SU_REGION_END_ADDR(clip->y2 / 4 + 1);
 	}
diff --git a/drivers/gpu/drm/i915/i915_reg.h b/drivers/gpu/drm/i915/i915_reg.h
index 14ce8809efdd..e927776ae183 100644
--- a/drivers/gpu/drm/i915/i915_reg.h
+++ b/drivers/gpu/drm/i915/i915_reg.h
@@ -4738,6 +4738,7 @@ enum {
 #define  ADLP_PSR2_MAN_TRK_CTL_SU_REGION_START_ADDR(val)	REG_FIELD_PREP(ADLP_PSR2_MAN_TRK_CTL_SU_REGION_START_ADDR_MASK, val)
 #define  ADLP_PSR2_MAN_TRK_CTL_SU_REGION_END_ADDR_MASK		REG_GENMASK(12, 0)
 #define  ADLP_PSR2_MAN_TRK_CTL_SU_REGION_END_ADDR(val)		REG_FIELD_PREP(ADLP_PSR2_MAN_TRK_CTL_SU_REGION_END_ADDR_MASK, val)
+#define  ADLP_PSR2_MAN_TRK_CTL_SF_PARTIAL_FRAME_UPDATE		REG_BIT(31)
 #define  ADLP_PSR2_MAN_TRK_CTL_SF_SINGLE_FULL_FRAME		REG_BIT(14)
 #define  ADLP_PSR2_MAN_TRK_CTL_SF_CONTINUOS_FULL_FRAME		REG_BIT(13)
 
-- 
2.34.1



