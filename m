Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6AB015F2E5
	for <lists+stable@lfdr.de>; Fri, 14 Feb 2020 19:20:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730774AbgBNPv2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 14 Feb 2020 10:51:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:56428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729758AbgBNPv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 14 Feb 2020 10:51:28 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E56DD2168B;
        Fri, 14 Feb 2020 15:51:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581695487;
        bh=v9kgbTRLSbsOE/FA6v/8+h7+wnByHJqRW7CwIyvCXio=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e4oY3o4UhveyG5wOPUgyvjmvzXiGxNGi4QRHnn4DCuFGNXwq+JSo0JB7pJwZTWPYo
         j6uHzZbr5JYQN5socnClFhBSGBlDxMtftH7wKRx1vRtBqyVzJ3g2EFuvXzVPqUeU23
         7pM7czD+MtotNmM3QtnAweCcRniTX48H3oVp2Tys=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Harry Wentland <harry.wentland@amd.com>,
        Louis Li <Ching-shih.Li@amd.com>,
        Wenjing Liu <Wenjing.Liu@amd.com>,
        Hersen Wu <hersenxs.wu@amd.com>,
        Eric Yang <Eric.Yang2@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.5 117/542] drm/amd/display: Retrain dongles when SINK_COUNT becomes non-zero
Date:   Fri, 14 Feb 2020 10:41:49 -0500
Message-Id: <20200214154854.6746-117-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200214154854.6746-1-sashal@kernel.org>
References: <20200214154854.6746-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Harry Wentland <harry.wentland@amd.com>

[ Upstream commit 3eb6d7aca53d81ce888624f09cd44dc0302161e8 ]

[WHY]
Two years ago the patch referenced by the Fixes tag stopped running
dp_verify_link_cap_with_retries during DP detection when the reason
for the detection was a short-pulse interrupt. This effectively meant
that we were no longer doing the verify_link_cap training on active
dongles when their SINK_COUNT changed from 0 to 1.

A year ago this was partly remedied with:
commit 80adaebd2d41 ("drm/amd/display: Don't skip link training for empty dongle")

This made sure that we trained the dongle on initial hotplug (without
connected downstream devices).

This is all fine and dandy if it weren't for the fact that there are
some dongles on the market that don't like link training when SINK_COUNT
is 0 These dongles will in fact indicate a SINK_COUNT of 0 immediately
after hotplug, even when a downstream device is connected, and then
trigger a shortpulse interrupt indicating a SINK_COUNT change to 1.

In order to play nicely we will need our policy to not link train an
active DP dongle when SINK_COUNT is 0 but ensure we train it when the
SINK_COUNT changes to 1.

[HOW]
Call dp_verify_link_cap_with_retries on detection even when the detection
is triggered from a short pulse interrupt.

With this change we can also revert this commit which we'll do in a separate
follow-up change:
commit 80adaebd2d41 ("drm/amd/display: Don't skip link training for empty dongle")

Fixes: 0301ccbaf67d ("drm/amd/display: DP Compliance 400.1.1 failure")
Suggested-by: Louis Li <Ching-shih.Li@amd.com>
Tested-by: Louis Li <Ching-shih.Li@amd.com>
Cc: Wenjing Liu <Wenjing.Liu@amd.com>
Cc: Hersen Wu <hersenxs.wu@amd.com>
Cc: Eric Yang <Eric.Yang2@amd.com>
Reviewed-by: Wenjing Liu <Wenjing.Liu@amd.com>
Signed-off-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link.c b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
index 4619f94f0ac78..70846ae7d854d 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link.c
@@ -968,8 +968,7 @@ static bool dc_link_detect_helper(struct dc_link *link,
 			same_edid = is_same_edid(&prev_sink->dc_edid, &sink->dc_edid);
 
 		if (link->connector_signal == SIGNAL_TYPE_DISPLAY_PORT &&
-			sink_caps.transaction_type == DDC_TRANSACTION_TYPE_I2C_OVER_AUX &&
-			reason != DETECT_REASON_HPDRX) {
+			sink_caps.transaction_type == DDC_TRANSACTION_TYPE_I2C_OVER_AUX) {
 			/*
 			 * TODO debug why Dell 2413 doesn't like
 			 *  two link trainings
-- 
2.20.1

