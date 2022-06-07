Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70094540C93
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:37:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349977AbiFGShZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:37:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352602AbiFGSey (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:34:54 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9B6D17F83E;
        Tue,  7 Jun 2022 10:57:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id D0449CE242B;
        Tue,  7 Jun 2022 17:57:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FB74C34115;
        Tue,  7 Jun 2022 17:57:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624669;
        bh=V+2fr26x6mH1tjdXZJG+wmFJjeJtUEdbGyA7Ms03VpE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NVPOaZ0tN9p7YhOulNx9Chq9rMVzhE5cgDBMD9OAuyma9XIJdHLvUOIOyd4eQmIzS
         FPOwTJ/8QYYvzsW0NSj4DaQHucWLbc5aA/3vbeyUr2/YRxkdzZZz4++77kKaA3xWpg
         g3MNuQ8Nx+0Fb7bYpl4tLSeGK1xZ+SNa5B+19J3PS51F+l2wUlh1ePrS7/Kv6CxAp7
         GNGXNOyHxBorkTqYHZnj4PdPDMWC9KzqSeC96qHGvLjILSnyqEuYmr3WzW2fwiIRMm
         L31y4UHwzFR84Yt8gcq0I3K4OrGmnnF8jo4Gog+U9n5aILn7vFyt2L5TP6BJBIfVow
         DH0Gh5sMP/Dtw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Lijo Lazar <lijo.lazar@amd.com>,
        Yang Wang <kevinyang.wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, evan.quan@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, luben.tuikov@amd.com, kevin1.wang@amd.com,
        Stanley.Yang@amd.com, tao.zhou1@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 39/51] drm/amd/pm: Fix missing thermal throttler status
Date:   Tue,  7 Jun 2022 13:55:38 -0400
Message-Id: <20220607175552.479948-39-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175552.479948-1-sashal@kernel.org>
References: <20220607175552.479948-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Lijo Lazar <lijo.lazar@amd.com>

[ Upstream commit b0f4d663fce6a4232d3c20ce820f919111b1c60b ]

On aldebaran, when thermal throttling happens due to excessive GPU
temperature, the reason for throttling event is missed in warning
message. This patch fixes it.

Signed-off-by: Lijo Lazar <lijo.lazar@amd.com>
Reviewed-by: Yang Wang <kevinyang.wang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
index c9cfeb094750..d0c6b864d00a 100644
--- a/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
+++ b/drivers/gpu/drm/amd/pm/swsmu/smu13/aldebaran_ppt.c
@@ -1627,6 +1627,7 @@ static const struct throttling_logging_label {
 	uint32_t feature_mask;
 	const char *label;
 } logging_label[] = {
+	{(1U << THROTTLER_TEMP_GPU_BIT), "GPU"},
 	{(1U << THROTTLER_TEMP_MEM_BIT), "HBM"},
 	{(1U << THROTTLER_TEMP_VR_GFX_BIT), "VR of GFX rail"},
 	{(1U << THROTTLER_TEMP_VR_MEM_BIT), "VR of HBM rail"},
-- 
2.35.1

