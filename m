Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2DB838DACE
	for <lists+stable@lfdr.de>; Wed, 14 Aug 2019 19:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728784AbfHNRUn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 14 Aug 2019 13:20:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:33116 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730129AbfHNRKY (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 14 Aug 2019 13:10:24 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17CF82133F;
        Wed, 14 Aug 2019 17:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565802623;
        bh=tOPneCiU3dnJ2IqXOI7xEijvZxNxzuf6Zmq9V0z+500=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W+/xf697LYG1jPcDt5YdmdQGGPNqz994osqzmDzMY/++B7USTYPXtrxAjjZaWgo/B
         AnD58qHpZX9rHRClgeEvm8MoKdOcDejZrNunUYk8oC/NBFCegdzPZe3crpuC1CVLTB
         Fldg8C3kAlwjxLzTXG2/KJOXz0wCGi5X1KB20Gvk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Jankowski <shasta@toxcorp.com>,
        Florian Westphal <fw@strlen.de>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 36/91] netfilter: conntrack: always store window size un-scaled
Date:   Wed, 14 Aug 2019 19:00:59 +0200
Message-Id: <20190814165751.214416473@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190814165748.991235624@linuxfoundation.org>
References: <20190814165748.991235624@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 959b69ef57db00cb33e9c4777400ae7183ebddd3 ]

Jakub Jankowski reported following oddity:

After 3 way handshake completes, timeout of new connection is set to
max_retrans (300s) instead of established (5 days).

shortened excerpt from pcap provided:
25.070622 IP (flags [DF], proto TCP (6), length 52)
10.8.5.4.1025 > 10.8.1.2.80: Flags [S], seq 11, win 64240, [wscale 8]
26.070462 IP (flags [DF], proto TCP (6), length 48)
10.8.1.2.80 > 10.8.5.4.1025: Flags [S.], seq 82, ack 12, win 65535, [wscale 3]
27.070449 IP (flags [DF], proto TCP (6), length 40)
10.8.5.4.1025 > 10.8.1.2.80: Flags [.], ack 83, win 512, length 0

Turns out the last_win is of u16 type, but we store the scaled value:
512 << 8 (== 0x20000) becomes 0 window.

The Fixes tag is not correct, as the bug has existed forever, but
without that change all that this causes might cause is to mistake a
window update (to-nonzero-from-zero) for a retransmit.

Fixes: fbcd253d2448b8 ("netfilter: conntrack: lower timeout to RETRANS seconds if window is 0")
Reported-by: Jakub Jankowski <shasta@toxcorp.com>
Tested-by: Jakub Jankowski <shasta@toxcorp.com>
Signed-off-by: Florian Westphal <fw@strlen.de>
Acked-by: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conntrack_proto_tcp.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/netfilter/nf_conntrack_proto_tcp.c b/net/netfilter/nf_conntrack_proto_tcp.c
index 842f3f86fb2e7..7011ab27c4371 100644
--- a/net/netfilter/nf_conntrack_proto_tcp.c
+++ b/net/netfilter/nf_conntrack_proto_tcp.c
@@ -480,6 +480,7 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	struct ip_ct_tcp_state *receiver = &state->seen[!dir];
 	const struct nf_conntrack_tuple *tuple = &ct->tuplehash[dir].tuple;
 	__u32 seq, ack, sack, end, win, swin;
+	u16 win_raw;
 	s32 receiver_offset;
 	bool res, in_recv_win;
 
@@ -488,7 +489,8 @@ static bool tcp_in_window(const struct nf_conn *ct,
 	 */
 	seq = ntohl(tcph->seq);
 	ack = sack = ntohl(tcph->ack_seq);
-	win = ntohs(tcph->window);
+	win_raw = ntohs(tcph->window);
+	win = win_raw;
 	end = segment_seq_plus_len(seq, skb->len, dataoff, tcph);
 
 	if (receiver->flags & IP_CT_TCP_FLAG_SACK_PERM)
@@ -663,14 +665,14 @@ static bool tcp_in_window(const struct nf_conn *ct,
 			    && state->last_seq == seq
 			    && state->last_ack == ack
 			    && state->last_end == end
-			    && state->last_win == win)
+			    && state->last_win == win_raw)
 				state->retrans++;
 			else {
 				state->last_dir = dir;
 				state->last_seq = seq;
 				state->last_ack = ack;
 				state->last_end = end;
-				state->last_win = win;
+				state->last_win = win_raw;
 				state->retrans = 0;
 			}
 		}
-- 
2.20.1



