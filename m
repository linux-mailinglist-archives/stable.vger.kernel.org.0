Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 12200C3C8E
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 18:54:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731682AbfJAQnc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:43:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:55618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726621AbfJAQnc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:43:32 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6CD321906;
        Tue,  1 Oct 2019 16:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569948211;
        bh=+DuzRebULHDIvNsak8ePy67Juc3WVmR5apIXYtucy5w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZAh0N3vPt4vGPEibB6Vv0li8CJhW5JtI/MhQophDyuGblSD+TdDL73UOlGawb1VxE
         W6OO9WZNkiRMSR5i6gAMJh7o3NIlJ4guAtDuVm77VsmJNHKvyxZv2QO30S4UV+BIRh
         3PBzALIbvnaihJryTVuY0JYzUZbmXOKQxwHuFW0w=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Trek <trek00@inbox.ru>, Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>, amd-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.19 14/43] drm/amdgpu: Check for valid number of registers to read
Date:   Tue,  1 Oct 2019 12:42:42 -0400
Message-Id: <20191001164311.15993-14-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001164311.15993-1-sashal@kernel.org>
References: <20191001164311.15993-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Trek <trek00@inbox.ru>

[ Upstream commit 73d8e6c7b841d9bf298c8928f228fb433676635c ]

Do not try to allocate any amount of memory requested by the user.
Instead limit it to 128 registers. Actually the longest series of
consecutive allowed registers are 48, mmGB_TILE_MODE0-31 and
mmGB_MACROTILE_MODE0-15 (0x2644-0x2673).

Bug: https://bugs.freedesktop.org/show_bug.cgi?id=111273
Signed-off-by: Trek <trek00@inbox.ru>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
index c0396e83f3526..fc93b103f7778 100644
--- a/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
+++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_kms.c
@@ -562,6 +562,9 @@ static int amdgpu_info_ioctl(struct drm_device *dev, void *data, struct drm_file
 		if (sh_num == AMDGPU_INFO_MMR_SH_INDEX_MASK)
 			sh_num = 0xffffffff;
 
+		if (info->read_mmr_reg.count > 128)
+			return -EINVAL;
+
 		regs = kmalloc_array(info->read_mmr_reg.count, sizeof(*regs), GFP_KERNEL);
 		if (!regs)
 			return -ENOMEM;
-- 
2.20.1

