Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7036323D30
	for <lists+stable@lfdr.de>; Wed, 24 Feb 2021 14:08:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235729AbhBXNFK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 24 Feb 2021 08:05:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:54882 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232086AbhBXM7X (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 24 Feb 2021 07:59:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DFE2E64F49;
        Wed, 24 Feb 2021 12:52:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614171171;
        bh=p7gDiyoo1dDO4nzxgLj07L99D6mGYPkqUUhEcJoHCBM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uufSrXhWRNeNTo9d/Yw4QOLDyOPanAEteuYGXkZis/4HRtoDKaNRrNQdwcuBdPsB0
         HJelqdfqlzviySjqVCghiE/80YWSKvyYqFQ4pBUzfhKthxjwUuH3HQDgWEFR8TfMpx
         rptPFP5BpCWEAfyJgekPUO+0WcJvID0izqrxaCM81W0mGoQ4CqdNFhjxw1GljH4hcQ
         MjzFg/02y8SAxZzMgnGatlH2YwhKNh2LoI8AfWyTxGAevJgKu9aViG8S9K2RRyReKv
         Asv1zruzICtOacyaHokmWQQy0a2Goo/JiSk7CO+9J45RXjvkOq2c4NXxfvjd/p2WLN
         lfuv1z/7Rd63Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Jingwen Chen <Jingwen.Chen2@amd.com>, Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.10 29/56] drm/amd/amdgpu: add error handling to amdgpu_virt_read_pf2vf_data
Date:   Wed, 24 Feb 2021 07:51:45 -0500
Message-Id: <20210224125212.482485-29-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210224125212.482485-1-sashal@kernel.org>
References: <20210224125212.482485-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jingwen Chen <Jingwen.Chen2@amd.com>

[ Upstream commit 64dcf2f01d59cf9fad19b1a387bd39736a8f4d69 ]

[Why]
when vram lost happened in guest, try to write vram can lead to
kernel stuck.

[How]
When the readback data is invalid, don't do write work, directly
reschedule a new work.

Signed-off-by: Jingwen Chen <Jingwen.Chen2@amd.com>
Reviewed-by: Monk Liu<monk.liu@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
index d0aea5e395315..e7678ba8fdcf8 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_virt.c
@@ -558,10 +558,14 @@ static int amdgpu_virt_write_vf2pf_data(struct amdgpu_device *adev)
 void amdgpu_virt_update_vf2pf_work_item(struct work_struct *work)
 {
 	struct amdgpu_device *adev = container_of(work, struct amdgpu_device, virt.vf2pf_work.work);
+	int ret;
 
-	amdgpu_virt_read_pf2vf_data(adev);
+	ret = amdgpu_virt_read_pf2vf_data(adev);
+	if (ret)
+		goto out;
 	amdgpu_virt_write_vf2pf_data(adev);
 
+out:
 	schedule_delayed_work(&(adev->virt.vf2pf_work), adev->virt.vf2pf_update_interval_ms);
 }
 
-- 
2.27.0

