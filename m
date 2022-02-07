Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 287694ABA6B
	for <lists+stable@lfdr.de>; Mon,  7 Feb 2022 12:28:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383700AbiBGLX0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Feb 2022 06:23:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379072AbiBGLQB (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Feb 2022 06:16:01 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADD30C0401C1;
        Mon,  7 Feb 2022 03:16:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14AABB80EC3;
        Mon,  7 Feb 2022 11:15:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 385B0C004E1;
        Mon,  7 Feb 2022 11:15:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1644232557;
        bh=rUMuAcN2LGESDpLVqYoXT1cCa4WWguHXuJ2RczFMAsk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RHWlABTM8xctAkIpyB3HJYybX9JaWXlawHf/Z8GnSL60iDspIFnC5dNefCis49DDC
         +a6gPNQh648Eu1YO+zJLkwIKXztqN0WGcJp9dXR/gRADTDpQHQ7147NXyxL2XrglVt
         iFsn2xCs2qsMA4wpNhClLsJp1DHQixKYEBOYMZsk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        Jason Xing <kerneljasonxing@gmail.com>,
        Zhang Changzhong <zhangchangzhong@huawei.com>,
        liweishi <liweishi@kuaishou.com>,
        Shujin Li <lishujin@kuaishou.com>,
        Neal Cardwell <ncardwell@google.com>
Subject: [PATCH 4.19 48/86] tcp: fix possible socket leaks in internal pacing mode
Date:   Mon,  7 Feb 2022 12:06:11 +0100
Message-Id: <20220207103759.122641352@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220207103757.550973048@linuxfoundation.org>
References: <20220207103757.550973048@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


From: Eric Dumazet <edumazet@google.com>

This patch is addressing an issue in stable linux-4.19 only.

In linux-4.20, TCP stack adopted EDT (Earliest Departure
Time) model and this issue was incidentally fixed.

Issue at hand was an extra sock_hold() from tcp_internal_pacing()
in paths not using tcp_xmit_retransmit_queue()

Jason Xing reported this leak and provided a patch stopping
the extra sock_hold() to happen.

This patch is more complete and makes sure to avoid
unnecessary extra delays, by reprogramming the high
resolution timer.

Fixes: 73a6bab5aa2a ("tcp: switch pacing timer to softirq based hrtimer")
Reference: https://lore.kernel.org/all/CANn89i+7-wE4xr5D9DpH+N-xkL1SB8oVghCKgz+CT5eG1ODQhA@mail.gmail.com/
Signed-off-by: Eric Dumazet <edumazet@google.com>
Reported-by: Jason Xing <kerneljasonxing@gmail.com>
Reported-by: Zhang Changzhong <zhangchangzhong@huawei.com>
Cc: liweishi <liweishi@kuaishou.com>
Cc: Shujin Li <lishujin@kuaishou.com>
Cc: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_output.c |   31 +++++++++++++++++++++++--------
 1 file changed, 23 insertions(+), 8 deletions(-)

--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -968,6 +968,8 @@ enum hrtimer_restart tcp_pace_kick(struc
 
 static void tcp_internal_pacing(struct sock *sk, const struct sk_buff *skb)
 {
+	struct tcp_sock *tp = tcp_sk(sk);
+	ktime_t expire, now;
 	u64 len_ns;
 	u32 rate;
 
@@ -979,12 +981,28 @@ static void tcp_internal_pacing(struct s
 
 	len_ns = (u64)skb->len * NSEC_PER_SEC;
 	do_div(len_ns, rate);
-	hrtimer_start(&tcp_sk(sk)->pacing_timer,
-		      ktime_add_ns(ktime_get(), len_ns),
+	now = ktime_get();
+	/* If hrtimer is already armed, then our caller has not
+	 * used tcp_pacing_check().
+	 */
+	if (unlikely(hrtimer_is_queued(&tp->pacing_timer))) {
+		expire = hrtimer_get_softexpires(&tp->pacing_timer);
+		if (ktime_after(expire, now))
+			now = expire;
+		if (hrtimer_try_to_cancel(&tp->pacing_timer) == 1)
+			__sock_put(sk);
+	}
+	hrtimer_start(&tp->pacing_timer, ktime_add_ns(now, len_ns),
 		      HRTIMER_MODE_ABS_PINNED_SOFT);
 	sock_hold(sk);
 }
 
+static bool tcp_pacing_check(const struct sock *sk)
+{
+	return tcp_needs_internal_pacing(sk) &&
+	       hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
+}
+
 static void tcp_update_skb_after_send(struct tcp_sock *tp, struct sk_buff *skb)
 {
 	skb->skb_mstamp = tp->tcp_mstamp;
@@ -2121,6 +2139,9 @@ static int tcp_mtu_probe(struct sock *sk
 	if (!tcp_can_coalesce_send_queue_head(sk, probe_size))
 		return -1;
 
+	if (tcp_pacing_check(sk))
+		return -1;
+
 	/* We're allowed to probe.  Build it now. */
 	nskb = sk_stream_alloc_skb(sk, probe_size, GFP_ATOMIC, false);
 	if (!nskb)
@@ -2194,12 +2215,6 @@ static int tcp_mtu_probe(struct sock *sk
 	return -1;
 }
 
-static bool tcp_pacing_check(const struct sock *sk)
-{
-	return tcp_needs_internal_pacing(sk) &&
-	       hrtimer_is_queued(&tcp_sk(sk)->pacing_timer);
-}
-
 /* TCP Small Queues :
  * Control number of packets in qdisc/devices to two packets / or ~1 ms.
  * (These limits are doubled for retransmits)


