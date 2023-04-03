Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA8426D4AE4
	for <lists+stable@lfdr.de>; Mon,  3 Apr 2023 16:50:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234105AbjDCOu6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Apr 2023 10:50:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37724 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234197AbjDCOum (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 3 Apr 2023 10:50:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5671E28E88
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 07:50:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 33C1D61F99
        for <stable@vger.kernel.org>; Mon,  3 Apr 2023 14:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 477EBC433D2;
        Mon,  3 Apr 2023 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1680533409;
        bh=Cs/XKB3CfXHVyAQ8XT08o6ywLTViCISSlU4tj2v5t1w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=uZf+WqJyBsR2CmXEVkpQrOMeq6iJ+YrVwVcesF/aDPc9gbAksx+Lw5o7j9ejvC3C0
         0vpVeu8nEJSmoLz6DPw2ip+STsYxOfy9NqEVRiue2Xd9qQtG9XMaryKhOY7kdng0CQ
         DT2j5s1nAhgE+E3r+8pFDVvF/ooiugOSM1tbDurU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Imre Deak <imre.deak@intel.com>,
        =?UTF-8?q?Ville=20Syrj=C3=A4l=C3=A4?= 
        <ville.syrjala@linux.intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 6.2 172/187] drm/i915/dpt: Treat the DPT BO as a framebuffer
Date:   Mon,  3 Apr 2023 16:10:17 +0200
Message-Id: <20230403140421.907168411@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140416.015323160@linuxfoundation.org>
References: <20230403140416.015323160@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ville Syrjälä <ville.syrjala@linux.intel.com>

commit 3413881e1ecc3cba722a2e87ec099692eed5be28 upstream.

Currently i915_gem_object_is_framebuffer() doesn't treat the
BO containing the framebuffer's DPT as a framebuffer itself.
This means eg. that the shrinker can evict the DPT BO while
leaving the actual FB BO bound, when the DPT is allocated
from regular shmem.

That causes an immediate oops during hibernate as we
try to rewrite the PTEs inside the already evicted
DPT obj.

TODO: presumably this might also be the reason for the
DPT related display faults under heavy memory pressure,
but I'm still not sure how that would happen as the object
should be pinned by intel_dpt_pin() while in active use by
the display engine...

Cc: stable@vger.kernel.org
Cc: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
Cc: Matthew Auld <matthew.auld@intel.com>
Cc: Imre Deak <imre.deak@intel.com>
Fixes: 0dc987b699ce ("drm/i915/display: Add smem fallback allocation for dpt")
Signed-off-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230320090522.9909-2-ville.syrjala@linux.intel.com
Reviewed-by: Juha-Pekka Heikkila <juhapekka.heikkila@gmail.com>
(cherry picked from commit 779cb5ba64ec7df80675a956c9022929514f517a)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/display/intel_dpt.c         |    2 ++
 drivers/gpu/drm/i915/gem/i915_gem_object.h       |    2 +-
 drivers/gpu/drm/i915/gem/i915_gem_object_types.h |    3 +++
 3 files changed, 6 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/display/intel_dpt.c
+++ b/drivers/gpu/drm/i915/display/intel_dpt.c
@@ -301,6 +301,7 @@ intel_dpt_create(struct intel_framebuffe
 	vm->pte_encode = gen8_ggtt_pte_encode;
 
 	dpt->obj = dpt_obj;
+	dpt->obj->is_dpt = true;
 
 	return &dpt->vm;
 }
@@ -309,5 +310,6 @@ void intel_dpt_destroy(struct i915_addre
 {
 	struct i915_dpt *dpt = i915_vm_to_dpt(vm);
 
+	dpt->obj->is_dpt = false;
 	i915_vm_put(&dpt->vm);
 }
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.h
@@ -319,7 +319,7 @@ i915_gem_object_never_mmap(const struct
 static inline bool
 i915_gem_object_is_framebuffer(const struct drm_i915_gem_object *obj)
 {
-	return READ_ONCE(obj->frontbuffer);
+	return READ_ONCE(obj->frontbuffer) || obj->is_dpt;
 }
 
 static inline unsigned int
--- a/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object_types.h
@@ -491,6 +491,9 @@ struct drm_i915_gem_object {
 	 */
 	unsigned int cache_dirty:1;
 
+	/* @is_dpt: Object houses a display page table (DPT) */
+	unsigned int is_dpt:1;
+
 	/**
 	 * @read_domains: Read memory domains.
 	 *


