Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDBF31BFD42
	for <lists+stable@lfdr.de>; Thu, 30 Apr 2020 16:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728077AbgD3OLR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Apr 2020 10:11:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:59746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728072AbgD3Nv2 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Apr 2020 09:51:28 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D06BB2137B;
        Thu, 30 Apr 2020 13:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588254687;
        bh=1LZPEe39UMnjvcdUsIgtXXcaZV3h47Euw7lnX/jEmRk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j2V4ankSg1LXv2x+qjUkv3aFSLRX9KbEtHQlXnGY6AuUBvGXEJ5FdWjmutKUDz3uo
         J480RKbzpW4i33ufxdJOvXTaYq24Yoad3RlBSGGE90cAueWM6Z0i2kJDYHSkURtH+U
         C1Gx3Ng+AUslP65vq07jScIfvYh/1mAPT9FuBglE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Prike Liang <Prike.Liang@amd.com>,
        Mengbing Wang <Mengbing.Wang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Huang Rui <ray.huang@amd.com>, Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.6 38/79] drm/amd/powerplay: fix resume failed as smu table initialize early exit
Date:   Thu, 30 Apr 2020 09:50:02 -0400
Message-Id: <20200430135043.19851-38-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200430135043.19851-1-sashal@kernel.org>
References: <20200430135043.19851-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prike Liang <Prike.Liang@amd.com>

[ Upstream commit 45a5e639548c459a5accebad340078e4e6e0e512 ]

When the amdgpu in the suspend/resume loop need notify the dpm disabled,
otherwise the smu table will be uninitialize and result in resume failed.

Signed-off-by: Prike Liang <Prike.Liang@amd.com>
Tested-by: Mengbing Wang <Mengbing.Wang@amd.com>
Reviewed-by: Alex Deucher <alexander.deucher@amd.com>
Reviewed-by: Huang Rui <ray.huang@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/renoir_ppt.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/powerplay/renoir_ppt.c b/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
index f7a1ce37227cd..4a52c310058d1 100644
--- a/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
+++ b/drivers/gpu/drm/amd/powerplay/renoir_ppt.c
@@ -889,12 +889,17 @@ static int renoir_read_sensor(struct smu_context *smu,
 
 static bool renoir_is_dpm_running(struct smu_context *smu)
 {
+	struct amdgpu_device *adev = smu->adev;
+
 	/*
 	 * Util now, the pmfw hasn't exported the interface of SMU
 	 * feature mask to APU SKU so just force on all the feature
 	 * at early initial stage.
 	 */
-	return true;
+	if (adev->in_suspend)
+		return false;
+	else
+		return true;
 
 }
 
-- 
2.20.1

