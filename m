Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6E0378878
	for <lists+stable@lfdr.de>; Mon, 10 May 2021 13:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234017AbhEJLVd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 10 May 2021 07:21:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:45768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237128AbhEJLLZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 10 May 2021 07:11:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D88CB616ED;
        Mon, 10 May 2021 11:07:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620644842;
        bh=tRWyyhcBXBvFUc+HVNLYEexxfPmuLpkO+e4d3RvyVO8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FslNKLbcJMCw9xCRlecdDeXcXQRtH2myQ16lhtPNJw5msafTi2z0+uHw8lhnxl3Kn
         5bA74cQNv0uNRsnKr99yiPeAjClP8me6VpL2zVEBsGWFCmYSpW7ZFmQk9U71xsr+/S
         oKTtZ+UNzn4IIMRJ4lbGs5vb7VBeeoeMOOcDfC1o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Tong Zhang <ztong0001@gmail.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 246/384] drm/radeon: dont evict if not initialized
Date:   Mon, 10 May 2021 12:20:35 +0200
Message-Id: <20210510102022.992843928@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210510102014.849075526@linuxfoundation.org>
References: <20210510102014.849075526@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tong Zhang <ztong0001@gmail.com>

[ Upstream commit 05eacc0f8f6c7e27f1841343611f4bed9ee178c1 ]

TTM_PL_VRAM may not initialized at all when calling
radeon_bo_evict_vram(). We need to check before doing eviction.

[    2.160837] BUG: kernel NULL pointer dereference, address: 0000000000000020
[    2.161212] #PF: supervisor read access in kernel mode
[    2.161490] #PF: error_code(0x0000) - not-present page
[    2.161767] PGD 0 P4D 0
[    2.163088] RIP: 0010:ttm_resource_manager_evict_all+0x70/0x1c0 [ttm]
[    2.168506] Call Trace:
[    2.168641]  radeon_bo_evict_vram+0x1c/0x20 [radeon]
[    2.168936]  radeon_device_fini+0x28/0xf9 [radeon]
[    2.169224]  radeon_driver_unload_kms+0x44/0xa0 [radeon]
[    2.169534]  radeon_driver_load_kms+0x174/0x210 [radeon]
[    2.169843]  drm_dev_register+0xd9/0x1c0 [drm]
[    2.170104]  radeon_pci_probe+0x117/0x1a0 [radeon]

Reviewed-by: Christian König <christian.koenig@amd.com>
Suggested-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Tong Zhang <ztong0001@gmail.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/radeon/radeon_object.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/gpu/drm/radeon/radeon_object.c b/drivers/gpu/drm/radeon/radeon_object.c
index 9b81786782de..499ce55e34cc 100644
--- a/drivers/gpu/drm/radeon/radeon_object.c
+++ b/drivers/gpu/drm/radeon/radeon_object.c
@@ -384,6 +384,8 @@ int radeon_bo_evict_vram(struct radeon_device *rdev)
 	}
 #endif
 	man = ttm_manager_type(bdev, TTM_PL_VRAM);
+	if (!man)
+		return 0;
 	return ttm_resource_manager_evict_all(bdev, man);
 }
 
-- 
2.30.2



