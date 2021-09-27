Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 385ED419C9E
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:28:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236721AbhI0Rab (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:30:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:41376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237605AbhI0R2F (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:28:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9544961414;
        Mon, 27 Sep 2021 17:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632763028;
        bh=eZx7t8aU74FnyagsJucAccLo92T2UEj9jZMdRzx9LFQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IPjLkvkv20W6tjuByNyL7H80Nsc7A+UFXEkmUwd490ZDuZ/ybBTAg5IURHh7lOAYS
         ag0CFzJKgWOnSnSlS9uoU1mjE72azk0v0NIPZkzuKXtWuI4DuDd2Q8utUeC4eEsQ6U
         e19TFfwykPHGQmLqburTGcUKqMQHlwBRSKrz7eFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>,
        Mikita Lipski <mikita.lipski@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 141/162] drm/amd/display: Fix unstable HPCP compliance on Chrome Barcelo
Date:   Mon, 27 Sep 2021 19:03:07 +0200
Message-Id: <20210927170238.304249501@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170233.453060397@linuxfoundation.org>
References: <20210927170233.453060397@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qingqing Zhuo <qingqing.zhuo@amd.com>

[ Upstream commit 4e00a434a08e0654a4dd9347485d9ec85deee1ef ]

[Why]
Intermittently, there presents two occurrences of 0 stream
commits in a single HPD event. Current HDCP sequence does
not consider such scenerio, and will thus disable HDCP.

[How]
Add condition check to include stream remove and re-enable
case for HDCP enable.

Reviewed-by: Bhawanpreet Lakha <bhawanpreet.lakha@amd.com>
Acked-by: Mikita Lipski <mikita.lipski@amd.com>
Signed-off-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 22 +++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index a4a4bb43c108..e7cf79b386da 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -8051,8 +8051,26 @@ static bool is_content_protection_different(struct drm_connector_state *state,
 	    state->content_protection == DRM_MODE_CONTENT_PROTECTION_ENABLED)
 		state->content_protection = DRM_MODE_CONTENT_PROTECTION_DESIRED;
 
-	/* Check if something is connected/enabled, otherwise we start hdcp but nothing is connected/enabled
-	 * hot-plug, headless s3, dpms
+	/* Stream removed and re-enabled
+	 *
+	 * Can sometimes overlap with the HPD case,
+	 * thus set update_hdcp to false to avoid
+	 * setting HDCP multiple times.
+	 *
+	 * Handles:	DESIRED -> DESIRED (Special case)
+	 */
+	if (!(old_state->crtc && old_state->crtc->enabled) &&
+		state->crtc && state->crtc->enabled &&
+		connector->state->content_protection == DRM_MODE_CONTENT_PROTECTION_DESIRED) {
+		dm_con_state->update_hdcp = false;
+		return true;
+	}
+
+	/* Hot-plug, headless s3, dpms
+	 *
+	 * Only start HDCP if the display is connected/enabled.
+	 * update_hdcp flag will be set to false until the next
+	 * HPD comes in.
 	 *
 	 * Handles:	DESIRED -> DESIRED (Special case)
 	 */
-- 
2.33.0



