Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E444C4EF11D
	for <lists+stable@lfdr.de>; Fri,  1 Apr 2022 16:39:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345514AbiDAOhB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 Apr 2022 10:37:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348599AbiDAOev (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 1 Apr 2022 10:34:51 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0EF11BC7;
        Fri,  1 Apr 2022 07:33:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BC09EB8250B;
        Fri,  1 Apr 2022 14:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 409EDC2BBE4;
        Fri,  1 Apr 2022 14:32:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1648823579;
        bh=NS4ep+ynH/MO4fqollxIkLZFOHEpGJ6529DTMzlgoz4=;
        h=From:To:Cc:Subject:Date:From;
        b=M6cCS9UB7h4Ib5PIRpnXgaaoBrDJ5LuumKLZEcapCmAxalmPjzBu/attW3UoiSj3k
         L5gE5KmGaB6WPVOLmo65q4PaO3yePOkJ2EBXcIquzj1xh/QoFYTXJ0RblcWOmFge8M
         oDGMT8DehEwxPdvci/lWPIb5Sqi3PN5zqyMvTWTjYU2egRAm1oUssspXe+JhErW7T6
         wFSz5u8fpl4BzOmb2np6GEVlwXjEo06b1uKf6r3Uhr4L+++upP5K6y3Djxz21pmiwr
         AaAQQvvUflGPzKUYdT9AzSQTTzunXZKbboDoVLDnv8SUfJmds2mdIXMAwEhl98ME15
         riVQjw+F5nUvw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Anisse Astier <anisse@astier.eu>,
        Hans de Goede <hdegoede@redhat.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@linux.ie, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 001/109] drm: Add orientation quirk for GPD Win Max
Date:   Fri,  1 Apr 2022 10:31:08 -0400
Message-Id: <20220401143256.1950537-1-sashal@kernel.org>
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
index b910978d3e48..4e853acfd1e8 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -180,6 +180,12 @@ static const struct dmi_system_id orientation_data[] = {
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

