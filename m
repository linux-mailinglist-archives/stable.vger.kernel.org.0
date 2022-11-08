Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A862F6215E2
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 15:16:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235370AbiKHOQf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 09:16:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235363AbiKHOQa (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 09:16:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56FD769DE3
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 06:16:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0212FB81AF2
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 14:16:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA40C433D6;
        Tue,  8 Nov 2022 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667916986;
        bh=AVAej9drSOqHmfAg8ANyOmkIdcju7arqS84cCbCyWn8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ijfGHbcQz04TZ7oKOSh0oL6PXOcloY1DrsTBzx8bEiQfuDkvyP1Vm8wx7Ipl6D53W
         tl+Ls7Ql81k/8sUI/eAjIq4zIlzUei3e0GOLDzC8VIHv63a+v2IdkestfdKTj5PED3
         Cw/xZwc7xz/EjwqHK5AY9aVBtn5GI5/1DYUdTg8U=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH 6.0 195/197] drm/i915/sdvo: Filter out invalid outputs more sensibly
Date:   Tue,  8 Nov 2022 14:40:33 +0100
Message-Id: <20221108133403.722149017@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
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

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 3e206b6aa6df7eed4297577e0cf8403169b800a2 upstream.

We try to filter out the corresponding xxx1 output
if the xxx0 output is not present. But the way that is
being done is pretty awkward. Make it less so.

Cc: stable@vger.kernel.org
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221026101134.20865-2-ville.syrjala@linux.intel.com
Reviewed-by: Jani Nikula <jani.nikula@intel.com>
(cherry picked from commit cc1e66394daaa7e9f005e2487a84e34a39f9308b)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_sdvo.c |   27 ++++++++++++++++++++++-----
 1 file changed, 22 insertions(+), 5 deletions(-)

--- a/drivers/gpu/drm/i915/display/intel_sdvo.c
+++ b/drivers/gpu/drm/i915/display/intel_sdvo.c
@@ -2926,16 +2926,33 @@ err:
 	return false;
 }
 
+static u16 intel_sdvo_filter_output_flags(u16 flags)
+{
+	flags &= SDVO_OUTPUT_MASK;
+
+	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+	if (!(flags & SDVO_OUTPUT_TMDS0))
+		flags &= ~SDVO_OUTPUT_TMDS1;
+
+	if (!(flags & SDVO_OUTPUT_RGB0))
+		flags &= ~SDVO_OUTPUT_RGB1;
+
+	if (!(flags & SDVO_OUTPUT_LVDS0))
+		flags &= ~SDVO_OUTPUT_LVDS1;
+
+	return flags;
+}
+
 static bool
 intel_sdvo_output_setup(struct intel_sdvo *intel_sdvo, u16 flags)
 {
-	/* SDVO requires XXX1 function may not exist unless it has XXX0 function.*/
+	flags = intel_sdvo_filter_output_flags(flags);
 
 	if (flags & SDVO_OUTPUT_TMDS0)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_TMDS_MASK) == SDVO_TMDS_MASK)
+	if (flags & SDVO_OUTPUT_TMDS1)
 		if (!intel_sdvo_dvi_init(intel_sdvo, 1))
 			return false;
 
@@ -2956,7 +2973,7 @@ intel_sdvo_output_setup(struct intel_sdv
 		if (!intel_sdvo_analog_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_RGB_MASK) == SDVO_RGB_MASK)
+	if (flags & SDVO_OUTPUT_RGB1)
 		if (!intel_sdvo_analog_init(intel_sdvo, 1))
 			return false;
 
@@ -2964,11 +2981,11 @@ intel_sdvo_output_setup(struct intel_sdv
 		if (!intel_sdvo_lvds_init(intel_sdvo, 0))
 			return false;
 
-	if ((flags & SDVO_LVDS_MASK) == SDVO_LVDS_MASK)
+	if (flags & SDVO_OUTPUT_LVDS1)
 		if (!intel_sdvo_lvds_init(intel_sdvo, 1))
 			return false;
 
-	if ((flags & SDVO_OUTPUT_MASK) == 0) {
+	if (flags == 0) {
 		unsigned char bytes[2];
 
 		intel_sdvo->controlled_output = 0;


