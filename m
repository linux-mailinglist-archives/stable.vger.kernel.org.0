Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 90B99811D7
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 07:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727297AbfHEF6A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 01:58:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:35105 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725951AbfHEF6A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 01:58:00 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 97738214DB;
        Mon,  5 Aug 2019 01:57:59 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 01:57:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=7q3GaE
        hSktfNqXmL6u5lLoASFDOKfQ9KEMhPRlZwXxw=; b=z2Td+pCC301qVwHhUE9kva
        SfJPn6X+FunRDm0m9uQYsfKysJT7jo1wExDOCOh40vVRSnb6LNkniyHbQO/6icEB
        e7YnGehZJ3eM9w4oEkF3uSe1UV3dPSFRPKoz7qJAqt1D2C+u1Ix0F4tglI7JgdEj
        IwemxvV3aGKsGyAxYiBrZWm5jiSVzER+TRxTnb4s1SmanygvEdFbJnb8UcLQprbe
        TnBgguSa3UQevynpDnC9z+CBDmYEGses+jk+l+5egLW8aXZHWINS+ERheHupMPsQ
        KkrmP+YF7JZUf3eeT+glzY1IhKcmeq0+NIngzTYXeCgOuZDyMVDDY2gOAhKY0Q7A
        ==
X-ME-Sender: <xms:Z8VHXb4gn0baULvR11fwLR6SZEWq6jnEnKCDnfwq3_vbLvWx0HYMbA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtiedgledtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgpdhkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:Z8VHXWrtny_ewUnz7urPW8pCptcftXqn9FwMqqrVrINHSHra7Shoyg>
    <xmx:Z8VHXQihIJzRmfdgeia_wcgECTQMBwMqhPx6YVsl5XLrbBa5Jozd_g>
    <xmx:Z8VHXWunBTdNri6bUX0TveRybUzOe5hGyZI0m1ZyP8AKjnz9XX-mjg>
    <xmx:Z8VHXdziP2KehlI5rIaCjuqC-VQPFlt4oIAGkGeAwbXuwFX4wgflww>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 1749B380074;
        Mon,  5 Aug 2019 01:57:58 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/userptr: Acquire the page lock around" failed to apply to 4.9-stable tree
To:     chris@chris-wilson.co.uk, jani.nikula@intel.com,
        tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Mon, 05 Aug 2019 07:57:56 +0200
Message-ID: <1564984676244180@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.9-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From aa56a292ce623734ddd30f52d73f527d1f3529b5 Mon Sep 17 00:00:00 2001
From: Chris Wilson <chris@chris-wilson.co.uk>
Date: Mon, 8 Jul 2019 15:03:27 +0100
Subject: [PATCH] drm/i915/userptr: Acquire the page lock around
 set_page_dirty()

set_page_dirty says:

	For pages with a mapping this should be done under the page lock
	for the benefit of asynchronous memory errors who prefer a
	consistent dirty state. This rule can be broken in some special
	cases, but should be better not to.

Under those rules, it is only safe for us to use the plain set_page_dirty
calls for shmemfs/anonymous memory. Userptr may be used with real
mappings and so needs to use the locked version (set_page_dirty_lock).

Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=203317
Fixes: 5cc9ed4b9a7a ("drm/i915: Introduce mapping of user pages into video memory (userptr) ioctl")
References: 6dcc693bc57f ("ext4: warn when page is dirtied without buffers")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Cc: stable@vger.kernel.org
Reviewed-by: Tvrtko Ursulin <tvrtko.ursulin@intel.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20190708140327.26825-1-chris@chris-wilson.co.uk
(cherry picked from commit cb6d7c7dc7ff8cace666ddec66334117a6068ce2)
Signed-off-by: Jani Nikula <jani.nikula@intel.com>

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index 528b61678334..2caa594322bc 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -664,7 +664,15 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 
 	for_each_sgt_page(page, sgt_iter, pages) {
 		if (obj->mm.dirty)
-			set_page_dirty(page);
+			/*
+			 * As this may not be anonymous memory (e.g. shmem)
+			 * but exist on a real mapping, we have to lock
+			 * the page in order to dirty it -- holding
+			 * the page reference is not sufficient to
+			 * prevent the inode from being truncated.
+			 * Play safe and take the lock.
+			 */
+			set_page_dirty_lock(page);
 
 		mark_page_accessed(page);
 		put_page(page);

