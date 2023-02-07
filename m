Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78AB968D863
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:09:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232290AbjBGNJK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:09:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232297AbjBGNJJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:09:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606C93B0FF
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:08:33 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 410E261405
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:08:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32B2DC433EF;
        Tue,  7 Feb 2023 13:08:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775312;
        bh=emuchSDpIVH9qZs3h1wPs42NfDhhwcKsbkKnIdiUw7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WZk1MyzzBhnQDtJrDBUdc1uWOWcaSWzm5WWyFYSIR3c8xkg7rPFtnZck/AJIsXIyn
         1E02lM6guKtNZH6y6TC33cQ4jzCGJduT4i5PzCa+XLVxYkKinhp/wZIXWNPExTbpiv
         hMX0vJhuVeMhyNCJpgQ3UAyA39FAwIc38/rOKmqA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Matthew Auld <matthew.auld@intel.com>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 179/208] drm/i915: Avoid potential vm use-after-free
Date:   Tue,  7 Feb 2023 13:57:13 +0100
Message-Id: <20230207125642.561286025@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125634.292109991@linuxfoundation.org>
References: <20230207125634.292109991@linuxfoundation.org>
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

From: Rob Clark <robdclark@chromium.org>

commit 41d419382ec7e257e54b7b6ff0d3623aafb1316d upstream.

Adding the vm to the vm_xa table makes it visible to userspace, which
could try to race with us to close the vm.  So we need to take our extra
reference before putting it in the table.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Fixes: 9ec8795e7d91 ("drm/i915: Drop __rcu from gem_context->vm")
Cc: <stable@vger.kernel.org> # v5.16+
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230119173321.2825472-1-robdclark@gmail.com
(cherry picked from commit 99343c46d4e2b34c285d3d5f68ff04274c2f9fb4)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_context.c | 14 +++++++++++---
 1 file changed, 11 insertions(+), 3 deletions(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_context.c b/drivers/gpu/drm/i915/gem/i915_gem_context.c
index 6250de9b9196..e4b78ab4773b 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_context.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_context.c
@@ -1861,11 +1861,19 @@ static int get_ppgtt(struct drm_i915_file_private *file_priv,
 	vm = ctx->vm;
 	GEM_BUG_ON(!vm);
 
+	/*
+	 * Get a reference for the allocated handle.  Once the handle is
+	 * visible in the vm_xa table, userspace could try to close it
+	 * from under our feet, so we need to hold the extra reference
+	 * first.
+	 */
+	i915_vm_get(vm);
+
 	err = xa_alloc(&file_priv->vm_xa, &id, vm, xa_limit_32b, GFP_KERNEL);
-	if (err)
+	if (err) {
+		i915_vm_put(vm);
 		return err;
-
-	i915_vm_get(vm);
+	}
 
 	GEM_BUG_ON(id == 0); /* reserved for invalid/unassigned ppgtt */
 	args->value = id;
-- 
2.39.1



