Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2BD7F1BC933
	for <lists+stable@lfdr.de>; Tue, 28 Apr 2020 20:40:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730740AbgD1Sje (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Apr 2020 14:39:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:58380 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730870AbgD1Sjd (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 28 Apr 2020 14:39:33 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 489A62085B;
        Tue, 28 Apr 2020 18:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588099172;
        bh=PDn7z5TjoQE7tSSAS//QLkvjBMmkHUo1fAqHroZxP34=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BwYCF2tSlzcr9YfYkG+h5IAiCqqpH79QJ+zdSh7jVCQAF1LL6l21COd5luJ2iJOaK
         LbCsAIeKAhDKVVqfFvL0If+ufr8ag4HYXXTh7qylSasY+wShSoSjYjaQYTpkvwOFYD
         rt977W2+aKsKqbJY17Mw9SeoHnDgd+/kyoHvBRVY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 068/168] net/x25: Fix x25_neigh refcnt leak when receiving frame
Date:   Tue, 28 Apr 2020 20:24:02 +0200
Message-Id: <20200428182240.523297736@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200428182231.704304409@linuxfoundation.org>
References: <20200428182231.704304409@linuxfoundation.org>
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
@@ -115,8 +115,10 @@ int x25_lapb_receive_frame(struct sk_buf
 		goto drop;
 	}
 
-	if (!pskb_may_pull(skb, 1))
+	if (!pskb_may_pull(skb, 1)) {
+		x25_neigh_put(nb);
 		return 0;
+	}
 
 	switch (skb->data[0]) {
 


