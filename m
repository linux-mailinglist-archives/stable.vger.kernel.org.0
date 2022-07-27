Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 386595830CA
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:42:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbiG0RmK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:42:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242174AbiG0Rl2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:41:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73E3E61DA9;
        Wed, 27 Jul 2022 09:51:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E75B9B821BE;
        Wed, 27 Jul 2022 16:51:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47594C433D7;
        Wed, 27 Jul 2022 16:51:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940703;
        bh=rrAiAUY+CENqu8GGV7DyCdwuyRFhTpEkcN0ZD03/S7g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fNEW3cikC9G2YwH/wCt5apXK7id+LUO7+y2l+vS+veczlRgLlpadtPXfiRLAQSET/
         JgOA+0lKxeZNz5e/OMXvinNPqkAQHtXAlL1n2q98j6BA8pLTYYWuoUYqRnD6OnKyh/
         673qrkpFmpbdEm3B/dUgp+Gtrdpxv08P5APuQxuA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 118/158] tcp: Fix a data-race around sysctl_tcp_early_retrans.
Date:   Wed, 27 Jul 2022 18:13:02 +0200
Message-Id: <20220727161026.194391483@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161021.428340041@linuxfoundation.org>
References: <20220727161021.428340041@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 52e65865deb6a36718a463030500f16530eaab74 ]

While reading sysctl_tcp_early_retrans, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: eed530b6c676 ("tcp: early retransmit")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_output.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index be3e90b526d8..5cda762a43dd 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -2739,7 +2739,7 @@ bool tcp_schedule_loss_probe(struct sock *sk, bool advancing_rto)
 	if (rcu_access_pointer(tp->fastopen_rsk))
 		return false;
 
-	early_retrans = sock_net(sk)->ipv4.sysctl_tcp_early_retrans;
+	early_retrans = READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_early_retrans);
 	/* Schedule a loss probe in 2*RTT for SACK capable connections
 	 * not in loss recovery, that are either limited by cwnd or application.
 	 */
-- 
2.35.1



