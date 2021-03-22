Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B6BC3441B7
	for <lists+stable@lfdr.de>; Mon, 22 Mar 2021 13:37:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231624AbhCVMfT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 22 Mar 2021 08:35:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:57028 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231654AbhCVMeF (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 22 Mar 2021 08:34:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B4DB160C3D;
        Mon, 22 Mar 2021 12:34:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1616416445;
        bh=QYikiHmXKoWFHEjIly0STU7ZVJxlVy3h/vt8CRqmNm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=j9ijWEblHSP7lE7b/nqBTObmdQhVEAJowavLKXdnqD67XRQFRTFVALT/zt26iKw7F
         PCwW9PYIBSaI1FF4HDTxGCCFZlFO5QNG5mjqEndhlkKViPiQuWeQXR5SUJGQ1eDUel
         fkcIhBFLCXloe/Qui4uigwJ0P9psHTqNLbcO1nmw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 074/120] drm/ttm: make ttm_bo_unpin more defensive
Date:   Mon, 22 Mar 2021 13:27:37 +0100
Message-Id: <20210322121932.146652565@linuxfoundation.org>
X-Mailer: git-send-email 2.31.0
In-Reply-To: <20210322121929.669628946@linuxfoundation.org>
References: <20210322121929.669628946@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

[ Upstream commit 6c5403173a13a08ff61dbdafa4c0ed4a9dedbfe0 ]

We seem to have some more driver bugs than thought.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: deb0814b43f3 ("drm/ttm: add ttm_bo_pin()/ttm_bo_unpin() v2")
Acked-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210312093810.2202-1-christian.koenig@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/drm/ttm/ttm_bo_api.h | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/drm/ttm/ttm_bo_api.h b/include/drm/ttm/ttm_bo_api.h
index 79b9367e0ffd..b5bef3199196 100644
--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -613,9 +613,11 @@ static inline void ttm_bo_pin(struct ttm_buffer_object *bo)
 static inline void ttm_bo_unpin(struct ttm_buffer_object *bo)
 {
 	dma_resv_assert_held(bo->base.resv);
-	WARN_ON_ONCE(!bo->pin_count);
 	WARN_ON_ONCE(!kref_read(&bo->kref));
-	--bo->pin_count;
+	if (bo->pin_count)
+		--bo->pin_count;
+	else
+		WARN_ON_ONCE(true);
 }
 
 int ttm_mem_evict_first(struct ttm_bo_device *bdev,
-- 
2.30.1



