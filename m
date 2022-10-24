Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A276260A7E8
	for <lists+stable@lfdr.de>; Mon, 24 Oct 2022 15:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232122AbiJXNA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Oct 2022 09:00:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234927AbiJXM6z (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Oct 2022 08:58:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B3B98CBA;
        Mon, 24 Oct 2022 05:17:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E4ED6612CA;
        Mon, 24 Oct 2022 12:15:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3431C433C1;
        Mon, 24 Oct 2022 12:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666613729;
        bh=vphyuMNTpGBaNmQQwhU17mOecsvvOTZxhLXb6ShGydk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HFmcdPaSrHIVU9EKgl/T1HkZG0Du0D7tn9U4deUkrW/OcXlCjpnnhsg0gqcCO7X7T
         aMtNExlG/xybaCV/P9lDuqCFTUEOei448kuESxszmaAZBecpeNvsxjJum7OXPLZ3Dy
         Zo93JvpvhOEFp+5hHfPWHwVbbMYSWfL8TIoQS7vM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Begunkov <asml.silence@gmail.com>,
        Thadeu Lima de Souza Cascardo <cascardo@canonical.com>,
        Jens Axboe <axboe@kernel.dk>,
        David Bouman <dbouman03@gmail.com>
Subject: [PATCH 5.4 247/255] io_uring/af_unix: defer registered files gc to io_uring release
Date:   Mon, 24 Oct 2022 13:32:37 +0200
Message-Id: <20221024113011.493035765@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221024113002.471093005@linuxfoundation.org>
References: <20221024113002.471093005@linuxfoundation.org>
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
@@ -3172,6 +3172,7 @@ static int __io_sqe_files_scm(struct io_
 	}
 
 	skb->sk = sk;
+	skb->scm_io_uring = 1;
 	skb->destructor = io_destruct_skb;
 
 	fpl->user = get_uid(ctx->user);
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -659,6 +659,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@wifi_acked: whether frame was acked on wifi or not
  *	@no_fcs:  Request NIC to treat last 4 bytes as Ethernet FCS
  *	@csum_not_inet: use CRC32c to resolve CHECKSUM_PARTIAL
+ *	@scm_io_uring: SKB holds io_uring registered files
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@napi_id: id of the NAPI struct this skb came from
@@ -824,6 +825,7 @@ struct sk_buff {
 #ifdef CONFIG_TLS_DEVICE
 	__u8			decrypted:1;
 #endif
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
 


