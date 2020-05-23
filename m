Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9F9E21DF4F9
	for <lists+stable@lfdr.de>; Sat, 23 May 2020 07:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387612AbgEWFXN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 23 May 2020 01:23:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:55716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387610AbgEWFXN (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 23 May 2020 01:23:13 -0400
Received: from localhost.localdomain (c-73-231-172-41.hsd1.ca.comcast.net [73.231.172.41])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8DB620814;
        Sat, 23 May 2020 05:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590211393;
        bh=2GgUabfP0TjV77fo/j+G1COH8CJdyHQfA5O/s6j40hw=;
        h=Date:From:To:Subject:In-Reply-To:From;
        b=ehhDgjkf/utTOZ0V9ynmjcSsbgo0wPxm0ILqJpOwhtnuT7H2LdKVOYv8CgkqzzWRB
         8HCdHb4DDLqshDvYxE2Hgqa/QfT1/PEC4qSIBBQFnpIFO5hxtkq+aPyzH3cfj6vRaW
         WpPcgG/MBWPFzK2PZzdpDfYpu/lTS+yA9eJVxv6o=
Date:   Fri, 22 May 2020 22:23:12 -0700
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, cai@lca.pw, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, shentino@gmail.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org,
        uladzislau.rezki@sony.com, vitaly.wool@konsulko.com
Subject:  [patch 10/11] z3fold: fix use-after-free when freeing
 handles
Message-ID: <20200523052312.8XR1NwGDV%akpm@linux-foundation.org>
In-Reply-To: <20200522222217.ee14ad7eda7aab1e6697da6c@linux-foundation.org>
User-Agent: s-nail v14.8.16
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uladzislau Rezki <uladzislau.rezki@sony.com>
Subject: z3fold: fix use-after-free when freeing handles

free_handle() for a foreign handle may race with inter-page compaction,
what can lead to memory corruption.  To avoid that, take write lock not
read lock in free_handle to be synchronized with __release_z3fold_page().

For example KASAN can detect it:

[   33.723357] ==================================================================
[   33.723401] BUG: KASAN: use-after-free in LZ4_decompress_safe+0x2c4/0x3b8
[   33.723418] Read of size 1 at addr ffffffc976695ca3 by task GoogleApiHandle/4121
[   33.723428]
[   33.723449] CPU: 0 PID: 4121 Comm: GoogleApiHandle Tainted: P S         OE     4.19.81-perf+ #162
[   33.723461] Hardware name: Sony Mobile Communications. PDX-203(KONA) (DT)
[   33.723473] Call trace:
[   33.723495] dump_backtrace+0x0/0x288
[   33.723512] show_stack+0x14/0x20
[   33.723533] dump_stack+0xe4/0x124
[   33.723551] print_address_description+0x80/0x2e0
[   33.723566] kasan_report+0x268/0x2d0
[   33.723584] __asan_load1+0x4c/0x58
[   33.723601] LZ4_decompress_safe+0x2c4/0x3b8
[   33.723619] lz4_decompress_crypto+0x3c/0x70
[   33.723636] crypto_decompress+0x58/0x70
[   33.723656] zcomp_decompress+0xd4/0x120
...

Apart from that, initialize zhdr->mapped_count in init_z3fold_page() and
remove "newpage" variable because it is not used anywhere.

Link: http://lkml.kernel.org/r/20200520082100.28876-1-vitaly.wool@konsulko.com
Signed-off-by: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.com>
Cc: Qian Cai <cai@lca.pw>
Cc: Raymond Jennings <shentino@gmail.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/z3fold.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/z3fold.c~z3fold-fix-use-after-free-when-freeing-handles
+++ a/mm/z3fold.c
@@ -318,16 +318,16 @@ static inline void free_handle(unsigned
 	slots = handle_to_slots(handle);
 	write_lock(&slots->lock);
 	*(unsigned long *)handle = 0;
-	write_unlock(&slots->lock);
-	if (zhdr->slots == slots)
+	if (zhdr->slots == slots) {
+		write_unlock(&slots->lock);
 		return; /* simple case, nothing else to do */
+	}
 
 	/* we are freeing a foreign handle if we are here */
 	zhdr->foreign_handles--;
 	is_free = true;
-	read_lock(&slots->lock);
 	if (!test_bit(HANDLES_ORPHANED, &slots->pool)) {
-		read_unlock(&slots->lock);
+		write_unlock(&slots->lock);
 		return;
 	}
 	for (i = 0; i <= BUDDY_MASK; i++) {
@@ -336,7 +336,7 @@ static inline void free_handle(unsigned
 			break;
 		}
 	}
-	read_unlock(&slots->lock);
+	write_unlock(&slots->lock);
 
 	if (is_free) {
 		struct z3fold_pool *pool = slots_to_pool(slots);
@@ -422,6 +422,7 @@ static struct z3fold_header *init_z3fold
 	zhdr->start_middle = 0;
 	zhdr->cpu = -1;
 	zhdr->foreign_handles = 0;
+	zhdr->mapped_count = 0;
 	zhdr->slots = slots;
 	zhdr->pool = pool;
 	INIT_LIST_HEAD(&zhdr->buddy);
_
