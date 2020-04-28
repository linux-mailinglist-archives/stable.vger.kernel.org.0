Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB9F1BCB44
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:56:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729982AbgD1Sds (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:33:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:50308 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729975AbgD1Sdp (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:33:45 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5327621835;
        Tue, 28 Apr 2020 18:33:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588098824;
        bh=1bJXgS9EGSsKXLluKrL63N6r/YnFN67KmUdN1uqhg/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1RDm59Y6ocUZgEO2JO6OlR2DUpqKpc0MkN6HSmzKuxejMX3B+HHckEQBFrumu7lL7
         RSD3eGh7O1VJ2bKje4dZ4I57havyHwr/3O114eNMul8HZ3+Cb6q8CgvLSwGgoY7xpT
         JzewWZ5ITmQG+ihNRbI7lPLcOF9y3+Jy7g0m3Jwc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 061/131] net/x25: Fix x25_neigh refcnt leak when receiving frame
Date:   Tue, 28 Apr 2020 20:24:33 +0200
Message-Id: <20200428182232.644879270@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182224.822179290@linuxfoundation.org>
References: <20200428182224.822179290@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xiyu Yang <xiyuyang19@fudan.edu.cn>

[ Upstream commit f35d12971b4d814cdb2f659d76b42f0c545270b6 ]

x25_lapb_receive_frame() invokes x25_get_neigh(), which returns a
reference of the specified x25_neigh object to "nb" with increased
refcnt.

When x25_lapb_receive_frame() returns, local variable "nb" becomes
invalid, so the refcount should be decreased to keep refcount balanced.

The reference counting issue happens in one path of
x25_lapb_receive_frame(). When pskb_may_pull() returns false, the
function forgets to decrease the refcnt increased by x25_get_neigh(),
causing a refcnt leak.

Fix this issue by calling x25_neigh_put() when pskb_may_pull() returns
false.

Fixes: cb101ed2c3c7 ("x25: Handle undersized/fragmented skbs")
Signed-off-by: Xiyu Yang <xiyuyang19@fudan.edu.cn>
Signed-off-by: Xin Tan <tanxin.ctf@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/x25/x25_dev.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/net/x25/x25_dev.c
+++ b/net/x25/x25_dev.c
@@ -120,8 +120,10 @@ int x25_lapb_receive_frame(struct sk_buf
 		goto drop;
 	}
 
-	if (!pskb_may_pull(skb, 1))
+	if (!pskb_may_pull(skb, 1)) {
+		x25_neigh_put(nb);
 		return 0;
+	}
 
 	switch (skb->data[0]) {
 


