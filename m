Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E11A2F6B3
	for <lists+stable@lfdr.de>; Tue, 30 Apr 2019 13:52:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730439AbfD3LvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 30 Apr 2019 07:51:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:38740 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731347AbfD3LvM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 30 Apr 2019 07:51:12 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B2C320449;
        Tue, 30 Apr 2019 11:51:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1556625071;
        bh=Dia8khkyeXuEmFqIkVPKZLv0GPdGtKJpyK5QhaOS6nA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=10LvycvOLEkBDX+VGmw7eNF2j/B99XgwrZnOyLz7H1zcwauNlYF4tkPDdkSWR8YTa
         JKfkw0qnesfbyCwJ085M9PvXplzb9NINtTluudw8ZkJsIbsPVhwwbfryb50jsysQs4
         /h5TbGqF4ViFfvKxqnD2DI67+fZnkaFypCzAOtH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        John Hurley <john.hurley@netronome.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.0 79/89] net/tls: fix refcount adjustment in fallback
Date:   Tue, 30 Apr 2019 13:39:10 +0200
Message-Id: <20190430113613.477214926@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190430113609.741196396@linuxfoundation.org>
References: <20190430113609.741196396@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>

[ Upstream commit 9188d5ca454fd665145904267e726e9e8d122f5c ]

Unlike atomic_add(), refcount_add() does not deal well
with a negative argument.  TLS fallback code reallocates
the skb and is very likely to shrink the truesize, leading to:

[  189.513254] WARNING: CPU: 5 PID: 0 at lib/refcount.c:81 refcount_add_not_zero_checked+0x15c/0x180
 Call Trace:
  refcount_add_checked+0x6/0x40
  tls_enc_skb+0xb93/0x13e0 [tls]

Once wmem_allocated count saturates the application can no longer
send data on the socket.  This is similar to Eric's fixes for GSO,
TCP:
commit 7ec318feeed1 ("tcp: gso: avoid refcount_t warning from tcp_gso_segment()")
and UDP:
commit 575b65bc5bff ("udp: avoid refcount_t saturation in __udp_gso_segment()").

Unlike the GSO case, for TLS fallback it's likely that the skb has
shrunk, so the "likely" annotation is the other way around (likely
branch being "sub").

Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: John Hurley <john.hurley@netronome.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/tls/tls_device_fallback.c |   13 ++++++++++---
 1 file changed, 10 insertions(+), 3 deletions(-)

--- a/net/tls/tls_device_fallback.c
+++ b/net/tls/tls_device_fallback.c
@@ -193,6 +193,9 @@ static void update_chksum(struct sk_buff
 
 static void complete_skb(struct sk_buff *nskb, struct sk_buff *skb, int headln)
 {
+	struct sock *sk = skb->sk;
+	int delta;
+
 	skb_copy_header(nskb, skb);
 
 	skb_put(nskb, skb->len);
@@ -200,11 +203,15 @@ static void complete_skb(struct sk_buff
 	update_chksum(nskb, headln);
 
 	nskb->destructor = skb->destructor;
-	nskb->sk = skb->sk;
+	nskb->sk = sk;
 	skb->destructor = NULL;
 	skb->sk = NULL;
-	refcount_add(nskb->truesize - skb->truesize,
-		     &nskb->sk->sk_wmem_alloc);
+
+	delta = nskb->truesize - skb->truesize;
+	if (likely(delta < 0))
+		WARN_ON_ONCE(refcount_sub_and_test(-delta, &sk->sk_wmem_alloc));
+	else if (delta)
+		refcount_add(delta, &sk->sk_wmem_alloc);
 }
 
 /* This function may be called after the user socket is already


