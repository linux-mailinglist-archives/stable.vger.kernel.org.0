Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C343D6B435D
	for <lists+stable@lfdr.de>; Fri, 10 Mar 2023 15:14:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231935AbjCJON7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Mar 2023 09:13:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50868 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231936AbjCJONi (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Mar 2023 09:13:38 -0500
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81FC0119978
        for <stable@vger.kernel.org>; Fri, 10 Mar 2023 06:12:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678457542; x=1709993542;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=i6ItQ63j+Yxjwed91mU6bmJf4zav9uIxwHbyZs+qIsE=;
  b=VJ1MBePcNrWdg4JZbVeE00mqnvybcyv28qCZXFhbFnEfJbIZARlYLDq1
   iGIbpzZQqCNTtIZQP07KYLu7BFafQ4ykX8bPRX+Oidch4LTz61JXZKI0d
   Zk4P2WFbgwdz40BXJ3WNmEQu55r/adnod/mwOF5kxUmMwoKsKqwPyaVd5
   MXxgyWSycFlKdfTb+tFv02LGZDWpEnIOMm7YX0/r2qKOuZsUWxHL2X1KT
   UBy6GlfMWGgzYuxL93eiZq/h6byvkigvdV/JNM4Es5a8AndtRv7Ca45hr
   ITsWjUjRuEPu3FISBJLEke5H4KUawUcXt90K+w2nV4zocG7n/vT+nqVK4
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="336753658"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="336753658"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 06:11:59 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10645"; a="923701871"
X-IronPort-AV: E=Sophos;i="5.98,249,1673942400"; 
   d="scan'208";a="923701871"
Received: from nirmoyda-desk.igk.intel.com ([10.102.42.231])
  by fmsmga006-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Mar 2023 06:11:58 -0800
From:   Nirmoy Das <nirmoy.das@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     Nirmoy Das <nirmoy.das@intel.com>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>, stable@vger.kernel.org
Subject: [PATCH] drm/i915/active: Fix missing debug object activation
Date:   Fri, 10 Mar 2023 15:11:38 +0100
Message-Id: <20230310141138.6592-1-nirmoy.das@intel.com>
X-Mailer: git-send-email 2.39.0
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Organization: Intel Deutschland GmbH, Registered Address: Am Campeon 10, 85579 Neubiberg, Germany, Commercial Register: Amtsgericht Muenchen HRB 186928 
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

debug_active_activate() expected ref->count to be zero
which is not true anymore as __i915_active_activate() calls
debug_active_activate() after incrementing the count.

Fixes: 04240e30ed06 ("drm/i915: Skip taking acquire mutex for no ref->active callback")
Cc: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>
Cc: intel-gfx@lists.freedesktop.org
Cc: <stable@vger.kernel.org> # v5.10+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
---
 drivers/gpu/drm/i915/i915_active.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/i915_active.c b/drivers/gpu/drm/i915/i915_active.c
index a9fea115f2d2..1c3066eb359a 100644
--- a/drivers/gpu/drm/i915/i915_active.c
+++ b/drivers/gpu/drm/i915/i915_active.c
@@ -92,7 +92,7 @@ static void debug_active_init(struct i915_active *ref)
 static void debug_active_activate(struct i915_active *ref)
 {
 	lockdep_assert_held(&ref->tree_lock);
-	if (!atomic_read(&ref->count)) /* before the first inc */
+	if (atomic_read(&ref->count) == 1) /* after the first inc */
 		debug_object_activate(ref, &active_debug_desc);
 }
 
-- 
2.39.0

