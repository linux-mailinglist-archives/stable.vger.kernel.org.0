Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B15081EAD37
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:44:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730327AbgFASKy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:10:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:57910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730308AbgFASKx (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:10:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E40F4206E2;
        Mon,  1 Jun 2020 18:10:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591035053;
        bh=S2SI/ZGiBbnJng5OesmlFF79jiK584W1YvWabB6Yq4A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XjLwQXFHG9yPLCjdO+p57UYueBtoX1XHuuXCI1fczi6mmjetS68r1Lk4cPDQXs9up
         sjnRaeumZ1OYzv9U5lqorBhU2mJDSEP6mMtriECUIhfxobMVEXGB2MNs2GM0qe4epx
         ufn6Wbmymq8kHNTCC52CVnt4orzSkyBGLVNcht5g=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>,
        Vinay Kumar Yadav <vinay.yadav@chelsio.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 131/142] crypto: chelsio/chtls: properly set tp->lsndtime
Date:   Mon,  1 Jun 2020 19:54:49 +0200
Message-Id: <20200601174051.334241879@linuxfoundation.org>
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
@@ -682,7 +682,7 @@ int chtls_push_frames(struct chtls_sock
 				make_tx_data_wr(sk, skb, immdlen, len,
 						credits_needed, completion);
 			tp->snd_nxt += len;
-			tp->lsndtime = tcp_time_stamp(tp);
+			tp->lsndtime = tcp_jiffies32;
 			if (completion)
 				ULP_SKB_CB(skb)->flags &= ~ULPCB_FLAG_NEED_HDR;
 		} else {


