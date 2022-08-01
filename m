Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8245869AE
	for <lists+stable@lfdr.de>; Mon,  1 Aug 2022 14:05:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233454AbiHAMFQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Aug 2022 08:05:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233241AbiHAMEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 1 Aug 2022 08:04:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3102CC98;
        Mon,  1 Aug 2022 04:54:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2C36361359;
        Mon,  1 Aug 2022 11:54:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 339D5C433C1;
        Mon,  1 Aug 2022 11:54:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659354869;
        bh=RHLZqNBbIgv64GmtlhKXb1VtjWOj9bh/sszpV2njg8Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x3PwZpKZTxiKYX/IMaXr8BHMZ5PbABOMxPIaKwNjS46aOCNyAp5QUjxR4J07zxr1K
         QaOyEhwhrHFqgDjLKPCimCMRWCpvaX77MCzkdutUHaCy5rW2qUD+kXplAj7BEcLmPK
         ls4t2izxLUxZyZEucpo1AF/a0+mdQU2zuvUgx1HA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 50/69] tcp: Fix a data-race around sysctl_tcp_comp_sack_slack_ns.
Date:   Mon,  1 Aug 2022 13:47:14 +0200
Message-Id: <20220801114136.500429302@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220801114134.468284027@linuxfoundation.org>
References: <20220801114134.468284027@linuxfoundation.org>
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

[ Upstream commit 22396941a7f343d704738360f9ef0e6576489d43 ]

While reading sysctl_tcp_comp_sack_slack_ns, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its reader.

Fixes: a70437cc09a1 ("tcp: add hrtimer slack to sack compression")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 486ca1d5b436..7b593865b4ae 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5517,7 +5517,7 @@ static void __tcp_ack_snd_check(struct sock *sk, int ofo_possible)
 		      rtt * (NSEC_PER_USEC >> 3)/20);
 	sock_hold(sk);
 	hrtimer_start_range_ns(&tp->compressed_ack_timer, ns_to_ktime(delay),
-			       sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns,
+			       READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_comp_sack_slack_ns),
 			       HRTIMER_MODE_REL_PINNED_SOFT);
 }
 
-- 
2.35.1



