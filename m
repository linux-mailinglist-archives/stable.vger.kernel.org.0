Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 695F0586A6D
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234215AbiHAMQ1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiHAMP2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F8979EC0;
        Mon,  1 Aug 2022 04:58:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0F9CF601C3;
        Mon,  1 Aug 2022 11:58:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18FAFC433D6;
        Mon,  1 Aug 2022 11:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355099;
        bh=5N9uNsQ0SJ0Qf0HCAEwVojCgpDfmLRr/FMEiPYEn17Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cVVezDBNsdhi+6plUeMK75V25SxyxgrUuuCFiAHjNsKGwHUo5hNgvlGcjK0zocrP3
         ir9PWoau/lIjYm6kEEcyEE2rC2FApPMYb2+TRqzQeOK8rV0bOV9XuMTO5P2O0CWHa+
         OpEJ2MHfzHXe7ujKwwKyKM/hDbEsJo/T8S8IYvnw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, LemmyHuang <hlm3280@163.com>,
        Neal Cardwell <ncardwell@google.com>,
        Wei Wang <weiwan@google.com>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.18 32/88] Revert "tcp: change pingpong threshold to 3"
Date:   Mon,  1 Aug 2022 13:46:46 +0200
Message-Id: <20220801114139.498415881@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114138.041018499@linuxfoundation.org>
References: <20220801114138.041018499@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Wei Wang <weiwan@google.com>

commit 4d8f24eeedc58d5f87b650ddda73c16e8ba56559 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/inet_connection_sock.h |   10 +---------
 net/ipv4/tcp_output.c              |   15 ++++++---------
 2 files changed, 7 insertions(+), 18 deletions(-)

--- a/include/net/inet_connection_sock.h
+++ b/include/net/inet_connection_sock.h
@@ -323,7 +323,7 @@ void inet_csk_update_fastreuse(struct in
 
 struct dst_entry *inet_csk_update_pmtu(struct sock *sk, u32 mtu);
 
-#define TCP_PINGPONG_THRESH	3
+#define TCP_PINGPONG_THRESH	1
 
 static inline void inet_csk_enter_pingpong_mode(struct sock *sk)
 {
@@ -340,14 +340,6 @@ static inline bool inet_csk_in_pingpong_
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
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -167,16 +167,13 @@ static void tcp_event_data_sent(struct t
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


