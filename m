Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4202C1B3F6A
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 12:38:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729728AbgDVKh1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 06:37:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:58682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726833AbgDVKW1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 06:22:27 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6156521655;
        Wed, 22 Apr 2020 10:22:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587550945;
        bh=ic5MMHZntN33IMBrTIWsQVmdcrIefTFAyiQjjyVZ7jg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FncPvH3lz6DOdZ/8+gCoVafD8iPvctaFHLeGMVYRpMzXRW9uAigEGpmMugUe6xB/T
         IsITaeogQoZ9TWqyD1mqMjNH5kz0ikelHbU7OAZ3bor4RZokWJa9ujcqNityx3sGgA
         416qSdPqge1DsXTIxDTyer6dO+dc+4fH8aMrEntk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, xinhui pan <xinhui.pan@amd.com>,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.6 039/166] drm/ttm: flush the fence on the bo after we individualize the reservation object
Date:   Wed, 22 Apr 2020 11:56:06 +0200
Message-Id: <20200422095053.101066297@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095047.669225321@linuxfoundation.org>
References: <20200422095047.669225321@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: xinhui pan <xinhui.pan@amd.com>

[ Upstream commit 1bbcf69e42fe7fd49b6f4339c970729d0e343753 ]

As we move the ttm_bo_individualize_resv() upwards, we need flush the
copied fence too. Otherwise the driver keeps waiting for fence.

run&Kill kfdtest, then perf top.

  25.53%  [ttm]                     [k] ttm_bo_delayed_delete
  24.29%  [kernel]                  [k] dma_resv_test_signaled_rcu
  19.72%  [kernel]                  [k] ww_mutex_lock

Fix: 378e2d5b("drm/ttm: fix ttm_bo_cleanup_refs_or_queue once more")
Signed-off-by: xinhui pan <xinhui.pan@amd.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/series/72339/
Signed-off-by: Christian König <christian.koenig@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/ttm/ttm_bo.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_bo.c b/drivers/gpu/drm/ttm/ttm_bo.c
index 5df596fb0280c..fe420ca454e0a 100644
--- a/drivers/gpu/drm/ttm/ttm_bo.c
+++ b/drivers/gpu/drm/ttm/ttm_bo.c
@@ -498,8 +498,10 @@ static void ttm_bo_cleanup_refs_or_queue(struct ttm_buffer_object *bo)
 
 		dma_resv_unlock(bo->base.resv);
 	}
-	if (bo->base.resv != &bo->base._resv)
+	if (bo->base.resv != &bo->base._resv) {
+		ttm_bo_flush_all_fences(bo);
 		dma_resv_unlock(&bo->base._resv);
+	}
 
 error:
 	kref_get(&bo->list_kref);
-- 
2.20.1



