Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 501622ABAFA
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:27:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732744AbgKINQy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:16:54 -0500
Received: from mail.kernel.org ([198.145.29.99]:43946 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387529AbgKINQt (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 08:16:49 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD5A520731;
        Mon,  9 Nov 2020 13:16:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604927809;
        bh=J5rFsEtFjx3tmHpPydneHua0DscrVW3wkBWKH8pwJ+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aeHjlU27M72Op9x8NBGVkef2B0bQme6TB0TtN8MRkzYam3irBVOF5ulkpqJPJxscG
         KXWBK9bbNV0SVUi5JJMabjM8ozXJ6GWV5kAF3k0+sq/GtphCs0Rfiv3/m1Jtt8mAd1
         eW4woJxarH9nsMkAG1JfD0lXTbE8NU+MHzABy8Q8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Matthew Auld <matthew.auld@intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>
Subject: [PATCH 5.9 003/133] drm/i915/gem: Avoid implicit vmap for highmem on x86-32
Date:   Mon,  9 Nov 2020 13:54:25 +0100
Message-Id: <20201109125030.883776719@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125030.706496283@linuxfoundation.org>
References: <20201109125030.706496283@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chris Wilson <chris@chris-wilson.co.uk>

commit 4caf017ee93703ba1c4504f3d73b50e6bbd4249e upstream.

On 32b, highmem using a finite set of indirect PTE (i.e. vmap) to provide
virtual mappings of the high pages.  As these are finite, map_new_virtual()
must wait for some other kmap() to finish when it runs out. If we map a
large number of objects, there is no method for it to tell us to release
the mappings, and we deadlock.

However, if we make an explicit vmap of the page, that uses a larger
vmalloc arena, and also has the ability to tell us to release unwanted
mappings. Most importantly, it will fail and propagate an error instead
of waiting forever.

Fixes: fb8621d3bee8 ("drm/i915: Avoid allocating a vmap arena for a single page") #x86-32
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Reviewed-by: Matthew Auld <matthew.auld@intel.com>
Cc: <stable@vger.kernel.org> # v4.7+
Link: https://patchwork.freedesktop.org/patch/msgid/20200915091417.4086-1-chris@chris-wilson.co.uk
(cherry picked from commit 060bb115c2d664f04db9c7613a104dfaef3fdd98)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c |   26 ++++++++++++++++++++++++--
 1 file changed, 24 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -255,8 +255,30 @@ static void *i915_gem_object_map(struct
 		return NULL;
 
 	/* A single page can always be kmapped */
-	if (n_pte == 1 && type == I915_MAP_WB)
-		return kmap(sg_page(sgt->sgl));
+	if (n_pte == 1 && type == I915_MAP_WB) {
+		struct page *page = sg_page(sgt->sgl);
+
+		/*
+		 * On 32b, highmem using a finite set of indirect PTE (i.e.
+		 * vmap) to provide virtual mappings of the high pages.
+		 * As these are finite, map_new_virtual() must wait for some
+		 * other kmap() to finish when it runs out. If we map a large
+		 * number of objects, there is no method for it to tell us
+		 * to release the mappings, and we deadlock.
+		 *
+		 * However, if we make an explicit vmap of the page, that
+		 * uses a larger vmalloc arena, and also has the ability
+		 * to tell us to release unwanted mappings. Most importantly,
+		 * it will fail and propagate an error instead of waiting
+		 * forever.
+		 *
+		 * So if the page is beyond the 32b boundary, make an explicit
+		 * vmap. On 64b, this check will be optimised away as we can
+		 * directly kmap any page on the system.
+		 */
+		if (!PageHighMem(page))
+			return kmap(page);
+	}
 
 	mem = stack;
 	if (n_pte > ARRAY_SIZE(stack)) {


