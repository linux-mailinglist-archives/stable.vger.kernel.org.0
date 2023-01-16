Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0675466C15F
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 15:10:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232261AbjAPOKw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 09:10:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232382AbjAPOJY (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 09:09:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB76B2887C;
        Mon, 16 Jan 2023 06:04:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8F026B80F96;
        Mon, 16 Jan 2023 14:04:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36E49C433D2;
        Mon, 16 Jan 2023 14:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673877851;
        bh=jGCWcPx+CzPb8AFiA86fPzDQoUj7rHxqqa3OsTm2tug=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DkkXE/E1rugktJ4fKjqh0Aiyme4ECoX6hpy7Z6Kz5WCLIycFKBfv1Y3AbwlFjRw0J
         2o1z73ewXyY8MgHLbc19xEfkVS8tSyeJzJUmymSxYQjgm2b5Tk3SL/nJJBxSoC2ZSU
         e2sO2M9LNfefd2IZ9LJaQ4EQNdsRfVd6A67zKlLQo55AFEEyBDUPLELy01R3qAmjao
         AL5z/gFVfn0qBaxxiF57rXE65qI5IduvfNYdgBfJkHfUogNGjwUaoyJB5dYI7beMln
         fsuG/zQBDm1ZcOdMwIhWjiZs0w01Q3Kqe478vkae/bkkvJ0o6hPeYkLAWcEaxEt4WH
         2qZudLFAh+Kgg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Patrick Thompson <ptf@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>,
        maarten.lankhorst@linux.intel.com, mripard@kernel.org,
        tzimmermann@suse.de, airlied@gmail.com, daniel@ffwll.ch,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 07/24] drm: Add orientation quirk for Lenovo ideapad D330-10IGL
Date:   Mon, 16 Jan 2023 09:03:42 -0500
Message-Id: <20230116140359.115716-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20230116140359.115716-1-sashal@kernel.org>
References: <20230116140359.115716-1-sashal@kernel.org>
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
index ca0fefeaab20..ce739ba45c55 100644
--- a/drivers/gpu/drm/drm_panel_orientation_quirks.c
+++ b/drivers/gpu/drm/drm_panel_orientation_quirks.c
@@ -272,6 +272,12 @@ static const struct dmi_system_id orientation_data[] = {
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

