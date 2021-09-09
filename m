Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35F214052E6
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348072AbhIIMsx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:48:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:55940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355117AbhIIMlC (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:41:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 17D4A61BBE;
        Thu,  9 Sep 2021 11:55:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188509;
        bh=12siGeLuNRMNegAARWNe0txf5wjF4ptGz5s0ho4zFTw=;
        h=From:To:Cc:Subject:Date:From;
        b=SI03uRknSp4iI+9F4WlxXjmqEHGtOmdZ0Mw0+nbqTaQazxLiHw90KmdWsSiWQeTac
         X7bNXftpbNI+tXBOp04yYS3tSt1/wz67mv+YhzKBs+Xjb31Toj8NqtXuOTFpE5ZkRU
         ESabJFd8KLkpzjLydurhmdO8zqpJmMmZXF2x187t+VRIbbgem5K6I4QCam1FNs58iI
         OfHVpl4ces0ir7uiPBpsQlLsVdobBwzNdTEruC2Mhv69x0poFvQzhSSO4m0f77hThE
         QUWp7ZooIyInLYcJmFLaE2HQ8MRHm6CM5gSs9FrzO782b7QvkVJimrX+ROdP5Szkdd
         Qm95T4+8+/L/A==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 001/109] drm/amdgpu: Fix amdgpu_ras_eeprom_init()
Date:   Thu,  9 Sep 2021 07:53:18 -0400
Message-Id: <20210909115507.147917-1-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Luben Tuikov <luben.tuikov@amd.com>

[ Upstream commit dce4400e6516d18313d23de45b5be8a18980b00e ]

No need to account for the 2 bytes of EEPROM
address--this is now well abstracted away by
the fixes the the lower layers.

Cc: Andrey Grodzovsky <andrey.grodzovsky@amd.com>
Cc: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Luben Tuikov <luben.tuikov@amd.com>
Acked-by: Alexander Deucher <Alexander.Deucher@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
index 8a32b5c93778..bd7ae3e130b6 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -138,7 +138,7 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control)
 		return ret;
 	}
 
-	__decode_table_header_from_buff(hdr, &buff[2]);
+	__decode_table_header_from_buff(hdr, buff);
 
 	if (hdr->header == EEPROM_TABLE_HDR_VAL) {
 		control->num_recs = (hdr->tbl_size - EEPROM_TABLE_HEADER_SIZE) /
-- 
2.30.2

