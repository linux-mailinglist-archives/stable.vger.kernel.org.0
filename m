Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B959E24D0D5
	for <lists+stable@lfdr.de>; Fri, 21 Aug 2020 10:50:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728182AbgHUIuc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 21 Aug 2020 04:50:32 -0400
Received: from mail.fireflyinternet.com ([77.68.26.236]:55731 "EHLO
        fireflyinternet.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727868AbgHUIu2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 21 Aug 2020 04:50:28 -0400
X-Default-Received-SPF: pass (skip=forwardok (res=PASS)) x-ip-name=78.156.65.138;
Received: from build.alporthouse.com (unverified [78.156.65.138]) 
        by fireflyinternet.com (Firefly Internet (M1)) with ESMTP id 22195098-1500050 
        for multiple; Fri, 21 Aug 2020 09:50:15 +0100
From:   Chris Wilson <chris@chris-wilson.co.uk>
To:     linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org
Cc:     linux-mm@kvack.org, Chris Wilson <chris@chris-wilson.co.uk>,
        Pavel Machek <pavel@ucw.cz>,
        Andrew Morton <akpm@linux-foundation.org>,
        Joerg Roedel <jroedel@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Dave Airlie <airlied@redhat.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>, stable@vger.kernel.org
Subject: [PATCH 2/4] drm/i915/gem: Sync the vmap PTEs upon construction
Date:   Fri, 21 Aug 2020 09:50:09 +0100
Message-Id: <20200821085011.28878-2-chris@chris-wilson.co.uk>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20200821085011.28878-1-chris@chris-wilson.co.uk>
References: <20200821085011.28878-1-chris@chris-wilson.co.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Since synchronising the PTE after assignment is a manual step, use the
newly exported interface to flush the PTE after assigning via
alloc_vm_area().

Reported-by: Pavel Machek <pavel@ucw.cz>
References: 2ba3e6947aed ("mm/vmalloc: track which page-table levels were modified")
Signed-off-by: Chris Wilson <chris@chris-wilson.co.uk>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Joerg Roedel <jroedel@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Dave Airlie <airlied@redhat.com>
Cc: Joonas Lahtinen <joonas.lahtinen@linux.intel.com>
Cc: Rodrigo Vivi <rodrigo.vivi@intel.com>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: <stable@vger.kernel.org> # v5.8+
---
 drivers/gpu/drm/i915/gem/i915_gem_pages.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/gpu/drm/i915/gem/i915_gem_pages.c b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
index 7050519c87a4..0fee67f34d74 100644
--- a/drivers/gpu/drm/i915/gem/i915_gem_pages.c
+++ b/drivers/gpu/drm/i915/gem/i915_gem_pages.c
@@ -304,6 +304,7 @@ static void *i915_gem_object_map(struct drm_i915_gem_object *obj,
 		for_each_sgt_daddr(addr, iter, sgt)
 			**ptes++ = iomap_pte(iomap, addr, pgprot);
 	}
+	flush_vm_area(area);
 
 	if (mem != stack)
 		kvfree(mem);
-- 
2.20.1

