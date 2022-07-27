Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5061582E92
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:15:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233775AbiG0RPA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:15:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241752AbiG0RO0 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:14:26 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A95E35C35B;
        Wed, 27 Jul 2022 09:42:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 810F0B821D2;
        Wed, 27 Jul 2022 16:42:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9535C433D7;
        Wed, 27 Jul 2022 16:42:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940155;
        bh=WFxdTAFTDOeA3kkSiLosrw9dd3leJML+aRruvvmgrDQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tvMpLGoc/BczxqdrKNQsj9lHJH/G8sTmtz4RVzqxqmr72INCHpTLEK/RbV2II5v+8
         6aMtD3Z0SPaM5IulCr8hlwu04/V2mbPjpPOq29Onttq/7OkN2uxNTkhqJkw0cFPBW5
         0D6YBccss0YGZ+4FZag25qhHUkl4+PAU5reDeVsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 124/201] tcp: Fix a data-race around sysctl_tcp_thin_linear_timeouts.
Date:   Wed, 27 Jul 2022 18:10:28 +0200
Message-Id: <20220727161032.901741719@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161026.977588183@linuxfoundation.org>
References: <20220727161026.977588183@linuxfoundation.org>
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
index ec5277becc6a..50bba370486e 100644
--- a/net/ipv4/tcp_timer.c
+++ b/net/ipv4/tcp_timer.c
@@ -578,7 +578,7 @@ void tcp_retransmit_timer(struct sock *sk)
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



