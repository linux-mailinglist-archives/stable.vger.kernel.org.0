Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 517F92A5571
	for <lists+stable@lfdr.de>; Tue,  3 Nov 2020 22:21:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388488AbgKCVSV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Nov 2020 16:18:21 -0500
Received: from mail.kernel.org ([198.145.29.99]:49424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388436AbgKCVJY (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 3 Nov 2020 16:09:24 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F34C520757;
        Tue,  3 Nov 2020 21:09:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604437763;
        bh=JLcEgLdL/kL4nRVPKC9wWdDIZP3QmaLJDeSXO5Gt35Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=07OP5VVzl6E3dRAWDt+nomVam5Ynr8Ww7aj4/dWkkjNwS3npYukx95HdmHQq/TU5A
         mpbaNhZ2R5UQdLam+C4QaoAm78ohiEIFvmiFZx8g4oAwFnpPIynphMlMySKN+vcwRu
         mJAQIECOn86BAz9+jilRoGGqzjrlZ1D6z2AInWWM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jon Maloy <jmaloy@redhat.com>,
        Thang Hoang Ngo <thang.h.ngo@dektech.com.au>,
        Tung Nguyen <tung.q.nguyen@dektech.com.au>,
        Xin Long <lucien.xin@gmail.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 4.14 006/125] tipc: fix memory leak caused by tipc_buf_append()
Date:   Tue,  3 Nov 2020 21:36:23 +0100
Message-Id: <20201103203157.313415426@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201103203156.372184213@linuxfoundation.org>
References: <20201103203156.372184213@linuxfoundation.org>
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
@@ -140,12 +140,11 @@ int tipc_buf_append(struct sk_buff **hea
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


