Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD42123A511
	for <lists+stable@lfdr.de>; Mon,  3 Aug 2020 14:33:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729392AbgHCMdE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 3 Aug 2020 08:33:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:32846 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729386AbgHCMdC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 3 Aug 2020 08:33:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 27DE3204EC;
        Mon,  3 Aug 2020 12:33:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596457981;
        bh=0Aup74NOSS42XQ7aEIwZYIA0RB6k4tahoOrwdO6yJoc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aHouRpdtEiNUA954OAhLcSwwkYxP/f+Sb9wVQ7934gsCuYSPj7aSdd3ZIsIDc2rEz
         4VJQKnozglM3YuF/k5VqB+TRfSHtz2U8FfjsjSEZL5EZGW3prnrK1PXJ1FLPaJczFq
         xgzu44Oskavjgr2F0x7rZ4rRRuUiQMWSWevjFhFQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 25/56] net/x25: Fix x25_neigh refcnt leak when x25 disconnect
Date:   Mon,  3 Aug 2020 14:19:40 +0200
Message-Id: <20200803121851.567113942@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200803121850.306734207@linuxfoundation.org>
References: <20200803121850.306734207@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

commit 4becb7ee5b3d2829ed7b9261a245a77d5b7de902 upstream.

x25_connect() invokes x25_get_neigh(), which returns a reference of the
specified x25_neigh object to "x25->neighbour" with increased refcnt.

When x25 connect success and returns, the reference still be hold by
"x25->neighbour", so the refcount should be decreased in
x25_disconnect() to keep refcount balanced.

The reference counting issue happens in x25_disconnect(), which forgets
to decrease the refcnt increased by x25_get_neigh() in x25_connect(),
causing a refcnt leak.

Fix this issue by calling x25_neigh_put() before x25_disconnect()
returns.

Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/x25/x25_subr.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/net/x25/x25_subr.c
+++ b/net/x25/x25_subr.c
@@ -362,6 +362,10 @@ void x25_disconnect(struct sock *sk, int
 		sk->sk_state_change(sk);
 		sock_set_flag(sk, SOCK_DEAD);
 	}
+	read_lock_bh(&x25_list_lock);
+	x25_neigh_put(x25->neighbour);
+	x25->neighbour = NULL;
+	read_unlock_bh(&x25_list_lock);
 }
 
 /*


