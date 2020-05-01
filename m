Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B67941C12F5
	for <lists+stable@lfdr.de>; Fri,  1 May 2020 15:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgEANZu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 1 May 2020 09:25:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:46942 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729103AbgEANZq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 1 May 2020 09:25:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3102D208D6;
        Fri,  1 May 2020 13:25:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588339546;
        bh=1bJXgS9EGSsKXLluKrL63N6r/YnFN67KmUdN1uqhg/E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qy5r1JfOsJMqU3m1VPMcqENC3r9++OFfGUnbbTBKwb5a6q8eETPENq4i0D4Lj9NlS
         aJVDEsasO+SnWvkU5A6jPyN/ME69Q3bgdf01xovEtIU1MrEFi4yXvG+QgrgDS7txcE
         BtG+RfQV6RceJhf0rtNfIi/9bJSXwFyk6uv/6O5M=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiyu Yang <xiyuyang19@fudan.edu.cn>,
        Xin Tan <tanxin.ctf@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 21/70] net/x25: Fix x25_neigh refcnt leak when receiving frame
Date:   Fri,  1 May 2020 15:21:09 +0200
Message-Id: <20200501131520.809525053@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200501131513.302599262@linuxfoundation.org>
References: <20200501131513.302599262@linuxfoundation.org>
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
 


