Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B7EB63DA55F
	for <lists+stable@lfdr.de>; Thu, 29 Jul 2021 16:01:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238174AbhG2OBJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 29 Jul 2021 10:01:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:50198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238370AbhG2N7F (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 29 Jul 2021 09:59:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7C9BA60F42;
        Thu, 29 Jul 2021 13:59:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627567141;
        bh=SgS92D8YtZxt1ox6McgFTvBPWgU+hwBTL57t+PUqMl8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=M2n5mSYxCLDKK8qnXMH2goATCzisKJyhpWEIvwKX2XIO5Fwb5GXpbBNe7LTrBZcmC
         Qe7WzhHSvMcUYqgan5hob3GjUkaNSYWqnYhzIWrPcxYQTXvuGAzas49fXpQESSpb0F
         poP8ckTvoQNkmFjBV1jeyxP5LIyNA8wrZQ+eyUSI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zheyu Ma <zheyuma97@gmail.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 12/22] drm/ttm: add a check against null pointer dereference
Date:   Thu, 29 Jul 2021 15:54:43 +0200
Message-Id: <20210729135137.731453496@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210729135137.336097792@linuxfoundation.org>
References: <20210729135137.336097792@linuxfoundation.org>
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
index 707e5c152896..ed053fd15c90 100644
--- a/drivers/gpu/drm/ttm/ttm_range_manager.c
+++ b/drivers/gpu/drm/ttm/ttm_range_manager.c
@@ -146,6 +146,9 @@ int ttm_range_man_fini(struct ttm_device *bdev,
 	struct drm_mm *mm = &rman->mm;
 	int ret;
 
+	if (!man)
+		return 0;
+
 	ttm_resource_manager_set_used(man, false);
 
 	ret = ttm_resource_manager_evict_all(bdev, man);
-- 
2.30.2



