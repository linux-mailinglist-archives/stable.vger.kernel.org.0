Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8975F33018D
	for <lists+stable@lfdr.de>; Sun,  7 Mar 2021 14:58:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231617AbhCGN6P (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Mar 2021 08:58:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43574 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231520AbhCGN5y (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Mar 2021 08:57:54 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 73BCF65100;
        Sun,  7 Mar 2021 13:57:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615125474;
        bh=8COthqnlqskV+ejnIwp7nd9fz9TC5lrgNtwYpEGcdQc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UDuuX7gvRDTKFKSci1DXqcqKMkU+oNR0II5uwF60GzI0+ongRmlkOc0yE3UsKmClm
         WuSxsG+2T78fAa2YS1O1m3kMoTGu3aiXjUlTEkQUtoWKJnED+EPvHV6F4uvktw4RIp
         h+tN8J3uXhKSsyTqfTJJUSt4cLoaTNSHpwzQbVDWqiEeN9WwmOFBGK9CTJqsCwmKIP
         VkQQ/HKrs/fi+rOVdotR1YBdZSbPUHT5//mgc7pDTrWYZ+4SfHDon59BBWIaF3ZesL
         jDIGqyWu9MgqrvYIjL/OsDZOM9p6oqlcmrs8XcTA/9EF1pnRk5GOQ2/CSKpBS78YFm
         8Zuk0IHC27H5Q==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Alex Deucher <alexander.deucher@amd.com>,
        Evan Quan <evan.quan@amd.com>,
        Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.11 06/12] drm/amdgpu: enable BACO runpm by default on sienna cichlid and navy flounder
Date:   Sun,  7 Mar 2021 08:57:40 -0500
Message-Id: <20210307135746.967418-6-sashal@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210307135746.967418-1-sashal@kernel.org>
References: <20210307135746.967418-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alex Deucher <alexander.deucher@amd.com>

[ Upstream commit 25951362db7b3791488ec45bf56c0043f107b94b ]

It works fine and was only disabled because primary GPUs
don't enter runpm if there is a console bound to the fbdev due
to the kmap.  This will at least allow runpm on secondary cards.

Reviewed-by: Evan Quan <evan.quan@amd.com>
Reviewed-by: Rajneesh Bhardwaj <rajneesh.bhardwaj@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index b16b32797624..ccfa2f9d5446 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -173,8 +173,6 @@ int amdgpu_driver_load_kms(struct amdgpu_device *adev, unsigned long flags)
 		switch (adev->asic_type) {
 		case CHIP_VEGA20:
 		case CHIP_ARCTURUS:
-		case CHIP_SIENNA_CICHLID:
-		case CHIP_NAVY_FLOUNDER:
 			/* enable runpm if runpm=1 */
 			if (amdgpu_runtime_pm > 0)
 				adev->runpm = true;
-- 
2.30.1

