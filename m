Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE7CF76DF2
	for <lists+stable@lfdr.de>; Fri, 26 Jul 2019 17:40:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388106AbfGZP06 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 26 Jul 2019 11:26:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:41058 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388153AbfGZP05 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 26 Jul 2019 11:26:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF68D205F4;
        Fri, 26 Jul 2019 15:26:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564154817;
        bh=J9mVdvHRsyD18vZN+RHx+sUHusiwj/x9TMSWTGX0uQU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hbsHcK2X3bVPGGCp2xUdHC14PbLqW0lrZ4RA1Z6Z2Sy/Lm6LWmEtzgSO+Jxd/zfIW
         VCCnAE0i+flEXfx8xt+P+lxCT9dOJmOTe11ia+5Dexm5DHxuIBiPaR50YQynaYyd+Y
         utC0biokDfuOHXQho/3G3OXPmeaZ2do+GOpnmn+g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+d6636a36d3c34bd88938@syzkaller.appspotmail.com,
        Cong Wang <xiyou.wangcong@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.2 34/66] netrom: fix a memory leak in nr_rx_frame()
Date:   Fri, 26 Jul 2019 17:24:33 +0200
Message-Id: <20190726152305.671081836@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190726152301.936055394@linuxfoundation.org>
References: <20190726152301.936055394@linuxfoundation.org>
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
@@ -869,7 +869,7 @@ int nr_rx_frame(struct sk_buff *skb, str
 	unsigned short frametype, flags, window, timeout;
 	int ret;
 
-	skb->sk = NULL;		/* Initially we don't know who it's for */
+	skb_orphan(skb);
 
 	/*
 	 *	skb->data points to the netrom frame start
@@ -968,6 +968,7 @@ int nr_rx_frame(struct sk_buff *skb, str
 	window = skb->data[20];
 
 	skb->sk             = make;
+	skb->destructor     = sock_efree;
 	make->sk_state	    = TCP_ESTABLISHED;
 
 	/* Fill in his circuit details */


