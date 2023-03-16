Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8480D6BD686
	for <lists+stable@lfdr.de>; Thu, 16 Mar 2023 17:59:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229489AbjCPQ7f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Mar 2023 12:59:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjCPQ7e (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 16 Mar 2023 12:59:34 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E26C6366AC
        for <stable@vger.kernel.org>; Thu, 16 Mar 2023 09:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678985973; x=1710521973;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=TipeZemj07QYm0tsNflZV+cnvwkXU70t44vwDs3ncuc=;
  b=eXYE6D5DkW4Z6k8Tixcq6tst2KpYaDZfWz/KvE+EDcm3CrjAqaKBKKPc
   6a/GbEe1M+uJ3ZijeRxawIqGKLtHd5blWrshoEpddAByKu5nkTBLRhd2A
   nix5h2KyFSt/9Nni3ZzmypNSVXxLQDXDDgaZZRZukrkK8R4WSZahmVqiM
   IkpHJNYSEbnBDV4pJsT2qcd7hz8efQEUiHsW52BU2LHEt9ZFO0lSpK2jg
   ufVVyrnfGhC3Gf5HKoKiIKeMmy7a7uiAJ/0t5zfTdiB9nIzoVnx4imZ4f
   fUKheUlgpfMkJx4tWKS3GTOLv25+4euDIri/A2Cvv4DLZwI8suKvlrl4k
   Q==;
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="317705510"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="317705510"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 09:59:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10651"; a="854130851"
X-IronPort-AV: E=Sophos;i="5.98,265,1673942400"; 
   d="scan'208";a="854130851"
Received: from nirmoyda-desk.igk.intel.com ([10.91.214.27])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Mar 2023 09:59:30 -0700
From:   Nirmoy Das <nirmoy.das@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Matthew Brost <matthew.brost@intel.com>,
        John Harrison <John.C.Harrison@Intel.com>,
        stable@vger.kernel.org, Nirmoy Das <nirmoy.das@intel.com>
Subject: [PATCH] drm/i915/gem: Flush lmem contents after construction
Date:   Thu, 16 Mar 2023 17:59:18 +0100
Message-Id: <20230316165918.13074-1-nirmoy.das@intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Organization: Intel Deutschland GmbH, Registered Address: Am Campeon 10, 85579 Neubiberg, Germany, Commercial Register: Amtsgericht Muenchen HRB 186928 
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@linux.intel.com>

i915_gem_object_create_lmem_from_data() lacks the flush of the data
written to lmem to ensure the object is marked as dirty and the writes
flushed to the backing store. Once created, we can immediately release
the obj->mm.mapping caching of the vmap.

Fixes: 7acbbc7cf485 ("drm/i915/guc: put all guc objects in lmem when available")
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Daniele Ceraolo Spurio <daniele.ceraolospurio@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: John Harrison <John.C.Harrison@Intel.com>
Signed-off-by: Chris Wilson <chris.p.wilson@linux.intel.com>
Cc: <stable@vger.kernel.org> # v5.16+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
---
 drivers/gpu/drm/i915/gem/i915_gem_lmem.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_lmem.c b/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
index 8949fb0a944f..3198b64ad7db 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_lmem.c
@@ -127,7 +127,8 @@ i915_gem_object_create_lmem_from_data(struct drm_i915_private *i915,
 
 	memcpy(map, data, size);
 
-	i915_gem_object_unpin_map(obj);
+	i915_gem_object_flush_map(obj);
+	__i915_gem_object_release_map(obj);
 
 	return obj;
 }
-- 
2.39.0

