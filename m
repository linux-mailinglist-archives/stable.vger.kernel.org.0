Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE2995417DF
	for <lists+stable@lfdr.de>; Tue,  7 Jun 2022 23:07:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378372AbiFGVGr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Jun 2022 17:06:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54818 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379414AbiFGVFz (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Jun 2022 17:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9306918DAE3;
        Tue,  7 Jun 2022 11:49:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FBC1616AF;
        Tue,  7 Jun 2022 18:49:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D7ECC385A5;
        Tue,  7 Jun 2022 18:49:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1654627768;
        bh=G8Lr5tC7exO+P44JmMYxw/QCR5EsrdoyP32XeHj5qcw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=2j834ykmfjyEZuhvzBCt+gpXKGZer9sT6onNE3NZGOtBx5Azg/BWork7XklboLOI2
         rvnn+wh6DsiZII+ZDY0KFldOqhmR2VeLeBZDWSUWq5/OQl7YQ0r/i4EEnyfsueAQNz
         +lFD9AbjsMrENmS2An2r47OnyOypKlR7M4uzg0hU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 086/879] tcp: consume incoming skb leading to a reset
Date:   Tue,  7 Jun 2022 18:53:24 +0200
Message-Id: <20220607165005.189550617@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220607165002.659942637@linuxfoundation.org>
References: <20220607165002.659942637@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit d9d024f96609016628d750ebc8ee4a6f0d80e6e1 ]

Whenever tcp_validate_incoming() handles a valid RST packet,
we should not pretend the packet was dropped.

Create a special section at the end of tcp_validate_incoming()
to handle this case.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 60f99e9fb6d1..1f3ce7aea716 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5711,7 +5711,7 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 						  &tp->last_oow_ack_time))
 				tcp_send_dupack(sk, skb);
 		} else if (tcp_reset_check(sk, skb)) {
-			tcp_reset(sk, skb);
+			goto reset;
 		}
 		goto discard;
 	}
@@ -5747,17 +5747,16 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 		}
 
 		if (rst_seq_match)
-			tcp_reset(sk, skb);
-		else {
-			/* Disable TFO if RST is out-of-order
-			 * and no data has been received
-			 * for current active TFO socket
-			 */
-			if (tp->syn_fastopen && !tp->data_segs_in &&
-			    sk->sk_state == TCP_ESTABLISHED)
-				tcp_fastopen_active_disable(sk);
-			tcp_send_challenge_ack(sk);
-		}
+			goto reset;
+
+		/* Disable TFO if RST is out-of-order
+		 * and no data has been received
+		 * for current active TFO socket
+		 */
+		if (tp->syn_fastopen && !tp->data_segs_in &&
+		    sk->sk_state == TCP_ESTABLISHED)
+			tcp_fastopen_active_disable(sk);
+		tcp_send_challenge_ack(sk);
 		goto discard;
 	}
 
@@ -5782,6 +5781,11 @@ static bool tcp_validate_incoming(struct sock *sk, struct sk_buff *skb,
 discard:
 	tcp_drop(sk, skb);
 	return false;
+
+reset:
+	tcp_reset(sk, skb);
+	__kfree_skb(skb);
+	return false;
 }
 
 /*
-- 
2.35.1



