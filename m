Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F75D5B7842
	for <lists+stable@lfdr.de>; Tue, 13 Sep 2022 19:43:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233433AbiIMRn0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Sep 2022 13:43:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233437AbiIMRmt (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 13 Sep 2022 13:42:49 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 74CBAA1D5E;
        Tue, 13 Sep 2022 09:36:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5B02B614DB;
        Tue, 13 Sep 2022 14:21:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EC2AC433C1;
        Tue, 13 Sep 2022 14:21:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1663078908;
        bh=YMNh48hMLp7Viyyb3H8h2tYTU2+J75YtrQoAIwfEWOs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=F2+bY1hReBdpaU5W75Hg0zySlBvnosmvsKJLR5XM2nOssEJ4CEx+vcJhxO0pNNEW9
         1I1etk5p2a7YtZ2s7t0Xxdr1oT/RaIwqKeIwhW3Jhe725061Hb03kiB/L50D/OCVd4
         8t7UIlwO4TlPQPDzKVXeVuXqciwveNXWHxPWmokc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nagaraj Arankal <nagaraj.p.arankal@hpe.com>,
        Neal Cardwell <ncardwell@google.com>,
        Yuchung Cheng <ycheng@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/121] tcp: fix early ETIMEDOUT after spurious non-SACK RTO
Date:   Tue, 13 Sep 2022 16:04:44 +0200
Message-Id: <20220913140401.356858232@linuxfoundation.org>
X-Mailer: git-send-email 2.37.3
In-Reply-To: <20220913140357.323297659@linuxfoundation.org>
References: <20220913140357.323297659@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Neal Cardwell <ncardwell@google.com>

[ Upstream commit 686dc2db2a0fdc1d34b424ec2c0a735becd8d62b ]

Fix a bug reported and analyzed by Nagaraj Arankal, where the handling
of a spurious non-SACK RTO could cause a connection to fail to clear
retrans_stamp, causing a later RTO to very prematurely time out the
connection with ETIMEDOUT.

Here is the buggy scenario, expanding upon Nagaraj Arankal's excellent
report:

(*1) Send one data packet on a non-SACK connection

(*2) Because no ACK packet is received, the packet is retransmitted
     and we enter CA_Loss; but this retransmission is spurious.

(*3) The ACK for the original data is received. The transmitted packet
     is acknowledged.  The TCP timestamp is before the retrans_stamp,
     so tcp_may_undo() returns true, and tcp_try_undo_loss() returns
     true without changing state to Open (because tcp_is_sack() is
     false), and tcp_process_loss() returns without calling
     tcp_try_undo_recovery().  Normally after undoing a CA_Loss
     episode, tcp_fastretrans_alert() would see that the connection
     has returned to CA_Open and fall through and call
     tcp_try_to_open(), which would set retrans_stamp to 0.  However,
     for non-SACK connections we hold the connection in CA_Loss, so do
     not fall through to call tcp_try_to_open() and do not set
     retrans_stamp to 0. So retrans_stamp is (erroneously) still
     non-zero.

     At this point the first "retransmission event" has passed and
     been recovered from. Any future retransmission is a completely
     new "event". However, retrans_stamp is erroneously still
     set. (And we are still in CA_Loss, which is correct.)

(*4) After 16 minutes (to correspond with tcp_retries2=15), a new data
     packet is sent. Note: No data is transmitted between (*3) and
     (*4) and we disabled keep alives.

     The socket's timeout SHOULD be calculated from this point in
     time, but instead it's calculated from the prior "event" 16
     minutes ago (step (*2)).

(*5) Because no ACK packet is received, the packet is retransmitted.

(*6) At the time of the 2nd retransmission, the socket returns
     ETIMEDOUT, prematurely, because retrans_stamp is (erroneously)
     too far in the past (set at the time of (*2)).

This commit fixes this bug by ensuring that we reuse in
tcp_try_undo_loss() the same careful logic for non-SACK connections
that we have in tcp_try_undo_recovery(). To avoid duplicating logic,
we factor out that logic into a new
tcp_is_non_sack_preventing_reopen() helper and call that helper from
both undo functions.

Fixes: da34ac7626b5 ("tcp: only undo on partial ACKs in CA_Loss")
Reported-by: Nagaraj Arankal <nagaraj.p.arankal@hpe.com>
Link: https://lore.kernel.org/all/SJ0PR84MB1847BE6C24D274C46A1B9B0EB27A9@SJ0PR84MB1847.NAMPRD84.PROD.OUTLOOK.COM/
Signed-off-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Yuchung Cheng <ycheng@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220903121023.866900-1-ncardwell.kernel@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 7fd7e7cba0c92..686e210d89c21 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -2506,6 +2506,21 @@ static inline bool tcp_may_undo(const struct tcp_sock *tp)
 	return tp->undo_marker && (!tp->undo_retrans || tcp_packet_delayed(tp));
 }
 
+static bool tcp_is_non_sack_preventing_reopen(struct sock *sk)
+{
+	struct tcp_sock *tp = tcp_sk(sk);
+
+	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
+		/* Hold old state until something *above* high_seq
+		 * is ACKed. For Reno it is MUST to prevent false
+		 * fast retransmits (RFC2582). SACK TCP is safe. */
+		if (!tcp_any_retrans_done(sk))
+			tp->retrans_stamp = 0;
+		return true;
+	}
+	return false;
+}
+
 /* People celebrate: "We love our President!" */
 static bool tcp_try_undo_recovery(struct sock *sk)
 {
@@ -2528,14 +2543,8 @@ static bool tcp_try_undo_recovery(struct sock *sk)
 	} else if (tp->rack.reo_wnd_persist) {
 		tp->rack.reo_wnd_persist--;
 	}
-	if (tp->snd_una == tp->high_seq && tcp_is_reno(tp)) {
-		/* Hold old state until something *above* high_seq
-		 * is ACKed. For Reno it is MUST to prevent false
-		 * fast retransmits (RFC2582). SACK TCP is safe. */
-		if (!tcp_any_retrans_done(sk))
-			tp->retrans_stamp = 0;
+	if (tcp_is_non_sack_preventing_reopen(sk))
 		return true;
-	}
 	tcp_set_ca_state(sk, TCP_CA_Open);
 	tp->is_sack_reneg = 0;
 	return false;
@@ -2571,6 +2580,8 @@ static bool tcp_try_undo_loss(struct sock *sk, bool frto_undo)
 			NET_INC_STATS(sock_net(sk),
 					LINUX_MIB_TCPSPURIOUSRTOS);
 		inet_csk(sk)->icsk_retransmits = 0;
+		if (tcp_is_non_sack_preventing_reopen(sk))
+			return true;
 		if (frto_undo || tcp_is_sack(tp)) {
 			tcp_set_ca_state(sk, TCP_CA_Open);
 			tp->is_sack_reneg = 0;
-- 
2.35.1



