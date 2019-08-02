Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 849AC7F295
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:49:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405550AbfHBJqX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:46:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:50564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2405546AbfHBJqV (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:46:21 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1200020880;
        Fri,  2 Aug 2019 09:46:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564739180;
        bh=won/3C//qnNMfS6DL9yndOAUy2B8vGvUBvsYexyleiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XR2h4KrzpES65aGmlEQz23hEYeq6w5KLRVCl0mHHDDgtL/Iu61JdZrKb7Fc06E+hB
         hqk7D3YYAGt9OCqf8NDnFN8rfTRzqWveblAiu88YF5p4Pu0h31AojrpNEO5Nx7GPPl
         RtLeb+/xxsWLIO32ffI22tzgkrCLOAw2u5YEnLSY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 144/223] netrom: fix a memory leak in nr_rx_frame()
Date:   Fri,  2 Aug 2019 11:36:09 +0200
Message-Id: <20190802092247.972811748@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092238.692035242@linuxfoundation.org>
References: <20190802092238.692035242@linuxfoundation.org>
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
@@ -870,7 +870,7 @@ int nr_rx_frame(struct sk_buff *skb, str
 	unsigned short frametype, flags, window, timeout;
 	int ret;
 
-	skb->sk = NULL;		/* Initially we don't know who it's for */
+	skb_orphan(skb);
 
 	/*
 	 *	skb->data points to the netrom frame start
@@ -969,6 +969,7 @@ int nr_rx_frame(struct sk_buff *skb, str
 	window = skb->data[20];
 
 	skb->sk             = make;
+	skb->destructor     = sock_efree;
 	make->sk_state	    = TCP_ESTABLISHED;
 
 	/* Fill in his circuit details */


