Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99AC531381F
	for <lists+stable@lfdr.de>; Mon,  8 Feb 2021 16:37:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234015AbhBHPgx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Feb 2021 10:36:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:36948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233911AbhBHPbi (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Feb 2021 10:31:38 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A290064F37;
        Mon,  8 Feb 2021 15:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612797456;
        bh=oGYFLcwBYUzIxPOwoh/aKsUxQYKMGRHnAS+QCYCIaTs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=L/tQYQzYHVso8zMUzuQXom7trBXU8UiL/DSrzalit8eOMO6dCRL388s6bRIddpSu5
         9Pp3D+BMjA3xTChhDSOiQrYArBWf8gdKWxud9XuPI6pOaa7wHqolBBzY2p3f2z5ERE
         kphBws32Wo5oDHNHqV++8cnx6iYbZRtpTxzeIq/0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Chinmay Agarwal <chinagar@codeaurora.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 116/120] neighbour: Prevent a dead entry from updating gc_list
Date:   Mon,  8 Feb 2021 16:01:43 +0100
Message-Id: <20210208145822.990723934@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210208145818.395353822@linuxfoundation.org>
References: <20210208145818.395353822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chinmay Agarwal <chinagar@codeaurora.org>

commit eb4e8fac00d1e01ada5e57c05d24739156086677 upstream.

Following race condition was detected:
<CPU A, t0> - neigh_flush_dev() is under execution and calls
neigh_mark_dead(n) marking the neighbour entry 'n' as dead.

<CPU B, t1> - Executing: __netif_receive_skb() ->
__netif_receive_skb_core() -> arp_rcv() -> arp_process().arp_process()
calls __neigh_lookup() which takes a reference on neighbour entry 'n'.

<CPU A, t2> - Moves further along neigh_flush_dev() and calls
neigh_cleanup_and_release(n), but since reference count increased in t2,
'n' couldn't be destroyed.

<CPU B, t3> - Moves further along, arp_process() and calls
neigh_update()-> __neigh_update() -> neigh_update_gc_list(), which adds
the neighbour entry back in gc_list(neigh_mark_dead(), removed it
earlier in t0 from gc_list)

<CPU B, t4> - arp_process() finally calls neigh_release(n), destroying
the neighbour entry.

This leads to 'n' still being part of gc_list, but the actual
neighbour structure has been freed.

The situation can be prevented from happening if we disallow a dead
entry to have any possibility of updating gc_list. This is what the
patch intends to achieve.

Fixes: 9c29a2f55ec0 ("neighbor: Fix locking order for gc_list changes")
Signed-off-by: Chinmay Agarwal <chinagar@codeaurora.org>
Reviewed-by: Cong Wang <xiyou.wangcong@gmail.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Link: https://lore.kernel.org/r/20210127165453.GA20514@chinagar-linux.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/neighbour.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/net/core/neighbour.c
+++ b/net/core/neighbour.c
@@ -1245,13 +1245,14 @@ static int __neigh_update(struct neighbo
 	old    = neigh->nud_state;
 	err    = -EPERM;
 
-	if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
-	    (old & (NUD_NOARP | NUD_PERMANENT)))
-		goto out;
 	if (neigh->dead) {
 		NL_SET_ERR_MSG(extack, "Neighbor entry is now dead");
+		new = old;
 		goto out;
 	}
+	if (!(flags & NEIGH_UPDATE_F_ADMIN) &&
+	    (old & (NUD_NOARP | NUD_PERMANENT)))
+		goto out;
 
 	ext_learn_change = neigh_update_ext_learned(neigh, flags, &notify);
 


