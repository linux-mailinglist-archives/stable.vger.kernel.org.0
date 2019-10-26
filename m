Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 18993E5CE5
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726256AbfJZNRx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:17:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:39482 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727550AbfJZNRw (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:17:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66AC021E6F;
        Sat, 26 Oct 2019 13:17:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095872;
        bh=+M/5ENxP6pEO4TqPPSztdt1841pC45RbxlaBLJurXks=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xY7KcvWBD0hJQuvZiakv5ITNmtixPxbo8lj2TQpEmVMeQ/AhNWHyTmdbqn/T2rWQS
         4503FjBVyD4bNTrrH1nIsG6zX6zoR2mn9LKW1QaXC5+OOFTcXY6Tf/9fguyX44OHuZ
         nggvF0vGrEv35y9eI6/FJxm8mTDQlCNWtrZPjrZ0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thellstrom@vmware.com>,
        Sasha Levin <sashal@kernel.org>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH AUTOSEL 5.3 61/99] drm/ttm: fix busy reference in ttm_mem_evict_first
Date:   Sat, 26 Oct 2019 09:15:22 -0400
Message-Id: <20191026131600.2507-61-sashal@kernel.org>
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

[ Upstream commit 73a88e4ce31055c415f1ddb55e3f08c9393cf4e3 ]

The busy BO might actually be already deleted,
so grab only a list reference.

Signed-off-by: Christian König <christian.koenig@amd.com>
Reviewed-by: Thomas Hellström <thellstrom@vmware.com>
Link: https://patchwork.freedesktop.org/patch/332877/
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 58c403eda04e7..c2df735a8f82c 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -874,11 +874,11 @@ static int ttm_mem_evict_first(struct ttm_bo_device *bdev,
 
 	if (!bo) {
 		if (busy_bo)
-			ttm_bo_get(busy_bo);
+			kref_get(&busy_bo->list_kref);
 		spin_unlock(&glob->lru_lock);
 		ret = ttm_mem_evict_wait_busy(busy_bo, ctx, ticket);
 		if (busy_bo)
-			ttm_bo_put(busy_bo);
+			kref_put(&busy_bo->list_kref, ttm_bo_release_list);
 		return ret;
 	}
 
-- 
2.20.1

