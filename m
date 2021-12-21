Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DCD8247B73B
	for <lists+stable@lfdr.de>; Tue, 21 Dec 2021 02:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232760AbhLUB6e (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 20:58:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233125AbhLUB6a (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 20:58:30 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C15FEC06173F;
        Mon, 20 Dec 2021 17:58:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E68CB81100;
        Tue, 21 Dec 2021 01:58:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35000C36AE5;
        Tue, 21 Dec 2021 01:58:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640051907;
        bh=lmeOJdPosyey6PSuVWhPHJ2SNeBDl1TEYMap3cbRQJk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q8B36IiKrh8KVcgc+AR2Ph8vCvtQgLcFsCx3ozibhxsyGgnekKpAPp0sz62srvEU6
         OUtP/rmKjjbhhNmoQVQ7t0voL7wifZ9s1NRQf7vKoMMA0iWWvhZZMvEBc6yVEayOqM
         Rlhwb3Rj4Z5jLiQWlM0RkvIvM55Xd+s2wYEPm+lUuUuVdl1Bu6C2jsd4cDAeRfnXWp
         aofpLrPjnVoz/btYNSLcMd5KPmibE7qWdZJBOy8cntypR0bA/nSqBijEoxfyolm5hb
         xcIlVnkNU9j4KXvb7ldQeKY10hzSHihqvvT1v+RklzbdRbIqJlI6xW0xEJrbtdk+OX
         vP63o6awE/Beg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>,
        Pavle Kotarac <Pavle.Kotarac@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, harry.wentland@amd.com,
        sunpeng.li@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com,
        airlied@linux.ie, daniel@ffwll.ch, Rodrigo.Siqueira@amd.com,
        Anson.Jacob@amd.com, qingqing.zhuo@amd.com, Roman.Li@amd.com,
        aurabindo.pillai@amd.com, nikola.cornij@amd.com,
        stylon.wang@amd.com, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.15 18/29] drm/amd/display: Reset DMCUB before HW init
Date:   Mon, 20 Dec 2021 20:57:39 -0500
Message-Id: <20211221015751.116328-18-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211221015751.116328-1-sashal@kernel.org>
References: <20211221015751.116328-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 791255ca9fbe38042cfd55df5deb116dc11fef18 ]

[Why]
If the firmware wasn't reset by PSP or HW and is currently running
then the firmware will hang or perform underfined behavior when we
modify its firmware state underneath it.

[How]
Reset DMCUB before setting up cache windows and performing HW init.

Reviewed-by: Aurabindo Jayamohanan Pillai <Aurabindo.Pillai@amd.com>
Acked-by: Pavle Kotarac <Pavle.Kotarac@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index fef13e93a99fd..bdc894bd66e31 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -900,6 +900,11 @@ static int dm_dmub_hw_init(struct amdgpu_device *adev)
 		return 0;
 	}
 
+	/* Reset DMCUB if it was previously running - before we overwrite its memory. */
+	status = dmub_srv_hw_reset(dmub_srv);
+	if (status != DMUB_STATUS_OK)
+		DRM_WARN("Error resetting DMUB HW: %d\n", status);
+
 	hdr = (const struct dmcub_firmware_header_v1_0 *)dmub_fw->data;
 
 	fw_inst_const = dmub_fw->data +
-- 
2.34.1

