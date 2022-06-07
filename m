Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0092C540B85
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 20:29:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350653AbiFGS3a (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 14:29:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352450AbiFGS0M (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 14:26:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6206B1406E5;
        Tue,  7 Jun 2022 10:54:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5CAEA60DBA;
        Tue,  7 Jun 2022 17:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE81C34119;
        Tue,  7 Jun 2022 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654624485;
        bh=UuT5pcuIYfI0vQXMOvXgNqqRRJ+ochAjLD8cGR0HfcE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=d7LLBdMTMUuNAbZvaT3NDdgyrIJlKffEgKa577AOftX+/fEqSXVI1+ZHyL/SF9nzx
         CDP8xaLQhI5BQT5XJfETMg3Njoum98+JHP9EWYeL7R9M+Un9YeePqcl5RhxP0vQZ+E
         dGgFcZVCxeQVFCY9xntjrbXfj7LdEjPAxpReN55/m9LVqgjOTVX18oDVdnNEz9AneG
         p+hJba+Jh1KUcq5LmTOz8MJi9Rk0dGFwlpN1+auD0CA0VWda1IEoeLiJhhfqPAQXaQ
         KJgtET/uPt4gKn+vRcP1sFYr2kssgTepltCMkY8sJyAXKnjy6rVwvYvizvIjuFSHIS
         HJLEClMZbnxfQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     David Galiffi <David.Galiffi@amd.com>,
        Martin Leung <Martin.Leung@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Hansen.Dsouza@amd.com, Charlene.Liu@amd.com,
        HaoPing.Liu@amd.com, baihaowen@meizu.com, dillon.varone@amd.com,
        alex.hung@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.17 41/60] drm/amd/display: Check if modulo is 0 before dividing.
Date:   Tue,  7 Jun 2022 13:52:38 -0400
Message-Id: <20220607175259.478835-41-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220607175259.478835-1-sashal@kernel.org>
References: <20220607175259.478835-1-sashal@kernel.org>
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

From: David Galiffi <David.Galiffi@amd.com>

[ Upstream commit 49947b906a6bd9668eaf4f9cf691973c25c26955 ]

[How & Why]
If a value of 0 is read, then this will cause a divide-by-0 panic.

Reviewed-by: Martin Leung <Martin.Leung@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: David Galiffi <David.Galiffi@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
index 2c7eb982eabc..054823d12403 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_clock_source.c
@@ -1013,9 +1013,12 @@ static bool get_pixel_clk_frequency_100hz(
 			 * not be programmed equal to DPREFCLK
 			 */
 			modulo_hz = REG_READ(MODULO[inst]);
-			*pixel_clk_khz = div_u64((uint64_t)clock_hz*
-				clock_source->ctx->dc->clk_mgr->dprefclk_khz*10,
-				modulo_hz);
+			if (modulo_hz)
+				*pixel_clk_khz = div_u64((uint64_t)clock_hz*
+					clock_source->ctx->dc->clk_mgr->dprefclk_khz*10,
+					modulo_hz);
+			else
+				*pixel_clk_khz = 0;
 		} else {
 			/* NOTE: There is agreement with VBIOS here that MODULO is
 			 * programmed equal to DPREFCLK, in which case PHASE will be
-- 
2.35.1

