Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5535B555C2
	for <lists+stable@lfdr.de>; Tue, 25 Jun 2019 19:19:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729987AbfFYRTz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Jun 2019 13:19:55 -0400
Received: from mx0a-00190b01.pphosted.com ([67.231.149.131]:16680 "EHLO
        mx0a-00190b01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726774AbfFYRTz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Jun 2019 13:19:55 -0400
Received: from pps.filterd (m0050093.ppops.net [127.0.0.1])
        by m0050093.ppops.net-00190b01. (8.16.0.27/8.16.0.27) with SMTP id x5PHH6PQ024368;
        Tue, 25 Jun 2019 18:19:52 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=akamai.com; h=from : to : cc :
 subject : date : message-id; s=jan2016.eng;
 bh=kKjkrTY4WuWGjQ0J1P94ThgbZCYFLwD3acDVoMvHEoc=;
 b=CtvsI3fF2+eZ1G0Q4uV1BtaOKOadSfNOOmcthMwHJ5VkfAIR1BRpxumTg15tR3Xciq7L
 FZfJVJRTD6IbEM83unReQ8Z9MI5PCHJ4dUda/ihFPaD0XCJBfAFYcpQB8iGG/ekhO2kV
 GCTMTwt3c8IGBT+XsC9sELnPGT/J3W4sN7Cy3BDN6UbIeKNIKnSmUS9BmNjD4MA+Xrq9
 GHmrDy+o4rVj6lL3b+J+X4v+K1eH7OGI5wNtDzWYICxdPET1lM39aufcnCjk1+CYZq4n
 bOFvvylHoV8Aezaj2n/80acd+Yfdb18vKj2GPd3Htgymgz8Mk6b91ogXftlnsYfsbIof 0g== 
Received: from prod-mail-ppoint2 (prod-mail-ppoint2.akamai.com [184.51.33.19] (may be forged))
        by m0050093.ppops.net-00190b01. with ESMTP id 2tba3vtw5w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Tue, 25 Jun 2019 18:19:51 +0100
Received: from pps.filterd (prod-mail-ppoint2.akamai.com [127.0.0.1])
        by prod-mail-ppoint2.akamai.com (8.16.0.27/8.16.0.27) with SMTP id x5PHHS5l030315;
        Tue, 25 Jun 2019 13:19:50 -0400
Received: from prod-mail-relay11.akamai.com ([172.27.118.250])
        by prod-mail-ppoint2.akamai.com with ESMTP id 2t9fnwj3mx-1;
        Tue, 25 Jun 2019 13:19:50 -0400
Received: from bos-lpwg1 (bos-lpwg1.kendall.corp.akamai.com [172.29.171.203])
        by prod-mail-relay11.akamai.com (Postfix) with ESMTP id 01CE31FC6E;
        Tue, 25 Jun 2019 17:19:50 +0000 (GMT)
Received: from johunt by bos-lpwg1 with local (Exim 4.86_2)
        (envelope-from <johunt@akamai.com>)
        id 1hfp6o-0007sz-SZ; Tue, 25 Jun 2019 13:19:54 -0400
From:   Josh Hunt <johunt@akamai.com>
To:     gregkh@linuxfoundation.org, edumazet@google.com
Cc:     stable@vger.kernel.org, jbaron@akamai.com,
        Josh Hunt <johunt@akamai.com>
Subject: [PATCH 4.14] tcp: refine memory limit test in tcp_fragment()
Date:   Tue, 25 Jun 2019 13:19:37 -0400
Message-Id: <1561483177-30254-1-git-send-email-johunt@akamai.com>
X-Mailer: git-send-email 2.7.4
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 phishscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=819
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.0.1-1810050000 definitions=main-1906250130
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-06-25_12:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 malwarescore=0
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 clxscore=1011
 lowpriorityscore=0 mlxscore=0 impostorscore=0 mlxlogscore=871 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.0.1-1810050000
 definitions=main-1906250130
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Backport of dad3a9314ac95dedc007bc7dacacb396ea10e376:

tcp_fragment() might be called for skbs in the write queue.

Memory limits might have been exceeded because tcp_sendmsg() only
checks limits at full skb (64KB) boundaries.

Therefore, we need to make sure tcp_fragment() wont punish applications
that might have setup very low SO_SNDBUF values.

Backport notes:
Initial version used tcp_queue type which is not present in older kernels,
so added a new arg to tcp_fragment() to determine whether this is a
retransmit or not.

Fixes: 9daf226ff926 ("tcp: tcp_fragment() should apply sane memory limits")
Signed-off-by: Josh Hunt <johunt@akamai.com>
Reviewed-by: Jason Baron <jbaron@akamai.com>
---

Eric/Greg - This applies on top of v4.14.130. I did not see anything come
through for the older (<4.19) stable kernels yet. Without this change
Christoph Paasch's packetrill script (https://lore.kernel.org/netdev/CALMXkpYVRxgeqarp4gnmX7GqYh1sWOAt6UaRFqYBOaaNFfZ5sw@mail.gmail.com/)
will fail on 4.14 stable kernels, but passes with this change.

 include/net/tcp.h     |  3 ++-
 net/ipv4/tcp_input.c  |  4 ++--
 net/ipv4/tcp_output.c | 16 ++++++++--------
 3 files changed, 12 insertions(+), 11 deletions(-)

diff --git a/include/net/tcp.h b/include/net/tcp.h
index 1179ef4f0768..9d69fefa365c 100644
--- a/include/net/tcp.h
+++ b/include/net/tcp.h
@@ -554,7 +554,8 @@ void tcp_xmit_retransmit_queue(struct sock *);
 void tcp_simple_retransmit(struct sock *);
 void tcp_enter_recovery(struct sock *sk, bool ece_ack);
 int tcp_trim_head(struct sock *, struct sk_buff *, u32);
-int tcp_fragment(struct sock *, struct sk_buff *, u32, unsigned int, gfp_t);
+int tcp_fragment(struct sock *, struct sk_buff *, u32, unsigned int, gfp_t,
+		 bool retrans);
 
 void tcp_send_probe0(struct sock *);
 void tcp_send_partial(struct sock *);
diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 8e080f3b75bd..0fd629587104 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -1202,7 +1202,7 @@ static int tcp_match_skb_to_sack(struct sock *sk, struct sk_buff *skb,
 		if (pkt_len >= skb->len && !in_sack)
 			return 0;
 
-		err = tcp_fragment(sk, skb, pkt_len, mss, GFP_ATOMIC);
+		err = tcp_fragment(sk, skb, pkt_len, mss, GFP_ATOMIC, true);
 		if (err < 0)
 			return err;
 	}
@@ -2266,7 +2266,7 @@ static void tcp_mark_head_lost(struct sock *sk, int packets, int mark_head)
 			/* If needed, chop off the prefix to mark as lost. */
 			lost = (packets - oldcnt) * mss;
 			if (lost < skb->len &&
-			    tcp_fragment(sk, skb, lost, mss, GFP_ATOMIC) < 0)
+			    tcp_fragment(sk, skb, lost, mss, GFP_ATOMIC, true) < 0)
 				break;
 			cnt = packets;
 		}
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index a8772e11dc1c..ca14770dd7ba 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1259,7 +1259,7 @@ static void tcp_skb_fragment_eor(struct sk_buff *skb, struct sk_buff *skb2)
  * Remember, these are still headerless SKBs at this point.
  */
 int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
