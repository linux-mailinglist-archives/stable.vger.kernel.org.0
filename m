Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6294F6A364D
	for <lists+stable@lfdr.de>; Mon, 27 Feb 2023 03:00:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbjB0CAv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 26 Feb 2023 21:00:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjB0CAu (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 26 Feb 2023 21:00:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 979FB12591;
        Sun, 26 Feb 2023 18:00:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EFAF060C87;
        Mon, 27 Feb 2023 02:00:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FA26C433D2;
        Mon, 27 Feb 2023 02:00:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677463248;
        bh=8aJ0BuC8eFjFvmG12zK43hoaXimGS+Q/sRi3gZOAhAk=;
        h=From:To:Cc:Subject:Date:From;
        b=PhDjKepEAtBb8BoUCNK4NyNw9aKbS4ahdeC2PlA+n7MoDv0soNGetbu0px8k4pkKL
         SAj4I/MCLFp2Vao5OQm882nxKWCLIdpzKOsXxlyDPlOvU08Z0LYjr5qVejD5dBaiG0
         yRm5KWZE0+8CmvJ7Iyhq/UmWka+6xzwrxl7NlmBDA6I3caPe2TdpomQQclUxgDdD6p
         /fEeeQMZ9HeVvMoknitmgSgzY/VOVb1K0xYxMiPTslxxJ0TX9iu0siya8KLndg3v7h
         z+UrqXwjz1tpQ4OzFaB8is/0ZM+oWPBQVkLlvPInWG3kiciU0Nq9gugSUb1I+Wajnb
         c9FQf5JdXA8Dg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Javier Martinez Canillas <javierm@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.2 01/60] drm: panel-orientation-quirks: Add quirk for Lenovo Yoga Tab 3 X90F
Date:   Sun, 26 Feb 2023 20:59:46 -0500
Message-Id: <20230227020045.1045105-1-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 8a238d7f7eea7592e0764bc3b9e79e7c6354b04c ]

The Lenovo Yoga Tab 3 X90F has a portrait 1600x2560 LCD used in
landscape mode, add a quirk for this.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Javier Martinez Canillas <javierm@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221127181539.104223-1-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 3659f0465a724..23d63a4d42d9c 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -127,6 +127,12 @@ static const struct drm_dmi_panel_orientation_data lcd1600x2560_leftside_up = {
 	.orientation = DRM_MODE_PANEL_ORIENTATION_LEFT_UP,
 };
 
+static const struct drm_dmi_panel_orientation_data lcd1600x2560_rightside_up = {
+	.width = 1600,
+	.height = 2560,
+	.orientation = DRM_MODE_PANEL_ORIENTATION_RIGHT_UP,
+};
+
 static const struct dmi_system_id orientation_data[] = {
 	{	/* Acer One 10 (S1003) */
 		.matches = {
@@ -331,6 +337,13 @@ static const struct dmi_system_id orientation_data[] = {
 		 DMI_MATCH(DMI_BIOS_VERSION, "BLADE_21"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Yoga Tab 3 X90F */
+		.matches = {
+		 DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),
+		 DMI_MATCH(DMI_PRODUCT_NAME, "CHERRYVIEW D1 PLATFORM"),
+		 DMI_MATCH(DMI_PRODUCT_VERSION, "Blade3-10A-001"),
+		},
+		.driver_data = (void *)&lcd1600x2560_rightside_up,
 	}, {	/* Nanote UMPC-01 */
 		.matches = {
 		 DMI_MATCH(DMI_SYS_VENDOR, "RWC CO.,LTD"),
-- 
2.39.0

