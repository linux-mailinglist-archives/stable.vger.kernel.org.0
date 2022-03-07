Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 710514CF816
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:52:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232908AbiCGJvU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:51:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238193AbiCGJrj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:47:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87D3F6BDDF;
        Mon,  7 Mar 2022 01:42:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A7738B80F9F;
        Mon,  7 Mar 2022 09:42:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4140C340F3;
        Mon,  7 Mar 2022 09:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646646134;
        bh=4b9lc6dNYJNoodIAKdmSZ8H3CH+rild8TcdIru7YDj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wJ0fo5z5Mahnj+hDUvQkR61YTNTBzfZzElO0GtUAkMNKh7EhzUxQjKGEamC8T7riq
         XrqVxv2o8/JogSJD4r7eTcSwto5RL8T1VrRe8vf04I+LGTmzzzH7fZcxAp3UkrvJlK
         F1Geu+tIIdD+Spty1kGuMVDma3qVl3CPais92xaI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matt Roper <matthew.d.roper@intel.com>,
        Vivek Kasireddy <vivek.kasireddy@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>, Tomas Bzatek <bugs@bzatek.net>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 5.15 145/262] drm/i915: s/JSP2/ICP2/ PCH
Date:   Mon,  7 Mar 2022 10:18:09 +0100
Message-Id: <20220307091706.537904667@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091702.378509770@linuxfoundation.org>
References: <20220307091702.378509770@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 08783aa7693f55619859f4f63f384abf17cb58c5 upstream.

This JSP2 PCH actually seems to be some special Apple
specific ICP variant rather than a JSP. Make it so. Or at
least all the references to it seem to be some Apple ICL
machines. Didn't manage to find these PCI IDs in any
public chipset docs unfortunately.

The only thing we're losing here with this JSP->ICP change
is Wa_14011294188, but based on the HSD that isn't actually
needed on any ICP based design (including JSP), only TGP
based stuff (including MCC) really need it. The documented
w/a just never made that distinction because Windows didn't
want to differentiate between JSP and MCC (not sure how
they handle hpd/ddc/etc. then though...).

Cc: stable@vger.kernel.org
Cc: Matt Roper <matthew.d.roper@intel.com>
Cc: Vivek Kasireddy <vivek.kasireddy@intel.com>
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/4226
Fixes: 943682e3bd19 ("drm/i915: Introduce Jasper Lake PCH")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220224132142.12927-1-ville.syrjala@linux.intel.com
Acked-by: Vivek Kasireddy <vivek.kasireddy@intel.com>
Tested-by: Tomas Bzatek <bugs@bzatek.net>
(cherry picked from commit 53581504a8e216d435f114a4f2596ad0dfd902fc)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/intel_pch.c |    2 +-
 drivers/gpu/drm/i915/intel_pch.h |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/intel_pch.c
+++ b/drivers/gpu/drm/i915/intel_pch.c
@@ -108,6 +108,7 @@ intel_pch_type(const struct drm_i915_pri
 		/* Comet Lake V PCH is based on KBP, which is SPT compatible */
 		return PCH_SPT;
 	case INTEL_PCH_ICP_DEVICE_ID_TYPE:
+	case INTEL_PCH_ICP2_DEVICE_ID_TYPE:
 		drm_dbg_kms(&dev_priv->drm, "Found Ice Lake PCH\n");
 		drm_WARN_ON(&dev_priv->drm, !IS_ICELAKE(dev_priv));
 		return PCH_ICP;
@@ -123,7 +124,6 @@ intel_pch_type(const struct drm_i915_pri
 			    !IS_GEN9_BC(dev_priv));
 		return PCH_TGP;
 	case INTEL_PCH_JSP_DEVICE_ID_TYPE:
-	case INTEL_PCH_JSP2_DEVICE_ID_TYPE:
 		drm_dbg_kms(&dev_priv->drm, "Found Jasper Lake PCH\n");
 		drm_WARN_ON(&dev_priv->drm, !IS_JSL_EHL(dev_priv));
 		return PCH_JSP;
--- a/drivers/gpu/drm/i915/intel_pch.h
+++ b/drivers/gpu/drm/i915/intel_pch.h
@@ -50,11 +50,11 @@ enum intel_pch {
 #define INTEL_PCH_CMP2_DEVICE_ID_TYPE		0x0680
 #define INTEL_PCH_CMP_V_DEVICE_ID_TYPE		0xA380
 #define INTEL_PCH_ICP_DEVICE_ID_TYPE		0x3480
+#define INTEL_PCH_ICP2_DEVICE_ID_TYPE		0x3880
 #define INTEL_PCH_MCC_DEVICE_ID_TYPE		0x4B00
 #define INTEL_PCH_TGP_DEVICE_ID_TYPE		0xA080
 #define INTEL_PCH_TGP2_DEVICE_ID_TYPE		0x4380
 #define INTEL_PCH_JSP_DEVICE_ID_TYPE		0x4D80
-#define INTEL_PCH_JSP2_DEVICE_ID_TYPE		0x3880
 #define INTEL_PCH_ADP_DEVICE_ID_TYPE		0x7A80
 #define INTEL_PCH_ADP2_DEVICE_ID_TYPE		0x5180
 #define INTEL_PCH_P2X_DEVICE_ID_TYPE		0x7100


