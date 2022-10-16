Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77208600381
	for <lists+stable@lfdr.de>; Sun, 16 Oct 2022 23:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229574AbiJPVpM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 16 Oct 2022 17:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbiJPVpL (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 16 Oct 2022 17:45:11 -0400
Received: from mail-ed1-x532.google.com (mail-ed1-x532.google.com [IPv6:2a00:1450:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66A1531FA7
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:10 -0700 (PDT)
Received: by mail-ed1-x532.google.com with SMTP id s2so13601530edd.2
        for <stable@vger.kernel.org>; Sun, 16 Oct 2022 14:45:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mz1a633h3Q38hTa6T4IrArZAkt29fPCRpOCkbFs8Ykg=;
        b=K2ths7SB+0jZTEofP4eDZDRCTCjwnNh8bfF0CYWmEhfj8ae8rJT35Tz2JjqLKdLhqW
         Wn91idVmVo6tf2pXru9++x0I8DArUOv1zBVUpu4a2qSCwioFw/r/lwE8u+5SglpqHqq7
         vL71XHzJBIvQDdBLZ71KCQmZv3eTT6HuS6naZhPupWkJPWV8fKPJh7la9lrS+TOGhVRr
         NmXPVrFu3Xq3RZsYhr59536zZLWKb4FHgzIxvQbl90uGelFZnRlOL2cK6+jHy3ujI7Q+
         oiIWedNeeqePYevRKTGuqwrdmhKAyS2Ui82rZicJYI1v54i5XJEc6FW2uECOJMoD/57q
         bJNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mz1a633h3Q38hTa6T4IrArZAkt29fPCRpOCkbFs8Ykg=;
        b=5E8470K6r7hj6nB0uHTbXwkSmlt48YvqTuTpk9GEhAJ2ab+i6skn8yFIX9SgOc8gbC
         gzi3zZo5vbxIvQryFDGw5L/uY3L7u5Uu06on3wHiJccEAQPkGq1zO+WNny9ArMITKerI
         GpJEG655kn2K/VSQWKA/yGITpwitJrgU/4UPFNH9wIOLJaw02uh6cHcTIAxOlVIIJL3U
         pfaPXwhOwLzP9pVt5QDQ/BVmddlnk15KYmIaBW1yRAPJOrdZHKSdLtyslFaHu9Jc+zLD
         FkKIo6/Dpy+sAVRiaugTJ2iUxQIb71ghcSVRKKW8x534MKZoiLwmlipH4Bg5sLD+Ja1A
         QY0Q==
X-Gm-Message-State: ACrzQf05eBGJymXanTyeyvEXXSJJbycibbEd8qm5U7vLcmYrIg7Ey0JL
        uWkY7zCjVw2pcwbzOnM9JWB9b1dHclU=
X-Google-Smtp-Source: AMsMyM4tlwyPCfntfRaelPvbXPVGBSRTcbXfFOvkpkD5pMXGrC+QdDcb2TesB5OnDQvvsMDatAk8Pg==
X-Received: by 2002:a05:6402:5cd:b0:446:5965:f4af with SMTP id n13-20020a05640205cd00b004465965f4afmr7516034edx.12.1665956708656;
        Sun, 16 Oct 2022 14:45:08 -0700 (PDT)
Received: from 127.0.0.1localhost (94.196.234.149.threembb.co.uk. [94.196.234.149])
        by smtp.gmail.com with ESMTPSA id q6-20020a17090676c600b0078c47463277sm5177331ejn.96.2022.10.16.14.45.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 16 Oct 2022 14:45:08 -0700 (PDT)
From:   Pavel Begunkov <asml.silence@gmail.com>
To:     stable@vger.kernel.org
Cc:     Jens Axboe <axboe@kernel.dk>, asml.silence@gmail.com
Subject: [PATCH stable-5.15 1/5] io_uring/af_unix: defer registered files gc to io_uring release
Date:   Sun, 16 Oct 2022 22:42:54 +0100
Message-Id: <a83df723eee66917424c39b62e5aec3871ddc481.1665954636.git.asml.silence@gmail.com>
X-Mailer: git-send-email 2.38.0
In-Reply-To: <cover.1665954636.git.asml.silence@gmail.com>
References: <cover.1665954636.git.asml.silence@gmail.com>
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
index ed6abd74f386..1b0e83fdea7a 100644
--- a/fs/io_uring.c
+++ b/fs/io_uring.c
@@ -8065,6 +8065,7 @@ static int __io_sqe_files_scm(struct io_ring_ctx *ctx, int nr, int offset)
 	}
 
 	skb->sk = sk;
+	skb->scm_io_uring = 1;
 
 	nr_files = 0;
 	fpl->user = get_uid(current_user());
diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index cfb889f66c70..19e595cab23a 100644
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

