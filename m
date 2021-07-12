Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E765E3C4F15
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:43:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242728AbhGLHXG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:23:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58216 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344112AbhGLHUU (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:20:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E2548610A6;
        Mon, 12 Jul 2021 07:17:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074251;
        bh=yHX5871xvMpf6sTfEo3jmWZZ7ROJNaQ43WdKczIs6IE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Pz1b9XPRPHf382mTR5+tcpFoaEC1wEo99Jh1MJTPYKuZebVTRfor7HDWyC/D8pet9
         i3P2KhCc6elaTZt9Pu9Tj6wgMOWj7lrGSZxCRr+wlDBbNkUJE6aXMbwRm/mECI75N1
         d9h+SVbBfAw13gLTyMcrbqBOGomL1trJUz2LQqO8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Menglong Dong <dong.menglong@zte.com.cn>,
        Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 515/700] net: tipc: fix FB_MTU eat two pages
Date:   Mon, 12 Jul 2021 08:09:58 +0200
Message-Id: <20210712061031.302106538@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Menglong Dong <dong.menglong@zte.com.cn>

[ Upstream commit 0c6de0c943dbb42831bf7502eb5c007f71e752d2 ]

FB_MTU is used in 'tipc_msg_build()' to alloc smaller skb when memory
allocation fails, which can avoid unnecessary sending failures.

The value of FB_MTU now is 3744, and the data size will be:

  (3744 + SKB_DATA_ALIGN(sizeof(struct skb_shared_info)) + \
    SKB_DATA_ALIGN(BUF_HEADROOM + BUF_TAILROOM + 3))

which is larger than one page(4096), and two pages will be allocated.

To avoid it, replace '3744' with a calculation:

  (PAGE_SIZE - SKB_DATA_ALIGN(BUF_OVERHEAD) - \
    SKB_DATA_ALIGN(sizeof(struct skb_shared_info)))

What's more, alloc_skb_fclone() will call SKB_DATA_ALIGN for data size,
and it's not necessary to make alignment for buf_size in
tipc_buf_acquire(). So, just remove it.

Fixes: 4c94cc2d3d57 ("tipc: fall back to smaller MTU if allocation of local send skb fails")
Signed-off-by: Menglong Dong <dong.menglong@zte.com.cn>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/tipc/bcast.c |  2 +-
 net/tipc/msg.c   | 17 ++++++++---------
 net/tipc/msg.h   |  3 ++-
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/net/tipc/bcast.c b/net/tipc/bcast.c
index d4beca895992..593846d25214 100644
--- a/net/tipc/bcast.c
+++ b/net/tipc/bcast.c
@@ -699,7 +699,7 @@ int tipc_bcast_init(struct net *net)
 	spin_lock_init(&tipc_net(net)->bclock);
 
 	if (!tipc_link_bc_create(net, 0, 0, NULL,
-				 FB_MTU,
+				 one_page_mtu,
 				 BCLINK_WIN_DEFAULT,
 				 BCLINK_WIN_DEFAULT,
 				 0,
diff --git a/net/tipc/msg.c b/net/tipc/msg.c
index d0fc5fadbc68..b7943da9d095 100644
--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -44,12 +44,15 @@
 #define MAX_FORWARD_SIZE 1024
 #ifdef CONFIG_TIPC_CRYPTO
 #define BUF_HEADROOM ALIGN(((LL_MAX_HEADER + 48) + EHDR_MAX_SIZE), 16)
-#define BUF_TAILROOM (TIPC_AES_GCM_TAG_SIZE)
+#define BUF_OVERHEAD (BUF_HEADROOM + TIPC_AES_GCM_TAG_SIZE)
 #else
 #define BUF_HEADROOM (LL_MAX_HEADER + 48)
-#define BUF_TAILROOM 16
+#define BUF_OVERHEAD BUF_HEADROOM
 #endif
 
+const int one_page_mtu = PAGE_SIZE - SKB_DATA_ALIGN(BUF_OVERHEAD) -
+			 SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+
 static unsigned int align(unsigned int i)
 {
 	return (i + 3) & ~3u;
@@ -69,13 +72,8 @@ static unsigned int align(unsigned int i)
 struct sk_buff *tipc_buf_acquire(u32 size, gfp_t gfp)
 {
 	struct sk_buff *skb;
-#ifdef CONFIG_TIPC_CRYPTO
-	unsigned int buf_size = (BUF_HEADROOM + size + BUF_TAILROOM + 3) & ~3u;
-#else
-	unsigned int buf_size = (BUF_HEADROOM + size + 3) & ~3u;
-#endif
 
-	skb = alloc_skb_fclone(buf_size, gfp);
+	skb = alloc_skb_fclone(BUF_OVERHEAD + size, gfp);
 	if (skb) {
 		skb_reserve(skb, BUF_HEADROOM);
 		skb_put(skb, size);
@@ -395,7 +393,8 @@ int tipc_msg_build(struct tipc_msg *mhdr, struct msghdr *m, int offset,
 		if (unlikely(!skb)) {
 			if (pktmax != MAX_MSG_SIZE)
 				return -ENOMEM;
-			rc = tipc_msg_build(mhdr, m, offset, dsz, FB_MTU, list);
+			rc = tipc_msg_build(mhdr, m, offset, dsz,
+					    one_page_mtu, list);
 			if (rc != dsz)
 				return rc;
 			if (tipc_msg_assemble(list))
diff --git a/net/tipc/msg.h b/net/tipc/msg.h
index 5d64596ba987..64ae4c4c44f8 100644
--- a/net/tipc/msg.h
+++ b/net/tipc/msg.h
@@ -99,9 +99,10 @@ struct plist;
 #define MAX_H_SIZE                60	/* Largest possible TIPC header size */
 
 #define MAX_MSG_SIZE (MAX_H_SIZE + TIPC_MAX_USER_MSG_SIZE)
-#define FB_MTU                  3744
 #define TIPC_MEDIA_INFO_OFFSET	5
 
+extern const int one_page_mtu;
+
 struct tipc_skb_cb {
 	union {
 		struct {
-- 
2.30.2



