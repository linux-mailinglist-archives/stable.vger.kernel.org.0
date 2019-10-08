Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9CA9BCFFC3
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726320AbfJHRZR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:25:17 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:47767 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbfJHRZR (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:25:17 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 759C221F2E;
        Tue,  8 Oct 2019 13:25:16 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:25:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=NS6Jdr
        TLJZOuCHqyU5yUWbQ/hMX6sFcG5JNoXphop0g=; b=CI1pv+QBIM3WLJ7vm3050f
        Q4HRJtYh00PhgalEnIer0T+/G7XUluRTl1QZ3te2EMbrEkkAHf0JCJ0etwLoJQPc
        5cfVhMATTgMMIOmCqGY5Z+fiM79XobBk+ao3ekwWMe8MztlF/gCva8oFZmMelv7b
        EqIT3DeCsBxMpjeDJ/fCtJ2e03kJFi806Kw5oGGQ4UHOZC4QBcrjJuf9ggcM0erK
        8EzoPw/Qjt2ZHYrKdE2Egqu8SVzslNFG9MATshzH2HFF2COUj+DmAUi9TXeq4Z6F
        MM5QUcf882I2VClLgrNhcpbCfv2JnenCfS1yHhwcsRyLSaHbqKKNXTFAiRSdE4QA
        ==
X-ME-Sender: <xms:fMacXcqmGkSkMZwt5udKBukPQ-xx0QoRSB0dF_oQK84yEjRTzpzJ_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgpdhkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:fMacXZGhNOkd1fMWMHAq5VI7ZMSVgL6KWsvP02nPP_tTfUpcbxgD3Q>
    <xmx:fMacXevESw5zWFOtlpgxWzZR6NPBnPI3ZpzGeX6YgwuKIsy-ECW1XA>
    <xmx:fMacXcQHjPpCAjKbmiSLYqjpuFdfbl5E1LXTKphLCbe30mk6-3Dl6Q>
    <xmx:fMacXS9hHSeaQJ-gR6Umb5V7VAfc9e4Hve9X6lmF92q5U-dWnNorvg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 17A82D6005D;
        Tue,  8 Oct 2019 13:25:15 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/userptr: Acquire the page lock around" failed to apply to 4.4-stable tree
To:     chris@chris-wilson.co.uk, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:25:05 +0200
Message-ID: <15705555054241@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 4.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From cb6d7c7dc7ff8cace666ddec66334117a6068ce2 Mon Sep 17 00:00:00 2001
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

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
index 16ccec7fb7da..32d208ede343 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_userptr.c
@@ -665,7 +665,15 @@ i915_gem_userptr_put_pages(struct drm_i915_gem_object *obj,
 
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

