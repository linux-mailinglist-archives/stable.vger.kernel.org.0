Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA9122A16DC
	for <lists+stable@lfdr.de>; Sat, 31 Oct 2020 12:51:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727252AbgJaLlV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 31 Oct 2020 07:41:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:40396 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727146AbgJaLlT (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 31 Oct 2020 07:41:19 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3DB1920731;
        Sat, 31 Oct 2020 11:41:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604144478;
        bh=tas5cm9xxl8iJAKYimul3Q9oDvKpwNk4kkBAmDm6xj4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=zhH6Su+wA6CtoaLNTSs5WeQhbM0nnL79QErwRjiUzhXTQ3trE3pN1asEKUxCKRlnn
         Xkvkztcc9eBb/FYoB7OYJenyWk68voNisbfFcz1xL5QGvvg7BAdrJPWWTiChKScZvM
         tCaAoz5+xLXYk/TEe7vdoIvIiZIWwmQN19wWIGk8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 34/70] chelsio/chtls: fix tls record info to user
Date:   Sat, 31 Oct 2020 12:36:06 +0100
Message-Id: <20201031113501.132118417@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201031113459.481803250@linuxfoundation.org>
References: <20201031113459.481803250@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

[ Upstream commit 4f3391ce8f5a69e7e6d66d0a3fc654eb6dbdc919 ]

chtls_pt_recvmsg() receives a skb with tls header and subsequent
skb with data, need to finalize the data copy whenever next skb
with tls header is available. but here current tls header is
overwritten by next available tls header, ends up corrupting
user buffer data. fixing it by finalizing current record whenever
next skb contains tls header.

v1->v2:
- Improved commit message.

Fixes: 17a7d24aa89d ("crypto: chtls - generic handling of data and hdr")
Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Link: https://lore.kernel.org/r/20201022190556.21308-1-vinay.yadav@chelsio.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/crypto/chelsio/chtls/chtls_io.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -1585,6 +1585,7 @@ skip_copy:
 			tp->urg_data = 0;
 
 		if ((avail + offset) >= skb->len) {
+			struct sk_buff *next_skb;
 			if (ULP_SKB_CB(skb)->flags & ULPCB_FLAG_TLS_HDR) {
 				tp->copied_seq += skb->len;
 				hws->rcvpld = skb->hdr_len;
@@ -1595,8 +1596,10 @@ skip_copy:
 			chtls_free_skb(sk, skb);
 			buffers_freed++;
 			hws->copied_seq = 0;
-			if (copied >= target &&
-			    !skb_peek(&sk->sk_receive_queue))
+			next_skb = skb_peek(&sk->sk_receive_queue);
+			if (copied >= target && !next_skb)
+				break;
+			if (ULP_SKB_CB(next_skb)->flags & ULPCB_FLAG_TLS_HDR)
 				break;
 		}
 	} while (len > 0);


