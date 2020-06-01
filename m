Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3ED1EAAAD
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:11:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgFASK0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:57160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730990AbgFASKX (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:23 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8E76E2077D;
        Mon,  1 Jun 2020 18:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035022;
        bh=mSY6GPV+wUi0r7Ri6uN32T0DfG/wRgeooF1ikJq+pIk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rMaetlvgNtPDBSndyGg15M6bfbj4hIdKSDN351c76IXK01lDyNDS9iASNFhAyNj6+
         Bdurz2JTWJ2+CkblOm9IER+OpMqG+JBv7i+hEI0ZQWxdGGKlqibfSZop9Q+I/CbHeK
         xtW2akv1zo/w45bYkZ+kxj5rMGufE3ZrxD9RuXGY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.4 118/142] xfrm: fix a NULL-ptr deref in xfrm_local_error
Date:   Mon,  1 Jun 2020 19:54:36 +0200
Message-Id: <20200601174050.079724026@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

commit f6a23d85d078c2ffde79c66ca81d0a1dde451649 upstream.

This patch is to fix a crash:

  [ ] kasan: GPF could be caused by NULL-ptr deref or user memory access
  [ ] general protection fault: 0000 [#1] SMP KASAN PTI
  [ ] RIP: 0010:ipv6_local_error+0xac/0x7a0
  [ ] Call Trace:
  [ ]  xfrm6_local_error+0x1eb/0x300
  [ ]  xfrm_local_error+0x95/0x130
  [ ]  __xfrm6_output+0x65f/0xb50
  [ ]  xfrm6_output+0x106/0x46f
  [ ]  udp_tunnel6_xmit_skb+0x618/0xbf0 [ip6_udp_tunnel]
  [ ]  vxlan_xmit_one+0xbc6/0x2c60 [vxlan]
  [ ]  vxlan_xmit+0x6a0/0x4276 [vxlan]
  [ ]  dev_hard_start_xmit+0x165/0x820
  [ ]  __dev_queue_xmit+0x1ff0/0x2b90
  [ ]  ip_finish_output2+0xd3e/0x1480
  [ ]  ip_do_fragment+0x182d/0x2210
  [ ]  ip_output+0x1d0/0x510
  [ ]  ip_send_skb+0x37/0xa0
  [ ]  raw_sendmsg+0x1b4c/0x2b80
  [ ]  sock_sendmsg+0xc0/0x110

This occurred when sending a v4 skb over vxlan6 over ipsec, in which case
skb->protocol == htons(ETH_P_IPV6) while skb->sk->sk_family == AF_INET in
xfrm_local_error(). Then it will go to xfrm6_local_error() where it tries
to get ipv6 info from a ipv4 sk.

This issue was actually fixed by Commit 628e341f319f ("xfrm: make local
error reporting more robust"), but brought back by Commit 844d48746e4b
("xfrm: choose protocol family by skb protocol").

So to fix it, we should call xfrm6_local_error() only when skb->protocol
is htons(ETH_P_IPV6) and skb->sk->sk_family is AF_INET6.

Fixes: 844d48746e4b ("xfrm: choose protocol family by skb protocol")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/xfrm_output.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/net/xfrm/xfrm_output.c
+++ b/net/xfrm/xfrm_output.c
@@ -645,7 +645,8 @@ void xfrm_local_error(struct sk_buff *sk
 
 	if (skb->protocol == htons(ETH_P_IP))
 		proto = AF_INET;
-	else if (skb->protocol == htons(ETH_P_IPV6))
+	else if (skb->protocol == htons(ETH_P_IPV6) &&
+		 skb->sk->sk_family == AF_INET6)
 		proto = AF_INET6;
 	else
 		return;


