Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AA31B6AF5A2
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 20:28:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231538AbjCGT17 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 14:27:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234126AbjCGT1n (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 14:27:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF3B8BF8C6
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 11:13:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2A7061535
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 19:13:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8ADAC433D2;
        Tue,  7 Mar 2023 19:13:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678216385;
        bh=Xg0X9O+oqwbhf1s+xLJNY0gJv2vvHl/xwF7HhHu8Eyc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nm4GkTUL/xfAjs/L1NUH+AZP3biMvzAt6tgUSYvxSrGeLRHyFsUTYYBRMWC/bhyz/
         KfT6if/RxAPAYjMq2l9sx72+zsdJaDp3sJm1tMYs9hnkI/eIyWAuyJlkAS3poWzcoV
         yUFHR0VwP376NyyttJiECCjd5Ye7iukiHdLMOgVM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Mark Hawrylak <mark.hawrylak@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 5.15 565/567] drm/radeon: Fix eDP for single-display iMac11,2
Date:   Tue,  7 Mar 2023 18:05:01 +0100
Message-Id: <20230307165930.431150039@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307165905.838066027@linuxfoundation.org>
References: <20230307165905.838066027@linuxfoundation.org>
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
@@ -2188,11 +2188,12 @@ int radeon_atom_pick_dig_encoder(struct
 
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


