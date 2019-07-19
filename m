Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B01056DF01
	for <lists+stable@lfdr.de>; Fri, 19 Jul 2019 06:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730661AbfGSEDs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jul 2019 00:03:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:35870 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729631AbfGSEDr (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jul 2019 00:03:47 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5D76921852;
        Fri, 19 Jul 2019 04:03:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563509027;
        bh=pI3vddgKINJgVjkWylDi2N58jA1dIv4Do39gLR5enI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ps9DPS9SI5p/MKQfHnu+GVp6BOmMWbCYkwtD85pRy4ZLxm6XEwMQE4SjI4R8XYa7i
         CbEqAItmBDfeTEVwEmkM55XK6n0Bz7QuzRquJcOgDaRTV0Bgf5abKCBjrXPsOz2C0r
         3eAK8+/eOuKNYjfjIcyCkhpVf1720NQnyFNWv00g=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Eryk Brol <eryk.brol@amd.com>, Jun Lei <Jun.Lei@amd.com>,
        Leo Li <sunpeng.li@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.1 027/141] drm/amd/display: Increase Backlight Gain Step Size
Date:   Fri, 19 Jul 2019 00:00:52 -0400
Message-Id: <20190719040246.15945-27-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190719040246.15945-1-sashal@kernel.org>
References: <20190719040246.15945-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eryk Brol <eryk.brol@amd.com>

[ Upstream commit e25228b02e4833e5b0fdd262801a2ae6cc72b39d ]

[Why]
Some backlight tests fail due to backlight settling
taking too long. This happens because the step
size used to change backlight levels is too small.

[How]
1. Change the size of the backlight gain step size
2. Change how DMCU firmware gets the step size value
   so that it is passed in by driver during DMCU initn

Signed-off-by: Eryk Brol <eryk.brol@amd.com>
Reviewed-by: Jun Lei <Jun.Lei@amd.com>
Acked-by: Leo Li <sunpeng.li@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c | 3 +++
 drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h | 2 ++
 2 files changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
index c2926cf19dee..407fb22be66a 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.c
@@ -365,6 +365,9 @@ static bool dcn10_dmcu_init(struct dmcu *dmcu)
 		/* Set initialized ramping boundary value */
 		REG_WRITE(MASTER_COMM_DATA_REG1, 0xFFFF);
 
+		/* Set backlight ramping stepsize */
+		REG_WRITE(MASTER_COMM_DATA_REG2, abm_gain_stepsize);
+
 		/* Set command to initialize microcontroller */
 		REG_UPDATE(MASTER_COMM_CMD_REG, MASTER_COMM_CMD_REG_BYTE0,
 			MCP_INIT_DMCU);
diff --git a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h
index c24c0e5ea44e..249a3c23b607 100644
--- a/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h
+++ b/drivers/gpu/drm/amd/display/dc/dce/dce_dmcu.h
@@ -263,4 +263,6 @@ struct dmcu *dcn10_dmcu_create(
 
 void dce_dmcu_destroy(struct dmcu **dmcu);
 
+static const uint32_t abm_gain_stepsize = 0x0060;
+
 #endif /* _DCE_ABM_H_ */
-- 
2.20.1

