Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46A285AEC3A
	for <lists+stable@lfdr.de>; Tue,  6 Sep 2022 16:28:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241089AbiIFOOy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Sep 2022 10:14:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241670AbiIFONu (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 6 Sep 2022 10:13:50 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79C29895DB;
        Tue,  6 Sep 2022 06:48:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1F0206154B;
        Tue,  6 Sep 2022 13:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2571FC433D6;
        Tue,  6 Sep 2022 13:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662472107;
        bh=hp4+wDUz1vpTGA4H7UWt2ATAzuhJfcjdpE/Clgj5Vlc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Z564nEZnPFL7ytdllsrno36x/YfnoDQW+8pmrxH+BH28X+OLDXClhqE/dwc5vH1Rg
         rzVfbRRa4GQrrYTgdKXg0SRjnJ+Lw9HwqFwETI/1b24LWzbIOtkfMN0BtlVKsjipGV
         YmgnK7klrtMuZATk0Tvp38xv3Mxbm78w8JviuvBU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.19 151/155] drm/i915: Skip wm/ddb readout for disabled pipes
Date:   Tue,  6 Sep 2022 15:31:39 +0200
Message-Id: <20220906132835.789925564@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220906132829.417117002@linuxfoundation.org>
References: <20220906132829.417117002@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 0211c2a0ea600e25db3044daaeff4fe41c3ed6d9 upstream.

The stuff programmed into the wm/ddb registers of planes
on disabled pipes doesn't matter. So during readout just
leave our software state tracking for those zeroed.

This should avoid us trying too hard to clean up after
whatever mess the VBIOS/GOP left in there. The actual
hardware state will get cleaned up if/when we enable
the pipe anyway.

Cc: stable@vger.kernel.org
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/5711
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220617195948.24007-1-ville.syrjala@linux.intel.com
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
(cherry picked from commit b183db8f4783ca2efc9b47734f15aad9477a108a)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pm.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/intel_pm.c
+++ b/drivers/gpu/drm/i915/intel_pm.c
@@ -6560,7 +6560,10 @@ void skl_wm_get_hw_state(struct drm_i915
 		enum plane_id plane_id;
 		u8 slices;
 
-		skl_pipe_wm_get_hw_state(crtc, &crtc_state->wm.skl.optimal);
+		memset(&crtc_state->wm.skl.optimal, 0,
+		       sizeof(crtc_state->wm.skl.optimal));
+		if (crtc_state->hw.active)
+			skl_pipe_wm_get_hw_state(crtc, &crtc_state->wm.skl.optimal);
 		crtc_state->wm.skl.raw = crtc_state->wm.skl.optimal;
 
 		memset(&dbuf_state->ddb[pipe], 0, sizeof(dbuf_state->ddb[pipe]));
@@ -6571,6 +6574,9 @@ void skl_wm_get_hw_state(struct drm_i915
 			struct skl_ddb_entry *ddb_y =
 				&crtc_state->wm.skl.plane_ddb_y[plane_id];
 
+			if (!crtc_state->hw.active)
+				continue;
+
 			skl_ddb_get_hw_plane_state(dev_priv, crtc->pipe,
 						   plane_id, ddb, ddb_y);
 


