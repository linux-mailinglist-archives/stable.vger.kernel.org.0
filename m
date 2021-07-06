Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6495A3BD4C2
	for <lists+stable@lfdr.de>; Tue,  6 Jul 2021 14:14:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhGFMRL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Jul 2021 08:17:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:42562 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235903AbhGFLad (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Jul 2021 07:30:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1A61161DF0;
        Tue,  6 Jul 2021 11:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1625570531;
        bh=fKQ7PvfjgHX7m9g6OkxTDJ25OnZOcDHQdz6K2NfupLI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jkPKZSOll57afhoYGgZ6AlQ6qVlQLCTAg/0KXBaZuCjRAU/AuyA1JJlMGj4MaSN06
         cSKb0868MGZy98nxnNrJbpsnhSeCJJfDmDddQdV4pJnWvjMCjAwXm6JQUzai+Gr/j1
         aPoNxFojyKy1Kfwe8FnDV+17MFOQLGono9IwEDbFAnvm3/7+LgqMfrzwvGCSJZnyjU
         Uyp2IZSNXKz66fy2DAJEUJZXbWM/EsS8wVv4ar/df8BRGNbD/DLkFzAIy8gGbnNu/j
         2hauBnSZDfR1m45VC+inYiGNSmGt9c6uj7nv2EQeKs56oaF7Tue39refHmNlR4We1r
         kNpUplX/ya6vQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jack Zhang <Jack.Zhang1@amd.com>, Emily Deng <Emily.Deng@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 006/137] drm/amd/amdgpu/sriov disable all ip hw status by default
Date:   Tue,  6 Jul 2021 07:19:52 -0400
Message-Id: <20210706112203.2062605-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210706112203.2062605-1-sashal@kernel.org>
References: <20210706112203.2062605-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jack Zhang <Jack.Zhang1@amd.com>

[ Upstream commit 95ea3dbc4e9548d35ab6fbf67675cef8c293e2f5 ]

Disable all ip's hw status to false before any hw_init.
Only set it to true until its hw_init is executed.

The old 5.9 branch has this change but somehow the 5.11 kernrel does
not have this fix.

Without this change, sriov tdr have gfx IB test fail.

Signed-off-by: Jack Zhang <Jack.Zhang1@amd.com>
Review-by: Emily Deng <Emily.Deng@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
index 87c7c45f1bb7..6948ab3c0d99 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_device.c
@@ -2760,7 +2760,7 @@ static int amdgpu_device_ip_reinit_early_sriov(struct amdgpu_device *adev)
 		AMD_IP_BLOCK_TYPE_IH,
 	};
 
-	for (i = 0; i < ARRAY_SIZE(ip_order); i++) {
+	for (i = 0; i < adev->num_ip_blocks; i++) {
 		int j;
 		struct amdgpu_ip_block *block;
 
-- 
2.30.2

