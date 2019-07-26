Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AEA4C76DD7
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:37:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389014AbfGZPaJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:30:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:45032 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388976AbfGZPaJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:30:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 83CB922CBD;
        Fri, 26 Jul 2019 15:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564155009;
        bh=FAbVGOf/4NqrHRC4j4DAffgINtihHAgReaZlF9DfIQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G8sITXrfofE2+jaxRfDBf1APKkO3fIQFSQh7oZV27ReuP4uuvzi/KLBjOc0MaaKvU
         JjVFDVnwRbIZxRuHKciNMKCh4znejdA3m704E1/uhx2efD5LqdbUwM5frvTWLmvNOe
         HjW2FKSllGqYh1A3nimRPVHGyY1cRb6qDn5Bextg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.1 34/62] netrom: fix a memory leak in nr_rx_frame()
Date:   Fri, 26 Jul 2019 17:24:46 +0200
Message-Id: <20190726152305.465612703@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.720139286@linuxfoundation.org>
References: <20190726152301.720139286@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Cong Wang <xiyou.wangcong@gmail.com>

[ Upstream commit c8c8218ec5af5d2598381883acbefbf604e56b5e ]

When the skb is associated with a new sock, just assigning
it to skb->sk is not sufficient, we have to set its destructor
to free the sock properly too.

Reported-by: syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/netrom/af_netrom.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/netrom/af_netrom.c
+++ b/net/netrom/af_netrom.c
@@ -872,7 +872,7 @@ int nr_rx_frame(struct sk_buff *skb, str
 	unsigned short frametype, flags, window, timeout;
 	int ret;
 
-	skb->sk = NULL;		/* Initially we don't know who it's for */
+	skb_orphan(skb);
 
 	/*
 	 *	skb->data points to the netrom frame start
@@ -971,6 +971,7 @@ int nr_rx_frame(struct sk_buff *skb, str
 	window = skb->data[20];
 
 	skb->sk             = make;
+	skb->destructor     = sock_efree;
 	make->sk_state	    = TCP_ESTABLISHED;
 
 	/* Fill in his circuit details */


