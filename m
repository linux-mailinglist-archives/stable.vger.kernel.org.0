Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5B144EF576
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 17:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355160AbiDAPOL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 11:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349775AbiDAO55 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:57:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DD401587BC;
        Fri,  1 Apr 2022 07:44:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC02260BAF;
        Fri,  1 Apr 2022 14:44:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 236DAC2BBE4;
        Fri,  1 Apr 2022 14:44:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648824289;
        bh=aNouMf6HB7bGVRYB3vXS2dnlB1LtY2eK90MMG/PNgRg=;
        h=From:To:Cc:Subject:Date:From;
        b=MUEtdsIrL2PIJlDKjVxasgQN0ydPITTqiyGMQidaRAbJh/OheYCQCfGTLFJzSbw0+
         YGhbxFib2+Jrs7tzdV+767khrcooYF3gQzophG00QVeyrqdJoXo5BViFg9+Pqj12Nm
         lFRb6WNeiC3njq2PeD95C8LSD1YxR4XniL9N45wV6GtlCBkoN44I02uIpZclM8jnXE
         aAItjt9l1Cbj1uoMnR9/DQDQ3xRoPHAOoPwnDp/SqvbTDnkTc299QA1DnjS9S8qTm7
         ZuvUq+8E+1/96h3jtel7YZ25YQkvy9pG1DPSt5EwcOwgbWhpI5lpcTto+Xq4onxmpZ
         xMfXTK+F2yYtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anisse Astier <anisse@astier.eu>,
        Hans de Goede <hdegoede@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 01/37] drm: Add orientation quirk for GPD Win Max
Date:   Fri,  1 Apr 2022 10:44:10 -0400
Message-Id: <20220401144446.1954694-1-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Anisse Astier <anisse@astier.eu>

[ Upstream commit 0b464ca3e0dd3cec65f28bc6d396d82f19080f69 ]

Panel is 800x1280, but mounted on a laptop form factor, sideways.

Signed-off-by: Anisse Astier <anisse@astier.eu>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20211229222200.53128-3-anisse@astier.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 448c2f2d803a..f5ab891731d0 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -166,6 +166,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "MicroPC"),
 		},
 		.driver_data = (void *)&lcd720x1280_rightside_up,
+	}, {	/* GPD Win Max */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "GPD"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_NAME, "G1619-01"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/*
 		 * GPD Pocket, note that the the DMI data is less generic then
 		 * it seems, devices with a board-vendor of "AMI Corporation"
-- 
2.34.1

