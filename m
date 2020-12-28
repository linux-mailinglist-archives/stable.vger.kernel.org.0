Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A29BD2E3DE2
	for <lists+stable@lfdr.de>; Mon, 28 Dec 2020 15:22:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437851AbgL1OVY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Dec 2020 09:21:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:56442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2502207AbgL1OVC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 28 Dec 2020 09:21:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9C59E20791;
        Mon, 28 Dec 2020 14:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1609165216;
        bh=mPmKAdohop4jaoZA/YxlgERgOmGMVxNu2YzXJicrU9U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MKJaFvAiZCpjO/22ru63iHm3attIV4/wb6zZ8C0HLVzIJnYUqMBOH21zoIglKQJKV
         X3MCa85klVNkj+1ef+cyYmvu5PkmGtwpkYbQqt+byO7R3yiwq1+ipPlZNMx0vdnYtZ
         fS61OmjnT3LhrM5WTtMbYLPHsiuN3wd5tFq6nSfo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vincenzo Frascino <vincenzo.frascino@arm.com>,
        Andrey Konovalov <andreyknvl@google.com>,
        Dmitry Vyukov <dvyukov@google.com>,
        Andrey Ryabinin <aryabinin@virtuozzo.com>,
        Alexander Potapenko <glider@google.com>,
        Marco Elver <elver@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 454/717] mm/vmalloc.c: fix kasan shadow poisoning size
Date:   Mon, 28 Dec 2020 13:47:32 +0100
Message-Id: <20201228125042.721318825@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201228125020.963311703@linuxfoundation.org>
References: <20201228125020.963311703@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vincenzo Frascino <vincenzo.frascino@arm.com>

[ Upstream commit c041098c690fe53cea5d20c62f128a4f7a5c19fe ]

The size of vm area can be affected by the presence or not of the guard
page.  In particular when VM_NO_GUARD is present, the actual accessible
size has to be considered like the real size minus the guard page.

Currently kasan does not keep into account this information during the
poison operation and in particular tries to poison the guard page as well.

This approach, even if incorrect, does not cause an issue because the tags
for the guard page are written in the shadow memory.  With the future
introduction of the Tag-Based KASAN, being the guard page inaccessible by
nature, the write tag operation on this page triggers a fault.

Fix kasan shadow poisoning size invoking get_vm_area_size() instead of
accessing directly the field in the data structure to detect the correct
value.

Link: https://lkml.kernel.org/r/20201027160213.32904-1-vincenzo.frascino@arm.com
Fixes: d98c9e83b5e7c ("kasan: fix crashes on access to memory mapped by vm_map_ram()")
Signed-off-by: Vincenzo Frascino <vincenzo.frascino@arm.com>
Cc: Andrey Konovalov <andreyknvl@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Andrey Ryabinin <aryabinin@virtuozzo.com>
Cc: Alexander Potapenko <glider@google.com>
Cc: Marco Elver <elver@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/vmalloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmalloc.c b/mm/vmalloc.c
index 75913f685c71e..279dc0c96568c 100644
--- a/mm/vmalloc.c
+++ b/mm/vmalloc.c
@@ -2256,7 +2256,7 @@ static void __vunmap(const void *addr, int deallocate_pages)
 	debug_check_no_locks_freed(area->addr, get_vm_area_size(area));
 	debug_check_no_obj_freed(area->addr, get_vm_area_size(area));
 
-	kasan_poison_vmalloc(area->addr, area->size);
+	kasan_poison_vmalloc(area->addr, get_vm_area_size(area));
 
 	vm_remove_mappings(area, deallocate_pages);
 
-- 
2.27.0



