Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B7B86899D9
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 14:36:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232468AbjBCNgi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 08:36:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBCNgh (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 08:36:37 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D3DC33ABF
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 05:36:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675431396; x=1706967396;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=r0fcSXW1yrn789f+eFpqI8loCTQYShTr8qGrw89Fl3U=;
  b=HD3qNnQk0uwvOQihlPhJH2gWRrC/p+AnuXgvjlCo6Ah3K1gvHjWdbw7F
   u/djHAD7qvsxW2OulabDTvl8H9MAv9EGeyMPjDJv/Z1Udd8TT6mBTn1o1
   NHOlp6/qagS/f8ODezCop8i9HSWxou9TOPdxeXUSlclmVGL85c0p1de70
   q6B1IK3aGng1dgoZN2HWYpBxxKK7lHNUG4VIqe254/1mZ5j5BHYeTM97D
   LEZ+ihnpHKGdMzelev2FQU4j/kpUS4mXYe7jeXBPosfY0nTH681ZHd8fK
   lumA1fSRNn1omkGlZCyF7+W0icbR6nI3mz883neGsTVhoyBTs2Y0+73Jx
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="330879186"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="330879186"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 05:36:36 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10610"; a="839611842"
X-IronPort-AV: E=Sophos;i="5.97,270,1669104000"; 
   d="scan'208";a="839611842"
Received: from aravind-dev.iind.intel.com ([10.145.162.80])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Feb 2023 05:36:34 -0800
From:   Aravind Iddamsetty <aravind.iddamsetty@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Subject: [PATCH v2] drm/i915: Initialize the obj flags for shmem objects
Date:   Fri,  3 Feb 2023 19:22:05 +0530
Message-Id: <20230203135205.4051149-1-aravind.iddamsetty@intel.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Obj flags for shmem objects is not being set correctly. Fixes in setting
BO_ALLOC_USER flag which applies to shmem objs as well.

Fixes: 13d29c823738 ("drm/i915/ehl: unconditionally flush the pages on acquire")
Cc: <stable@vger.kernel.org> # v5.15+

v2: Add fixes tag (Tvrtko, Matt A)

Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Aravind Iddamsetty <aravind.iddamsetty@intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_shmem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
index 114443096841..37d1efcd3ca6 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_shmem.c
@@ -596,7 +596,7 @@ static int shmem_object_init(struct intel_memory_region *mem,
 	mapping_set_gfp_mask(mapping, mask);
 	GEM_BUG_ON(!(mapping_gfp_mask(mapping) & __GFP_RECLAIM));
 
-	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, 0);
+	i915_gem_object_init(obj, &i915_gem_shmem_ops, &lock_class, flags);
 	obj->mem_flags |= I915_BO_FLAG_STRUCT_PAGE;
 	obj->write_domain = I915_GEM_DOMAIN_CPU;
 	obj->read_domains = I915_GEM_DOMAIN_CPU;
-- 
2.25.1

