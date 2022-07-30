Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 39145585AFE
	for <lists+stable@lfdr.de>; Sat, 30 Jul 2022 17:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234808AbiG3PY6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 30 Jul 2022 11:24:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234829AbiG3PY5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 30 Jul 2022 11:24:57 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A77A13FB2
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 08:24:55 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1411C60DE8
        for <stable@vger.kernel.org>; Sat, 30 Jul 2022 15:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10EF5C433C1;
        Sat, 30 Jul 2022 15:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659194694;
        bh=rZRcPAPhXwdOO00ShcblMRpN0eUJMmUTWveMLXcoXU4=;
        h=Subject:To:Cc:From:Date:From;
        b=hyqxFDB819oFcw5qyJjb22PCHw0vufx6ESPhCpWuAJxLcz5JlVZ0x58jcaXnSde4O
         qFnSXF3OQN8XuplbHj9PH9up/ltUVtGyx3tXPr66DVkIhsi8Zui6ewlyMu0WSvsa/S
         TGDXmYzRyY6LFnEjS+BnghlyZK+PzTgpl5gwF2rw=
Subject: FAILED: patch "[PATCH] Revert "tcp: change pingpong threshold to 3"" failed to apply to 5.4-stable tree
To:     weiwan@google.com, edumazet@google.com, hlm3280@163.com,
        kuba@kernel.org, ncardwell@google.com
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sat, 30 Jul 2022 17:24:51 +0200
Message-ID: <165919469116877@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From 4d8f24eeedc58d5f87b650ddda73c16e8ba56559 Mon Sep 17 00:00:00 2001
From: Wei Wang <weiwan@google.com>
Date: Thu, 21 Jul 2022 20:44:04 +0000
Subject: [PATCH] Revert "tcp: change pingpong threshold to 3"

This reverts commit 4a41f453bedfd5e9cd040bad509d9da49feb3e2c.

This to-be-reverted commit was meant to apply a stricter rule for the
stack to enter pingpong mode. However, the condition used to check for
interactive session "before(tp->lsndtime, icsk->icsk_ack.lrcvtime)" is
jiffy based and might be too coarse, which delays the stack entering
pingpong mode.
We revert this patch so that we no longer use the above condition to
determine interactive session, and also reduce pingpong threshold to 1.

Fixes: 4a41f453bedf ("tcp: change pingpong threshold to 3")
Reported-by: LemmyHuang <hlm3280@163.com>
Suggested-by: Neal Cardwell <ncardwell@google.com>
Signed-off-by: Wei Wang <weiwan@google.com>
Acked-by: Neal Cardwell <ncardwell@google.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20220721204404.388396-1-weiwan@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>

diff --git a/include/net/inet_connection_sock.h b/include/net/inet_connection_sock.h
index 85cd695e7fd1..ee88f0f1350f 100644
--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -321,7 +321,7 @@ void inet_csk_update_fastreuse(struct inet_bind_bucket *tb,
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
-#define TCP_PINGPONG_THRESH	3
+#define TCP_PINGPONG_THRESH	1
 
 static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
 {
@@ -338,14 +338,6 @@ static inline bool inet_csk_in_pingpong_mode(struct sock *sk)
 	return inet_csk(sk)->icsk_ack.pingpong >= TCP_PINGPONG_THRESH;
 }
 
-static inline void inet_csk_inc_pingpong_cnt(struct sock *sk)
-{
-	struct inet_connection_sock *icsk = inet_csk(sk);
-
-	if (icsk->icsk_ack.pingpong < U8_MAX)
-		icsk->icsk_ack.pingpong++;
-}
-
 static inline bool inet_csk_has_ulp(struct sock *sk)
 {
 	return inet_sk(sk)->is_icsk && !!inet_csk(sk)->icsk_ulp_ops;
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index cf6713c9567e..2efe41c84ee8 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -167,16 +167,13 @@ static void tcp_event_data_sent(struct tcp_sock *tp,
 	if (tcp_packets_in_flight(tp) == 0)
 		tcp_ca_event(sk, CA_EVENT_TX_START);
 
-	/* If this is the first data packet sent in response to the
-	 * previous received data,
-	 * and it is a reply for ato after last received packet,
-	 * increase pingpong count.
-	 */
-	if (before(tp->lsndtime, icsk->icsk_ack.lrcvtime) &&
-	    (u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
-		inet_csk_inc_pingpong_cnt(sk);
-
 	tp->lsndtime = now;
+
+	/* If it is a reply for ato after last received
+	 * packet, enter pingpong mode.
+	 */
+	if ((u32)(now - icsk->icsk_ack.lrcvtime) < icsk->icsk_ack.ato)
+		inet_csk_enter_pingpong_mode(sk);
 }
 
 /* Account for an ACK we sent. */

