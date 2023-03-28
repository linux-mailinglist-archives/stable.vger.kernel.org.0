Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217256CC2A6
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 16:47:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233289AbjC1OrX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 10:47:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbjC1OrK (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 10:47:10 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74BCEE06E
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 07:46:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 180EE61827
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 14:46:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A1B6C433D2;
        Tue, 28 Mar 2023 14:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680014807;
        bh=gQxc+3WKPVTBXitOCBuOXHUTTuLHFnQGH+NYDA+012c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RLskUJKJnBGfAsaxSBcN1B9YMri5c7aC2LW+EwYCBn2hVcEN1tF3/x25UuoqrK2k
         ejEK3MF1Kq74V6p4YBpmScgGaVFskIJQkY5RXzIw+dqOhIN06Yz8BOc9xgEXwzIsF3
         hqF4n7BgyWsP0jq8g5IghpN9G7AO07+W6WhIHuq0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Jani Nikula <jani.nikula@intel.com>,
        Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 059/240] drm/i915: Update vblank timestamping stuff on seamless M/N change
Date:   Tue, 28 Mar 2023 16:40:22 +0200
Message-Id: <20230328142622.178499619@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230328142619.643313678@linuxfoundation.org>
References: <20230328142619.643313678@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

[ Upstream commit 59ad01c786a4c94afacc7feb0ab97bf8d6672a46 ]

When we change the M/N values seamlessly during a fastset we should
also update the vblank timestamping stuff to make sure the vblank
timestamp corrections/guesstimations come out exact.

Note that only crtc_clock and framedur_ns can actually end up
changing here during fastsets. Everything else we touch can
only change during full modesets.

Technically we should try to do this exactly at the start of
vblank, but that would require some kind of double buffering
scheme. Let's skip that for now and just update things right
after the commit has been submitted to the hardware. This
means the information will be properly up to date when the
vblank irq handler goes to work. Only if someone ends up
querying some vblanky stuff in between the commit and start
of vblank may we see a slight discrepancy.

Also this same problem really exists for the DRRS downclocking
stuff. But as that is supposed to be more or less transparent
to the user, and it only drops to low gear after a long delay
(1 sec currently) we probably don't have to worry about it.
Any time something is actively submitting updates DRRS will
remain in high gear and so the timestamping constants will
match the hardware state.

Reviewed-by: Jani Nikula <jani.nikula@intel.com>
Reviewed-by: Mitul Golani <mitulkumar.ajitkumar.golani@intel.com>
Fixes: e6f29923c048 ("drm/i915: Allow M/N change during fastset on bdw+")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230310235828.17439-1-ville.syrjala@linux.intel.com
(cherry picked from commit 8cb1f95cca68421b08333175719fdd3615372ca8)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/display/intel_crtc.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/gpu/drm/i915/display/intel_crtc.c b/drivers/gpu/drm/i915/display/intel_crtc.c
index 037fc140b585c..098acef59c10f 100644
--- a/drivers/gpu/drm/i915/display/intel_crtc.c
+++ b/drivers/gpu/drm/i915/display/intel_crtc.c
@@ -682,6 +682,14 @@ void intel_pipe_update_end(struct intel_crtc_state *new_crtc_state)
 	 */
 	intel_vrr_send_push(new_crtc_state);
 
+	/*
+	 * Seamless M/N update may need to update frame timings.
+	 *
+	 * FIXME Should be synchronized with the start of vblank somehow...
+	 */
+	if (new_crtc_state->seamless_m_n && intel_crtc_needs_fastset(new_crtc_state))
+		intel_crtc_update_active_timings(new_crtc_state);
+
 	local_irq_enable();
 
 	if (intel_vgpu_active(dev_priv))
-- 
2.39.2



