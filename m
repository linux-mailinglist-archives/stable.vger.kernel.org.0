Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B63865A069E
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:43:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234957AbiHYBnS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:43:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234980AbiHYBmO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:42:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6D279DB71;
        Wed, 24 Aug 2022 18:38:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F4F8B826DA;
        Thu, 25 Aug 2022 01:38:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29ACAC433D7;
        Thu, 25 Aug 2022 01:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391530;
        bh=HwLh1b9ngThAZW8y0Od1yxXyL/4+OzGVdxcZXcN8Tck=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fsOoTQOOwDAUPSN3vnZ7BQuJGII0Az1ACGihmX2eG6uvUowofnvwZ/P6Fffmh5Rwb
         sjn5nPBkinm1FJcizliMPm4xgR4X0ZxF8hkLBs1Hgpx929xpzHnN8eGR+dOV4+bYTV
         fIojCmj54xpOJEyawoBNjxffN3dOAoMP4I7epX6laRYgo6QdFeY02RKWc4yOQdt4Z4
         tejmfpKcOtmEEGql7eypnPkihkb6kMOJFrNWcrZpFv2psbx8PQv5zXA6etNBWr24uL
         CYtYsANBuMq2S39RBAXvFgIdWiOj20NVeO/dBRjz3Uxqra6/fjtlbib0OmFesDieuY
         BYDz7oSrtH3WA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Fudong Wang <Fudong.Wang@amd.com>, Alvin Lee <alvin.lee2@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, Charlene.Liu@amd.com, isabbasso@riseup.net,
        Anson.Jacob@amd.com, oliver.logush@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 03/11] drm/amd/display: clear optc underflow before turn off odm clock
Date:   Wed, 24 Aug 2022 21:38:24 -0400
Message-Id: <20220825013836.23205-3-sashal@kernel.org>
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

From: Fudong Wang <Fudong.Wang@amd.com>

[ Upstream commit b2a93490201300a749ad261b5c5d05cb50179c44 ]

[Why]
After ODM clock off, optc underflow bit will be kept there always and clear not work.
We need to clear that before clock off.

[How]
Clear that if have when clock off.

Reviewed-by: Alvin Lee <alvin.lee2@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Fudong Wang <Fudong.Wang@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
index 800be2693fac..963d72f96dca 100644
--- a/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
+++ b/drivers/gpu/drm/amd/display/dc/dcn10/dcn10_optc.c
@@ -464,6 +464,11 @@ void optc1_enable_optc_clock(struct timing_generator *optc, bool enable)
 				OTG_CLOCK_ON, 1,
 				1, 1000);
 	} else  {
+
+		//last chance to clear underflow, otherwise, it will always there due to clock is off.
+		if (optc->funcs->is_optc_underflow_occurred(optc) == true)
+			optc->funcs->clear_optc_underflow(optc);
+
 		REG_UPDATE_2(OTG_CLOCK_CONTROL,
 				OTG_CLOCK_GATE_DIS, 0,
 				OTG_CLOCK_EN, 0);
-- 
2.35.1

