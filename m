Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 931C0600417
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 01:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229794AbiJPXFf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 19:05:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbiJPXFe (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 19:05:34 -0400
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BCAC220F4
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 16:05:33 -0700 (PDT)
Received: by mail-ej1-x630.google.com with SMTP id fy4so21273142ejc.5
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 16:05:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=dy2eNayoUQfURO4aHscYNf1Q5oDbHRY/ZlMbjJLVe54=;
        b=g+8Jm/YC/BeBHau4drpZ1JeIgNGZ4cbU0cOT9EM+1AWN/F+yCBappUpw/6vkOzZGCQ
         Hh6JGD4EK8jXwDlFqenfNowrrqmR2vUaiNAVFa7ISXGxyCyeAiQaytpirW0QnF6ZV5VT
         Xnvs1ZabTuwNqXLMyCTN1HaS8nsNOD3mc7XYFWIfT9sKLCzOBAMZEcmPn6hw5bPf2Zd8
         vybIuCBZvSAK3lsuhJ6sm9NkgsBJPb+/zWAnkBe6k6YFj0iB3nPCATrgIf6ZRYivx7Cw
         WZEpgL3XuNd0kcowfJtNz7697h0A0v4GW7PLlsu4ZkODIZFVTi6ZIXx4nuEXzhdwUclP
         Fgkg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=dy2eNayoUQfURO4aHscYNf1Q5oDbHRY/ZlMbjJLVe54=;
        b=NoOHrZJSCDgIYpTunTQn/bL/y7HYjbXJ+pGnUAPTtAIgbpJuYSQmaN8jSIgGIJCtIu
         sSmZ8+4xuvEEmfY6ZqlTsFVi65K0G2kvs7/aIlBzYS9rdh+GIjIKCs5bjyyPN2Z5WKzC
         YyoBWnfkX1n3eqvRUGrhUp+lowUQu1X+15LsWbHwSsM73a1URVfmiS3mb5zBaAdjvdwj
         k6GbF2rFYxeoKqyloLZ4qp8Swtp8eCW4qCVminp3lsbkQsePkfyG0so9qR4OnNGq+6l7
         bcI8jnVvOlxWfsYw41DAnXRhDRNATuX3lY9rNunb+n/stnuN1jOx+Mg2eSnYsSrH7p4G
         l4Ig==
X-Gm-Message-State: ACrzQf1ML648/6fpM2m99mdGBVyadP6yP805nI7xyc1JPoH6mXU52/mi
        nC2zXy6K5v7kXgTgh+wKb3VyDCMMPyc=
X-Google-Smtp-Source: AMsMyM59CBAFDffnrFmWL1tjHgqwdzYIUpWIe1Q4+MRWofuzcLGRjgDaQFTJ7b4O20/r/NsgterWEg==
X-Received: by 2002:a17:907:2711:b0:78e:c2a:a3fb with SMTP id w17-20020a170907271100b0078e0c2aa3fbmr6498144ejk.556.1665961531700;
        Sun, 16 Oct 2022 16:05:31 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id c1-20020a17090618a100b007877ad05b32sm5133125ejf.208.2022.10.16.16.05.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 16:05:31 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.4 1/1] io_uring/af_unix: defer registered files gc to io_uring release
Date:   Mon, 17 Oct 2022 00:03:11 +0100
Message-Id: <84f1ec07537215261750d29ac6353fcfca8674e1.1665961345.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
---
 fs/io_uring.c          |  1 +
 include/linux/skbuff.h |  2 ++
 net/unix/garbage.c     | 20 ++++++++++++++++++++
 3 files changed, 23 insertions(+)

diff --git a/fs/io_uring.c b/fs/io_uring.c
index 501c7e14c07c..e8df6345a812 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -3172,6 +3172,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	}
 
 	skb->sk = sk;
+	skb->scm_io_uring = 1;
 	skb->destructor = io_destruct_skb;
 
 	fpl->user = get_uid(ctx->user);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 680f71ecdc08..eab3a4d02f32 100644
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
 
-- 
2.38.0

