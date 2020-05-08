Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 860F91CB00B
	for <lists+stable@lfdr.de>; Fri,  8 May 2020 15:24:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728362AbgEHNX1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 8 May 2020 09:23:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:53906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728378AbgEHMiY (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 8 May 2020 08:38:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8B94024968;
        Fri,  8 May 2020 12:38:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588941504;
        bh=YiG3H9HqTXW2QqFS7PgVLcz+lfygo584WVKmM9d3lao=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=a3hfeaNf4LYQ6c2Q3V9Ah5/6Z1xzpUsKdiUlB90oUUaeEPEV6bQ3zq0U0mbVoQ6uI
         IMFku5TUFvICK1RftnYEz6qg6ko2oTSFcP7VzclaHUqlNdK47OngBXV2xE3oE3fJMe
         rknFHBDUYW8x5VD3T4cW74pDECS6y0fSuNYW8+KE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Willem de Bruijn <willemb@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.4 057/312] dccp: limit sk_filter trim to payload
Date:   Fri,  8 May 2020 14:30:48 +0200
Message-Id: <20200508123128.569712900@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200508123124.574959822@linuxfoundation.org>
References: <20200508123124.574959822@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willem de Bruijn <willemb@google.com>

commit 4f0c40d94461cfd23893a17335b2ab78ecb333c8 upstream.

Dccp verifies packet integrity, including length, at initial rcv in
dccp_invalid_packet, later pulls headers in dccp_enqueue_skb.

A call to sk_filter in-between can cause __skb_pull to wrap skb->len.
skb_copy_datagram_msg interprets this as a negative value, so
(correctly) fails with EFAULT. The negative length is reported in
ioctl SIOCINQ or possibly in a DCCP_WARN in dccp_close.

Introduce an sk_receive_skb variant that caps how small a filter
program can trim packets, and call this in dccp with the header
length. Excessively trimmed packets are now processed normally and
queued for reception as 0B payloads.

Fixes: 7c657876b63c ("[DCCP]: Initial implementation")
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 include/net/sock.h |    8 +++++++-
 net/core/sock.c    |    7 ++++---
 net/dccp/ipv4.c    |    2 +-
 net/dccp/ipv6.c    |    2 +-
 4 files changed, 13 insertions(+), 6 deletions(-)

--- a/include/net/sock.h
+++ b/include/net/sock.h
@@ -1651,7 +1651,13 @@ static inline void sock_put(struct sock
  */
 void sock_gen_put(struct sock *sk);
 
-int sk_receive_skb(struct sock *sk, struct sk_buff *skb, const int nested);
+int __sk_receive_skb(struct sock *sk, struct sk_buff *skb, const int nested,
+		     unsigned int trim_cap);
+static inline int sk_receive_skb(struct sock *sk, struct sk_buff *skb,
+				 const int nested)
+{
+	return __sk_receive_skb(sk, skb, nested, 1);
+}
 
 static inline void sk_tx_queue_set(struct sock *sk, int tx_queue)
 {
--- a/net/core/sock.c
+++ b/net/core/sock.c
@@ -484,11 +484,12 @@ int sock_queue_rcv_skb(struct sock *sk,
 }
 EXPORT_SYMBOL(sock_queue_rcv_skb);
 
-int sk_receive_skb(struct sock *sk, struct sk_buff *skb, const int nested)
+int __sk_receive_skb(struct sock *sk, struct sk_buff *skb,
+		     const int nested, unsigned int trim_cap)
 {
 	int rc = NET_RX_SUCCESS;
 
-	if (sk_filter(sk, skb))
+	if (sk_filter_trim_cap(sk, skb, trim_cap))
 		goto discard_and_relse;
 
 	skb->dev = NULL;
@@ -524,7 +525,7 @@ discard_and_relse:
 	kfree_skb(skb);
 	goto out;
 }
-EXPORT_SYMBOL(sk_receive_skb);
+EXPORT_SYMBOL(__sk_receive_skb);
 
 struct dst_entry *__sk_dst_check(struct sock *sk, u32 cookie)
 {
--- a/net/dccp/ipv4.c
+++ b/net/dccp/ipv4.c
@@ -868,7 +868,7 @@ lookup:
 		goto discard_and_relse;
 	nf_reset(skb);
 
-	return sk_receive_skb(sk, skb, 1);
+	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4);
 
 no_dccp_socket:
 	if (!xfrm4_policy_check(NULL, XFRM_POLICY_IN, skb))
--- a/net/dccp/ipv6.c
+++ b/net/dccp/ipv6.c
@@ -741,7 +741,7 @@ lookup:
 	if (!xfrm6_policy_check(sk, XFRM_POLICY_IN, skb))
 		goto discard_and_relse;
 
-	return sk_receive_skb(sk, skb, 1) ? -1 : 0;
+	return __sk_receive_skb(sk, skb, 1, dh->dccph_doff * 4) ? -1 : 0;
 
 no_dccp_socket:
 	if (!xfrm6_policy_check(NULL, XFRM_POLICY_IN, skb))


