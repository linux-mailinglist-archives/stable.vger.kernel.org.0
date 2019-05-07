Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5F998159DE
	for <lists+stable@lfdr.de>; Tue,  7 May 2019 07:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729140AbfEGFki (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 May 2019 01:40:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:60086 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729136AbfEGFki (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 7 May 2019 01:40:38 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A5A4A20578;
        Tue,  7 May 2019 05:40:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1557207637;
        bh=pNoHONEm1X9opg3xl9NbGvRfo6Og1Tx2dproK5eTanU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eMYCK3wtrE7IvV0gQzSlZL/zBwGU4POxkmXUxvS/CdJf6YshP3/f0idjABTj0iA64
         Iz/DycLKqufCQCaVgTKDvSnX9BWVy/jhwjEioqkb1+LBobrBFintNYnINk+M7XzyNb
         aWViDuA0uxQNKoRQh+DsCTFWlt4vRo7VCCxisSgs=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Michal Hocko <mhocko@suse.com>,
        Robert Shteynfeld <robert.shteynfeld@gmail.com>,
        stable@kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <alexander.levin@microsoft.com>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 4.14 71/95] Revert "mm, memory_hotplug: initialize struct pages for the full memory section"
Date:   Tue,  7 May 2019 01:38:00 -0400
Message-Id: <20190507053826.31622-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190507053826.31622-1-sashal@kernel.org>
References: <20190507053826.31622-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Michal Hocko <mhocko@suse.com>

[ Upstream commit 4aa9fc2a435abe95a1e8d7f8c7b3d6356514b37a ]

This reverts commit 2830bf6f05fb3e05bc4743274b806c821807a684.

The underlying assumption that one sparse section belongs into a single
numa node doesn't hold really. Robert Shteynfeld has reported a boot
failure. The boot log was not captured but his memory layout is as
follows:

  Early memory node ranges
    node   1: [mem 0x0000000000001000-0x0000000000090fff]
    node   1: [mem 0x0000000000100000-0x00000000dbdf8fff]
    node   1: [mem 0x0000000100000000-0x0000001423ffffff]
    node   0: [mem 0x0000001424000000-0x0000002023ffffff]

This means that node0 starts in the middle of a memory section which is
also in node1.  memmap_init_zone tries to initialize padding of a
section even when it is outside of the given pfn range because there are
code paths (e.g.  memory hotplug) which assume that the full worth of
memory section is always initialized.

In this particular case, though, such a range is already intialized and
most likely already managed by the page allocator.  Scribbling over
those pages corrupts the internal state and likely blows up when any of
those pages gets used.

Reported-by: Robert Shteynfeld <robert.shteynfeld@gmail.com>
Fixes: 2830bf6f05fb ("mm, memory_hotplug: initialize struct pages for the full memory section")
Cc: stable@kernel.org
Signed-off-by: Michal Hocko <mhocko@suse.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <alexander.levin@microsoft.com>
---
 mm/page_alloc.c | 12 ------------
 1 file changed, 12 deletions(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 16c20d9e771f..923deb33bf34 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -5348,18 +5348,6 @@ void __meminit memmap_init_zone(unsigned long size, int nid, unsigned long zone,
 			__init_single_pfn(pfn, zone, nid);
 		}
 	}
-#ifdef CONFIG_SPARSEMEM
-	/*
-	 * If the zone does not span the rest of the section then
-	 * we should at least initialize those pages. Otherwise we
-	 * could blow up on a poisoned page in some paths which depend
-	 * on full sections being initialized (e.g. memory hotplug).
-	 */
-	while (end_pfn % PAGES_PER_SECTION) {
-		__init_single_page(pfn_to_page(end_pfn), end_pfn, zone, nid);
-		end_pfn++;
-	}
-#endif
 }
 
 static void __meminit zone_init_free_lists(struct zone *zone)
-- 
2.20.1

