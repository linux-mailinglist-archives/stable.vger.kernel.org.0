Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDE55582D25
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240741AbiG0QyH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:54:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240865AbiG0Qwp (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4B884C612;
        Wed, 27 Jul 2022 09:34:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 41BF761A24;
        Wed, 27 Jul 2022 16:34:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 507C7C433C1;
        Wed, 27 Jul 2022 16:34:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939692;
        bh=taGXvwh8QulMfFeNAopT3SELzpb/vZWaKrweY7XJzN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ySPejKRWluxQqaWzN1ZUdJUNJJJQGDlB6dVo44/ci5e69hjuRYsGeRDtwtqDaZCRG
         s/WqDptFEgzt0S/ji+kyeZ93J/tYfDFRuwWVSu/rcU+9fBMH2cdvGlJG1uImPpq8kA
         6Jn1gvumm4jEXSGrb5/F6R1M9EJAkpVrumCiRCBY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 071/105] tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
Date:   Wed, 27 Jul 2022 18:10:57 +0200
Message-Id: <20220727161014.907629753@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
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

[ Upstream commit 7c6f2a86ca590d5187a073d987e9599985fb1c7c ]

While reading sysctl_tcp_thin_linear_timeouts, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: 36e31b0af587 ("net: TCP thin linear timeouts")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_timer.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_timer.c b/net/ipv4/tcp_timer.c
index e20fd86a2a89..888683f2ff3e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -574,7 +574,7 @@ void tcp_retransmit_timer(struct sock *sk)
 	 * linear-timeout retransmissions into a black hole
 	 */
 	if (sk->sk_state == TCP_ESTABLISHED &&
-	    (tp->thin_lto || net->ipv4.sysctl_tcp_thin_linear_timeouts) &&
+	    (tp->thin_lto || READ_ONCE(net->ipv4.sysctl_tcp_thin_linear_timeouts)) &&
 	    tcp_stream_is_thin(tp) &&
 	    icsk->icsk_retransmits <= TCP_THIN_LINEAR_RETRIES) {
 		icsk->icsk_backoff = 0;
-- 
2.35.1



