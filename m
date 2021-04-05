Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7054035400D
	for <lists+stable@lfdr.de>; Mon,  5 Apr 2021 12:36:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240632AbhDEJPu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Apr 2021 05:15:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:34464 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240513AbhDEJPO (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 5 Apr 2021 05:15:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1474C61393;
        Mon,  5 Apr 2021 09:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617614108;
        bh=KTvRSqI9mu9nKjVPHJNP+VYjO8sA3acTXCdGexO4q9k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=k4cONqUff6JHmO4On/DyriG/j3EwEChTF0lha9W7UoGCUxtaArwh2i8k03Fa0k/X5
         GAA8ImxngpY3KikXuX7Kgqf6Ne8Iuy5R6NpeJVAifLARoSPbO0yzczREQ+M+nRaFoE
         ssM7bbrhJ9jsmWV2EAfYOu4omNmNSDQ0mRr3vknM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Matthew Auld <matthew.auld@intel.com>
Subject: [PATCH 5.11 086/152] drm/ttm: make ttm_bo_unpin more defensive
Date:   Mon,  5 Apr 2021 10:53:55 +0200
Message-Id: <20210405085037.051552291@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210405085034.233917714@linuxfoundation.org>
References: <20210405085034.233917714@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian König <christian.koenig@amd.com>

commit 6c5403173a13a08ff61dbdafa4c0ed4a9dedbfe0 upstream.

We seem to have some more driver bugs than thought.

Signed-off-by: Christian König <christian.koenig@amd.com>
Fixes: deb0814b43f3 ("drm/ttm: add ttm_bo_pin()/ttm_bo_unpin() v2")
Acked-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210312093810.2202-1-christian.koenig@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/drm/ttm/ttm_bo_api.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/include/drm/ttm/ttm_bo_api.h
+++ b/include/drm/ttm/ttm_bo_api.h
@@ -612,8 +612,10 @@ static inline void ttm_bo_pin(struct ttm
 static inline void ttm_bo_unpin(struct ttm_buffer_object *bo)
 {
 	dma_resv_assert_held(bo->base.resv);
-	WARN_ON_ONCE(!bo->pin_count);
-	--bo->pin_count;
+	if (bo->pin_count)
+		--bo->pin_count;
+	else
+		WARN_ON_ONCE(true);
 }
 
 int ttm_mem_evict_first(struct ttm_bo_device *bdev,


