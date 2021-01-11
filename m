Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A202F13BF
	for <lists+stable@lfdr.de>; Mon, 11 Jan 2021 14:14:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726526AbhAKNOE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jan 2021 08:14:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:60360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731877AbhAKNNX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Jan 2021 08:13:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A1F422B49;
        Mon, 11 Jan 2021 13:12:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610370762;
        bh=ZGs3UEZL5g3cIwQdpC4iOJhgacp1piMgr86kLlOwMx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MQJ6rzVIEDSxQzWHNENyr3AEUg7VRsNpkZcf7C34DqjHD00aBYEGTR85SNeFEfvj+
         WM5lDkHUUl9ea5verxymjjRPseQCxp3KCV9sRyll+/j7Tcv0Yw4Pk0gvu4DZ5KR6w9
         qLG73QgCzxZuWGBuNdpJRMDQUQfjD8TTXr1spVrw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Matthew Auld <matthew.auld@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.4 86/92] drm/i915: clear the gpu reloc batch
Date:   Mon, 11 Jan 2021 14:02:30 +0100
Message-Id: <20210111130043.303143630@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210111130039.165470698@linuxfoundation.org>
References: <20210111130039.165470698@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Matthew Auld <matthew.auld@intel.com>

commit 641382e9b44fba81a0778e1914ee35b8471121f9 upstream.

The reloc batch is short lived but can exist in the user visible ppGTT,
and since it's backed by an internal object, which lacks page clearing,
we should take care to clear it upfront.

Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Chris Wilson <chris@chris-wilson.co.uk>
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Link: https://patchwork.freedesktop.org/patch/msgid/20201224151358.401345-2-matthew.auld@intel.com
Cc: stable@vger.kernel.org
(cherry picked from commit 26ebc511e799f621357982ccc37a7987a56a00f4)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -936,7 +936,7 @@ static void reloc_gpu_flush(struct reloc
 	GEM_BUG_ON(cache->rq_size >= obj->base.size / sizeof(u32));
 	cache->rq_cmd[cache->rq_size] = MI_BATCH_BUFFER_END;
 
-	__i915_gem_object_flush_map(obj, 0, sizeof(u32) * (cache->rq_size + 1));
+	i915_gem_object_flush_map(obj);
 	i915_gem_object_unpin_map(obj);
 
 	intel_gt_chipset_flush(cache->rq->engine->gt);
@@ -1163,6 +1163,8 @@ static int __reloc_gpu_alloc(struct i915
 		goto out_pool;
 	}
 
+	memset32(cmd, 0, pool->obj->base.size / sizeof(u32));
+
 	batch = i915_vma_instance(pool->obj, vma->vm, NULL);
 	if (IS_ERR(batch)) {
 		err = PTR_ERR(batch);


