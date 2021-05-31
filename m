Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DC41D3960D0
	for <lists+stable@lfdr.de>; Mon, 31 May 2021 16:30:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232240AbhEaObk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 31 May 2021 10:31:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:56238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233985AbhEaO3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 31 May 2021 10:29:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 14CF261C28;
        Mon, 31 May 2021 13:48:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1622468911;
        bh=95C73nfouQFTJ+QBHIZMzTYe7qD618sSkUDJj+FuyCc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=khrdLc8CiYYk+PMg2sntVr3U12REGwLNtBw9vIcEZF+VwGoLxCkGYdcXDQG8BgIAn
         cPTq7DyVBfOFO0PGX1o02IO/Ypm2fAuSHoXlapc6Vf3e8C+evHf+BgahxHqViYXRIp
         41F8qOm7r15fYLkVi6o8Ja7hKVGZoIxY7/375fZ8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chinmay Agarwal <chinagar@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 176/177] neighbour: Prevent Race condition in neighbour subsytem
Date:   Mon, 31 May 2021 15:15:33 +0200
Message-Id: <20210531130654.013624997@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210531130647.887605866@linuxfoundation.org>
References: <20210531130647.887605866@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chinmay Agarwal <chinagar@codeaurora.org>

commit eefb45eef5c4c425e87667af8f5e904fbdd47abf upstream.

Following Race Condition was detected:

<CPU A, t0>: Executing: __netif_receive_skb() ->__netif_receive_skb_core()
-> arp_rcv() -> arp_process().arp_process() calls __neigh_lookup() which
takes a reference on neighbour entry 'n'.
Moves further along, arp_process() and calls neigh_update()->
__neigh_update(). Neighbour entry is unlocked just before a call to
neigh_update_gc_list.

This unlocking paves way for another thread that may take a reference on
the same and mark it dead and remove it from gc_list.

<CPU B, t1> - neigh_flush_dev() is under execution and calls
neigh_mark_dead(n) marking the neighbour entry 'n' as dead. Also n will be
removed from gc_list.
Moves further along neigh_flush_dev() and calls
neigh_cleanup_and_release(n), but since reference count increased in t1,
'n' couldn't be destroyed.

<CPU A, t3>- Code hits neigh_update_gc_list, with neighbour entry
set as dead.

<CPU A, t4> - arp_process() finally calls neigh_release(n), destroying
the neighbour entry and we have a destroyed ntry still part of gc_list.

Fixes: eb4e8fac00d1("neighbour: Prevent a dead entry from updating gc_list")
Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -132,6 +132,9 @@ static void neigh_update_gc_list(struct
 	write_lock_bh(&n->tbl->lock);
 	write_lock(&n->lock);
 
+	if (n->dead)
+		goto out;
+
 	/* remove from the gc list if new state is permanent or if neighbor
 	 * is externally learned; otherwise entry should be on the gc list
 	 */
@@ -148,6 +151,7 @@ static void neigh_update_gc_list(struct
 		atomic_inc(&n->tbl->gc_entries);
 	}
 
+out:
 	write_unlock(&n->lock);
 	write_unlock_bh(&n->tbl->lock);
 }


