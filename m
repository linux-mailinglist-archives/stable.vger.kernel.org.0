Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B9BE45B7106
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 16:43:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234349AbiIMOhb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 10:37:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234116AbiIMOfy (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 10:35:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94FE6B16F;
        Tue, 13 Sep 2022 07:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B3B9D614A3;
        Tue, 13 Sep 2022 14:19:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC80C433D6;
        Tue, 13 Sep 2022 14:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078743;
        bh=kDMmMf1yRrffTbIUOjmtO+5HpD0fMGY6x05p67h0Ru0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=bZN4XPZ8rAZAYKGRY1Wif2LdXI0VZFt0hUCVJMdQ7z5CcDMNv83+ATkij0nBqNtng
         tkB1MMdCN+Z9p0VNg1vre1hiKlxSITwWa1UP1D1BBH8UPQPXm1staA6KoQMCwEKuYJ
         SZybRcbldsoec9ZvYCCl1tuW4FBAbvidr0jj75fE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Aaron Ma <aaron.ma@canonical.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.15 040/121] drm/i915: Implement WaEdpLinkRateDataReload
Date:   Tue, 13 Sep 2022 16:03:51 +0200
Message-Id: <20220913140359.079997709@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
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

commit 672d6ca758651f0ec12cd0d59787067a5bde1c96 upstream.

A lot of modern laptops use the Parade PS8461E MUX for eDP
switching. The MUX can operate in jitter cleaning mode or
redriver mode, the first one resulting in higher link
quality. The jitter cleaning mode needs to know the link
rate used and the MUX achieves this by snooping the
LINK_BW_SET, LINK_RATE_SELECT and SUPPORTED_LINK_RATES
DPCD accesses.

When the MUX is powered down (seems this can happen whenever
the display is turned off) it loses track of the snooped
link rates so when we do the LINK_RATE_SELECT write it no
longer knowns which link rate we're selecting, and thus it
falls back to the lower quality redriver mode. This results
in unstable high link rates (eg. usually 8.1Gbps link rate
no longer works correctly).

In order to avoid all that let's re-snoop SUPPORTED_LINK_RATES
from the sink at the start of every link training.

Unfortunately we don't have a way to detect the presence of
the MUX. It looks like the set of laptops equipped with this
MUX is fairly large and contains devices from multiple
manufacturers. It may also still be growing with new models.
So a quirk doesn't seem like a very easily maintainable
option, thus we shall attempt to do this unconditionally on
all machines that use LINK_RATE_SELECT. Hopefully this extra
DPCD read doesn't cause issues for any unaffected machine.
If that turns out to be the case we'll need to convert this
into a quirk in the future.

Cc: stable@vger.kernel.org
Cc: Jason A. Donenfeld <Jason@zx2c4.com>
Cc: Ankit Nautiyal <ankit.k.nautiyal@intel.com>
Cc: Jani Nikula <jani.nikula@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6205
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220902070319.15395-1-ville.syrjala@linux.intel.com
Tested-by: Aaron Ma <aaron.ma@canonical.com>
Tested-by: Jason A. Donenfeld <Jason@zx2c4.com>
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit 25899c590cb5ba9b9f284c6ca8e7e9086793d641)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dp_link_training.c |   22 ++++++++++++++++++
 1 file changed, 22 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -475,6 +475,28 @@ intel_dp_prepare_link_train(struct intel
 	intel_dp_compute_rate(intel_dp, crtc_state->port_clock,
 			      &link_bw, &rate_select);
 
+	/*
+	 * WaEdpLinkRateDataReload
+	 *
+	 * Parade PS8461E MUX (used on varius TGL+ laptops) needs
+	 * to snoop the link rates reported by the sink when we
+	 * use LINK_RATE_SET in order to operate in jitter cleaning
+	 * mode (as opposed to redriver mode). Unfortunately it
+	 * loses track of the snooped link rates when powered down,
+	 * so we need to make it re-snoop often. Without this high
+	 * link rates are not stable.
+	 */
+	if (!link_bw) {
+		struct intel_connector *connector = intel_dp->attached_connector;
+		__le16 sink_rates[DP_MAX_SUPPORTED_RATES];
+
+		drm_dbg_kms(&i915->drm, "[CONNECTOR:%d:%s] Reloading eDP link rates\n",
+			    connector->base.base.id, connector->base.name);
+
+		drm_dp_dpcd_read(&intel_dp->aux, DP_SUPPORTED_LINK_RATES,
+				 sink_rates, sizeof(sink_rates));
+	}
+
 	if (link_bw)
 		drm_dbg_kms(&i915->drm,
 			    "Using LINK_BW_SET value %02x\n", link_bw);


