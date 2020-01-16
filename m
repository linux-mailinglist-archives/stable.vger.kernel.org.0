Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9457B13E16B
	for <lists+stable@lfdr.de>; Thu, 16 Jan 2020 17:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729016AbgAPQsG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Jan 2020 11:48:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729795AbgAPQsG (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Jan 2020 11:48:06 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EBF2520663;
        Thu, 16 Jan 2020 16:48:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579193285;
        bh=SvnjTp3S3Rs2yeHSY5+SCBEcB5/rFV/XnzG7hbKOwAs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tn382tP+vC1YosrVFQbuXjhyzZKZsPAfIokd5ZSfkFAy1S0Tt0gz0q7/JKcv8FzI2
         TzECo6eTeqhEKsiIQ0juLmhT3iwsEOMuakUesSalgsJ5kOia8bNa3yLUKDRsE2dIvH
         LvqB2nu+t/I2kaw5PAR/VTJz2NmrNewzlZZCieVE=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Dan Carpenter <dan.carpenter@oracle.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.4 066/205] drm/amdgpu/vi: silence an uninitialized variable warning
Date:   Thu, 16 Jan 2020 11:40:41 -0500
Message-Id: <20200116164300.6705-66-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200116164300.6705-1-sashal@kernel.org>
References: <20200116164300.6705-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

[ Upstream commit 4ff17a1df7d550257972a838220a8af4611c8f2c ]

Smatch complains that we need to initialized "*cap" otherwise it can
lead to an uninitialized variable bug in the caller.  This seems like a
reasonable warning and it doesn't hurt to silence it at least.

drivers/gpu/drm/amd/amdgpu/vi.c:767 vi_asic_reset_method() error: uninitialized symbol 'baco_reset'.

Fixes: 425db2553e43 ("drm/amdgpu: expose BACO interfaces to upper level from PP")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/powerplay/amd_powerplay.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
index fa8ad7db2b3a..d306cc711997 100644
--- a/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
+++ b/drivers/gpu/drm/amd/powerplay/amd_powerplay.c
@@ -1421,6 +1421,7 @@ static int pp_get_asic_baco_capability(void *handle, bool *cap)
 {
 	struct pp_hwmgr *hwmgr = handle;
 
+	*cap = false;
 	if (!hwmgr)
 		return -EINVAL;
 
-- 
2.20.1

