Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1D160ACFE
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 16:17:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234520AbiJXORN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 10:17:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237039AbiJXOPj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 10:15:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF8AD786C6;
        Mon, 24 Oct 2022 05:55:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9EF0E61299;
        Mon, 24 Oct 2022 12:55:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1FF4C433D6;
        Mon, 24 Oct 2022 12:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666616125;
        bh=vZxHQEYkwUYEww/BYu+LZN0VT8kKqZphbhq2OTlMmi0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FWzaSTGhtPbxbCckhw63P0k4Aks7Ko+bzLPaWzbk+w4pV2fOiIp2E9I0YA5aHGMfm
         d2wGeadeFhcIQtv75wJRmCvCz8qE5boXuOA04A4oSbANHvNBQMCPlWn0UMZ45igXwk
         oriWRyxG4z68cYmQVfTsZTgRtLrMCWSGIJ7hxKEo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Jens Axboe <axboe@kernel.dk>,
        David Bouman <dbouman03@gmail.com>
Subject: [PATCH 5.15 511/530] io_uring/af_unix: defer registered files gc to io_uring release
Date:   Mon, 24 Oct 2022 13:34:15 +0200
Message-Id: <20221024113108.166182541@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113044.976326639@linuxfoundation.org>
References: <20221024113044.976326639@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pavel Begunkov <asml.silence@gmail.com>

[ upstream commit 0091bfc81741b8d3aeb3b7ab8636f911b2de6e80 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/io_uring.c          |    1 +
 include/linux/skbuff.h |    2 ++
 net/unix/garbage.c     |   20 ++++++++++++++++++++
 3 files changed, 23 insertions(+)

--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8066,6 +8066,7 @@ static int __io_sqe_files_scm(struct io_
 	}
 
 	skb->sk = sk;
+	skb->scm_io_uring = 1;
 
 	nr_files = 0;
 	fpl->user = get_uid(current_user());
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -725,6 +725,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@csum_level: indicates the number of consecutive checksums found in
  *		the packet minus one that have been verified as
  *		CHECKSUM_UNNECESSARY (max 3)
+ *	@scm_io_uring: SKB holds io_uring registered files
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@slow_gro: state present at GRO time, slower prepare step required
@@ -910,6 +911,7 @@ struct sk_buff {
 	__u8			decrypted:1;
 #endif
 	__u8			slow_gro:1;
+	__u8			scm_io_uring:1;
 
 #ifdef CONFIG_NET_SCHED
 	__u16			tc_index;	/* traffic control index */
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
 


