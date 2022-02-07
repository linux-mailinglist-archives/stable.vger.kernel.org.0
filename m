Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 932984ACB6B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 22:41:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240123AbiBGVjv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 16:39:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231607AbiBGVju (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 16:39:50 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id CA32EC061355
        for <stable@vger.kernel.org>; Mon,  7 Feb 2022 13:39:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1644269988;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=AvJ9N+RokT/quaPmMZhpaU8mvk15cL5DRf0vZEA2K/0=;
        b=Qh4maPoRmIKsHlxU5yBKyt+Dm5+8p2ikEoglcTNgUYSHAMsneDBtsMPvHClVoYrEvTI2Q8
        iRAG8J7AApUpRzv7utsABeW+33UMqXFBt8xdsZBV3FEGTAb//2CfJvy4nmBG6sXGbSz1gC
        Ri5Y/XgkDOkSfVzGHJzAiXTIryelkKY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-441-vgSPi0YHOzOjbRTZsRCqcQ-1; Mon, 07 Feb 2022 16:39:45 -0500
X-MC-Unique: vgSPi0YHOzOjbRTZsRCqcQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 1D0B1101F7A1;
        Mon,  7 Feb 2022 21:39:43 +0000 (UTC)
Received: from emerald.redhat.com (unknown [10.22.8.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0A52E1037F38;
        Mon,  7 Feb 2022 21:39:34 +0000 (UTC)
From:   Lyude Paul <lyude@redhat.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Cc:     Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        =?UTF-8?q?Jos=C3=A9=20Roberto=20de=20Souza?= <jose.souza@intel.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>,
        Matt Roper <matthew.d.roper@intel.com>,
        Lucas De Marchi <lucas.demarchi@intel.com>,
        linux-kernel@vger.kernel.org (open list)
Subject: [PATCH] drm/i915/psr: Disable PSR2 selective fetch for all TGL steps
Date:   Mon,  7 Feb 2022 16:38:20 -0500
Message-Id: <20220207213923.3605-1-lyude@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

As we've unfortunately started to come to expect from PSR on Intel
platforms, PSR2 selective fetch is not at all ready to be enabled on
Tigerlake as it results in severe flickering issues - at least on this
ThinkPad X1 Carbon 9th generation. The easiest way I've found of
reproducing these issues is to just move the cursor around the left border
of the screen (suspicious…).

So, fix people's displays again and turn PSR2 selective fetch off for all
steppings of Tigerlake. This can be re-enabled again if someone from Intel
finds the time to fix this functionality on OEM machines.

Signed-off-by: Lyude Paul <lyude@redhat.com>
Fixes: 7f6002e58025 ("drm/i915/display: Enable PSR2 selective fetch by default")
Cc: Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>
Cc: Ville Syrjälä <ville.syrjala@linux.intel.com>
Cc: José Roberto de Souza <jose.souza@intel.com>
Cc: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.16+
---
 drivers/gpu/drm/i915/display/intel_psr.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/display/intel_psr.c b/drivers/gpu/drm/i915/display/intel_psr.c
index a1a663f362e7..25c16abcd9cd 100644
--- a/drivers/gpu/drm/i915/display/intel_psr.c
+++ b/drivers/gpu/drm/i915/display/intel_psr.c
@@ -737,10 +737,14 @@ static bool intel_psr2_sel_fetch_config_valid(struct intel_dp *intel_dp,
 		return false;
 	}
 
-	/* Wa_14010254185 Wa_14010103792 */
-	if (IS_TGL_DISPLAY_STEP(dev_priv, STEP_A0, STEP_C0)) {
+	/*
+	 * There's two things stopping this from being enabled on TGL:
+	 * For steps A0-C0: workarounds Wa_14010254185 Wa_14010103792 are missing
+	 * For all steps: PSR2 selective fetch causes screen flickering
+	 */
+	if (IS_TIGERLAKE(dev_priv)) {
 		drm_dbg_kms(&dev_priv->drm,
-			    "PSR2 sel fetch not enabled, missing the implementation of WAs\n");
+			    "PSR2 sel fetch not enabled, currently broken on TGL\n");
 		return false;
 	}
 
-- 
2.34.1

