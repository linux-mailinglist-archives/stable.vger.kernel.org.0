Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EC782D87DD
	for <lists+stable@lfdr.de>; Sat, 12 Dec 2020 17:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2436532AbgLLQRO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 12 Dec 2020 11:17:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:59608 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405775AbgLLQK7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 12 Dec 2020 11:10:59 -0500
From:   Sasha Levin <sashal@kernel.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Mark Hounschell <markh@compro.net>,
        Karol Herbst <kherbst@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 4.14 2/8] drm/nouveau: make sure ret is initialized in nouveau_ttm_io_mem_reserve
Date:   Sat, 12 Dec 2020 11:08:53 -0500
Message-Id: <20201212160859.2335412-2-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201212160859.2335412-1-sashal@kernel.org>
References: <20201212160859.2335412-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit aea656b0d05ec5b8ed5beb2f94c4dd42ea834e9d ]

This wasn't initialized for pre NV50 hardware.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reported-and-Tested-by: Mark Hounschell <markh@compro.net>
Reviewed-by: Karol Herbst <kherbst@redhat.com>
Link: https://patchwork.freedesktop.org/series/84298/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/nouveau/nouveau_bo.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/nouveau/nouveau_bo.c b/drivers/gpu/drm/nouveau/nouveau_bo.c
index e427f80344c4d..fddbe66935464 100644
--- a/drivers/gpu/drm/nouveau/nouveau_bo.c
+++ b/drivers/gpu/drm/nouveau/nouveau_bo.c
@@ -1375,6 +1375,7 @@ nouveau_ttm_io_mem_reserve(struct ttm_bo_device *bdev, struct ttm_mem_reg *reg)
 			nvkm_vm_map(&mem->bar_vma, mem);
 			reg->bus.offset = mem->bar_vma.offset;
 		}
+		ret = 0;
 		break;
 	default:
 		return -EINVAL;
-- 
2.27.0

