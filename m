Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D23D1582D1D
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:55:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240841AbiG0QzK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240824AbiG0Qwy (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:52:54 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA2FA4F64F;
        Wed, 27 Jul 2022 09:35:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EBB1F61A90;
        Wed, 27 Jul 2022 16:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF02CC43140;
        Wed, 27 Jul 2022 16:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939704;
        bh=kZs9JDzZYR3FSSE5A7UZZCTDpN4sqytA4Vh3sGJMBXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R16yoMbKoMjsxqI7Qg833yNoWZzwiqXJk8/ozeZhwgJlu4u0Z36HY6CCRwPh0RgIK
         zKOdeBeyBwiiRrLzRHBLUgNgGQfl6nUsniHmPhoRHwnAKPDR78VW6tygpqhVCkWaoL
         /eq1AYW1bKq79hKekFLRpQoA5SqMjyogtPvBGt9o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 074/105] tcp: Fix a data-race around sysctl_tcp_stdurg.
Date:   Wed, 27 Jul 2022 18:11:00 +0200
Message-Id: <20220727161015.026334309@linuxfoundation.org>
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

[ Upstream commit 4e08ed41cb1194009fc1a916a59ce3ed4afd77cd ]

While reading sysctl_tcp_stdurg, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its reader.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_input.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_input.c b/net/ipv4/tcp_input.c
index 1dc1d62093b3..c89452761b3f 100644
--- a/net/ipv4/tcp_input.c
+++ b/net/ipv4/tcp_input.c
@@ -5492,7 +5492,7 @@ static void tcp_check_urg(struct sock *sk, const struct tcphdr *th)
 	struct tcp_sock *tp = tcp_sk(sk);
 	u32 ptr = ntohs(th->urg_ptr);
 
-	if (ptr && !sock_net(sk)->ipv4.sysctl_tcp_stdurg)
+	if (ptr && !READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_stdurg))
 		ptr--;
 	ptr += ntohl(th->seq);
 
-- 
2.35.1



