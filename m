Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 376DD5FFDBB
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 09:08:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229594AbiJPHIV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 03:08:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229665AbiJPHIV (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 03:08:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12F6339105
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 00:08:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B2608B80B71
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 07:08:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C75CC433C1;
        Sun, 16 Oct 2022 07:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1665904097;
        bh=dRiJ1JMVekiudQ8LyxGk6Ufu4jn4Qy8SoPqly5l+Q+s=;
        h=Subject:To:Cc:From:Date:From;
        b=njum6m/FVFwqyWo95yYTT4qaGOVGjlnSRnT983kL229Kradrplqg0zeHb0db84M0k
         sI7BL68c5WR3r8wvHjVjgycH4zlw9sacbxMhrOheDsaIpRG+LSygWt2Grb0udgveIl
         xlfzs1G12VVE0/8NFnu0FnydRJXebceTGwwmKkSI=
Subject: FAILED: patch "[PATCH] io_uring/af_unix: defer registered files gc to io_uring" failed to apply to 5.15-stable tree
To:     asml.silence@gmail.com, axboe@kernel.dk, cascardo@canonical.com,
        dbouman03@gmail.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 16 Oct 2022 09:09:04 +0200
Message-ID: <166590414445199@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.15-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

Possible dependencies:

0091bfc81741 ("io_uring/af_unix: defer registered files gc to io_uring release")
735729844819 ("io_uring: move rsrc related data, core, and commands")
3b77495a9723 ("io_uring: split provided buffers handling into its own file")
7aaff708a768 ("io_uring: move cancelation into its own file")
329061d3e2f9 ("io_uring: move poll handling into its own file")
cfd22e6b3319 ("io_uring: add opcode name to io_op_defs")
92ac8beaea1f ("io_uring: include and forward-declaration sanitation")
c9f06aa7de15 ("io_uring: move io_uring_task (tctx) helpers into its own file")
a4ad4f748ea9 ("io_uring: move fdinfo helpers to its own file")
e5550a1447bf ("io_uring: use io_is_uring_fops() consistently")
17437f311490 ("io_uring: move SQPOLL related handling into its own file")
59915143e89f ("io_uring: move timeout opcodes and handling into its own file")
e418bbc97bff ("io_uring: move our reference counting into a header")
36404b09aa60 ("io_uring: move msg_ring into its own file")
f9ead18c1058 ("io_uring: split network related opcodes into its own file")
e0da14def1ee ("io_uring: move statx handling to its own file")
a9c210cebe13 ("io_uring: move epoll handler to its own file")
4cf90495281b ("io_uring: add a dummy -EOPNOTSUPP prep handler")
99f15d8d6136 ("io_uring: move uring_cmd handling to its own file")
cd40cae29ef8 ("io_uring: split out open/close operations")

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 0091bfc81741b8d3aeb3b7ab8636f911b2de6e80 Mon Sep 17 00:00:00 2001
From: Pavel Begunkov <asml.silence@gmail.com>
Date: Mon, 3 Oct 2022 13:59:47 +0100
Subject: [PATCH] io_uring/af_unix: defer registered files gc to io_uring
 release

Instead of putting io_uring's registered files in unix_gc() we want it
to be done by io_uring itself. The trick here is to consider io_uring
registered files for cycle detection but not actually putting them down.
Because io_uring can't register other ring instances, this will remove
all refs to the ring file triggering the ->release path and clean up
with io_ring_ctx_free().

Cc: stable@vger.kernel.org
Fixes: 6b06314c47e1 ("io_uring: add file set registration")
Reported-and-tested-by: David Bouman <dbouman03@gmail.com>
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Thadeu Lima de Souza Cascardo <cascardo@canonical.com>
[axboe: add kerneldoc comment to skb, fold in skb leak fix]
Signed-off-by: Jens Axboe <axboe@kernel.dk>

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 9fcf534f2d92..7be5bb4c94b6 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -803,6 +803,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@csum_level: indicates the number of consecutive checksums found in
  *		the packet minus one that have been verified as
  *		CHECKSUM_UNNECESSARY (max 3)
+ *	@scm_io_uring: SKB holds io_uring registered files
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@slow_gro: state present at GRO time, slower prepare step required
@@ -982,6 +983,7 @@ struct sk_buff {
 #endif
 	__u8			slow_gro:1;
 	__u8			csum_not_inet:1;
+	__u8			scm_io_uring:1;
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
diff --git a/io_uring/rsrc.c b/io_uring/rsrc.c
index 6f88ded0e7e5..012fdb04ec23 100644
--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -855,6 +855,7 @@ int __io_scm_file_account(struct io_ring_ctx *ctx, struct file *file)
 
 		UNIXCB(skb).fp = fpl;
 		skb->sk = sk;
+		skb->scm_io_uring = 1;
 		skb->destructor = unix_destruct_scm;
 		refcount_add(skb->truesize, &sk->sk_wmem_alloc);
 	}
diff --git a/net/unix/garbage.c b/net/unix/garbage.c
index d45d5366115a..dc2763540393 100644
--- a/net/unix/garbage.c
+++ b/net/unix/garbage.c
@@ -204,6 +204,7 @@ void wait_for_unix_gc(void)
 /* The external entry point: unix_gc() */
 void unix_gc(void)
 {
+	struct sk_buff *next_skb, *skb;
 	struct unix_sock *u;
 	struct unix_sock *next;
 	struct sk_buff_head hitlist;
@@ -297,11 +298,30 @@ void unix_gc(void)
 
 	spin_unlock(&unix_gc_lock);
 
+	/* We need io_uring to clean its registered files, ignore all io_uring
+	 * originated skbs. It's fine as io_uring doesn't keep references to
+	 * other io_uring instances and so killing all other files in the cycle
+	 * will put all io_uring references forcing it to go through normal
+	 * release.path eventually putting registered files.
+	 */
+	skb_queue_walk_safe(&hitlist, skb, next_skb) {
+		if (skb->scm_io_uring) {
+			__skb_unlink(skb, &hitlist);
+			skb_queue_tail(&skb->sk->sk_receive_queue, skb);
+		}
+	}
+
 	/* Here we are. Hitlist is filled. Die. */
 	__skb_queue_purge(&hitlist);
 
 	spin_lock(&unix_gc_lock);
 
+	/* There could be io_uring registered files, just push them back to
+	 * the inflight list
+	 */
+	list_for_each_entry_safe(u, next, &gc_candidates, link)
+		list_move_tail(&u->link, &gc_inflight_list);
+
 	/* All candidates should have been detached by now. */
 	BUG_ON(!list_empty(&gc_candidates));
 

