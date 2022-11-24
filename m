Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A55A637899
	for <lists+stable@lfdr.de>; Thu, 24 Nov 2022 13:10:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229480AbiKXMKF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 24 Nov 2022 07:10:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229472AbiKXMKE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 24 Nov 2022 07:10:04 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C409623B5
        for <stable@vger.kernel.org>; Thu, 24 Nov 2022 04:10:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1669291803; x=1700827803;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=VeGMyYTTMhuWLDGwGgpvKEsDAECcBQ0fUZpyt0ZS84s=;
  b=GEDy6Yi6jQMLrsCBpFTUEMWbv5GwD3uTDpMsIuAMXl8BQK5InZdHorML
   iF+Fn3urWoecoXiNz7Mq/4UZKlpu6f16hwVLyCKJmnnN6LzoSwoNSGc7L
   uggTGeUCzGcCZLG6JJEu6FBieK2WKTMQZojV/3KzxsA1Q5XmBhW1OCgMd
   GVBFuJt0Q+H2RZYEqfG22/OV9J6dLiha8NuXy57Ly5+YuqsV1PiOJOEta
   DqvhasGQu5qN1kXxAcKOAGZ/KuYvuk/RjYszno57MBlAspyPoZRxPpUoQ
   6b01GK1leiSjE7+GvDXDvxsydjFPO77R3PKtVezJluRMRrq0RUDmUTBNH
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="301850649"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="301850649"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:10:03 -0800
X-IronPort-AV: E=McAfee;i="6500,9779,10540"; a="642330155"
X-IronPort-AV: E=Sophos;i="5.96,190,1665471600"; 
   d="scan'208";a="642330155"
Received: from gsimsek-mobl1.ger.corp.intel.com (HELO mwauld-desk1.intel.com) ([10.252.2.4])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Nov 2022 04:10:00 -0800
From:   Matthew Auld <matthew.auld@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Chris Wilson <chris.p.wilson@intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>, stable@vger.kernel.org
Subject: [PATCH v4 1/3] drm/i915/migrate: Account for the reserved_space
Date:   Thu, 24 Nov 2022 12:09:41 +0000
Message-Id: <20221124120943.241543-1-matthew.auld@intel.com>
X-Mailer: git-send-email 2.38.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris.p.wilson@intel.com>

If the ring is nearly full when calling into emit_pte(), we might
incorrectly trample the reserved_space when constructing the packet to
emit the PTEs. This then triggers the GEM_BUG_ON(rq->reserved_space >
ring->space) when later submitting the request, since the request itself
doesn't have enough space left in the ring to emit things like
workarounds, breadcrumbs etc.

Testcase: igt@i915_selftests@live_emit_pte_full_ring
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/7535
Closes: https://gitlab.freedesktop.org/drm/intel/-/issues/6889
Fixes: cf586021642d ("drm/i915/gt: Pipelined page migration")
Signed-off-by: Chris Wilson <chris.p.wilson@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Andrzej Hajda <andrzej.hajda@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: Nirmoy Das <nirmoy.das@intel.com>
Cc: <stable@vger.kernel.org> # v5.15+
Tested-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_migrate.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/i915/gt/intel_migrate.c b/drivers/gpu/drm/i915/gt/intel_migrate.c
index b405a04135ca..48c3b5168558 100644
--- a/drivers/gpu/drm/i915/gt/intel_migrate.c
+++ b/drivers/gpu/drm/i915/gt/intel_migrate.c
@@ -342,6 +342,16 @@ static int emit_no_arbitration(struct i915_request *rq)
 	return 0;
 }
 
+static int max_pte_pkt_size(struct i915_request *rq, int pkt)
+{
+       struct intel_ring *ring = rq->ring;
+
+       pkt = min_t(int, pkt, (ring->space - rq->reserved_space) / sizeof(u32) + 5);
+       pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+
+       return pkt;
+}
+
 static int emit_pte(struct i915_request *rq,
 		    struct sgt_dma *it,
 		    enum i915_cache_level cache_level,
@@ -388,8 +398,7 @@ static int emit_pte(struct i915_request *rq,
 		return PTR_ERR(cs);
 
 	/* Pack as many PTE updates as possible into a single MI command */
-	pkt = min_t(int, dword_length, ring->space / sizeof(u32) + 5);
-	pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+	pkt = max_pte_pkt_size(rq, dword_length);
 
 	hdr = cs;
 	*cs++ = MI_STORE_DATA_IMM | REG_BIT(21); /* as qword elements */
@@ -422,8 +431,7 @@ static int emit_pte(struct i915_request *rq,
 				}
 			}
 
-			pkt = min_t(int, dword_rem, ring->space / sizeof(u32) + 5);
-			pkt = min_t(int, pkt, (ring->size - ring->emit) / sizeof(u32) + 5);
+			pkt = max_pte_pkt_size(rq, dword_rem);
 
 			hdr = cs;
 			*cs++ = MI_STORE_DATA_IMM | REG_BIT(21);
-- 
2.38.1

