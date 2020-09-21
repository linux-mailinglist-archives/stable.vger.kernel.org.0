Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C23332727FE
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 16:40:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727870AbgIUOkq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 10:40:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:49418 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727867AbgIUOkp (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 10:40:45 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BC34122574;
        Mon, 21 Sep 2020 14:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600699244;
        bh=D+jP0hxkPbhpy/8gi/F3wmT+MlFROMr33HDS7vMN3hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FLHtJmK7jv4vAlUO6rwtVap/LgllxcWa775E3ValwFoYdwIaQo4Ye9mwzzvaT4RA1
         FnwQoqdmQnw+EEBHN3jIXoU4BbzXUKisyImXnxTaI9GS+0MfbrtPJb2OkbRMbIpH+I
         nCGPX0G/ipiZgWUqiaVnpHOJ09nRi1Ak0VhcUzIw=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.8 13/20] drm/amd/display: Don't use DRM_ERROR() for DTM add topology
Date:   Mon, 21 Sep 2020 10:40:20 -0400
Message-Id: <20200921144027.2135390-13-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200921144027.2135390-1-sashal@kernel.org>
References: <20200921144027.2135390-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>

[ Upstream commit 4cdd7b332ed139b1e37faeb82409a14490adb644 ]

[Why]
Previously we were only calling add_topology when hdcp was being enabled.
Now we call add_topology by default so the ERROR messages are printed if
the firmware is not loaded.

This error message is not relevant for normal display functionality so
no need to print a ERROR message.

[How]
Change DRM_ERROR to DRM_INFO

Signed-off-by: Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>
Acked-by: Aurabindo Pillai <aurabindo.pillai@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
index fb1161dd7ea80..3a367a5968ae1 100644
--- a/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
+++ b/drivers/gpu/drm/amd/display/modules/hdcp/hdcp_psp.c
@@ -88,7 +88,7 @@ enum mod_hdcp_status mod_hdcp_add_display_to_topology(struct mod_hdcp *hdcp,
 	enum mod_hdcp_status status = MOD_HDCP_STATUS_SUCCESS;
 
 	if (!psp->dtm_context.dtm_initialized) {
-		DRM_ERROR("Failed to add display topology, DTM TA is not initialized.");
+		DRM_INFO("Failed to add display topology, DTM TA is not initialized.");
 		display->state = MOD_HDCP_DISPLAY_INACTIVE;
 		return MOD_HDCP_STATUS_FAILURE;
 	}
-- 
2.25.1

