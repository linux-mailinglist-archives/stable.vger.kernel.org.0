Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5906D1E2CA7
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 21:16:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404608AbgEZTQA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 15:16:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48066 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2404599AbgEZTP7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 15:15:59 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 777BF2053B;
        Tue, 26 May 2020 19:15:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590520559;
        bh=H808ll5pOciU4ZgyBdWkuOSBa/nNmFeGOtSNwFG9MiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A6sl0p3RM5uidaK1/cXUy6q6WSBAp7d/So7InFN0Z49cCYFwKHG6tXLc9VvYqzGm8
         mSDxG0zXG2aE1c5c8JB8e+lYoc+191inEEpf7alnq06FHTtJkYPxduIuo0Qz4l7gPp
         2Av75tyYFlLUbxO47JKq1g2/YKDHnw5szEbkYysg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Uladzislau Rezki <uladzislau.rezki@sony.com>,
        Vitaly Wool <vitaly.wool@konsulko.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Qian Cai <cai@lca.pw>, Raymond Jennings <shentino@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.6 113/126] z3fold: fix use-after-free when freeing handles
Date:   Tue, 26 May 2020 20:54:10 +0200
Message-Id: <20200526183947.013870148@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200526183937.471379031@linuxfoundation.org>
References: <20200526183937.471379031@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Uladzislau Rezki <uladzislau.rezki@sony.com>

commit d8f117abb380ba968b5e3ef2042d901c02872a4c upstream.

free_handle() for a foreign handle may race with inter-page compaction,
what can lead to memory corruption.

To avoid that, take write lock not read lock in free_handle to be
synchronized with __release_z3fold_page().

For example KASAN can detect it:

  ==================================================================
  BUG: KASAN: use-after-free in LZ4_decompress_safe+0x2c4/0x3b8
  Read of size 1 at addr ffffffc976695ca3 by task GoogleApiHandle/4121

  CPU: 0 PID: 4121 Comm: GoogleApiHandle Tainted: P S         OE     4.19.81-perf+ #162
  Hardware name: Sony Mobile Communications. PDX-203(KONA) (DT)
  Call trace:
     LZ4_decompress_safe+0x2c4/0x3b8
     lz4_decompress_crypto+0x3c/0x70
     crypto_decompress+0x58/0x70
     zcomp_decompress+0xd4/0x120
     ...

Apart from that, initialize zhdr->mapped_count in init_z3fold_page() and
remove "newpage" variable because it is not used anywhere.

Signed-off-by: Uladzislau Rezki <uladzislau.rezki@sony.com>
Signed-off-by: Vitaly Wool <vitaly.wool@konsulko.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Qian Cai <cai@lca.pw>
Cc: Raymond Jennings <shentino@gmail.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/20200520082100.28876-1-vitaly.wool@konsulko.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/z3fold.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/mm/z3fold.c
+++ b/mm/z3fold.c
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


