Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C8B454B4B5C
	for <lists+stable@lfdr.de>; Mon, 14 Feb 2022 11:41:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346954AbiBNK1v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Feb 2022 05:27:51 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348375AbiBNK0z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Feb 2022 05:26:55 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73C038301E;
        Mon, 14 Feb 2022 01:57:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8F26B80DCE;
        Mon, 14 Feb 2022 09:57:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F15C4C340E9;
        Mon, 14 Feb 2022 09:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644832670;
        bh=Jxz/D8ATym+ryfklp5SjcQN48vMeOigzH2dvKKlKqWQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iEUrECsVoilixxT6UI9ryS+ldTy4jOH2FXtXkl4wtP3SWUjOtpQB1NqeL4o5mJzc5
         v+fjbvZGNbSHQpjiPkEWjqne2G5KDSFH2t5ZAyWnLSg+/cdxDDY6PFCfSjtdnSfnXL
         YJpkiuvqKvgPnafbmq762apa6aIJ4V9XiH7aPYAo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.16 089/203] drm/i915: Disable DRRS on IVB/HSW port != A
Date:   Mon, 14 Feb 2022 10:25:33 +0100
Message-Id: <20220214092513.289637602@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220214092510.221474733@linuxfoundation.org>
References: <20220214092510.221474733@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit ee59792c97176f12c1da31f29fc4c2aab187f06e upstream.

Currently we allow DRRS on IVB PCH ports, but we're missing a
few programming steps meaning it is guaranteed to not work.
And on HSW DRRS is not supported on anything but port A ever
as only transcoder EDP has the M2/N2 registers (though I'm
not sure if HSW ever has eDP on any other port).

Starting from BDW all transcoders have the dynamically
reprogrammable M/N registers so DRRS could work on any
port.

Stop initializing DRRS on ports where it cannot possibly work.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220128103757.22461-11-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit f0d4ce59f4d48622044933054a0e0cefa91ba15e)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_drrs.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/drivers/gpu/drm/i915/display/intel_drrs.c
+++ b/drivers/gpu/drm/i915/display/intel_drrs.c
@@ -405,6 +405,7 @@ intel_drrs_init(struct intel_connector *
 		struct drm_display_mode *fixed_mode)
 {
 	struct drm_i915_private *dev_priv = to_i915(connector->base.dev);
+	struct intel_encoder *encoder = connector->encoder;
 	struct drm_display_mode *downclock_mode = NULL;
 
 	INIT_DELAYED_WORK(&dev_priv->drrs.work, intel_drrs_downclock_work);
@@ -416,6 +417,13 @@ intel_drrs_init(struct intel_connector *
 		return NULL;
 	}
 
+	if ((DISPLAY_VER(dev_priv) < 8 && !HAS_GMCH(dev_priv)) &&
+	    encoder->port != PORT_A) {
+		drm_dbg_kms(&dev_priv->drm,
+			    "DRRS only supported on eDP port A\n");
+		return NULL;
+	}
+
 	if (dev_priv->vbt.drrs_type != SEAMLESS_DRRS_SUPPORT) {
 		drm_dbg_kms(&dev_priv->drm, "VBT doesn't support DRRS\n");
 		return NULL;


