Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D7BE2ABDAE
	for <lists+stable@lfdr.de>; Mon,  9 Nov 2020 14:48:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730122AbgKINsN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Nov 2020 08:48:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:50962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729673AbgKIM4I (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Nov 2020 07:56:08 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 236902084C;
        Mon,  9 Nov 2020 12:56:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604926566;
        bh=wOKd70eCl0dYc/plvXuW6jYdj0jygRl90Hi7NnE0zwo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OmdRnmJRTwrsB/IQ8eneIODzbPb8+tkAmpu5FG6PO41Fvs/bNqFJF78AW9TkJ66V4
         DiUe7JEHulh1D3fyPl0ffP8D5Kaag57y0gEv0+BEoYXbEv4JXyZmFUUW6VexB+2ynq
         JloQ9jen2W4g3l04Gti6VN1H37sk26o+6uzRvUPo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Thang Hoang Ngo <thang.h.ngo@dektech.com.au>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Xin Long <lucien.xin@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.4 06/86] tipc: fix memory leak caused by tipc_buf_append()
Date:   Mon,  9 Nov 2020 13:54:13 +0100
Message-Id: <20201109125021.170376387@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201109125020.852643676@linuxfoundation.org>
References: <20201109125020.852643676@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tung Nguyen <tung.q.nguyen@dektech.com.au>

[ Upstream commit ceb1eb2fb609c88363e06618b8d4bbf7815a4e03 ]

Commit ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
replaced skb_unshare() with skb_copy() to not reduce the data reference
counter of the original skb intentionally. This is not the correct
way to handle the cloned skb because it causes memory leak in 2
following cases:
 1/ Sending multicast messages via broadcast link
  The original skb list is cloned to the local skb list for local
  destination. After that, the data reference counter of each skb
  in the original list has the value of 2. This causes each skb not
  to be freed after receiving ACK:
  tipc_link_advance_transmq()
  {
   ...
   /* release skb */
   __skb_unlink(skb, &l->transmq);
   kfree_skb(skb); <-- memory exists after being freed
  }

 2/ Sending multicast messages via replicast link
  Similar to the above case, each skb cannot be freed after purging
  the skb list:
  tipc_mcast_xmit()
  {
   ...
   __skb_queue_purge(pkts); <-- memory exists after being freed
  }

This commit fixes this issue by using skb_unshare() instead. Besides,
to avoid use-after-free error reported by KASAN, the pointer to the
fragment is set to NULL before calling skb_unshare() to make sure that
the original skb is not freed after freeing the fragment 2 times in
case skb_unshare() returns NULL.

Fixes: ed42989eab57 ("tipc: fix the skb_unshare() in tipc_buf_append()")
Acked-by: Jon Maloy <jmaloy@redhat.com>
Reported-by: Thang Hoang Ngo <thang.h.ngo@dektech.com.au>
Signed-off-by: Tung Nguyen <tung.q.nguyen@dektech.com.au>
Reviewed-by: Xin Long <lucien.xin@gmail.com>
Acked-by: Cong Wang <xiyou.wangcong@gmail.com>
Link: https://lore.kernel.org/r/20201027032403.1823-1-tung.q.nguyen@dektech.com.au
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tipc/msg.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

--- a/net/tipc/msg.c
+++ b/net/tipc/msg.c
@@ -138,12 +138,11 @@ int tipc_buf_append(struct sk_buff **hea
 	if (fragid == FIRST_FRAGMENT) {
 		if (unlikely(head))
 			goto err;
-		if (skb_cloned(frag))
-			frag = skb_copy(frag, GFP_ATOMIC);
+		*buf = NULL;
+		frag = skb_unshare(frag, GFP_ATOMIC);
 		if (unlikely(!frag))
 			goto err;
 		head = *headbuf = frag;
-		*buf = NULL;
 		TIPC_SKB_CB(head)->tail = NULL;
 		if (skb_is_nonlinear(head)) {
 			skb_walk_frags(head, tail) {


