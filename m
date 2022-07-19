Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A910579926
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 13:59:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237734AbiGSL7g (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 07:59:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237778AbiGSL7R (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 07:59:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3089A422FF;
        Tue, 19 Jul 2022 04:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD23CB81B1C;
        Tue, 19 Jul 2022 11:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 299D0C341C6;
        Tue, 19 Jul 2022 11:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658231852;
        bh=hDYxTrmhxg2oXocl7+kJNSoaNXsxGhvVaUgtHU2TV7A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NHss98e22jvDz1DEFW+LJEvVatJlXqPju5miZ0+Yo/OnVUFPzo+goMMZeS6JqS0Mt
         KqojP0aqySwenocDOdcrP73m4eFkJ5VqRetrObvLPOBvNTG5+2Llnxi30EYq216IwB
         K8PAJ4fulMW63/a6lcPH/BWwoAZNwO1LnesfmVfs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/43] ipv4: Fix data-races around sysctl_ip_dynaddr.
Date:   Tue, 19 Jul 2022 13:53:51 +0200
Message-Id: <20220719114523.783441466@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114521.868169025@linuxfoundation.org>
References: <20220719114521.868169025@linuxfoundation.org>
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
 Documentation/networking/ip-sysctl.txt | 2 +-
 net/ipv4/af_inet.c                     | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/Documentation/networking/ip-sysctl.txt b/Documentation/networking/ip-sysctl.txt
index 0278b6d1bc71..5849c119e0ef 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -858,7 +858,7 @@ ip_nonlocal_bind - BOOLEAN
 	which can be quite useful - but may break some applications.
 	Default: 0
 
-ip_dynaddr - BOOLEAN
+ip_dynaddr - INTEGER
 	If set non-zero, enables support for dynamic addresses.
 	If set to a non-zero value larger than 1, a kernel log
 	message will be printed when dynamic address rewriting
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index ee42907f4827..93dea10ef9a6 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1152,7 +1152,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	if (new_saddr == old_saddr)
 		return 0;
 
-	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) > 1) {
 		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
 			__func__, &old_saddr, &new_saddr);
 	}
@@ -1207,7 +1207,7 @@ int inet_sk_rebuild_header(struct sock *sk)
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



