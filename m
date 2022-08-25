Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1D9B35A05CD
	for <lists+stable@lfdr.de>; Thu, 25 Aug 2022 03:35:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232346AbiHYBfi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Aug 2022 21:35:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232464AbiHYBfO (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 24 Aug 2022 21:35:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 576855AC72;
        Wed, 24 Aug 2022 18:35:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05BC4B826C8;
        Thu, 25 Aug 2022 01:35:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B81C43140;
        Thu, 25 Aug 2022 01:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661391309;
        bh=lrrNFEl0vGA+79mhCUIz0uHj9v5/rtnv5eKLywRXP48=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fFEYdUxtF2CeqZFJddlsbl3k6EuPgE4emZuTv4qE7SQl6ArgrX4TB1xEp5D3hcmER
         Rohr0UvzX3As1We0iaoeGSSEjLiOYuAhUDIWdwDI7jeN+IUCa4jU1ffSdclTV+YTZJ
         5Z9SnwMAIA0jLKRNnWd6ka654YG5DW6ARFPHpygOiPDpYfSu5LBXU8jUsDqPul/Ikx
         AwdzXIzVAWpEWUs3h4xdg/0um5q7XRZ5n1RHNnzuZdp8QVIuivRovCKCbXRUxWlda+
         hgQEBpWbY+1DjnE6+SfOE8+QYbyyLSEnTRqE7BkIc8P5dl/LKJp/24OlBhqHdgQbzd
         mmp1EPtVmy3aw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>,
        Jimmy Kizito <Jimmy.Kizito@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Tom Chung <chiahsuan.chung@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com,
        christian.koenig@amd.com, Xinhui.Pan@amd.com, airlied@linux.ie,
        daniel@ffwll.ch, nicholas.kazlauskas@amd.com, martin.leung@amd.com,
        alvin.lee2@amd.com, Samson.Tam@amd.com, alex.hung@amd.com,
        wenjing.liu@amd.com, joshua.aberback@amd.com, George.Shen@amd.com,
        hanghong.ma@amd.com, Jerry.Zuo@amd.com, Wayne.Lin@amd.com,
        michael.strauss@amd.com, po-tchen@amd.com,
        amd-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.19 11/38] drm/amd/display: Fix TDR eDP and USB4 display light up issue
Date:   Wed, 24 Aug 2022 21:33:34 -0400
Message-Id: <20220825013401.22096-11-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220825013401.22096-1-sashal@kernel.org>
References: <20220825013401.22096-1-sashal@kernel.org>
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

From: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>

[ Upstream commit 30456ffa65469d1d2e5e1da05017e6728d24c11c ]

[Why]
After TDR recovery, eDP and USB4 display does not light up. Because
dmub outbox notifications are not enabled after dmub reload and link
encoder assignments for the streams are not cleared before dc state
reset.

[How]
- Dmub outbox notification is enabled after tdr recovery by issuing
  inbox command to dmub.
- Link encoders for the streams are unassigned before dc state reset.

Reviewed-by: Jimmy Kizito <Jimmy.Kizito@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Tom Chung <chiahsuan.chung@amd.com>
Signed-off-by: Meenakshikumar Somasundaram <meenakshikumar.somasundaram@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc.c | 1 +
 drivers/gpu/drm/amd/display/dc/dc_link.h | 1 +
 2 files changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc.c b/drivers/gpu/drm/amd/display/dc/core/dc.c
index f14449401188..7d69341acca0 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc.c
@@ -3783,6 +3783,7 @@ void dc_enable_dmub_outbox(struct dc *dc)
 	struct dc_context *dc_ctx = dc->ctx;
 
 	dmub_enable_outbox_notification(dc_ctx->dmub_srv);
+	DC_LOG_DC("%s: dmub outbox notifications enabled\n", __func__);
 }
 
 /**
diff --git a/drivers/gpu/drm/amd/display/dc/dc_link.h b/drivers/gpu/drm/amd/display/dc/dc_link.h
index a3c37ee3f849..f96f53c1bc25 100644
--- a/drivers/gpu/drm/amd/display/dc/dc_link.h
+++ b/drivers/gpu/drm/amd/display/dc/dc_link.h
@@ -337,6 +337,7 @@ enum dc_detect_reason {
 	DETECT_REASON_HPDRX,
 	DETECT_REASON_FALLBACK,
 	DETECT_REASON_RETRAIN,
+	DETECT_REASON_TDR,
 };
 
 bool dc_link_detect(struct dc_link *dc_link, enum dc_detect_reason reason);
-- 
2.35.1

