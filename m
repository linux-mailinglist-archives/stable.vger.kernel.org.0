Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8217E6812C2
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:25:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236154AbjA3OZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:25:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237515AbjA3OYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:24:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E93967681
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:23:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B51E1B811D5
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:22:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00F57C433EF;
        Mon, 30 Jan 2023 14:22:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675088570;
        bh=iotfxC6gX3+waooXzUDPz5egyLXcWTSdKdt6M8DbW68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVtdmk8c40Q0CdtwlDZs3V4Epl0Pi5EQisBZXJ2TtDfVijlUsmJ3+hlA6WFSwQ6iF
         X7UsC6k7uDym5iqR+sZy4M3vTHWsZ6+yZqsVeeJWmTUWzngP2zqdfXuGpszPXvzZTf
         EfO+NqkUkru/qBMoeAyiROhdJj8J27/LbqMavaJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Patrick Thompson <ptf@google.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/143] drm: Add orientation quirk for Lenovo ideapad D330-10IGL
Date:   Mon, 30 Jan 2023 14:52:01 +0100
Message-Id: <20230130134309.488625491@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134306.862721518@linuxfoundation.org>
References: <20230130134306.862721518@linuxfoundation.org>
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
2.39.0



