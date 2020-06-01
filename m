Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 177961EAE06
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:50:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgFASFu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:05:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:50994 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727875AbgFASFq (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:05:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3576E206E2;
        Mon,  1 Jun 2020 18:05:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034745;
        bh=Qr5v3sY4zDvVsYmbz2qcrOzPLFgTZAkXnyLn+oMJwXY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9B/Ob4Lm3XVv5pleDaoV/+oqOiAPF7U9+frl4pc2FO2fSxYMxUjNo7YLBIZf+hiz
         iVl6LmHYV3EB7++d6fnQGLNMhLxB5q/uVQ0kchWtzRS6+Zu32DXl2MTg7XP0w5/eWo
         kTDe32cWrCAybonsPBOOJEF15zAxpR/tT2XyUhJ0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 91/95] crypto: chelsio/chtls: properly set tp->lsndtime
Date:   Mon,  1 Jun 2020 19:54:31 +0200
Message-Id: <20200601174034.277040237@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174020.759151073@linuxfoundation.org>
References: <20200601174020.759151073@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

commit a4976a3ef844c510ae9120290b23e9f3f47d6bce upstream.

TCP tp->lsndtime unit/base is tcp_jiffies32, not tcp_time_stamp()

Fixes: 36bedb3f2e5b ("crypto: chtls - Inline TLS record Tx")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Ayush Sawal <ayush.sawal@chelsio.com>
Cc: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/crypto/chelsio/chtls/chtls_io.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/crypto/chelsio/chtls/chtls_io.c
+++ b/drivers/crypto/chelsio/chtls/chtls_io.c
@@ -686,7 +686,7 @@ int chtls_push_frames(struct chtls_sock
 				make_tx_data_wr(sk, skb, immdlen, len,
 						credits_needed, completion);
 			tp->snd_nxt += len;
-			tp->lsndtime = tcp_time_stamp(tp);
+			tp->lsndtime = tcp_jiffies32;
 			if (completion)
 				ULP_SKB_CB(skb)->flags &= ~ULPCB_FLAG_NEED_HDR;
 		} else {