-		 unsigned int mss_now, gfp_t gfp)
+		 unsigned int mss_now, gfp_t gfp, bool retrans)
 {
 	struct tcp_sock *tp = tcp_sk(sk);
 	struct sk_buff *buff;
@@ -1274,7 +1274,7 @@ int tcp_fragment(struct sock *sk, struct sk_buff *skb, u32 len,
 	if (nsize < 0)
 		nsize = 0;
 
-	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf)) {
+	if (unlikely((sk->sk_wmem_queued >> 1) > sk->sk_sndbuf && retrans)) {
 		NET_INC_STATS(sock_net(sk), LINUX_MIB_TCPWQUEUETOOBIG);
 		return -ENOMEM;
 	}
@@ -1834,7 +1834,7 @@ static bool tcp_snd_wnd_test(const struct tcp_sock *tp,
  * packet has never been sent out before (and thus is not cloned).
  */
 static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
-			unsigned int mss_now, gfp_t gfp)
+			unsigned int mss_now, gfp_t gfp, bool retrans)
 {
 	struct sk_buff *buff;
 	int nlen = skb->len - len;
@@ -1842,7 +1842,7 @@ static int tso_fragment(struct sock *sk, struct sk_buff *skb, unsigned int len,
 
 	/* All of a TSO frame must be composed of paged data.  */
 	if (skb->len != skb->data_len)
-		return tcp_fragment(sk, skb, len, mss_now, gfp);
+		return tcp_fragment(sk, skb, len, mss_now, gfp, retrans);
 
 	buff = sk_stream_alloc_skb(sk, 0, gfp, true);
 	if (unlikely(!buff))
@@ -2361,7 +2361,7 @@ static bool tcp_write_xmit(struct sock *sk, unsigned int mss_now, int nonagle,
 						    nonagle);
 
 		if (skb->len > limit &&
-		    unlikely(tso_fragment(sk, skb, limit, mss_now, gfp)))
+		    unlikely(tso_fragment(sk, skb, limit, mss_now, gfp, false)))
 			break;
 
 		if (test_bit(TCP_TSQ_DEFERRED, &sk->sk_tsq_flags))
@@ -2514,7 +2514,7 @@ void tcp_send_loss_probe(struct sock *sk)
 
 	if ((pcount > 1) && (skb->len > (pcount - 1) * mss)) {
 		if (unlikely(tcp_fragment(sk, skb, (pcount - 1) * mss, mss,
-					  GFP_ATOMIC)))
+					  GFP_ATOMIC, true)))
 			goto rearm_timer;
 		skb = tcp_write_queue_next(sk, skb);
 	}
@@ -2874,7 +2874,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 
 	len = cur_mss * segs;
 	if (skb->len > len) {
-		if (tcp_fragment(sk, skb, len, cur_mss, GFP_ATOMIC))
+		if (tcp_fragment(sk, skb, len, cur_mss, GFP_ATOMIC, true))
 			return -ENOMEM; /* We'll try again later. */
 	} else {
 		if (skb_unclone(skb, GFP_ATOMIC))
@@ -3696,7 +3696,7 @@ int tcp_write_wakeup(struct sock *sk, int mib)
 		    skb->len > mss) {
 			seg_size = min(seg_size, mss);
 			TCP_SKB_CB(skb)->tcp_flags |= TCPHDR_PSH;
-			if (tcp_fragment(sk, skb, seg_size, mss, GFP_ATOMIC))
+			if (tcp_fragment(sk, skb, seg_size, mss, GFP_ATOMIC, false))
 				return -1;
 		} else if (!tcp_skb_pcount(skb))
 			tcp_set_skb_tso_segs(skb, mss);
-- 
2.7.4

