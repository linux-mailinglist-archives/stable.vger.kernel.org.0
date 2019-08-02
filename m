Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A3D6C7FAF3
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 15:36:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390653AbfHBNf6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 09:35:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:58946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2393378AbfHBNUa (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 09:20:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 05B512173E;
        Fri,  2 Aug 2019 13:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564752029;
        bh=sLxGRHB82ABi8IPvwEJ48S+TkbwPSy9Tse9vCufO+2E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jSO4b/GITALvkSAnH+jQ4eOj7bJRU76fskGBG2bpUClmaEm+M1k5DUfbXk0Bf0AWK
         a95juFbLRtR2g9ta2/u2fBSbCXb/aUcpaBrE4qfdN5rjwSc9ohw729ZZiVY9lfMSoA
         PSPmlPzuqFCqletJMj5m6mkTdMBr1qeJrWZHYKeE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tai Man <taiman.wong@amd.com>,
        Joshua Aberback <Joshua.Aberback@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.2 25/76] drm/amd/display: Increase size of audios array
Date:   Fri,  2 Aug 2019 09:18:59 -0400
Message-Id: <20190802131951.11600-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190802131951.11600-1-sashal@kernel.org>
References: <20190802131951.11600-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tai Man <taiman.wong@amd.com>

[ Upstream commit 7352193a33dfc9b69ba3bf6a8caea925b96243b1 ]

[Why]
The audios array defined in "struct resource_pool" is only 6 (MAX_PIPES)
but the max number of audio devices (num_audio) is 7. In some projects,
it will run out of audios array.

[How]
Incraese the audios array size to 7.

Signed-off-by: Tai Man <taiman.wong@amd.com>
Reviewed-by: Joshua Aberback <Joshua.Aberback@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/inc/core_types.h   | 2 +-
 drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h | 1 +
 2 files changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/inc/core_types.h b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
index 6f5ab05d64677..6f0cc718fbd75 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/core_types.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/core_types.h
@@ -169,7 +169,7 @@ struct resource_pool {
 	struct clock_source *clock_sources[MAX_CLOCK_SOURCES];
 	unsigned int clk_src_count;
 
-	struct audio *audios[MAX_PIPES];
+	struct audio *audios[MAX_AUDIOS];
 	unsigned int audio_count;
 	struct audio_support audio_support;
 
diff --git a/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h b/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
index 4c8e2c6fb6dbc..72266efd826cf 100644
--- a/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
+++ b/drivers/gpu/drm/amd/display/dc/inc/hw/hw_shared.h
@@ -34,6 +34,7 @@
  * Data types shared between different Virtual HW blocks
  ******************************************************************************/
 
+#define MAX_AUDIOS 7
 #define MAX_PIPES 6
 
 struct gamma_curve {
-- 
2.20.1

