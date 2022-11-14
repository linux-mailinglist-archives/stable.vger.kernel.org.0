Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BF71628014
	for <lists+stable@lfdr.de>; Mon, 14 Nov 2022 14:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237731AbiKNNDN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Nov 2022 08:03:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237724AbiKNNDL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Nov 2022 08:03:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F6F12936C
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 05:03:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C4B46B80EA5
        for <stable@vger.kernel.org>; Mon, 14 Nov 2022 13:03:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2119AC433C1;
        Mon, 14 Nov 2022 13:03:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1668430987;
        bh=dS9B6KURR1d1dIye6u9f8n6AL65JCIbq7LhoRL4xy7o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tl3ymc30dhUfxWrNCQjpBkmqSqEqTUI2JsMjmGmZkNbCAxGYnkIGQlY+TRRcTaBd7
         cMa1b4BTNI/yICBGd8vMtom3xztz5kpJR2PovEqkdRpPYlAuwromloe3fY6SrS/WPY
         5zmTsu8O2UJnpFSXOndp9fNtmnPn87+LzJphK98o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Matthew Auld <matthew.auld@intel.com>,
        Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 058/190] drm/i915: Do not set cache_dirty for DGFX
Date:   Mon, 14 Nov 2022 13:44:42 +0100
Message-Id: <20221114124501.298644670@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221114124458.806324402@linuxfoundation.org>
References: <20221114124458.806324402@linuxfoundation.org>
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

From: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>

[ Upstream commit 19b168136395150a4a6e011f944eb30d3d85094b ]

Currently on DG1, which does not have LLC, we hit the below
warning while rebinding an userptr invalidated object.

WARNING: CPU: 4 PID: 13008 at drivers/gpu/drm/i915/gem/i915_gem_pages.c:34 __i915_gem_object_set_pages+0x296/0x2d0 [i915]
...
RIP: 0010:__i915_gem_object_set_pages+0x296/0x2d0 [i915]
...
Call Trace:
 <TASK>
 i915_gem_userptr_get_pages+0x175/0x1a0 [i915]
 ____i915_gem_object_get_pages+0x32/0xb0 [i915]
 i915_gem_object_userptr_submit_init+0x286/0x470 [i915]
 eb_lookup_vmas+0x2ff/0xcf0 [i915]
 ? __intel_wakeref_get_first+0x55/0xb0 [i915]
 i915_gem_do_execbuffer+0x785/0x21d0 [i915]
 i915_gem_execbuffer2_ioctl+0xe7/0x3d0 [i915]

We shouldn't be setting the obj->cache_dirty for DGFX,
fix it.

Fixes: d70af57944a1 ("drm/i915/shmem: ensure flush during swap-in on non-LLC")
Suggested-by: Matthew Auld <matthew.auld@intel.com>
Reported-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Signed-off-by: Niranjana Vishwanathapura <niranjana.vishwanathapura@intel.com>
Acked-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221102051416.27327-1-niranjana.vishwanathapura@intel.com
(cherry picked from commit 0aeec60c76ca2631696b4228f3fc99fe3a80013d)
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 34b9c76cd8e6..b5eb279a5c2c 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -369,14 +369,14 @@ __i915_gem_object_release_shmem(struct drm_i915_gem_object *obj,
 
 	__start_cpu_write(obj);
 	/*
-	 * On non-LLC platforms, force the flush-on-acquire if this is ever
+	 * On non-LLC igfx platforms, force the flush-on-acquire if this is ever
 	 * swapped-in. Our async flush path is not trust worthy enough yet(and
 	 * happens in the wrong order), and with some tricks it's conceivable
 	 * for userspace to change the cache-level to I915_CACHE_NONE after the
 	 * pages are swapped-in, and since execbuf binds the object before doing
 	 * the async flush, we have a race window.
 	 */
-	if (!HAS_LLC(i915))
+	if (!HAS_LLC(i915) && !IS_DGFX(i915))
 		obj->cache_dirty = true;
 }
 
-- 
2.35.1



