Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD1B36003F1
	for <lists+stable@lfdr.de>; Mon, 17 Oct 2022 00:33:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229579AbiJPWdt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 18:33:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229486AbiJPWds (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 18:33:48 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CF1A28E0B
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:33:47 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id bj12so21120162ejb.13
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 15:33:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aPNYKEPZJDYFfKXHeHlYcdJYK0qq9N8qJZ8acJgu+uU=;
        b=mhDHHnISIgJ/TjmH27onufb9VWiaiqOsQ8Sp5Q+HnQ0wtpKRmjXmYwsT6L3nt0a5IX
         vqtOkCwVQikGDgc5W43JIez5sr94fUKBeg0nyGN0/eLu4Ks/OeLDSMfahhRKCV4ItlZA
         AP3zULJQmB8fLbibnaycVcBwugp09wNPtwi1JjFSnSLzndW2r8CXOKRgCH8G2A3IIuUg
         urEPJLLzCxxhEDhhIcGCwyFQFXfP/xo3FsAjhu82XE3KtJFfoE/n1RphzxnKcsAvdGVE
         3QKnhCIRgSLx/bZlGJZ1I+OrrcsvSEySBDrxt8S9BHsu8zQ1SBlapfrNqwcZMPKsH20t
         NDdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aPNYKEPZJDYFfKXHeHlYcdJYK0qq9N8qJZ8acJgu+uU=;
        b=Agwx9VlpkVnvA8f5SJbz8TBa6/nOwSXBDVSQBSIUUM0UucyYSeHM7wXlsFhddaGkV6
         57m+A2wUqLhX+vPSlWhXRxaGdjHG75IziPrwvBej3l26vnX71vZenXT9S7GV9e/rvPEn
         8kDRcZhl5Lvk9o6e/V0G3IOBcF+6f3uv+Zr6qbrMFJ3TrTkeZeJScnIhSSFxb9aEFtM2
         TKaswXbgCq/O7IjmYBqYwfTj9ue3gatUBINrVprycYbkRnVYcvJoLTwjfhmz4r6SiycT
         VVXIZbm2LHxo891ObAp7rhshpbwAItFHdd88sOo5DFy3gYIVlOmefbrrOeC7JnuNzJ5z
         0kxQ==
X-Gm-Message-State: ACrzQf0lKv6DuKVidyHWhIqNNYqcgWH5pjYW+8in7YJZI1Ouyk/jAjjR
        WqbypDYEekqD/gh7px2QdaAu3xP6R78=
X-Google-Smtp-Source: AMsMyM5CbHw3UxfWrn0otrZUblZgC8Qju1pn+IdrMCFNlXqgJujDvzrwtb/BUKFGDk17UCEfzVMdLw==
X-Received: by 2002:a17:907:1deb:b0:78d:4a0e:f654 with SMTP id og43-20020a1709071deb00b0078d4a0ef654mr6522184ejc.757.1665959625669;
        Sun, 16 Oct 2022 15:33:45 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id jt3-20020a170906dfc300b0078db5bddd9csm5193496ejc.22.2022.10.16.15.33.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 15:33:45 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.10 2/2] io_uring/af_unix: defer registered files gc to io_uring release
Date:   Sun, 16 Oct 2022 23:31:26 +0100
Message-Id: <3b70b8129d507c477912c442311be4f5d205e057.1665959215.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665959215.git.asml.silence@gmail.com>
References: <cover.1665959215.git.asml.silence@gmail.com>
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
index b82a446d5e59..05f360b66b07 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -7301,6 +7301,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	}
 
 	skb->sk = sk;
+	skb->scm_io_uring = 1;
 
 	nr_files = 0;
 	fpl->user = get_uid(ctx->user);
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 61fc053a4a4e..462b0e3ef2b2 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -681,6 +681,7 @@ typedef unsigned char *sk_buff_data_t;
  *	@csum_level: indicates the number of consecutive checksums found in
  *		the packet minus one that have been verified as
  *		CHECKSUM_UNNECESSARY (max 3)
+ *	@scm_io_uring: SKB holds io_uring registered files
  *	@dst_pending_confirm: need to confirm neighbour
  *	@decrypted: Decrypted SKB
  *	@napi_id: id of the NAPI struct this skb came from
@@ -858,6 +859,7 @@ struct sk_buff {
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

