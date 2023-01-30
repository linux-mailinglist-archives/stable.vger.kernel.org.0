Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F82A681079
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:03:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236926AbjA3ODr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:03:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42772 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236956AbjA3ODl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:03:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8E3A193F2
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:03:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4C7736102D
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:03:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D898C433EF;
        Mon, 30 Jan 2023 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087412;
        bh=y8DANwa9r8BrpiMpP9xKg5+PSuooKCJqyFKOQgHqsMQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eC/IFsvLGey9g3tIiPQkcHu6bTdsLvqsiT2CfxQ177rZ9/h2y8pXAnQIotE0Shy7w
         B8AR6duymyj0awtKbE3pwqKjB7RbV8qv90+hPup74bQ19V1Z6KpdD9PcyWtJOQaZp8
         RnuRH2yRyJwkMKWw1GOquxNeEmWiSv4fbucCur2o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 198/313] drm/i915: Allow panel fixed modes to have differing sync polarities
Date:   Mon, 30 Jan 2023 14:50:33 +0100
Message-Id: <20230130134345.927614369@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 2bd0db4b3f0bd529f75b32538fc5a3775e3591c0 ]

Apparently some panels declare multiple modes with random
sync polarities. Seems a bit weird, but looks like Windows/GOP
doesn't care, so let follow suit and accept alternate fixed
modes regardless of their sync polarities.

v2: Don't pollute the DRM_ namespace with a define (Jani)

Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6968
Acked-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221020093938.27200-1-ville.syrjala@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_panel.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_panel.c b/drivers/gpu/drm/i915/display/intel_panel.c
index 41cec9dc4223..f72f4646c0d7 100644
--- a/drivers/gpu/drm/i915/display/intel_panel.c
+++ b/drivers/gpu/drm/i915/display/intel_panel.c
@@ -85,9 +85,10 @@ static bool is_alt_drrs_mode(const struct drm_display_mode *mode,
 static bool is_alt_fixed_mode(const struct drm_display_mode *mode,
 			      const struct drm_display_mode *preferred_mode)
 {
-	return drm_mode_match(mode, preferred_mode,
-			      DRM_MODE_MATCH_FLAGS |
-			      DRM_MODE_MATCH_3D_FLAGS) &&
+	u32 sync_flags = DRM_MODE_FLAG_PHSYNC | DRM_MODE_FLAG_NHSYNC |
+		DRM_MODE_FLAG_PVSYNC | DRM_MODE_FLAG_NVSYNC;
+
+	return (mode->flags & ~sync_flags) == (preferred_mode->flags & ~sync_flags) &&
 		mode->hdisplay == preferred_mode->hdisplay &&
 		mode->vdisplay == preferred_mode->vdisplay;
 }
-- 
2.39.0



