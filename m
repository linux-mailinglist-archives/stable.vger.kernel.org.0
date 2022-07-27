Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 98D65582E3E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:10:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241270AbiG0RKD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:10:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241753AbiG0RJm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:09:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3F61501BF;
        Wed, 27 Jul 2022 09:41:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C5D80601CE;
        Wed, 27 Jul 2022 16:41:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF276C433D6;
        Wed, 27 Jul 2022 16:41:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940068;
        bh=4nPOBYRVh1TeKFhmDIyIk4pggIEMowzCSYFN4GeClBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=p2q7R4/qg6V+3FgIzzUAF7MTTylqVSiEWg1/M/FiIE5JOdJBzXEFnaRlIGgbTXhhY
         QZkZujKsSOQzMc6orUbF+z32N81np+bg0o3n4FT7oiOBkC1XXy0ykk6qyM2M0moTNN
         eizXFmVqras/+6bG2B6cfaIu0Y8hh8fr7w7KRAps=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 093/201] tcp: Fix data-races around sysctl_tcp_migrate_req.
Date:   Wed, 27 Jul 2022 18:09:57 +0200
Message-Id: <20220727161031.613409590@linuxfoundation.org>
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

[ Upstream commit 4177f545895b1da08447a80692f30617154efa6e ]

While reading sysctl_tcp_migrate_req, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: f9ac779f881c ("net: Introduce net.ipv4.tcp_migrate_req.")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/sock_reuseport.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/core/sock_reuseport.c b/net/core/sock_reuseport.c
index 3f00a28fe762..5daa1fa54249 100644
--- a/net/core/sock_reuseport.c
+++ b/net/core/sock_reuseport.c
@@ -387,7 +387,7 @@ void reuseport_stop_listen_sock(struct sock *sk)
 		prog = rcu_dereference_protected(reuse->prog,
 						 lockdep_is_held(&reuseport_lock));
 
-		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req ||
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_migrate_req) ||
 		    (prog && prog->expected_attach_type == BPF_SK_REUSEPORT_SELECT_OR_MIGRATE)) {
 			/* Migration capable, move sk from the listening section
 			 * to the closed section.
@@ -545,7 +545,7 @@ struct sock *reuseport_migrate_sock(struct sock *sk,
 	hash = migrating_sk->sk_hash;
 	prog = rcu_dereference(reuse->prog);
 	if (!prog || prog->expected_attach_type != BPF_SK_REUSEPORT_SELECT_OR_MIGRATE) {
-		if (sock_net(sk)->ipv4.sysctl_tcp_migrate_req)
+		if (READ_ONCE(sock_net(sk)->ipv4.sysctl_tcp_migrate_req))
 			goto select_by_hash;
 		goto failure;
 	}
-- 
2.35.1



