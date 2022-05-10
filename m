Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F827521759
	for <lists+stable@lfdr.de>; Tue, 10 May 2022 15:21:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242732AbiEJNYG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 May 2022 09:24:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242758AbiEJNVB (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 10 May 2022 09:21:01 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0045F2BB2D0;
        Tue, 10 May 2022 06:13:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 4CE18CE1EE2;
        Tue, 10 May 2022 13:13:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62230C385A6;
        Tue, 10 May 2022 13:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652188423;
        bh=4BevFSo4u1/OOEbkv59wJVzgE798kjeM/YDKIqMo4us=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KaLee5XcmUm9YaTkbRjxcGxD85i5ijsjjAOSCLEGsCXZYoaLCmCQ+/yX/mKrHVd1q
         4+V3Mbhh45A9HErcuB9UWK9UH5AjQySCSiUarHwKN0PYeUjpW/lmX9PN0/h1gCrcBC
         JbQTzjQvWCtiz8mN3dPz0VA0uHO6GH8mtAcDmimk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Doug Porter <dsp@fb.com>,
        Soheil Hassas Yeganeh <soheil@google.com>,
        Neal Cardwell <ncardwell@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 29/66] tcp: fix potential xmit stalls caused by TCP_NOTSENT_LOWAT
Date:   Tue, 10 May 2022 15:07:19 +0200
Message-Id: <20220510130730.620579032@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220510130729.762341544@linuxfoundation.org>
References: <20220510130729.762341544@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 4bfe744ff1644fbc0a991a2677dc874475dd6776 ]

I had this bug sitting for too long in my pile, it is time to fix it.

Thanks to Doug Porter for reminding me of it!

We had various attempts in the past, including commit
0cbe6a8f089e ("tcp: remove SOCK_QUEUE_SHRUNK"),
but the issue is that TCP stack currently only generates
EPOLLOUT from input path, when tp->snd_una has advanced
and skb(s) cleaned from rtx queue.

If a flow has a big RTT, and/or receives SACKs, it is possible
that the notsent part (tp->write_seq - tp->snd_nxt) reaches 0
and no more data can be sent until tp->snd_una finally advances.

What is needed is to also check if POLLOUT needs to be generated
whenever tp->snd_nxt is advanced, from output path.

This bug triggers more often after an idle period, as
we do not receive ACK for at least one RTT. tcp_notsent_lowat
could be a fraction of what CWND and pacing rate would allow to
send during this RTT.

In a followup patch, I will remove the bogus call
to tcp_chrono_stop(sk, TCP_CHRONO_SNDBUF_LIMITED)
from tcp_check_space(). Fact that we have decided to generate
an EPOLLOUT does not mean the application has immediately
refilled the transmit queue. This optimistic call
might have been the reason the bug seemed not too serious.

Tested:

200 ms rtt, 1% packet loss, 32 MB tcp_rmem[2] and tcp_wmem[2]

$ echo 500000 >/proc/sys/net/ipv4/tcp_notsent_lowat
$ cat bench_rr.sh
SUM=0
for i in {1..10}
do
 V=`netperf -H remote_host -l30 -t TCP_RR -- -r 10000000,10000 -o LOCAL_BYTES_SENT | egrep -v "MIGRATED|Bytes"`
 echo $V
 SUM=$(($SUM + $V))
done
echo SUM=$SUM

Before patch:
$ bench_rr.sh
130000000
80000000
140000000
140000000
140000000
140000000
130000000
40000000
90000000
110000000
SUM=1140000000

After patch:
$ bench_rr.sh
430000000
590000000
530000000
450000000
450000000
350000000
450000000
490000000
480000000
460000000
SUM=4680000000  # This is 410 % of the value before patch.

Fixes: c9bee3b7fdec ("tcp: TCP_NOTSENT_LOWAT socket option")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Doug Porter <dsp@fb.com>
Cc: Soheil Hassas Yeganeh <soheil@google.com>
Cc: Neal Cardwell <ncardwell@google.com>
Acked-by: Soheil Hassas Yeganeh <soheil@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/tcp.h     |  1 +
 net/ipv4/tcp_input.c  | 12 +++++++++++-
 net/ipv4/tcp_output.c |  1 +
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index f26f075250b4..97df2f6fcbd7 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -579,6 +579,7 @@ void tcp_synack_rtt_meas(struct sock *sk, struct request_sock *req);
 void tcp_reset(struct sock *sk);
 void tcp_skb_mark_lost_uncond_verify(struct tcp_sock *tp, struct sk_buff *skb);
 void tcp_fin(struct sock *sk);
+void tcp_check_space(struct sock *sk);
 
 /* tcp_timer.c */
 void tcp_init_xmit_timers(struct sock *);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 01c73775ed00..7f48f8504284 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5159,7 +5159,17 @@ static void tcp_new_space(struct sock *sk)
 	sk->sk_write_space(sk);
 }
 
-static void tcp_check_space(struct sock *sk)
+/* Caller made space either from:
+ * 1) Freeing skbs in rtx queues (after tp->snd_una has advanced)
+ * 2) Sent skbs from output queue (and thus advancing tp->snd_nxt)
+ *
+ * We might be able to generate EPOLLOUT to the application if:
+ * 1) Space consumed in output/rtx queues is below sk->sk_sndbuf/2
+ * 2) notsent amount (tp->write_seq - tp->snd_nxt) became
+ *    small enough that tcp_stream_memory_free() decides it
+ *    is time to generate EPOLLOUT.
+ */
+void tcp_check_space(struct sock *sk)
 {
 	if (sock_flag(sk, SOCK_QUEUE_SHRUNK)) {
 		sock_reset_flag(sk, SOCK_QUEUE_SHRUNK);
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index aafea53c7c06..95b0f486cb10 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -83,6 +83,7 @@ static void tcp_event_new_data_sent(struct sock *sk, const struct sk_buff *skb)
 
 	NET_ADD_STATS(sock_net(sk), LINUX_MIB_TCPORIGDATASENT,
 		      tcp_skb_pcount(skb));
+	tcp_check_space(sk);
 }
 
 /* SND.NXT, if window was not shrunk.
-- 
2.35.1



