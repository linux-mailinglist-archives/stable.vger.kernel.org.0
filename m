Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A47466C0CC
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:04:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231835AbjAPOEj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:04:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231878AbjAPODp (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:03:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5212623309;
        Mon, 16 Jan 2023 06:02:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id B1E4ECE1161;
        Mon, 16 Jan 2023 14:02:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDFFCC433F0;
        Mon, 16 Jan 2023 14:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877774;
        bh=PCOMQ8cyBkpfAdWRtEkxUVs1mHVGtQvzfE+wUDZzs30=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a2qhVCVddFKH/EWFRWCDmETSlQ3EXXco+mybJ2RUUzAwRrxwQGtOcFXXA/fgcY8wN
         5ipf0ZR5fhRSlHEk7eGI2lNieFr8N/ZW/0//o6MZgXoLK/EUUOg2y2HWWNNMA5+nyx
         e3eyKc85+7AYr4gWFr4VL9xRdxV2NCMnVMah5UoMk7hIYcKkQeXHa0eZANbMU0Fvr8
         iZ18AJgmNLk4bBaZ7SfHAu5S8K2n0Fiada+NCU6eiaDoiHjby/ByOCYIaL4sw8SoAY
         Uj2j4vw2XBj9lhpDRWmGbOpcB/ulxSq2wipt9t4JqFgrM2DVIAqb2Ve8AxAM+4jEpY
         QSKz8VvWSukIA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Thompson <ptf@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 6.1 18/53] drm: Add orientation quirk for Lenovo ideapad D330-10IGL
Date:   Mon, 16 Jan 2023 09:01:18 -0500
Message-Id: <20230116140154.114951-18-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140154.114951-1-sashal@kernel.org>
References: <20230116140154.114951-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Patrick Thompson <ptf@google.com>

[ Upstream commit 0688773f0710528e1ab302c3d6317e269f2e2e6e ]

Panel is 800x1280 but mounted on a detachable form factor sideways.

Signed-off-by: Patrick Thompson <ptf@google.com>
Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
Link: https://patchwork.freedesktop.org/patch/msgid/20221220205826.178008-1-ptf@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_panel_orientation_quirks.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/drm_panel_orientation_quirks.c b/drivers/gpu/drm/drm_panel_orientation_quirks.c
index 52d8800a8ab8..3659f0465a72 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -304,6 +304,12 @@ static const struct dmi_system_id orientation_data[] = {
 		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGM"),
 		},
 		.driver_data = (void *)&lcd1200x1920_rightside_up,
+	}, {	/* Lenovo Ideapad D330-10IGL (HD) */
+		.matches = {
+		  DMI_EXACT_MATCH(DMI_SYS_VENDOR, "LENOVO"),
+		  DMI_EXACT_MATCH(DMI_PRODUCT_VERSION, "Lenovo ideapad D330-10IGL"),
+		},
+		.driver_data = (void *)&lcd800x1280_rightside_up,
 	}, {	/* Lenovo Yoga Book X90F / X91F / X91L */
 		.matches = {
 		  /* Non exact match to match all versions */
-- 
2.35.1

