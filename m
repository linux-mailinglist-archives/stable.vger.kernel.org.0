Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1B874E5CE6
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727561AbfJZNRy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:17:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:39504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727556AbfJZNRx (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:53 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7494D21655;
        Sat, 26 Oct 2019 13:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095873;
        bh=gE4ymf6zHwL6N+dtVJnaBxxAtY4WkI95AJrq2UqkCYc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A3XSJwgOR5cZAujC/UTQZrGO0X0ucRYvozAecZYQhbLfkdm0MiFBzhvD1gq+zsKYr
         cLWt/8dY53j8GVJrgZuWaZVrmF8N61Wg4EfmZPUYiRk+JhlOb5pudX15lMkkTxsNxL
         V1yDtDYWNMCBMGa8UEz7tj0KAzKwwP4xDd1Ikh3M=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Kevin Wang <kevin1.wang@amd.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 62/99] drm/ttm: fix handling in ttm_bo_add_mem_to_lru
Date:   Sat, 26 Oct 2019 09:15:23 -0400
Message-Id: <20191026131600.2507-62-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 7fbc899ddeaa9aaef0ba646529089149572c84ee ]

We should not add the BO to the swap LRU when the new mem is fixed and
the TTM object about to be destroyed.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Kevin Wang <kevin1.wang@amd.com>
Link: https://patchwork.freedesktop.org/patch/335246/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index c2df735a8f82c..5d2ae69e8becc 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -184,8 +184,9 @@ static void ttm_bo_add_mem_to_lru(struct ttm_buffer_object *bo,
 	list_add_tail(&bo->lru, &man->lru[bo->priority]);
 	kref_get(&bo->list_kref);
 
-	if (bo->ttm && !(bo->ttm->page_flags &
-			 (TTM_PAGE_FLAG_SG | TTM_PAGE_FLAG_SWAPPED))) {
+	if (!(man->flags & TTM_MEMTYPE_FLAG_FIXED) && bo->ttm &&
+	    !(bo->ttm->page_flags & (TTM_PAGE_FLAG_SG |
+				     TTM_PAGE_FLAG_SWAPPED))) {
 		list_add_tail(&bo->swap, &bdev->glob->swap_lru[bo->priority]);
 		kref_get(&bo->list_kref);
 	}
-- 
2.20.1

