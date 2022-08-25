Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFE9C5A06AE
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:45:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235390AbiHYBnj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:43:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235391AbiHYBmw (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:42:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CA019A962;
        Wed, 24 Aug 2022 18:39:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A4C5BB826E1;
        Thu, 25 Aug 2022 01:39:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC650C433D6;
        Thu, 25 Aug 2022 01:39:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391551;
        bh=o1QrfKF+i/qmQHWMO+c3wU6n2YSPND9HqGjnyLoHgw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L8mdDao6RLi9YEcrnLMuafLqxkaNItL3Z1KZiszR+QXdX8k+JGSjCewznFYoWXnqM
         ZktiBnsPn/4YPseDPMyxenS96r/QfedmieEVaG963hbPZNVd/qhCK8rMNIqcNCzhUz
         I59KEQahe15kSQD7YrAM9BUmICQCQ9uGiRB670ky3CW6W3YbynqcgqvBPGoGf6Ajkf
         3yrpJ87OmwATAYMtR8kcODjVjLQmqSGM6oHF9mbi38h8zEb5bzFVnMIIiLaCWGmny7
         pKIsJoAETstp2dBP9rqyx0Pm8/BScllToiVWq5eFbRvcsw6m6fHnhID7PnY87K+g7S
         gT57zikPeY37A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Ilya Bakoulin <Ilya.Bakoulin@amd.com>, Aric Cyr <Aric.Cyr@amd.com>,
        Brian Chang <Brian.Chang@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, HaoPing.Liu@amd.com, Hansen.Dsouza@amd.com,
        Charlene.Liu@amd.com, dillon.varone@amd.com, baihaowen@meizu.com,
        michael.strauss@amd.com, alex.hung@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 07/11] drm/amd/display: Fix pixel clock programming
Date:   Wed, 24 Aug 2022 21:38:28 -0400
Message-Id: <20220825013836.23205-7-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013836.23205-1-sashal@kernel.org>
References: <20220825013836.23205-1-sashal@kernel.org>
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

From: Ilya Bakoulin <Ilya.Bakoulin@amd.com>

[ Upstream commit 04fb918bf421b299feaee1006e82921d7d381f18 ]

[Why]
Some pixel clock values could cause HDMI TMDS SSCPs to be misaligned
between different HDMI lanes when using YCbCr420 10-bit pixel format.

BIOS functions for transmitter/encoder control take pixel clock in kHz
increments, whereas the function for setting the pixel clock is in 100Hz
increments. Setting pixel clock to a value that is not on a kHz boundary
will cause the issue.

[How]
Round pixel clock down to nearest kHz in 10/12-bpc cases.

Reviewed-by: Aric Cyr <Aric.Cyr@amd.com>
Acked-by: Brian Chang <Brian.Chang@amd.com>
Signed-off-by: Ilya Bakoulin <Ilya.Bakoulin@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index bae3a146b2cc..89cc852cb27c 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -546,9 +546,11 @@ static void dce112_get_pix_clk_dividers_helper (
 		switch (pix_clk_params->color_depth) {
 		case COLOR_DEPTH_101010:
 			actual_pixel_clock_100hz = (actual_pixel_clock_100hz * 5) >> 2;
+			actual_pixel_clock_100hz -= actual_pixel_clock_100hz % 10;
 			break;
 		case COLOR_DEPTH_121212:
 			actual_pixel_clock_100hz = (actual_pixel_clock_100hz * 6) >> 2;
+			actual_pixel_clock_100hz -= actual_pixel_clock_100hz % 10;
 			break;
 		case COLOR_DEPTH_161616:
 			actual_pixel_clock_100hz = actual_pixel_clock_100hz * 2;
-- 
2.35.1

