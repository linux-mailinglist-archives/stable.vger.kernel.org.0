Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 562A2461F36
	for <lists+stable@lfdr.de>; Mon, 29 Nov 2021 19:42:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355166AbhK2So7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Nov 2021 13:44:59 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:48026 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352764AbhK2Sm4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Nov 2021 13:42:56 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 032CFB815D4;
        Mon, 29 Nov 2021 18:39:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F639C53FCF;
        Mon, 29 Nov 2021 18:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1638211176;
        bh=77lKU25UqTxrpcyjhlWsg48qZH2NtkMQ9vIFqit5rqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ow/DRxAueMf8BiEVwWiGcVWVo9upSRonKWCb/JZJhnADrAid59OW2qz5RgJyReb8R
         ITPG0YJXhpldOm5ZUZrcPm42OdvWpzdXCYpqypYOHY0n5+TVH9ifHT23mjTgAQgIuV
         Lqgjr6/SJLKQZfqWsXK+vSJby04Pmh9qbI5VHimM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jude Shih <Jude.Shih@amd.com>,
        Qingqing Zhuo <qingqing.zhuo@amd.com>,
        Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>,
        Daniel Wheeler <daniel.wheeler@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 131/179] drm/amd/display: Fix DPIA outbox timeout after GPU reset
Date:   Mon, 29 Nov 2021 19:18:45 +0100
Message-Id: <20211129181723.266322935@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211129181718.913038547@linuxfoundation.org>
References: <20211129181718.913038547@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>

[ Upstream commit 6eff272dbee7ad444c491c9a96d49e78e91e2161 ]

[Why]
The HW interrupt gets disabled after GPU reset so we don't receive
notifications for HPD or AUX from DMUB - leading to timeout and
black screen with (or without) DPIA links connected.

[How]
Re-enable the interrupt after GPU reset like we do for the other
DC interrupts.

Fixes: 81927e2808be ("drm/amd/display: Support for DMUB AUX")

Reviewed-by: Jude Shih <Jude.Shih@amd.com>
Acked-by: Qingqing Zhuo <qingqing.zhuo@amd.com>
Signed-off-by: Nicholas Kazlauskas <nicholas.kazlauskas@amd.com>
Tested-by: Daniel Wheeler <daniel.wheeler@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
index d15967239474e..56f4569da2f7d 100644
--- a/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
+++ b/drivers/gpu/drm/amd/display/amdgpu_dm/amdgpu_dm.c
@@ -2213,6 +2213,8 @@ static int dm_resume(void *handle)
 	if (amdgpu_in_reset(adev)) {
 		dc_state = dm->cached_dc_state;
 
+		amdgpu_dm_outbox_init(adev);
+
 		r = dm_dmub_hw_init(adev);
 		if (r)
 			DRM_ERROR("DMUB interface failed to initialize: status=%d\n", r);
-- 
2.33.0



