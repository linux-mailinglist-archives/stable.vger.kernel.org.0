Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 094CA3DA52C
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 15:58:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238142AbhG2N6z (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 09:58:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:48872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237981AbhG2N6I (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:58:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9B1FD60F42;
        Thu, 29 Jul 2021 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567085;
        bh=sj8PzKPK4hd3q6UKKXJ5PZscVDWl0QR/ZBUL1AKbBvw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ALIBXys2K4b4o9YdDWQnQCJ3M+xEOwqphCZ867Go+H3Iqm1GAMuTedyOuvsNteehp
         sXgjEIMAkDYEcSu/cGc8J/o2z0ju+VDqZ607FpOiDIUmL0uzTJx8V+s8lTyg+MWKpw
         b94IcL87+ZZA9NhCZRNgDnUx3fubvXsuFG6Ubln0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 14/24] drm/ttm: add a check against null pointer dereference
Date:   Thu, 29 Jul 2021 15:54:34 +0200
Message-Id: <20210729135137.710299830@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.267680390@linuxfoundation.org>
References: <20210729135137.267680390@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zheyu Ma <zheyuma97@gmail.com>

[ Upstream commit 9e5c772954406829e928dbe59891d08938ead04b ]

When calling ttm_range_man_fini(), 'man' may be uninitialized, which may
cause a null pointer dereference bug.

Fix this by checking if it is a null pointer.

This log reveals it:

[    7.902580 ] BUG: kernel NULL pointer dereference, address: 0000000000000058
[    7.905721 ] RIP: 0010:ttm_range_man_fini+0x40/0x160
[    7.911826 ] Call Trace:
[    7.911826 ]  radeon_ttm_fini+0x167/0x210
[    7.911826 ]  radeon_bo_fini+0x15/0x40
[    7.913767 ]  rs400_fini+0x55/0x80
[    7.914358 ]  radeon_device_fini+0x3c/0x140
[    7.914358 ]  radeon_driver_unload_kms+0x5c/0xe0
[    7.914358 ]  radeon_driver_load_kms+0x13a/0x200
[    7.914358 ]  ? radeon_driver_unload_kms+0xe0/0xe0
[    7.914358 ]  drm_dev_register+0x1db/0x290
[    7.914358 ]  radeon_pci_probe+0x16a/0x230
[    7.914358 ]  local_pci_probe+0x4a/0xb0

Signed-off-by: Zheyu Ma <zheyuma97@gmail.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/1626274459-8148-1-git-send-email-zheyuma97@gmail.com
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_range_manager.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/ttm/ttm_range_manager.c b/drivers/gpu/drm/ttm/ttm_range_manager.c
index 1da0e277c511..ce9d127edbb5 100644
--- a/drivers/gpu/drm/ttm/ttm_range_manager.c
+++ b/drivers/gpu/drm/ttm/ttm_range_manager.c
@@ -147,6 +147,9 @@ int ttm_range_man_fini(struct ttm_bo_device *bdev,
 	struct drm_mm *mm = &rman->mm;
 	int ret;
 
+	if (!man)
+		return 0;
+
 	ttm_resource_manager_set_used(man, false);
 
 	ret = ttm_resource_manager_force_list_clean(bdev, man);
-- 
2.30.2



