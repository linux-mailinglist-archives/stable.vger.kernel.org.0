Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC62383766
	for <lists+stable@lfdr.de>; Mon, 17 May 2021 17:42:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238727AbhEQPnH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 May 2021 11:43:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:50372 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S245249AbhEQPlD (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 17 May 2021 11:41:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B7E9361D0D;
        Mon, 17 May 2021 14:41:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621262514;
        bh=pqssFOUIfO6hePtW8m+069C+9Bm1Ta8j//cyuQLZ8MM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WpRlIlxT5PeIM8BfuT1s9s0Pf9T3KFqJ6MAXvAaHZB8eLiFkzRPt07P3P3+MV93gn
         eD/JMdl3BS5CTE4w6tkWUKlsOfKv1ipPkheE2FA8rU+NACEcOdkLA89hgipCGwt07O
         1DZDr5PNHxlFCBzaCcy6WB0x+H/E/diTp2gfp5ns=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lv Yunlong <lyl2019@mail.ustc.edu.cn>,
        Matthew Auld <matthew.auld@intel.com>,
        Jani Nikula <jani.nikula@intel.com>
Subject: [PATCH 5.11 311/329] drm/i915/gt: Fix a double free in gen8_preallocate_top_level_pdp
Date:   Mon, 17 May 2021 16:03:42 +0200
Message-Id: <20210517140312.610892516@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210517140302.043055203@linuxfoundation.org>
References: <20210517140302.043055203@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lv Yunlong <lyl2019@mail.ustc.edu.cn>

commit ea995218dddba171fecd05496c69617c5ef3c5b8 upstream.

Our code analyzer reported a double free bug.

In gen8_preallocate_top_level_pdp, pde and pde->pt.base are allocated
via alloc_pd(vm) with one reference. If pin_pt_dma() failed, pde->pt.base
is freed by i915_gem_object_put() with a reference dropped. Then free_pd
calls free_px() defined in intel_ppgtt.c, which calls i915_gem_object_put()
to put pde->pt.base again.

As pde->pt.base is protected by refcount, so the second put will not free
pde->pt.base actually. But, maybe it is better to remove the first put?

Fixes: 82adf901138cc ("drm/i915/gt: Shrink i915_page_directory's slab bucket")
Signed-off-by: Lv Yunlong <lyl2019@mail.ustc.edu.cn>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20210426124340.4238-1-lyl2019@mail.ustc.edu.cn
(cherry picked from commit ac69496fe65cca0611d5917b7d232730ff605bc7)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/i915/gt/gen8_ppgtt.c |    1 -
 1 file changed, 1 deletion(-)

--- a/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
+++ b/drivers/gpu/drm/i915/gt/gen8_ppgtt.c
@@ -631,7 +631,6 @@ static int gen8_preallocate_top_level_pd
 
 		err = pin_pt_dma(vm, pde->pt.base);
 		if (err) {
-			i915_gem_object_put(pde->pt.base);
 			free_pd(vm, pde);
 			return err;
 		}


