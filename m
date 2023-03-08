Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F13CB6B0339
	for <lists+stable@lfdr.de>; Wed,  8 Mar 2023 10:42:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbjCHJmO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 8 Mar 2023 04:42:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230184AbjCHJmB (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 8 Mar 2023 04:42:01 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88AD6B79F2
        for <stable@vger.kernel.org>; Wed,  8 Mar 2023 01:41:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678268502; x=1709804502;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=uGzmLhdp64nUyBhMNT/W4I80zrlNOpI/Un78hvV180M=;
  b=ZqS2gYTpoNUQ61LfTJ+8k0AjdbGfql6G6YKCA0w9AvwLFqsFPfVSFEpg
   vDUPEm3bg3uTBpkh1TnFpFxv/PL+uZ4BTkaTiaK9XerObsY7aRmt3jnVj
   GN3fbJGxeVga/GDg3I2j8V+F6A4Z7QrnJmoHRflG19lO7RI2kUK1pl4if
   /+isG+B7UP9n7tY8ItfKCf+ZRy0cxrXMKbTX8ohCMv3+NB/4MvpS9ibnW
   VTsQGWVd9LKVBsgUDcP1mpBkN8wPPyIqpwzpS8srOTYFKTady8DvRCZlk
   DSPYfJseNaNqOi3xm7mZfLvc5bsckRT3RLDql8om5K75IXNr7A8UIdGi1
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="338437615"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="338437615"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:42 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10642"; a="741056280"
X-IronPort-AV: E=Sophos;i="5.98,243,1673942400"; 
   d="scan'208";a="741056280"
Received: from gbain-mobl1.ger.corp.intel.com (HELO intel.com) ([10.252.47.108])
  by fmsmga008-auth.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 08 Mar 2023 01:41:39 -0800
From:   Andi Shyti <andi.shyti@linux.intel.com>
To:     intel-gfx@lists.freedesktop.org, dri-devel@lists.freedesktop.org,
        stable@vger.kernel.org
Cc:     Matthew Auld <matthew.auld@intel.com>,
        Maciej Patelczyk <maciej.patelczyk@intel.com>,
        Chris Wilson <chris.p.wilson@linux.intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH v4 2/5] drm/i915/gt: Add intel_context_timeline_is_locked helper
Date:   Wed,  8 Mar 2023 10:41:03 +0100
Message-Id: <20230308094106.203686-3-andi.shyti@linux.intel.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230308094106.203686-1-andi.shyti@linux.intel.com>
References: <20230308094106.203686-1-andi.shyti@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
---
 drivers/gpu/drm/i915/gt/intel_context.h | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/gt/intel_context.h b/drivers/gpu/drm/i915/gt/intel_context.h
index f919a66cebf5b..87d5e2d60b6db 100644
--- a/drivers/gpu/drm/i915/gt/intel_context.h
+++ b/drivers/gpu/drm/i915/gt/intel_context.h
@@ -265,6 +265,12 @@ static inline void intel_context_timeline_unlock(struct intel_timeline *tl)
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

