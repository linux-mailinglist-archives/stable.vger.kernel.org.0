Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28776395B4D
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 15:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231837AbhEaNTI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 09:19:08 -0400
Received: from mail.kernel.org ([198.145.29.99]:54266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231704AbhEaNSo (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 09:18:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6A7586135C;
        Mon, 31 May 2021 13:17:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622467024;
        bh=9YJDKqPe0tOfaDOkxdtSFo/DvlgUp/DBWGwo+WF/7o4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=QoPnKZInbx7WtF0qv5fQdqSu16Ej5Q5gr4y5a2jWaDOpVzC/Fwq+OjTGCNu76M1dF
         95U+Xyto+AHOgl31InAw8ByV8b4f65tj2hSch10FvFZ1vWAMNHg8Zss0dT5Fm0tLkF
         NnnV2GUaFsJ8vzAk/z7J6lO3sUIMko+rBIF6mIIw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Li Shuang <shuali@redhat.com>,
        Xin Long <lucien.xin@gmail.com>, Jon Maloy <jmaloy@redhat.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 28/54] tipc: skb_linearize the head skb when reassembling msgs
Date:   Mon, 31 May 2021 15:13:54 +0200
Message-Id: <20210531130635.966639758@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130635.070310929@linuxfoundation.org>
References: <20210531130635.070310929@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit b7df21cf1b79ab7026f545e7bf837bd5750ac026 upstream.

It's not a good idea to append the frag skb to a skb's frag_list if
the frag_list already has skbs from elsewhere, such as this skb was
created by pskb_copy() where the frag_list was cloned (all the skbs
in it were skb_get'ed) and shared by multiple skbs.

However, the new appended frag skb should have been only seen by the
current skb. Otherwise, it will cause use after free crashes as this
appended frag skb are seen by multiple skbs but it only got skb_get
called once.

The same thing happens with a skb updated by pskb_may_pull() with a
skb_cloned skb. Li Shuang has reported quite a few crashes caused
by this when doing testing over macvlan devices:

  [] kernel BUG at net/core/skbuff.c:1970!
  [] Call Trace:
  []  skb_clone+0x4d/0xb0
  []  macvlan_broadcast+0xd8/0x160 [macvlan]
  []  macvlan_process_broadcast+0x148/0x150 [macvlan]
  []  process_one_work+0x1a7/0x360
  []  worker_thread+0x30/0x390

  [] kernel BUG at mm/usercopy.c:102!
  [] Call Trace:
  []  __check_heap_object+0xd3/0x100
  []  __check_object_size+0xff/0x16b
  []  simple_copy_to_iter+0x1c/0x30
  []  __skb_datagram_iter+0x7d/0x310
  []  __skb_datagram_iter+0x2a5/0x310
  []  skb_copy_datagram_iter+0x3b/0x90
  []  tipc_recvmsg+0x14a/0x3a0 [tipc]
  []  ____sys_recvmsg+0x91/0x150
  []  ___sys_recvmsg+0x7b/0xc0

  [] kernel BUG at mm/slub.c:305!
  [] Call Trace:
  []  <IRQ>
  []  kmem_cache_free+0x3ff/0x400
  []  __netif_receive_skb_core+0x12c/0xc40
  []  ? kmem_cache_alloc+0x12e/0x270
  []  netif_receive_skb_internal+0x3d/0xb0
  []  ? get_rx_page_info+0x8e/0xa0 [be2net]
  []  be_poll+0x6ef/0xd00 [be2net]
  []  ? irq_exit+0x4f/0x100
  []  net_rx_action+0x149/0x3b0

  ...

This patch is to fix it by linearizing the head skb if it has frag_list
set in tipc_buf_append(). Note that we choose to do this before calling
skb_unshare(), as __skb_linearize() will avoid skb_copy(). Also, we can
not just drop the frag_list either as the early time.

Fixes: 45c8b7b175ce ("tipc: allow non-linear first fragment buffer")
Reported-by: Li Shuang <shuali@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Jon Maloy <jmaloy@redhat.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/msg.c |    9 ++-------
 1 file changed, 2 insertions(+), 7 deletions(-)

--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -139,18 +139,13 @@ int tipc_buf_append(struct sk_buff **hea
 		if (unlikely(head))
 			goto err;
 		*buf = NULL;
+		if (skb_has_frag_list(frag) && __skb_linearize(frag))
+			goto err;
 		frag = skb_unshare(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
 		TIPC_SKB_CB(head)->tail = NULL;
-		if (skb_is_nonlinear(head)) {
-			skb_walk_frags(head, tail) {
-				TIPC_SKB_CB(head)->tail = tail;
-			}
-		} else {
-			skb_frag_list_init(head);
-		}
 		return 0;
 	}
 


