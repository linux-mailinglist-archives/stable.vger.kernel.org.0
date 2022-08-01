Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E14D586A63
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234029AbiHAMQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbiHAMPL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:15:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06E0978DC4;
        Mon,  1 Aug 2022 04:58:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9BBC8B81170;
        Mon,  1 Aug 2022 11:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DD47C433C1;
        Mon,  1 Aug 2022 11:58:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659355091;
        bh=F7T5biOEcTaFfcc4pS0uPhSCEkkPqFXDcQ+ZcZUxk9g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kZEpXsjxjdOjyf3d+xDmQFNgXRuDcEz+EO9Hl8nlZr54RzXdAe515UvSVJ7U0PCPI
         kC84gmoocT4kVarDrSA14MpOjE1inYPHSGSCnnVHiSwx8W4w2qktoIfFNQVV3nZq5U
         aUKa9bVClb/d5SaHdXQjsZOCeKc2XQYecavkSPjE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 58/88] tcp: Fix data-races around sk_pacing_rate.
Date:   Mon,  1 Aug 2022 13:47:12 +0200
Message-Id: <20220801114140.696861219@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 59bf6c65a09fff74215517aecffbbdcd67df76e3 ]

While reading sysctl_tcp_pacing_(ss|ca)_ratio, they can be changed
concurrently.  Thus, we need to add READ_ONCE() to their readers.

Fixes: 43e122b014c9 ("tcp: refine pacing rate determination")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index db78197a44ff..de066fad7dfe 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -910,9 +910,9 @@ static void tcp_update_pacing_rate(struct sock *sk)
 	 *	 end of slow start and should slow down.
 	 */
 	if (tcp_snd_cwnd(tp) < tp->snd_ssthresh / 2)
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ss_ratio);
 	else
-		rate *= sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio;
+		rate *= READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_pacing_ca_ratio);
 
 	rate *= max(tcp_snd_cwnd(tp), tp->packets_out);
 
-- 
2.35.1



