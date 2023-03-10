Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 79E466B49B5
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 16:15:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233120AbjCJPPT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 10:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233311AbjCJPOi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 10:14:38 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A8511125A6
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 07:06:01 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4128261A7F
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 15:05:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C8A8C433D2;
        Fri, 10 Mar 2023 15:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678460704;
        bh=4p3Zho8LJo+WuZe/3T6tuwPNGPxMpPR4AljLoQgSwYQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cnV5LosyHvvdBRHskvz4OEX1Ni2Slt7J993w6eaVap5TqFStsnKTrfeB8S5RqUeTW
         ZSzaTXvZQXjJA+bM1hcHwrG7iL1gwkwJn8TocISU9Dl9Dv5B1M0XqEQbOiaQBMPV19
         njZwgISceZIbuZTWa3NR02mGigUFsFVhL02FHrOE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Hawrylak <mark.hawrylak@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.10 424/529] drm/radeon: Fix eDP for single-display iMac11,2
Date:   Fri, 10 Mar 2023 14:39:27 +0100
Message-Id: <20230310133824.631858546@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Hawrylak <mark.hawrylak@gmail.com>

commit 05eacc198c68cbb35a7281ce4011f8899ee1cfb8 upstream.

Apple iMac11,2 (mid 2010) also with Radeon HD-4670 that has the same
issue as iMac10,1 (late 2009) where the internal eDP panel stays dark on
driver load.  This patch treats iMac11,2 the same as iMac10,1,
so the eDP panel stays active.

Additional steps:
Kernel boot parameter radeon.nomodeset=0 required to keep the eDP
panel active.

This patch is an extension of
commit 564d8a2cf3ab ("drm/radeon: Fix eDP for single-display iMac10,1 (v2)")
Link: https://lore.kernel.org/all/lsq.1507553064.833262317@decadent.org.uk/
Signed-off-by: Mark Hawrylak <mark.hawrylak@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/radeon/atombios_encoders.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/radeon/atombios_encoders.c
+++ b/drivers/gpu/drm/radeon/atombios_encoders.c
@@ -2191,11 +2191,12 @@ int radeon_atom_pick_dig_encoder(struct
 
 	/*
 	 * On DCE32 any encoder can drive any block so usually just use crtc id,
-	 * but Apple thinks different at least on iMac10,1, so there use linkb,
+	 * but Apple thinks different at least on iMac10,1 and iMac11,2, so there use linkb,
 	 * otherwise the internal eDP panel will stay dark.
 	 */
 	if (ASIC_IS_DCE32(rdev)) {
-		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1"))
+		if (dmi_match(DMI_PRODUCT_NAME, "iMac10,1") ||
+		    dmi_match(DMI_PRODUCT_NAME, "iMac11,2"))
 			enc_idx = (dig->linkb) ? 1 : 0;
 		else
 			enc_idx = radeon_crtc->crtc_id;


