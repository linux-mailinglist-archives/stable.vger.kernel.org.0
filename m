Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 57DAE663ACC
	for <lists+stable@lfdr.de>; Tue, 10 Jan 2023 09:20:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbjAJIUG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Jan 2023 03:20:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbjAJIUE (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 Jan 2023 03:20:04 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E088542E2C
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 00:20:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7FFA3B81106
        for <stable@vger.kernel.org>; Tue, 10 Jan 2023 08:20:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64E83C433D2;
        Tue, 10 Jan 2023 08:20:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673338800;
        bh=d50POXJpH48ogqKbH6/NVl9b6SbiE/OCysc2+IVmtgk=;
        h=Subject:To:Cc:From:Date:From;
        b=hd1f/mp7NBQ5o/qXO4PArzWz1S6o78uZV25sxHCGEZM69YRTtp+Z4Vr/D9AyCxFxL
         B912n5Ck7u+xbcVkdGMep3eqkZGTnSalU/GX1Qzef/F1Eb2mgjUvhSftt8ts5DjGWD
         gq33tfxX4GqhQ6AoLf/LcKndUG6BX1NY2zS4rwFU=
Subject: FAILED: patch "[PATCH] drm/amd/display: Uninitialized variables causing 4k60 UCLK to" failed to apply to 6.0-stable tree
To:     samson.tam@amd.com, alexander.deucher@amd.com, aric.cyr@amd.com,
        aurabindo.pillai@amd.com, daniel.wheeler@amd.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 10 Jan 2023 09:19:49 +0100
Message-ID: <1673338789226131@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 6.0-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

f3c23bea598a ("drm/amd/display: Uninitialized variables causing 4k60 UCLK to stay at DPM1 and not DPM0")
6d4727c80947 ("drm/amd/display: Add check for DET fetch latency hiding for dcn32")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f3c23bea598ab7e8e4b8c5ca66598921310f718e Mon Sep 17 00:00:00 2001
From: Samson Tam <samson.tam@amd.com>
Date: Mon, 5 Dec 2022 11:08:40 -0500
Subject: [PATCH] drm/amd/display: Uninitialized variables causing 4k60 UCLK to
 stay at DPM1 and not DPM0

[Why]
SwathSizePerSurfaceY[] and SwathSizePerSurfaceC[] values are uninitialized
 because we are using += instead of = operator.

[How]
Assign values in loop with = operator.

Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Samson Tam <samson.tam@amd.com>
Reviewed-by: Aric Cyr <aric.cyr@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org # 6.0.x, 6.1.x

diff --git a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
index 5af601cff1a0..b53feeaf5cf1 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
+++ b/drivers/gpu/drm/amd/display/dc/dml/dcn32/display_mode_vba_util_32.c
@@ -6257,12 +6257,12 @@ bool dml32_CalculateDETSwathFillLatencyHiding(unsigned int NumberOfActiveSurface
 	double SwathSizePerSurfaceC[DC__NUM_DPP__MAX];
 	bool NotEnoughDETSwathFillLatencyHiding = false;
 
-	/* calculate sum of single swath size for all pipes in bytes*/
+	/* calculate sum of single swath size for all pipes in bytes */
 	for (k = 0; k < NumberOfActiveSurfaces; k++) {
-		SwathSizePerSurfaceY[k] += SwathHeightY[k] * SwathWidthY[k] * BytePerPixelInDETY[k] * NumOfDPP[k];
+		SwathSizePerSurfaceY[k] = SwathHeightY[k] * SwathWidthY[k] * BytePerPixelInDETY[k] * NumOfDPP[k];
 
 		if (SwathHeightC[k] != 0)
-			SwathSizePerSurfaceC[k] += SwathHeightC[k] * SwathWidthC[k] * BytePerPixelInDETC[k] * NumOfDPP[k];
+			SwathSizePerSurfaceC[k] = SwathHeightC[k] * SwathWidthC[k] * BytePerPixelInDETC[k] * NumOfDPP[k];
 		else
 			SwathSizePerSurfaceC[k] = 0;
 

