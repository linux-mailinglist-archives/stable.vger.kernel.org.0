Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 293D047AD1B
	for <lists+stable@lfdr.de>; Mon, 20 Dec 2021 15:51:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235067AbhLTOtX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Dec 2021 09:49:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235202AbhLTOrU (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Dec 2021 09:47:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C142DC0698CC;
        Mon, 20 Dec 2021 06:44:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81864B80EEC;
        Mon, 20 Dec 2021 14:44:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD432C36AE9;
        Mon, 20 Dec 2021 14:43:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1640011440;
        bh=h6dBMFL8HhmNGJH6tmPsvDmPl98rk2azHa/lGZNdzFM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=TImYryWF6miUWqGCCS49f1ffFvGvC5gwKg4Aj4w9fVAtY7x82ZCaObqLf0d8Z62nj
         in+9tlG8P0mSjcfpRB0OKKEuekR15T78rYlahUCyOuUL3+DjP8vX7suD+0mKIRoBpb
         qtDW8l5AKXx+ZrDwZ3pwspgGksmVL0j18l/gYbhQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 21/71] inet_diag: use jiffies_delta_to_msecs()
Date:   Mon, 20 Dec 2021 15:34:10 +0100
Message-Id: <20211220143026.403869052@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211220143025.683747691@linuxfoundation.org>
References: <20211220143025.683747691@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 3828a93f5cfdf5d8a4ff9dead741e9a2871ff57b ]

Use jiffies_delta_to_msecs() to avoid reporting 'infinite'
timeouts and to cleanup code.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/inet_diag.c | 15 ++++++---------
 1 file changed, 6 insertions(+), 9 deletions(-)

diff --git a/net/ipv4/inet_diag.c b/net/ipv4/inet_diag.c
index 4f71aca156662..6f8118b29ba51 100644
--- a/net/ipv4/inet_diag.c
+++ b/net/ipv4/inet_diag.c
@@ -240,17 +240,17 @@ int inet_sk_diag_fill(struct sock *sk, struct inet_connection_sock *icsk,
 		r->idiag_timer = 1;
 		r->idiag_retrans = icsk->icsk_retransmits;
 		r->idiag_expires =
-			jiffies_to_msecs(icsk->icsk_timeout - jiffies);
+			jiffies_delta_to_msecs(icsk->icsk_timeout - jiffies);
 	} else if (icsk->icsk_pending == ICSK_TIME_PROBE0) {
 		r->idiag_timer = 4;
 		r->idiag_retrans = icsk->icsk_probes_out;
 		r->idiag_expires =
-			jiffies_to_msecs(icsk->icsk_timeout - jiffies);
+			jiffies_delta_to_msecs(icsk->icsk_timeout - jiffies);
 	} else if (timer_pending(&sk->sk_timer)) {
 		r->idiag_timer = 2;
 		r->idiag_retrans = icsk->icsk_probes_out;
 		r->idiag_expires =
-			jiffies_to_msecs(sk->sk_timer.expires - jiffies);
+			jiffies_delta_to_msecs(sk->sk_timer.expires - jiffies);
 	} else {
 		r->idiag_timer = 0;
 		r->idiag_expires = 0;
@@ -338,16 +338,13 @@ static int inet_twsk_diag_fill(struct sock *sk,
 	r = nlmsg_data(nlh);
 	BUG_ON(tw->tw_state != TCP_TIME_WAIT);
 
-	tmo = tw->tw_timer.expires - jiffies;
-	if (tmo < 0)
-		tmo = 0;
-
 	inet_diag_msg_common_fill(r, sk);
 	r->idiag_retrans      = 0;
 
 	r->idiag_state	      = tw->tw_substate;
 	r->idiag_timer	      = 3;
-	r->idiag_expires      = jiffies_to_msecs(tmo);
+	tmo = tw->tw_timer.expires - jiffies;
+	r->idiag_expires      = jiffies_delta_to_msecs(tmo);
 	r->idiag_rqueue	      = 0;
 	r->idiag_wqueue	      = 0;
 	r->idiag_uid	      = 0;
@@ -381,7 +378,7 @@ static int inet_req_diag_fill(struct sock *sk, struct sk_buff *skb,
 		     offsetof(struct sock, sk_cookie));
 
 	tmo = inet_reqsk(sk)->rsk_timer.expires - jiffies;
-	r->idiag_expires = (tmo >= 0) ? jiffies_to_msecs(tmo) : 0;
+	r->idiag_expires = jiffies_delta_to_msecs(tmo);
 	r->idiag_rqueue	= 0;
 	r->idiag_wqueue	= 0;
 	r->idiag_uid	= 0;
-- 
2.33.0



