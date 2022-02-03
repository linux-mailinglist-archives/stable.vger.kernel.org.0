Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D5BE4A8DBE
	for <lists+stable@lfdr.de>; Thu,  3 Feb 2022 21:33:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354482AbiBCUcp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Feb 2022 15:32:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354530AbiBCUbs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 3 Feb 2022 15:31:48 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AEF7C06178A;
        Thu,  3 Feb 2022 12:31:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 58CDBB835A2;
        Thu,  3 Feb 2022 20:31:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C9AAC340EF;
        Thu,  3 Feb 2022 20:31:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643920297;
        bh=Vv//BExRI3t85Qsd/+tzwcI53cblzmjE6OyXjRNe/UE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=guzqe2jqKMS06lrroT4FRQg0LZNUoxZoIQ4whJ91bk137i7hL+u495EIo86FeD9Cb
         3ADAlKU1yzCfBhOI9N+3547t1juie0WS9McJ4HApZJnDJ4bf/9p00oJ8GlR3c4XjRX
         ZskJymJPMXuYtdGmxIu8fv5RWcX9hifcIP5G77IZR85CBQ6KEgi8RZpNI3nvr29FkS
         Ch1GDuYAkzSEkri6PBzkMX/QetJWi9rfBMckb77SlAsCV2e71O7+21gQ0dhbJ5lynz
         srTG0aP6drX6u+m4B7+5I2Dj4rrgoapiymrQFQom7Ey3bPEzNSX1ywaBoNv8s/MdVc
         ksQXrmP3nx+EQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Harry Wentland <harry.wentland@amd.com>,
        Sasha Levin <sashal@kernel.org>, sunpeng.li@amd.com,
        Rodrigo.Siqueira@amd.com, christian.koenig@amd.com,
        Xinhui.Pan@amd.com, airlied@linux.ie, daniel@ffwll.ch,
        Jun.Lei@amd.com, wenjing.liu@amd.com, George.Shen@amd.com,
        Jimmy.Kizito@amd.com, Wesley.Chalmers@amd.com, Jerry.Zuo@amd.com,
        stylon.wang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.16 40/52] drm/amdgpu/display: use msleep rather than udelay for long delays
Date:   Thu,  3 Feb 2022 15:29:34 -0500
Message-Id: <20220203202947.2304-40-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220203202947.2304-1-sashal@kernel.org>
References: <20220203202947.2304-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 98fdcacb45f7cd2092151d6af2e60152811eb79c ]

Some architectures (e.g., ARM) throw an compilation error if the
udelay is too long.  In general udelays of longer than 2000us are
not recommended on any architecture.  Switch to msleep in these
cases.

Reviewed-by: Harry Wentland <harry.wentland@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
index 01ac1a64c78b9..d1b47c0d7791a 100644
--- a/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
+++ b/drivers/gpu/drm/amd/display/dc/core/dc_link_dp.c
@@ -6038,7 +6038,7 @@ bool dpcd_write_128b_132b_sst_payload_allocation_table(
 			}
 		}
 		retries++;
-		udelay(5000);
+		msleep(5);
 	}
 
 	if (!result && retries == max_retries) {
@@ -6090,7 +6090,7 @@ bool dpcd_poll_for_allocation_change_trigger(struct dc_link *link)
 			break;
 		}
 
-		udelay(5000);
+		msleep(5);
 	}
 
 	if (result == ACT_FAILED) {
-- 
2.34.1

