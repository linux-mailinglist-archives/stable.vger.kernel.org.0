Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 86775540635
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 19:34:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347121AbiFGRd3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 13:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347340AbiFGRah (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 13:30:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5FDCE1105F5;
        Tue,  7 Jun 2022 10:26:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E25C3B822B4;
        Tue,  7 Jun 2022 17:26:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F99BC36B08;
        Tue,  7 Jun 2022 17:26:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654622779;
        bh=63WuIew4xYAGrgpmwGTDNvRsLDHZCbrIlhGQGxz486s=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SV2OH/s/IDIfcoU/ZMw9pRT4CGExYPNxREP+qQaL79lz2gNYiMxsJEJek5QOEqOJ1
         /S3SEwFob1rXvdoIq42CFDdHsy+bbqaFQt0At5R9YkEJJxOLvgc5AEeIq+Ap+vilGf
         IDPP0L46B7+E0GaKJ64N96GJnjZ2MfUj4qYSlTtU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jagan Teki <jagan@amarulasolutions.com>,
        Robert Foss <robert.foss@linaro.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 180/452] drm/panel: panel-simple: Fix proper bpc for AM-1280800N3TZQW-T00H
Date:   Tue,  7 Jun 2022 19:00:37 +0200
Message-Id: <20220607164913.926447914@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607164908.521895282@linuxfoundation.org>
References: <20220607164908.521895282@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jagan Teki <jagan@amarulasolutions.com>

[ Upstream commit 7eafbecd2288c542ea15ea20cf1a7e64a25c21bc ]

AM-1280800N3TZQW-T00H panel support 8 bpc not 6 bpc as per
recent testing in i.MX8MM platform.

Fix it.

Fixes: bca684e69c4c ("drm/panel: simple: Add AM-1280800N3TZQW-T00H")
Signed-off-by: Jagan Teki <jagan@amarulasolutions.com>
Reviewed-by: Robert Foss <robert.foss@linaro.org>
Signed-off-by: Robert Foss <robert.foss@linaro.org>
Link: https://patchwork.freedesktop.org/patch/msgid/20211111094103.494831-1-jagan@amarulasolutions.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/panel/panel-simple.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/panel/panel-simple.c b/drivers/gpu/drm/panel/panel-simple.c
index 18850439a2ab..bf2c845ef3a2 100644
--- a/drivers/gpu/drm/panel/panel-simple.c
+++ b/drivers/gpu/drm/panel/panel-simple.c
@@ -676,7 +676,7 @@ static const struct drm_display_mode ampire_am_1280800n3tzqw_t00h_mode = {
 static const struct panel_desc ampire_am_1280800n3tzqw_t00h = {
 	.modes = &ampire_am_1280800n3tzqw_t00h_mode,
 	.num_modes = 1,
-	.bpc = 6,
+	.bpc = 8,
 	.size = {
 		.width = 217,
 		.height = 136,
-- 
2.35.1



