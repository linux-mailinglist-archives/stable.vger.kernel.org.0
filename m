Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1B46C1935
	for <lists+stable@lfdr.de>; Mon, 20 Mar 2023 16:31:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233085AbjCTPbr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Mar 2023 11:31:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232839AbjCTPb2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Mar 2023 11:31:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D823734020
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 08:23:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0C97FB80E55
        for <stable@vger.kernel.org>; Mon, 20 Mar 2023 15:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 328C4C4339C;
        Mon, 20 Mar 2023 15:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1679325827;
        bh=SfCZawwhNVkHFA9/sY9LZNRj6mtwDsVyCSJo6iC8ZxI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R+kRlSBM027emes+TDJwlRfWMAzqt8y0XSLiJY0ujgljnASz9gmo9/n/1BvN+dvhW
         2sIs/TlzQCquh9uL9eDjSBHhqR6yg/vMnW3vJ5cXbWbj0QJhjFdiT9srcVK1frQ7iu
         UnXqhSFNXarCLgj1BIOPBWALwxdxSyuxOgt35pzI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Christian=20K=C3=B6nig?= <christian.koenig@amd.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Huang Rui <ray.huang@amd.com>,
        Alex Deucher <alexander.deucher@amd.com>,
        Felix Kuehling <Felix.Kuehling@amd.com>,
        Philip Yang <Philip.Yang@amd.com>, Qiang Yu <qiang.yu@amd.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Anshuman Gupta <anshuman.gupta@intel.com>,
        Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>,
        dri-devel@lists.freedesktop.org
Subject: [PATCH 6.1 127/198] drm/ttm: Fix a NULL pointer dereference
Date:   Mon, 20 Mar 2023 15:54:25 +0100
Message-Id: <20230320145512.868867333@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

commit 9a9a8fe26751334b7739193a94eba741073b8a55 upstream.

The LRU mechanism may look up a resource in the process of being removed
from an object. The locking rules here are a bit unclear but it looks
currently like res->bo assignment is protected by the LRU lock, whereas
bo->resource is protected by the object lock, while *clearing* of
bo->resource is also protected by the LRU lock. This means that if
we check that bo->resource points to the LRU resource under the LRU
lock we should be safe.
So perform that check before deciding to swap out a bo. That avoids
dereferencing a NULL bo->resource in ttm_bo_swapout().

Fixes: 6a9b02899402 ("drm/ttm: move the LRU into resource handling v4")
Cc: Christian König <christian.koenig@amd.com>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>
Cc: Christian Koenig <christian.koenig@amd.com>
Cc: Huang Rui <ray.huang@amd.com>
Cc: Alex Deucher <alexander.deucher@amd.com>
Cc: Felix Kuehling <Felix.Kuehling@amd.com>
Cc: Philip Yang <Philip.Yang@amd.com>
Cc: Qiang Yu <qiang.yu@amd.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: "Thomas Hellström" <thomas.hellstrom@linux.intel.com>
Cc: Anshuman Gupta <anshuman.gupta@intel.com>
Cc: Arunpravin Paneer Selvam <Arunpravin.PaneerSelvam@amd.com>
Cc: dri-devel@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.19+
Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Christian König <christian.koenig@amd.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230307144621.10748-2-thomas.hellstrom@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/ttm/ttm_device.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/ttm/ttm_device.c b/drivers/gpu/drm/ttm/ttm_device.c
index e7147e304637..b84f74807ca1 100644
--- a/drivers/gpu/drm/ttm/ttm_device.c
+++ b/drivers/gpu/drm/ttm/ttm_device.c
@@ -158,7 +158,7 @@ int ttm_device_swapout(struct ttm_device *bdev, struct ttm_operation_ctx *ctx,
 			struct ttm_buffer_object *bo = res->bo;
 			uint32_t num_pages;
 
-			if (!bo)
+			if (!bo || bo->resource != res)
 				continue;
 
 			num_pages = PFN_UP(bo->base.size);
-- 
2.40.0



