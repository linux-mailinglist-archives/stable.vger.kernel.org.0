Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 482186DF3D5
	for <lists+stable@lfdr.de>; Wed, 12 Apr 2023 13:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230455AbjDLLgC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 12 Apr 2023 07:36:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231466AbjDLLf5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 12 Apr 2023 07:35:57 -0400
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A99D07D8A
        for <stable@vger.kernel.org>; Wed, 12 Apr 2023 04:35:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1681299337; x=1712835337;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=QV8fCkV7Ki8q1dYVTX3JPG1FpteI9tEg2KLpZ1mBAjo=;
  b=jPSs7RcCg9jN82rI4Vp6R+maKama+H1WOygtlAEYSoFn5+X9Rg5ksngD
   EYQi56yHkUTaPutyerxVGP43kSwOH5MN9T/DOH4rwcq5OiCya6JWAtHBk
   qcst2oLvXC7VLEi/cBosWBzU43HZNFMWjhN0WzYLHZ6q+zNkfcW8X1HH9
   m79xKpRCIViqI64r5qpj3WWBA/dq7HuiPswgY+VYwgOvWsEPDV+tbBeQx
   8WIZhVMOtUYgD7nvgBQpOO2/RcqkwQYwjUvpL1CPL18My9LFBo98NGS02
   mLpaIbEIFWxTFlJN0MYyggLHPawfcmt+BSRT31KZm6hjxBS5Zr7HB7OCq
   A==;
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="327978227"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="327978227"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:34:03 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10677"; a="778268744"
X-IronPort-AV: E=Sophos;i="5.98,339,1673942400"; 
   d="scan'208";a="778268744"
Received: from zbiro-mobl.ger.corp.intel.com (HELO intel.com) ([10.251.212.144])
  by fmsmga003-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 12 Apr 2023 04:33:59 -0700
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Andrzej Hajda <andrzej.hajda@intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH v5 1/5] drm/i915/gt: Add intel_context_timeline_is_locked helper
Date:   Wed, 12 Apr 2023 13:33:04 +0200
Message-Id: <20230412113308.812468-2-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230412113308.812468-1-andi.shyti@linux.intel.com>
References: <20230412113308.812468-1-andi.shyti@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have:

 - intel_context_timeline_lock()
 - intel_context_timeline_unlock()

In the next patches we will also need:

 - intel_context_timeline_is_locked()

Add it.

Signed-off-by: Andi Shyti <andi.shyti@linux.intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Nirmoy Das <nirmoy.das@intel.com>
---
 drivers/gpu/drm/i915/gt/intel_context.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
index 48f888c3da083..f2f79ff0dfd1d 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -270,6 +270,12 @@ static inline void intel_context_timeline_unlock(struct intel_timeline *tl)
 	mutex_unlock(&tl->mutex);
 }
 
+static inline void intel_context_assert_timeline_is_locked(struct intel_timeline *tl)
+	__must_hold(&tl->mutex)
+{
+	lockdep_assert_held(&tl->mutex);
+}
+
 int intel_context_prepare_remote_request(struct intel_context *ce,
 					 struct i915_request *rq);
 
-- 
2.39.2

