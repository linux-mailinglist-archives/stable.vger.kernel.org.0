Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1B53662800D
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237725AbiKNNDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237727AbiKNNDF (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CA22981C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 62384B80EB8
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8445BC433D6;
        Mon, 14 Nov 2022 13:03:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430982;
        bh=biixqmWxD53mMNFl7XdHDOf86v0B1fkpdMGB6CJ2dtE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Vz4gCuOYU3OiWKyDCZ8Mi3GKv8XxK5vPz27PllgYfl0tqLSTaztsPcbjFewzm63Vx
         k2Kojiz04N4jSH12RoOC0WkewEk94yrE1uYMcKNOjm5QJ7SiGCxyer9dybKkwfovVk
         siqKGpeQ16CCx7Na/d57CRLM4oc9W41ndovIe/KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Mika Kahola <mika.kahola@intel.com>,
        =?UTF-8?q?Jouni=20H=C3=B6gander?= <jouni.hogander@intel.com>,
        "Brian J. Tarricone" <brian@tarricone.org>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 057/190] drm/i915/psr: Send update also on invalidate
Date:   Mon, 14 Nov 2022 13:44:41 +0100
Message-Id: <20221114124501.254451723@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jouni Högander <jouni.hogander@intel.com>

[ Upstream commit 4ff4ebac3f1378f4ba6e11fe5ad4a4ac590bb8a4 ]

Currently we are observing mouse cursor stuttering when using
xrandr --scaling=1.2x1.2. X scaling/transformation seems to be
doing fronbuffer rendering. When moving mouse cursor X seems to
perform several invalidates and only one DirtyFB. I.e. it seems
to be assuming updates are sent to panel while drawing is done.

Earlier we were disabling PSR in frontbuffer invalidate call back
(when drawing in X started). PSR was re-enabled in frontbuffer
flush callback (dirtyfb ioctl). This was working fine with X
scaling/transformation. Now we are just enabling continuous full
frame (cff) in PSR invalidate callback. Enabling cff doesn't
trigger any updates. It just configures PSR to send full frame
when updates are sent. I.e. there are no updates on screen before
PSR flush callback is made. X seems to be doing several updates
in frontbuffer before doing dirtyfb ioctl.

Fix this by sending single update on every invalidate callback.

Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: Mika Kahola <mika.kahola@intel.com>

Fixes: 805f04d42a6b ("drm/i915/display/psr: Use continuos full frame to handle frontbuffer invalidations")
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6679
Signed-off-by: Jouni Högander <jouni.hogander@intel.com>
Reported-by: Brian J. Tarricone <brian@tarricone.org>
Tested-by: Brian J. Tarricone <brian@tarricone.org>
Reviewed-by: Mika Kahola <mika.kahola@intel.com>
Reviewed-by: José Roberto de Souza <jose.souza@intel.com>
Signed-off-by: José Roberto de Souza <jose.souza@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221024054649.31299-1-jouni.hogander@intel.com
(cherry picked from commit d755f89220a2b49bc90b7b520bb6edeb4adb5f01)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_psr.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index e6a870641cd2..fbe777e02ea7 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -2188,8 +2188,11 @@ static void _psr_invalidate_handle(struct intel_dp *intel_dp)
 	if (intel_dp->psr.psr2_sel_fetch_enabled) {
 		u32 val;
 
-		if (intel_dp->psr.psr2_sel_fetch_cff_enabled)
+		if (intel_dp->psr.psr2_sel_fetch_cff_enabled) {
+			/* Send one update otherwise lag is observed in screen */
+			intel_de_write(dev_priv, CURSURFLIVE(intel_dp->psr.pipe), 0);
 			return;
+		}
 
 		val = man_trk_ctl_enable_bit_get(dev_priv) |
 		      man_trk_ctl_partial_frame_bit_get(dev_priv) |
-- 
2.35.1



