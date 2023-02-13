Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B9E569495C
	for <lists+stable@lfdr.de>; Mon, 13 Feb 2023 15:58:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231196AbjBMO6c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Feb 2023 09:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231203AbjBMO6Q (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Feb 2023 09:58:16 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B5556A44
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 06:57:53 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBF4F6112F
        for <stable@vger.kernel.org>; Mon, 13 Feb 2023 14:57:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0815EC433D2;
        Mon, 13 Feb 2023 14:57:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1676300225;
        bh=UQRvJN2wi/x7Jxw7mkAWrK8rQQz6vlysSPL99h9+hrw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=yrbi5J8xBb3zJ9Lc+QLokK3pWr74gfc+TOHtipYsg/bfqyam+aNr7tnmNUfYyPEjP
         6j2oUmnIFcwVvcbEDKfpBq1Rfqb8oNhos7oeqj859ogWIk3Z8bcoNgi6Bnnto/OWsc
         TS97sXVfFd8t2ydn973H3jrI6OI8Khc/mOLF/vo0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Rob Clark <robdclark@chromium.org>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 112/114] drm/i915: Move fd_install after last use of fence
Date:   Mon, 13 Feb 2023 15:49:07 +0100
Message-Id: <20230213144748.021478384@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230213144742.219399167@linuxfoundation.org>
References: <20230213144742.219399167@linuxfoundation.org>
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

commit 251e8c5b1b1fadcc387a8e618c7437d330bdac3e upstream.

Because eb_composite_fence_create() drops the fence_array reference
after creation of the sync_file, only the sync_file holds a ref to the
fence.  But fd_install() makes that reference visable to userspace, so
it must be the last thing we do with the fence.

Signed-off-by: Rob Clark <robdclark@chromium.org>
Fixes: 00dae4d3d35d ("drm/i915: Implement SINGLE_TIMELINE with a syncobj (v4)")
Cc: <stable@vger.kernel.org> # v5.15+
[tursulin: Added stable tag.]
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Signed-off-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20230203164937.4035503-1-robdclark@gmail.com
(cherry picked from commit 960dafa30455450d318756a9896a02727f2639e0)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_execbuffer.c
@@ -3478,6 +3478,13 @@ err_request:
 				   eb.composite_fence :
 				   &eb.requests[0]->fence);
 
+	if (unlikely(eb.gem_context->syncobj)) {
+		drm_syncobj_replace_fence(eb.gem_context->syncobj,
+					  eb.composite_fence ?
+					  eb.composite_fence :
+					  &eb.requests[0]->fence);
+	}
+
 	if (out_fence) {
 		if (err == 0) {
 			fd_install(out_fence_fd, out_fence->file);
@@ -3489,13 +3496,6 @@ err_request:
 		}
 	}
 
-	if (unlikely(eb.gem_context->syncobj)) {
-		drm_syncobj_replace_fence(eb.gem_context->syncobj,
-					  eb.composite_fence ?
-					  eb.composite_fence :
-					  &eb.requests[0]->fence);
-	}
-
 	if (!out_fence && eb.composite_fence)
 		dma_fence_put(eb.composite_fence);
 


