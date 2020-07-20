Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 111B3226B9A
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 18:43:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729430AbgGTPme (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:42:34 -0400
Received: from mail.kernel.org ([198.145.29.99]:35442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730094AbgGTPmb (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:42:31 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1C75120773;
        Mon, 20 Jul 2020 15:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595259750;
        bh=hC4pvOV0218MlFHhrKJk2sI41gTgfZF5zc1K89z40po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GPiSaUPO3tqtF9BmUsvfTGvJa4jvpNOqI+iXaqvJ8cCC3zash0PrCFtwU2RV8mc6S
         3+YdU28e0c0ubykBEqBVmL3kmOW5vHzJ/TW61DYeCw3Kcz/XKHnYxkx4o4JEAOuM1S
         LMf2K06n1Gezx4yksdONtM7/t+sq2ZO/Mopd1PAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 36/86] tcp: md5: do not send silly options in SYNCOOKIES
Date:   Mon, 20 Jul 2020 17:36:32 +0200
Message-Id: <20200720152754.980513276@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152753.138974850@linuxfoundation.org>
References: <20200720152753.138974850@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit e114e1e8ac9d31f25b9dd873bab5d80c1fc482ca ]

Whenever cookie_init_timestamp() has been used to encode
ECN,SACK,WSCALE options, we can not remove the TS option in the SYNACK.

Otherwise, tcp_synack_options() will still advertize options like WSCALE
that we can not deduce later when receiving the packet from the client
to complete 3WHS.

Note that modern linux TCP stacks wont use MD5+TS+SACK in a SYN packet,
but we can not know for sure that all TCP stacks have the same logic.

Before the fix a tcpdump would exhibit this wrong exchange :

10:12:15.464591 IP C > S: Flags [S], seq 4202415601, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 456965269 ecr 0,nop,wscale 8], length 0
10:12:15.464602 IP S > C: Flags [S.], seq 253516766, ack 4202415602, win 65535, options [nop,nop,md5 valid,mss 1400,nop,nop,sackOK,nop,wscale 8], length 0
10:12:15.464611 IP C > S: Flags [.], ack 1, win 256, options [nop,nop,md5 valid], length 0
10:12:15.464678 IP C > S: Flags [P.], seq 1:13, ack 1, win 256, options [nop,nop,md5 valid], length 12
10:12:15.464685 IP S > C: Flags [.], ack 13, win 65535, options [nop,nop,md5 valid], length 0

After this patch the exchange looks saner :

11:59:59.882990 IP C > S: Flags [S], seq 517075944, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 1751508483 ecr 0,nop,wscale 8], length 0
11:59:59.883002 IP S > C: Flags [S.], seq 1902939253, ack 517075945, win 65535, options [nop,nop,md5 valid,mss 1400,sackOK,TS val 1751508479 ecr 1751508483,nop,wscale 8], length 0
11:59:59.883012 IP C > S: Flags [.], ack 1, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508479], length 0
11:59:59.883114 IP C > S: Flags [P.], seq 1:13, ack 1, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508479], length 12
11:59:59.883122 IP S > C: Flags [.], ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508483 ecr 1751508483], length 0
11:59:59.883152 IP S > C: Flags [P.], seq 1:13, ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508484 ecr 1751508483], length 12
11:59:59.883170 IP C > S: Flags [.], ack 13, win 256, options [nop,nop,md5 valid,nop,nop,TS val 1751508484 ecr 1751508484], length 0

Of course, no SACK block will ever be added later, but nothing should break.
Technically, we could remove the 4 nops included in MD5+TS options,
but again some stacks could break seeing not conventional alignment.

Fixes: 4957faade11b ("TCPCT part 1g: Responder Cookie => Initiator")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Florian Westphal <fw@strlen.de>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |   10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -615,7 +615,8 @@ static unsigned int tcp_synack_options(s
 				       unsigned int mss, struct sk_buff *skb,
 				       struct tcp_out_options *opts,
 				       const struct tcp_md5sig_key *md5,
-				       struct tcp_fastopen_cookie *foc)
+				       struct tcp_fastopen_cookie *foc,
+				       enum tcp_synack_type synack_type)
 {
 	struct inet_request_sock *ireq = inet_rsk(req);
 	unsigned int remaining = MAX_TCP_OPTION_SPACE;
@@ -630,7 +631,8 @@ static unsigned int tcp_synack_options(s
 		 * rather than TS in order to fit in better with old,
 		 * buggy kernels, but that was deemed to be unnecessary.
 		 */
-		ireq->tstamp_ok &= !ireq->sack_ok;
+		if (synack_type != TCP_SYNACK_COOKIE)
+			ireq->tstamp_ok &= !ireq->sack_ok;
 	}
 #endif
 
@@ -3165,8 +3167,8 @@ struct sk_buff *tcp_make_synack(const st
 	md5 = tcp_rsk(req)->af_specific->req_md5_lookup(sk, req_to_sk(req));
 #endif
 	skb_set_hash(skb, tcp_rsk(req)->txhash, PKT_HASH_TYPE_L4);
-	tcp_header_size = tcp_synack_options(req, mss, skb, &opts, md5, foc) +
-			  sizeof(*th);
+	tcp_header_size = tcp_synack_options(req, mss, skb, &opts, md5,
+					     foc, synack_type) + sizeof(*th);
 
 	skb_push(skb, tcp_header_size);
 	skb_reset_transport_header(skb);


