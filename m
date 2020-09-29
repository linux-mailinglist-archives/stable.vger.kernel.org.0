Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 92E1827C69F
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:47:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729811AbgI2Lqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:46830 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbgI2LqS (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:46:18 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A084A2074A;
        Tue, 29 Sep 2020 11:46:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379978;
        bh=D+jP0hxkPbhpy/8gi/F3wmT+MlFROMr33HDS7vMN3hQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qo2DSCO7VZ1f/sub3B1fOZn8vXSUsirDzUibBrnPSSN8pad+Iyfx7tr56MMDDgPes
         rc8mlq6Dq+OqXB3EaUx+mGNkDt2d0i6AYBClv2/fDgtZw/B5RK3KGVtJmV95EKilaL
         q8H3nGqfDakaNhUDcsK4fRwRvg//jr6EJ1cuhBM8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Bhawanpreet Lakha <Bhawanpreet.Lakha@amd.com>,
        Aurabindo Pillai <aurabindo.pillai@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 13/99] drm/amd/display: Dont use DRM_ERROR() for DTM add topology
Date:   Tue, 29 Sep 2020 13:00:56 +0200
Message-Id: <20200929105930.383193687@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105929.719230296@linuxfoundation.org>
References: <20200929105929.719230296@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



