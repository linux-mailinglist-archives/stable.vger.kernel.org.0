Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D36E96810BC
	for <lists+stable@lfdr.de>; Mon, 30 Jan 2023 15:06:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237049AbjA3OGP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 30 Jan 2023 09:06:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237081AbjA3OGL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 30 Jan 2023 09:06:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C8F71F5E6
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 06:06:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07399B80C9B
        for <stable@vger.kernel.org>; Mon, 30 Jan 2023 14:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EF74C433D2;
        Mon, 30 Jan 2023 14:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675087566;
        bh=WDeKM/8hT4upI98m8Tu4RR4xYnAVlAnBW3nPYgSqTO0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LntvXhBSJAaP+7MYNg2i5cZNt3my6a9PGjSawML5QAtKnm2Zk5M05UPtqA30xskBE
         u5PsAaprAcny2uT342oivtuEf3OzsU5HrQetKlJfZ5EnKlkupr3oQ9ndHdH20l8Swc
         4w3/bM6YY83HEzFAoXQipA7Y9Ztf2pF9Bs5dA138=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>,
        Andi Shyti <andi.shyti@linux.intel.com>,
        Nirmoy Das <nirmoy.das@intel.com>,
        Chuansheng Liu <chuansheng.liu@intel.com>,
        Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>,
        Tvrtko Ursulin <tvrtko.ursulin@intel.com>,
        Maxime Ripard <maxime@cerno.tech>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 251/313] drm/i915: Fix a memory leak with reused mmap_offset
Date:   Mon, 30 Jan 2023 14:51:26 +0100
Message-Id: <20230130134348.402494797@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134336.532886729@linuxfoundation.org>
References: <20230130134336.532886729@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nirmoy Das <nirmoy.das@intel.com>

[ Upstream commit 0220e4fe178c3390eb0291cdb34912d66972db8a ]

drm_vma_node_allow() and drm_vma_node_revoke() should be called in
balanced pairs. We call drm_vma_node_allow() once per-file everytime a
user calls mmap_offset, but only call drm_vma_node_revoke once per-file
on each mmap_offset. As the mmap_offset is reused by the client, the
per-file vm_count may remain non-zero and the rbtree leaked.

Call drm_vma_node_allow_once() instead to prevent that memory leak.

Cc: Tvrtko Ursulin <tvrtko.ursulin@linux.intel.com>
Cc: Andi Shyti <andi.shyti@linux.intel.com>

Signed-off-by: Nirmoy Das <nirmoy.das@intel.com>
Fixes: 786555987207 ("drm/i915/gem: Store mmap_offsets in an rbtree rather than a plain list")
Reported-by: Chuansheng Liu <chuansheng.liu@intel.com>
Reported-by: Mirsad Todorovac <mirsad.todorovac@alu.unizg.hr>
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Reviewed-by: Andi Shyti <andi.shyti@linux.intel.com>
Link: https://lore.kernel.org/r/20230117175236.22317-2-nirmoy.das@intel.com
Signed-off-by: Maxime Ripard <maxime@cerno.tech>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_mman.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_mman.c b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
index 354c1d6dab84..d445e2d63c9c 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_mman.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_mman.c
@@ -697,7 +697,7 @@ mmap_offset_attach(struct drm_i915_gem_object *obj,
 	GEM_BUG_ON(lookup_mmo(obj, mmap_type) != mmo);
 out:
 	if (file)
-		drm_vma_node_allow(&mmo->vma_node, file);
+		drm_vma_node_allow_once(&mmo->vma_node, file);
 	return mmo;
 
 err:
-- 
2.39.0



