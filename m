Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4AC03CFFC4
	for <lists+stable@lfdr.de>; Tue,  8 Oct 2019 19:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726322AbfJHRZS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Oct 2019 13:25:18 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:46849 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725900AbfJHRZS (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Oct 2019 13:25:18 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 09CE021F57;
        Tue,  8 Oct 2019 13:25:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 08 Oct 2019 13:25:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:message-id:mime-version:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=J0MReE
        PqjDHMgD1oSjzvjB0IY09Pl8/yLTPp7loH+zc=; b=Bjhfu1h9dPwyCMm3TPK1ww
        yUOwwP+HX9pu1WFt5DbU3ZnYQMR//3nws6XhdKvcUASrsoEbj3VC+JgjhuR9IHan
        oGcpoXEM1DxvcdaI7fcXtF0dTY382upf4JqY/+QUfkot8Jr4/dPiSNzTryG/Ux5y
        FU6/GerIWY8QgE8CxKgeU4PQr6To5fX+fTbaW+oNZmltuAP4IRrULMLjvFTnd8Vp
        teaMlvJVzcmshDQljbcwJlo7mNXaJ6zjp5++G3mVDZn1ArQ2imPDGys9z/S0Mdav
        6slju3lnPvWAfsRZ4fE2p1uuH83yxyKgc7x72XMTx7Fp9IlOrCpCaGzK9XxBwhSA
        ==
X-ME-Sender: <xms:fcacXU_PEeTEkeFIXkNHzglFGmFf1jmtBnDkbWvoM_bglDbhmYekYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedufedrheelgdduudehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefuvffhfffkgggtgfesthekredttd
    dtlfenucfhrhhomhepoehgrhgvghhkhheslhhinhhugihfohhunhgurghtihhonhdrohhr
    gheqnecuffhomhgrihhnpehfrhgvvgguvghskhhtohhprdhorhhgpdhkvghrnhgvlhdroh
    hrghenucfkphepkeefrdekiedrkeelrddutdejnecurfgrrhgrmhepmhgrihhlfhhrohhm
    pehgrhgvgheskhhrohgrhhdrtghomhenucevlhhushhtvghrufhiiigvpedu
X-ME-Proxy: <xmx:fcacXYYV91XSWDt4QFRpk2wMzAwLvucpnGZYHVtbaEku_RatbB0ofw>
    <xmx:fcacXQ6GhG-vhT06F0Bau1Q228WgQhV553w_D5tbnVE7gOltWKKk1Q>
    <xmx:fcacXZRospJmG_fS0s6_ZPD3R8_nZR2odwfbmpCJFkdRe2S6z8WheQ>
    <xmx:fsacXYcdAuS7xczoBzzV6Huwvq0NWoNskxVJEymyBfrnGwSNn9PSgg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9DC4CD6005D;
        Tue,  8 Oct 2019 13:25:17 -0400 (EDT)
Subject: FAILED: patch "[PATCH] drm/i915/userptr: Acquire the page lock around" failed to apply to 4.9-stable tree
To:     chris@chris-wilson.co.uk, tvrtko.ursulin@intel.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Tue, 08 Oct 2019 19:25:05 +0200
Message-ID: <1570555505226224@kroah.com>
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

