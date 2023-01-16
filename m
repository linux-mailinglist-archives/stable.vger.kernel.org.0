Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8169E66C479
	for <lists+stable@lfdr.de>; Mon, 16 Jan 2023 16:55:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231689AbjAPPzU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Jan 2023 10:55:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231366AbjAPPzH (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Jan 2023 10:55:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 301E022798
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 07:55:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D9526102D
        for <stable@vger.kernel.org>; Mon, 16 Jan 2023 15:55:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2134FC433EF;
        Mon, 16 Jan 2023 15:55:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1673884503;
        bh=8qRTdXvIvxl0/gerX2qxYxM0dkK3Mf/RxEFqs2Rw+T8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FS+117yzegP93yp4CxlFZqiEk0MDh31VKGyGlx7MgCAhQR6JQlKjmP/fryzLZVXzA
         FkqY9tlRcFqMOhZ2nP7KMuVpyPrU0rhTYvGLOd7FL6k4M490/KCAKU38Du0nuWrnCW
         k4wEbFQFgNg174C2LOiaHiOE9muhEb+A5TKwusbw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 6.1 030/183] drm/i915: Reserve enough fence slot for i915_vma_unbind_async
Date:   Mon, 16 Jan 2023 16:49:13 +0100
Message-Id: <20230116154804.633702520@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154803.321528435@linuxfoundation.org>
References: <20230116154803.321528435@linuxfoundation.org>
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

From: Nirmoy Das <nirmoy.das@intel.com>

commit 476fdcdaaae7b06c780cdfc234c704107f16c529 upstream.

A nested dma_resv_reserve_fences(1) will not reserve slot from the
2nd call onwards and folowing dma_resv_add_fence() might hit the
"BUG_ON(fobj->num_fences >= fobj->max_fences)" check.

I915 hit above nested dma_resv case in ttm_bo_handle_move_mem() with
async unbind:

dma_resv_reserve_fences() from --> ttm_bo_handle_move_mem()
        dma_resv_reserve_fences() from --> i915_vma_unbind_async()
        dma_resv_add_fence() from --> i915_vma_unbind_async()
dma_resv_add_fence() from -->ttm_bo_move_accel_cleanup()

Resolve this by adding an extra fence in i915_vma_unbind_async().

Suggested-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Fixes: 2f6b90da9192 ("drm/i915: Use vma resources for async unbinding")
Cc: <stable@vger.kernel.org> # v5.18+
Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20221223092011.11657-1-nirmoy.das@intel.com
(cherry picked from commit 4f0755c2faf7388616109717facc5bbde6850e60)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/i915_vma.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/gpu/drm/i915/i915_vma.c
+++ b/drivers/gpu/drm/i915/i915_vma.c
@@ -2114,7 +2114,7 @@ int i915_vma_unbind_async(struct i915_vm
 	if (!obj->mm.rsgt)
 		return -EBUSY;
 
-	err = dma_resv_reserve_fences(obj->base.resv, 1);
+	err = dma_resv_reserve_fences(obj->base.resv, 2);
 	if (err)
 		return -EBUSY;
 


