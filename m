Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F49F56FD5D
	for <lists+stable@lfdr.de>; Mon, 11 Jul 2022 11:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbiGKJye (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Jul 2022 05:54:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233943AbiGKJx5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Jul 2022 05:53:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4294AEF53;
        Mon, 11 Jul 2022 02:25:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9487D6136F;
        Mon, 11 Jul 2022 09:25:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6C1C36AED;
        Mon, 11 Jul 2022 09:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657531541;
        bh=nY92Q6t9HQ1EGT2GXplwzbOzFAiJHfULIB3VSs63zjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wgko3kNsBIzDMdOsWkE0CyVbcojpPg6XqkMicw5x20s1dVk9X0lk0HXhILEHYJY2P
         p4DL36uH8ZvW2d5XAd1TYIM52MpvHXd/gJxf5c6j6sXdA9XhRqEiKzdyK8jq1ZFWPH
         KdxOZ3lbO7su0vO1T4OmlONJXfGTKagbqcTxjK1Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Thomas=20Hellstr=C3=B6m?= 
        <thomas.hellstrom@linux.intel.com>,
        Maarten Lankhorst <maarten.lankhorst@linux.intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 143/230] drm/i915: Fix a race between vma / object destruction and unbinding
Date:   Mon, 11 Jul 2022 11:06:39 +0200
Message-Id: <20220711090608.119577076@linuxfoundation.org>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <20220711090604.055883544@linuxfoundation.org>
References: <20220711090604.055883544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Hellström <thomas.hellstrom@linux.intel.com>

[ Upstream commit bc1922e5d349db4be14c55513102c024c2ae8a50 ]

The vma destruction code was using an unlocked advisory check for
drm_mm_node_allocated() to avoid racing with eviction code unbinding
the vma.

This is very fragile and prohibits the dereference of non-refcounted
pointers of dying vmas after a call to __i915_vma_unbind(). It also
prohibits the dereference of vma->obj of refcounted pointers of
dying vmas after a call to __i915_vma_unbind(), since even if a
refcount is held on the vma, that won't guarantee that its backing
object doesn't get destroyed.

So introduce an unbind under the vm mutex at object destroy time,
removing all weak references of the vma and its object from the
object vma list and from the vm bound list.

Signed-off-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Maarten Lankhorst <maarten.lankhorst@linux.intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20220127115622.302970-1-thomas.hellstrom@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/i915/gem/i915_gem_object.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_object.c b/drivers/gpu/drm/i915/gem/i915_gem_object.c
index 6fb9afb65034..5f48d5ea5c15 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_object.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_object.c
@@ -224,6 +224,12 @@ void __i915_gem_free_object(struct drm_i915_gem_object *obj)
 			GEM_BUG_ON(vma->obj != obj);
 			spin_unlock(&obj->vma.lock);
 
+			/* Verify that the vma is unbound under the vm mutex. */
+			mutex_lock(&vma->vm->mutex);
+			atomic_and(~I915_VMA_PIN_MASK, &vma->flags);
+			__i915_vma_unbind(vma);
+			mutex_unlock(&vma->vm->mutex);
+
 			__i915_vma_put(vma);
 
 			spin_lock(&obj->vma.lock);
-- 
2.35.1



