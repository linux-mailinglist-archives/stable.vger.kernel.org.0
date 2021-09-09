Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B5E540507E
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 14:41:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353169AbhIIM2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 08:28:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:34530 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1346102AbhIIMYO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 08:24:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFC9161AFB;
        Thu,  9 Sep 2021 11:51:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631188281;
        bh=66PsxHGFF27Jtkv9Tx0NBeYhrP2C21IWHYups0lC3cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rzeErnJQGc6ApPTB2vJeajUp5fRjdyRui1eC6DWvPoKYVwKFD/FyL5Vv4IDIFIl3u
         Q0cMBfkhlUYkQWN2t6cTLRKTWYfC3dSWIG43ma+1rUR2nw2PL6Ejrz6R/jo6ck8n7Q
         /wvd5eR8JjyTDJxG/x6wCnHaMVhs/ic+4QTuqmFVGIsKkmjz/vw2kaacYqpvHoltAZ
         cutnonBbKtDYbi8pkdHQNi67IIqSjHoTzhpHh2QKRbcx2wQ89mMeSiV/eFpWHoMeS5
         7s9l0IUeMGN4NuJSiKTRvwWCGVUTOQzUYanhqXa2le9Ksh3ETS1BThzsIVhZmpdj1x
         xccX9RA4EOwYA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 002/176] drm/amdgpu: Fix amdgpu_ras_eeprom_init()
Date:   Thu,  9 Sep 2021 07:48:24 -0400
Message-Id: <20210909115118.146181-2-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909115118.146181-1-sashal@kernel.org>
References: <20210909115118.146181-1-sashal@kernel.org>
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
index 0e64c39a2372..7c3efc5f1be0 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -305,7 +305,7 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control,
 		return ret;
 	}
 
-	__decode_table_header_from_buff(hdr, &buff[2]);
+	__decode_table_header_from_buff(hdr, buff);
 
 	if (hdr->header == EEPROM_TABLE_HDR_VAL) {
 		control->num_recs = (hdr->tbl_size - EEPROM_TABLE_HEADER_SIZE) /
-- 
2.30.2

