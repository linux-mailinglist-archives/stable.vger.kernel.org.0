Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F776B4618
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:40:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbjCJOkG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:40:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232735AbjCJOkC (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:40:02 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5009112049C
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:39:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 927EB61771
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 14:39:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E660C433D2;
        Fri, 10 Mar 2023 14:39:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678459199;
        bh=boUZcNcovaUdbWQr+onI2Y/r8sdyizDNwfxRAFQuXOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SQcPRKPkiGWBJho+0rSRCByRbfKlgaF59k+lYRmi/B+PZbG61dd/tox1XGBOUnp5V
         w9fzigdCh+x5/D7d9KPcuFVaWzo0RDDEwQ6C8SbOH1UcRBgmOnsQrIoRkJMmQ721DY
         VfSPloDgWNVEPHP/4M2/XSp7IvHP4Ht5d91m2MxY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Hawrylak <mark.hawrylak@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.4 280/357] drm/radeon: Fix eDP for single-display iMac11,2
Date:   Fri, 10 Mar 2023 14:39:29 +0100
Message-Id: <20230310133747.108336661@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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
@@ -2192,11 +2192,12 @@ int radeon_atom_pick_dig_encoder(struct
 
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


