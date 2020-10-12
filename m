Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBE1B28B8B0
	for <lists+stable@lfdr.de>; Mon, 12 Oct 2020 15:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390153AbgJLNyd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Oct 2020 09:54:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:48502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389725AbgJLNpw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Oct 2020 09:45:52 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF17B22280;
        Mon, 12 Oct 2020 13:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602510287;
        bh=HRDv39Xla1NMyf8uCl6RKkjVzCPjBkY8NBYynyoZq3g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=wcNh0OGVrnmk5+cHZ+2UxgkxUBtdrLcMyyWHcmJlJA/bVPIscdE/LoLGlywYniNqI
         NRpUGil6RNjfzKIgwWK2ftSk8Vc1/pvUuDTNI8pVjqWS6ddl9Be60UWioUzm2Q9v/5
         d5xL2ZSQkHzKzO+WnC6CbV6YBTMAUfoiIOxx38jk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Xiumei Mu <xmu@redhat.com>,
        Sabrina Dubroca <sd@queasysnail.net>,
        Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.8 035/124] espintcp: restore IP CB before handing the packet to xfrm
Date:   Mon, 12 Oct 2020 15:30:39 +0200
Message-Id: <20201012133148.549483577@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201012133146.834528783@linuxfoundation.org>
References: <20201012133146.834528783@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sabrina Dubroca <sd@queasysnail.net>

commit 4eb2e13415757a2bce5bb0d580d22bbeef1f5346 upstream.

Xiumei reported a bug with espintcp over IPv6 in transport mode,
because xfrm6_transport_finish expects to find IP6CB data (struct
inet6_skb_cb). Currently, espintcp zeroes the CB, but the relevant
part is actually preserved by previous layers (first set up by tcp,
then strparser only zeroes a small part of tcp_skb_tb), so we can just
relocate it to the start of skb->cb.

Fixes: e27cca96cd68 ("xfrm: add espintcp (RFC 8229)")
Reported-by: Xiumei Mu <xmu@redhat.com>
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/xfrm/espintcp.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/net/xfrm/espintcp.c
+++ b/net/xfrm/espintcp.c
@@ -29,8 +29,12 @@ static void handle_nonesp(struct espintc
 
 static void handle_esp(struct sk_buff *skb, struct sock *sk)
 {
+	struct tcp_skb_cb *tcp_cb = (struct tcp_skb_cb *)skb->cb;
+
 	skb_reset_transport_header(skb);
-	memset(skb->cb, 0, sizeof(skb->cb));
+
+	/* restore IP CB, we need at least IP6CB->nhoff */
+	memmove(skb->cb, &tcp_cb->header, sizeof(tcp_cb->header));
 
 	rcu_read_lock();
 	skb->dev = dev_get_by_index_rcu(sock_net(sk), skb->skb_iif);


