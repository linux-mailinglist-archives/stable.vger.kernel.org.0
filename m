Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A93D579B32
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:25:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239721AbiGSMZ2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40122 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240327AbiGSMYw (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:24:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF284AD5B;
        Tue, 19 Jul 2022 05:09:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED5EA6177E;
        Tue, 19 Jul 2022 12:09:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61F44C341CA;
        Tue, 19 Jul 2022 12:09:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232548;
        bh=1jbgUH0Mel0TYxpjgWUOesjGNI5LW/zvQ0Etj2CkzhU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qJFeM2ZMdxNF8PRFXaQOP/b1mOQ+iNxGzvlebNsM0hXod7P/Dd09QEk6oSw9kj1At
         0Q4+NYg18PYDqKH+KNt42urF5us2QXWY7IOrg9/rEEQgt1mMwW+WYigoLLHS8xiZS6
         +lzmLseGA2Kx7OU82Ut+MRbnjA+vkaHy23r/CR74=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 062/112] ipv4: Fix data-races around sysctl_ip_dynaddr.
Date:   Tue, 19 Jul 2022 13:53:55 +0200
Message-Id: <20220719114632.518016482@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114626.156073229@linuxfoundation.org>
References: <20220719114626.156073229@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e49e4aff7ec19b2d0d0957ee30e93dade57dab9e ]

While reading sysctl_ip_dynaddr, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/networking/ip-sysctl.rst | 2 +-
 net/ipv4/af_inet.c                     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.rst b/Documentation/networking/ip-sysctl.rst
index 73de75906b24..0b1f3235aa77 100644
--- a/Documentation/networking/ip-sysctl.rst
+++ b/Documentation/networking/ip-sysctl.rst
@@ -1080,7 +1080,7 @@ ip_autobind_reuse - BOOLEAN
 	option should only be set by experts.
 	Default: 0
 
-ip_dynaddr - BOOLEAN
+ip_dynaddr - INTEGER
 	If set non-zero, enables support for dynamic addresses.
 	If set to a non-zero value larger than 1, a kernel log
 	message will be printed when dynamic address rewriting
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index 742218594741..e77283069c7b 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1245,7 +1245,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	if (new_saddr == old_saddr)
 		return 0;
 
-	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) > 1) {
 		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
 			__func__, &old_saddr, &new_saddr);
 	}
@@ -1300,7 +1300,7 @@ int inet_sk_rebuild_header(struct sock *sk)
 		 * Other protocols have to map its equivalent state to TCP_SYN_SENT.
 		 * DCCP maps its DCCP_REQUESTING state to TCP_SYN_SENT. -acme
 		 */
-		if (!sock_net(sk)->ipv4.sysctl_ip_dynaddr ||
+		if (!READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) ||
 		    sk->sk_state != TCP_SYN_SENT ||
 		    (sk->sk_userlocks & SOCK_BINDADDR_LOCK) ||
 		    (err = inet_sk_reselect_saddr(sk)) != 0)
-- 
2.35.1



