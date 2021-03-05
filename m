Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F14E532E92B
	for <lists+stable@lfdr.de>; Fri,  5 Mar 2021 13:31:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231423AbhCEMbI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 5 Mar 2021 07:31:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:40326 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230516AbhCEMah (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 5 Mar 2021 07:30:37 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5DC776501A;
        Fri,  5 Mar 2021 12:30:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614947437;
        bh=+gNYgdiPN5ljdiYDoNP+TEofI6lHz2nhy+TQychr16w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uJbf4OCVbiGs2argigRjZ3GzWtT837mRJ2fV2Oq/9pB9j7R+YrtORqiFbQxMJHOFc
         lEenFhIGTCHxq7jovdiTMCLJFWOQHTVKjBtwzm/ZcDYqqhXtSxa0ia2GUEyoAuO2fC
         smFmFY/h8T3lerR6QsC0vRjdwkXZB8JWjJTQJDpY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jingwen Chen <Jingwen.Chen2@amd.com>,
        Monk Liu <monk.liu@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 064/102] drm/amd/amdgpu: add error handling to amdgpu_virt_read_pf2vf_data
Date:   Fri,  5 Mar 2021 13:21:23 +0100
Message-Id: <20210305120906.430202495@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210305120903.276489876@linuxfoundation.org>
References: <20210305120903.276489876@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index d0aea5e39531..e7678ba8fdcf 100644
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
2.30.1



