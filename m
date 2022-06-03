Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C153253CFC4
	for <lists+stable@lfdr.de>; Fri,  3 Jun 2022 19:56:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345716AbiFCR4E (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Jun 2022 13:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345508AbiFCRxw (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Jun 2022 13:53:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 465BC26121;
        Fri,  3 Jun 2022 10:52:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3140B60F3B;
        Fri,  3 Jun 2022 17:52:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2719DC385B8;
        Fri,  3 Jun 2022 17:52:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654278753;
        bh=r07Ht/o8tyr7rzBej9Sx5OpKHymm6LYC2S7Uzqujyko=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dOZaKE79cGjmNVA5CCzGx15xa+kNjsdUbm7wrQhuqpcSPyKm5A2mTocBiwZFVtimR
         wD3BJcYE99eQQR+dIMPqtpFqLx5j3NBmyDCxnp8yG9kUDkaUM/Rj45/OybzwBxVUP6
         aWZrGO/MU0KqOJtsc4qQGwcHJgOzLSzk9Si/zzYs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, David Howells <dhowells@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        zdi-disclosures@trendmicro.com
Subject: [PATCH 5.17 16/75] pipe: Fix missing lock in pipe_resize_ring()
Date:   Fri,  3 Jun 2022 19:43:00 +0200
Message-Id: <20220603173822.209807762@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220603173821.749019262@linuxfoundation.org>
References: <20220603173821.749019262@linuxfoundation.org>
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

From: David Howells <dhowells@redhat.com>

commit 189b0ddc245139af81198d1a3637cac74f96e13a upstream.

pipe_resize_ring() needs to take the pipe->rd_wait.lock spinlock to
prevent post_one_notification() from trying to insert into the ring
whilst the ring is being replaced.

The occupancy check must be done after the lock is taken, and the lock
must be taken after the new ring is allocated.

The bug can lead to an oops looking something like:

 BUG: KASAN: use-after-free in post_one_notification.isra.0+0x62e/0x840
 Read of size 4 at addr ffff88801cc72a70 by task poc/27196
 ...
 Call Trace:
  post_one_notification.isra.0+0x62e/0x840
  __post_watch_notification+0x3b7/0x650
  key_create_or_update+0xb8b/0xd20
  __do_sys_add_key+0x175/0x340
  __x64_sys_add_key+0xbe/0x140
  do_syscall_64+0x5c/0xc0
  entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported by Selim Enes Karaduman @Enesdex working with Trend Micro Zero
Day Initiative.

Fixes: c73be61cede5 ("pipe: Add general notification queue support")
Reported-by: zdi-disclosures@trendmicro.com # ZDI-CAN-17291
Signed-off-by: David Howells <dhowells@redhat.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/pipe.c |   31 ++++++++++++++++++-------------
 1 file changed, 18 insertions(+), 13 deletions(-)

--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -1245,30 +1245,33 @@ unsigned int round_pipe_size(unsigned lo
 
 /*
  * Resize the pipe ring to a number of slots.
+ *
+ * Note the pipe can be reduced in capacity, but only if the current
+ * occupancy doesn't exceed nr_slots; if it does, EBUSY will be
+ * returned instead.
  */
 int pipe_resize_ring(struct pipe_inode_info *pipe, unsigned int nr_slots)
 {
 	struct pipe_buffer *bufs;
 	unsigned int head, tail, mask, n;
 
-	/*
-	 * We can shrink the pipe, if arg is greater than the ring occupancy.
-	 * Since we don't expect a lot of shrink+grow operations, just free and
-	 * allocate again like we would do for growing.  If the pipe currently
-	 * contains more buffers than arg, then return busy.
-	 */
-	mask = pipe->ring_size - 1;
-	head = pipe->head;
-	tail = pipe->tail;
-	n = pipe_occupancy(pipe->head, pipe->tail);
-	if (nr_slots < n)
-		return -EBUSY;
-
 	bufs = kcalloc(nr_slots, sizeof(*bufs),
 		       GFP_KERNEL_ACCOUNT | __GFP_NOWARN);
 	if (unlikely(!bufs))
 		return -ENOMEM;
 
+	spin_lock_irq(&pipe->rd_wait.lock);
+	mask = pipe->ring_size - 1;
+	head = pipe->head;
+	tail = pipe->tail;
+
+	n = pipe_occupancy(head, tail);
+	if (nr_slots < n) {
+		spin_unlock_irq(&pipe->rd_wait.lock);
+		kfree(bufs);
+		return -EBUSY;
+	}
+
 	/*
 	 * The pipe array wraps around, so just start the new one at zero
 	 * and adjust the indices.
@@ -1300,6 +1303,8 @@ int pipe_resize_ring(struct pipe_inode_i
 	pipe->tail = tail;
 	pipe->head = head;
 
+	spin_unlock_irq(&pipe->rd_wait.lock);
+
 	/* This might have made more room for writers */
 	wake_up_interruptible(&pipe->wr_wait);
 	return 0;


