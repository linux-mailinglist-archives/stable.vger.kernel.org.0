Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1251383564
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:25:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241693AbhEQPSq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:18:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:55936 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243233AbhEQPQh (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:16:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DD21E613F2;
        Mon, 17 May 2021 14:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621261974;
        bh=6PQON8TrRTuXub8gaDKgvVSPTBaOmdFFtDEcbgenb5I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rCxQ2YRRjbM5BhuwlG88NDTdG7im6rgayc81wh5P1JHflrHRHbOQKSBdnBrAAI0Kd
         80/rIjPiFeleFWc5Ee1GXYWpYvVv//drOwLn0Rn9ZytA1YDGO1mxLrwzSOtAE4Ts62
         GIdxFCHwr6uWHG/V69mxVElr04NE8ON6aE3KFQWE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kees Cook <keescook@chromium.org>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 198/329] drm/radeon: Avoid power table parsing memory leaks
Date:   Mon, 17 May 2021 16:01:49 +0200
Message-Id: <20210517140308.823971885@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kees Cook <keescook@chromium.org>

[ Upstream commit c69f27137a38d24301a6b659454a91ad85dff4aa ]

Avoid leaving a hanging pre-allocated clock_info if last mode is
invalid, and avoid heap corruption if no valid modes are found.

Bug: https://bugzilla.kernel.org/show_bug.cgi?id=211537
Fixes: 6991b8f2a319 ("drm/radeon/kms: fix segfault in pm rework")
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_atombios.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/radeon/radeon_atombios.c b/drivers/gpu/drm/radeon/radeon_atombios.c
index 11eeabe13d22..70821d73f58f 100644
--- a/drivers/gpu/drm/radeon/radeon_atombios.c
+++ b/drivers/gpu/drm/radeon/radeon_atombios.c
@@ -2119,11 +2119,14 @@ static int radeon_atombios_parse_power_table_1_3(struct radeon_device *rdev)
 		return state_index;
 	/* last mode is usually default, array is low to high */
 	for (i = 0; i < num_modes; i++) {
-		rdev->pm.power_state[state_index].clock_info =
-			kcalloc(1, sizeof(struct radeon_pm_clock_info),
-				GFP_KERNEL);
+		/* avoid memory leaks from invalid modes or unknown frev. */
+		if (!rdev->pm.power_state[state_index].clock_info) {
+			rdev->pm.power_state[state_index].clock_info =
+				kzalloc(sizeof(struct radeon_pm_clock_info),
+					GFP_KERNEL);
+		}
 		if (!rdev->pm.power_state[state_index].clock_info)
-			return state_index;
+			goto out;
 		rdev->pm.power_state[state_index].num_clock_modes = 1;
 		rdev->pm.power_state[state_index].clock_info[0].voltage.type = VOLTAGE_NONE;
 		switch (frev) {
@@ -2242,8 +2245,15 @@ static int radeon_atombios_parse_power_table_1_3(struct radeon_device *rdev)
 			break;
 		}
 	}
+out:
+	/* free any unused clock_info allocation. */
+	if (state_index && state_index < num_modes) {
+		kfree(rdev->pm.power_state[state_index].clock_info);
+		rdev->pm.power_state[state_index].clock_info = NULL;
+	}
+
 	/* last mode is usually default */
-	if (rdev->pm.default_power_state_index == -1) {
+	if (state_index && rdev->pm.default_power_state_index == -1) {
 		rdev->pm.power_state[state_index - 1].type =
 			POWER_STATE_TYPE_DEFAULT;
 		rdev->pm.default_power_state_index = state_index - 1;
-- 
2.30.2



