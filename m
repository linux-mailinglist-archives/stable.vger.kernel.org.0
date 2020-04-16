Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 427631AC863
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:08:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442100AbgDPPHj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:07:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:37532 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388826AbgDPNvZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:51:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67B1E21734;
        Thu, 16 Apr 2020 13:51:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587045084;
        bh=6+oJ7PTP3fBINPUhEl2O/+YvcOWV+wkkE4+IcT2lYTM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2LQPnl9S/uwVGgR24ukAkI/S8QN7MFSovC2k6YPPKvnr+QfHf0joqdmxxtlKJLxsU
         +bp3QuN1AtduLoMlNjrdeaQAjWOYu39GSjPPdh0TYNRvzkf48Yj64Zs3MdanIHWHcE
         +Z/D2/LRyxJH8in2y5tDGuXe7+PI559bOr18WNoU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.william.auld@gmail.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.4 183/232] drm/i915/gem: Flush all the reloc_gpu batch
Date:   Thu, 16 Apr 2020 15:24:37 +0200
Message-Id: <20200416131337.996434225@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131316.640996080@linuxfoundation.org>
References: <20200416131316.640996080@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 1aaea8476d9f014667d2cb24819f9bcaf3ebb7a4 upstream.

__i915_gem_object_flush_map() takes a byte range, so feed it the written
bytes and do not mistake the u32 index as bytes!

Fixes: a679f58d0510 ("drm/i915: Flush pages on acquisition")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Matthew Auld <matthew.william.auld@gmail.com>
Cc: <stable@vger.kernel.org> # v5.2+
Reviewed-by: Matthew Auld <matthew.william.auld@gmail.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200406114821.10949-1-chris@chris-wilson.co.uk
(cherry picked from commit 30c88a47f1abd5744908d3681f54dcf823fe2a12)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -931,11 +931,13 @@ static inline struct i915_ggtt *cache_to
 
 static void reloc_gpu_flush(struct reloc_cache *cache)
 {
-	GEM_BUG_ON(cache->rq_size >= cache->rq->batch->obj->base.size / sizeof(u32));
+	struct drm_i915_gem_object *obj = cache->rq->batch->obj;
+
+	GEM_BUG_ON(cache->rq_size >= obj->base.size / sizeof(u32));
 	cache->rq_cmd[cache->rq_size] = MI_BATCH_BUFFER_END;
 
-	__i915_gem_object_flush_map(cache->rq->batch->obj, 0, cache->rq_size);
-	i915_gem_object_unpin_map(cache->rq->batch->obj);
+	__i915_gem_object_flush_map(obj, 0, sizeof(u32) * (cache->rq_size + 1));
+	i915_gem_object_unpin_map(obj);
 
 	intel_gt_chipset_flush(cache->rq->engine->gt);
 


