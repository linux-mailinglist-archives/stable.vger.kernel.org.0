Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6894A404977
	for <lists+stable@lfdr.de>; Thu,  9 Sep 2021 13:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236339AbhIILmb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Sep 2021 07:42:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:45668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236155AbhIILmZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 9 Sep 2021 07:42:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 859F4611AF;
        Thu,  9 Sep 2021 11:41:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631187676;
        bh=JMuvoOMn0WXbrk8IZIC+V8mXCbi5cEU69e4oQiPf2E0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SGU6cNJYU39s4HSPix45y/uPxmolxK77uIFMvSpWh0n5iPlqApajKgkNhm7tHNZyP
         /xDsix8+LWOYv8l0vtKXDFBKoQSCD4YPa5rd1ont6YN7cqrMWKIubyvlKvHM9xAyZA
         WFsQIywJ9Kp6J9zuG+CLO9gwHC44IeUUZtDo4WP8bC/ugLEKCyCxaiKDaPCQCr64vs
         O3zxYlSkhw+NgJg9QZHz8GNr1Tn4q3XrOTCGmKeFnIGPT9YeU3uNedevVCRdBWul8T
         E5liQbrBpEQjroL7QMqokJmEchIsylShSOYbMGyDTKTox1/NYdfsFpzlqtPfCv0Xfs
         bgs126Ma8CsUw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Luben Tuikov <luben.tuikov@amd.com>,
        Andrey Grodzovsky <andrey.grodzovsky@amd.com>,
        Alexander Deucher <Alexander.Deucher@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.14 007/252] drm/amdgpu: Fix amdgpu_ras_eeprom_init()
Date:   Thu,  9 Sep 2021 07:37:01 -0400
Message-Id: <20210909114106.141462-7-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210909114106.141462-1-sashal@kernel.org>
References: <20210909114106.141462-1-sashal@kernel.org>
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
index 38222de921d1..8dd151c9e459 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_ras_eeprom.c
@@ -325,7 +325,7 @@ int amdgpu_ras_eeprom_init(struct amdgpu_ras_eeprom_control *control,
 		return ret;
 	}
 
-	__decode_table_header_from_buff(hdr, &buff[2]);
+	__decode_table_header_from_buff(hdr, buff);
 
 	if (hdr->header == EEPROM_TABLE_HDR_VAL) {
 		control->num_recs = (hdr->tbl_size - EEPROM_TABLE_HEADER_SIZE) /
-- 
2.30.2

