Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70FE26674DD
	for <lists+stable@lfdr.de>; Thu, 12 Jan 2023 15:15:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234629AbjALOPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 12 Jan 2023 09:15:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38042 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234571AbjALOOf (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 12 Jan 2023 09:14:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDB5F5C1F8
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 06:06:46 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5916161F74
        for <stable@vger.kernel.org>; Thu, 12 Jan 2023 14:06:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5889CC433F0;
        Thu, 12 Jan 2023 14:06:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673532405;
        bh=SIHZjR8b0Y6Dlp5IfzAcNyz6TT3kMPxE6Dojv1T06d4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q+QAqzYDeAvt+Ouv889Wv681U6lYoGhf3uLmXfntVzCJfzyVAnCDScKUt7/Pdy+Do
         Iq6Y54Xwb8Y08svuLZZtKcpsqb4wWb2B5Soe/+/YpULIRtQsU8i30tsH/ZnUiMTLMm
         syB3tKKgTgOEAwSNHZU83tNNiyN4AxSBDB1iVpjY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        George Kennedy <george.kennedy@oracle.com>,
        butt3rflyh4ck <butterflyhuangxx@gmail.com>,
        Brian Starkey <brian.starkey@arm.com>,
        Liviu Dudau <liviu.dudau@arm.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 152/783] drm/fourcc: Fix vsub/hsub for Q410 and Q401
Date:   Thu, 12 Jan 2023 14:47:48 +0100
Message-Id: <20230112135531.393028013@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230112135524.143670746@linuxfoundation.org>
References: <20230112135524.143670746@linuxfoundation.org>
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

From: Brian Starkey <brian.starkey@arm.com>

[ Upstream commit b230555f3257f197dd98641ef6ebaf778b52dd51 ]

These formats are not subsampled, but that means hsub and vsub should be
1, not 0.

Fixes: 94b292b27734 ("drm: drm_fourcc: add NV15, Q410, Q401 YUV formats")
Reported-by: George Kennedy <george.kennedy@oracle.com>
Reported-by: butt3rflyh4ck <butterflyhuangxx@gmail.com>
Signed-off-by: Brian Starkey <brian.starkey@arm.com>
Reviewed-by: Liviu Dudau <liviu.dudau@arm.com>
Signed-off-by: Liviu Dudau <liviu.dudau@arm.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220913144306.17279-1-brian.starkey@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_fourcc.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/drm_fourcc.c b/drivers/gpu/drm/drm_fourcc.c
index 4d4b65a88bd1..92152c06b75b 100644
--- a/drivers/gpu/drm/drm_fourcc.c
+++ b/drivers/gpu/drm/drm_fourcc.c
@@ -280,12 +280,12 @@ const struct drm_format_info *__drm_format_info(u32 format)
 		  .vsub = 2, .is_yuv = true },
 		{ .format = DRM_FORMAT_Q410,		.depth = 0,
 		  .num_planes = 3, .char_per_block = { 2, 2, 2 },
-		  .block_w = { 1, 1, 1 }, .block_h = { 1, 1, 1 }, .hsub = 0,
-		  .vsub = 0, .is_yuv = true },
+		  .block_w = { 1, 1, 1 }, .block_h = { 1, 1, 1 }, .hsub = 1,
+		  .vsub = 1, .is_yuv = true },
 		{ .format = DRM_FORMAT_Q401,		.depth = 0,
 		  .num_planes = 3, .char_per_block = { 2, 2, 2 },
-		  .block_w = { 1, 1, 1 }, .block_h = { 1, 1, 1 }, .hsub = 0,
-		  .vsub = 0, .is_yuv = true },
+		  .block_w = { 1, 1, 1 }, .block_h = { 1, 1, 1 }, .hsub = 1,
+		  .vsub = 1, .is_yuv = true },
 		{ .format = DRM_FORMAT_P030,            .depth = 0,  .num_planes = 2,
 		  .char_per_block = { 4, 8, 0 }, .block_w = { 3, 3, 0 }, .block_h = { 1, 1, 0 },
 		  .hsub = 2, .vsub = 2, .is_yuv = true},
-- 
2.35.1



