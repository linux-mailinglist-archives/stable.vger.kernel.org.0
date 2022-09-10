Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97B1D5B44D1
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 08:52:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiIJGwy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 02:52:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbiIJGwx (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 02:52:53 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C80E7963E
        for <stable@vger.kernel.org>; Fri,  9 Sep 2022 23:52:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 207B960C01
        for <stable@vger.kernel.org>; Sat, 10 Sep 2022 06:52:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D90FCC433D6;
        Sat, 10 Sep 2022 06:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662792771;
        bh=jflQtBab/oRIwnnNapv8HwPV26lZnawQUZsw5Oy8lpk=;
        h=Subject:To:Cc:From:Date:From;
        b=EvF8lrZexboHqyFaP2PdsuEK3NtckeK/lDDT1jjGtqFpdAAUToINMkdCTxQCGDM3T
         kpO9gV3ds3uDwZeTJWFj9ifRrgA3XRkz01e1yNI7s+6d84YRB8ZZvXj68/cArpvHqs
         1Z2kaPiBWWMqbA9wWW+Av6lzFAAi00tx41GzO/Yk=
Subject: FAILED: patch "[PATCH] drm/i915: Implement WaEdpLinkRateDataReload" failed to apply to 5.4-stable tree
To:     ville.syrjala@linux.intel.com, Jason@zx2c4.com,
        aaron.ma@canonical.com, ankit.k.nautiyal@intel.com,
        jani.nikula@intel.com, rodrigo.vivi@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 10 Sep 2022 08:53:13 +0200
Message-ID: <166279279319234@kroah.com>
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


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

672d6ca75865 ("drm/i915: Implement WaEdpLinkRateDataReload")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 672d6ca758651f0ec12cd0d59787067a5bde1c96 Mon Sep 17 00:00:00 2001
From: =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= <ville.syrjala@linux.intel.com>
Date: Fri, 2 Sep 2022 10:03:18 +0300
Subject: [PATCH] drm/i915: Implement WaEdpLinkRateDataReload
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

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

diff --git a/drivers/gpu/drm/i915/display/intel_dp_link_training.c b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
index 9feaf1a589f3..d213d8ad1ea5 100644
--- a/drivers/gpu/drm/i915/display/intel_dp_link_training.c
+++ b/drivers/gpu/drm/i915/display/intel_dp_link_training.c
@@ -671,6 +671,28 @@ intel_dp_prepare_link_train(struct intel_dp *intel_dp,
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
 			    "[ENCODER:%d:%s] Using LINK_BW_SET value %02x\n",

