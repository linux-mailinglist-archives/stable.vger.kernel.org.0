Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ED1B6300C2E
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 20:21:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729804AbhAVSlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 13:41:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:37470 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728459AbhAVOVB (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:21:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CE7AD23AA3;
        Fri, 22 Jan 2021 14:14:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611324889;
        bh=stopOueBLpDCRcNtvxkdz0c/fQruL3SUtd4aoCm04qo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=acbgc9a+GhuGOlNHcc+cEucImPdW6s44CuQWr49WncQyE3/fSbNJJVqwfIODsqUE2
         a6reQbAMRgveoZewBlc0TTBkigfrr1yR3TbhpGTN69AJsKddPuTO8s8Gki5NqJctna
         w2NOSc9tGx35GxCvgNw3wEIijHtWN6vaIEx+bed8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Hoang Le <hoang.h.le@dektech.com.au>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 45/50] tipc: fix NULL deref in tipc_link_xmit()
Date:   Fri, 22 Jan 2021 15:12:26 +0100
Message-Id: <20210122135737.025525695@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.176469491@linuxfoundation.org>
References: <20210122135735.176469491@linuxfoundation.org>
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
 net/tipc/link.c |    9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

--- a/net/tipc/link.c
+++ b/net/tipc/link.c
@@ -882,9 +882,7 @@ void tipc_link_reset(struct tipc_link *l
 int tipc_link_xmit(struct tipc_link *l, struct sk_buff_head *list,
 		   struct sk_buff_head *xmitq)
 {
-	struct tipc_msg *hdr = buf_msg(skb_peek(list));
 	unsigned int maxwin = l->window;
-	int imp = msg_importance(hdr);
 	unsigned int mtu = l->mtu;
 	u16 ack = l->rcv_nxt - 1;
 	u16 seqno = l->snd_nxt;
@@ -893,13 +891,20 @@ int tipc_link_xmit(struct tipc_link *l,
 	struct sk_buff_head *backlogq = &l->backlogq;
 	struct sk_buff *skb, *_skb, **tskb;
 	int pkt_cnt = skb_queue_len(list);
+	struct tipc_msg *hdr;
 	int rc = 0;
+	int imp;
 
+	if (pkt_cnt <= 0)
+		return 0;
+
+	hdr = buf_msg(skb_peek(list));
 	if (unlikely(msg_size(hdr) > mtu)) {
 		skb_queue_purge(list);
 		return -EMSGSIZE;
 	}
 
+	imp = msg_importance(hdr);
 	/* Allow oversubscription of one data msg per source at congestion */
 	if (unlikely(l->backlog[imp].len >= l->backlog[imp].limit)) {
 		if (imp == TIPC_SYSTEM_IMPORTANCE) {


