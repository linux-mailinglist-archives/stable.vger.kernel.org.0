Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB6A3300524
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:19:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727944AbhAVORR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:17:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:34950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728428AbhAVOPL (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:15:11 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8B4B8239EE;
        Fri, 22 Jan 2021 14:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324709;
        bh=zMUBhIrBMWSQJ/8uoD2Svo4/FRyX8kp+w3+5tktxVBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=It21UrUCzCY9lZpZ44S+Q30mUMjmi40uZjvLlpB3Nxx8iv1eJn/7JWVBJcAfkfSeh
         mzZjLN5Fbk1tAM+gnMqB62dIUNkjn3/1u/Zc59Og4XgyOTKqNQouIUP6jm7iFGWdKQ
         TkNlDiwpzOSWsKZeB7vatZBwholNmjnlSNUI8/bA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.9 34/35] tipc: fix NULL deref in tipc_link_xmit()
Date:   Fri, 22 Jan 2021 15:10:36 +0100
Message-Id: <20210122135733.695282527@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135732.357969201@linuxfoundation.org>
References: <20210122135732.357969201@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hoang Le <hoang.h.le@dektech.com.au>

[ Upstream commit b77413446408fdd256599daf00d5be72b5f3e7c6 ]

The buffer list can have zero skb as following path:
tipc_named_node_up()->tipc_node_xmit()->tipc_link_xmit(), so
we need to check the list before casting an &sk_buff.

Fault report:
 [] tipc: Bulk publication failure
 [] general protection fault, probably for non-canonical [#1] PREEMPT [...]
 [] KASAN: null-ptr-deref in range [0x00000000000000c8-0x00000000000000cf]
 [] CPU: 0 PID: 0 Comm: swapper/0 Kdump: loaded Not tainted 5.10.0-rc4+ #2
 [] Hardware name: Bochs ..., BIOS Bochs 01/01/2011
 [] RIP: 0010:tipc_link_xmit+0xc1/0x2180
 [] Code: 24 b8 00 00 00 00 4d 39 ec 4c 0f 44 e8 e8 d7 0a 10 f9 48 [...]
 [] RSP: 0018:ffffc90000006ea0 EFLAGS: 00010202
 [] RAX: dffffc0000000000 RBX: ffff8880224da000 RCX: 1ffff11003d3cc0d
 [] RDX: 0000000000000019 RSI: ffffffff886007b9 RDI: 00000000000000c8
 [] RBP: ffffc90000007018 R08: 0000000000000001 R09: fffff52000000ded
 [] R10: 0000000000000003 R11: fffff52000000dec R12: ffffc90000007148
 [] R13: 0000000000000000 R14: 0000000000000000 R15: ffffc90000007018
 [] FS:  0000000000000000(0000) GS:ffff888037400000(0000) knlGS:000[...]
 [] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 [] CR2: 00007fffd2db5000 CR3: 000000002b08f000 CR4: 00000000000006f0

Fixes: af9b028e270fd ("tipc: make media xmit call outside node spinlock context")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: Hoang Le <hoang.h.le@dektech.com.au>
Link: https://lore.kernel.org/r/20210108071337.3598-1-hoang.h.le@dektech.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/link.c |   11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -877,9 +877,8 @@ void tipc_link_reset(struct tipc_link *l
 int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		   struct sk_buff_head *xmitq)
 {
-	struct tipc_msg *hdr = buf_msg(skb_peek(list));
 	unsigned int maxwin = l->window;
-	unsigned int i, imp = msg_importance(hdr);
+	unsigned int i;
 	unsigned int mtu = l->mtu;
 	u16 ack = l->rcv_nxt - 1;
 	u16 seqno = l->snd_nxt;
@@ -888,7 +887,13 @@ int tipc_link_xmit(struct tipc_link *l,
 	struct sk_buff_head *backlogq = &l->backlogq;
 	struct sk_buff *skb, *_skb, *bskb;
 	int pkt_cnt = skb_queue_len(list);
+	struct tipc_msg *hdr;
+	int imp;
 
+	if (pkt_cnt <= 0)
+		return 0;
+
+	imp = msg_importance(hdr);
 	/* Match msg importance against this and all higher backlog limits: */
 	if (!skb_queue_empty(backlogq)) {
 		for (i = imp; i <= TIPC_SYSTEM_IMPORTANCE; i++) {
@@ -896,6 +901,8 @@ int tipc_link_xmit(struct tipc_link *l,
 				return link_schedule_user(l, list);
 		}
 	}
+
+	hdr = buf_msg(skb_peek(list));
 	if (unlikely(msg_size(hdr) > mtu)) {
 		skb_queue_purge(list);
 		return -EMSGSIZE;


