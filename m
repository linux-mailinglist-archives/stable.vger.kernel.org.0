Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D40DE579A11
	for <lists+stable@lfdr.de>; Tue, 19 Jul 2022 14:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238537AbiGSMKa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 19 Jul 2022 08:10:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238932AbiGSMJv (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 19 Jul 2022 08:09:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98E914B0D6;
        Tue, 19 Jul 2022 05:02:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1A75D616F9;
        Tue, 19 Jul 2022 12:02:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE51C341C6;
        Tue, 19 Jul 2022 12:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658232170;
        bh=32cDH5LJ8oO8iHcpk6DSNjGqQgqrVEeIe+MIDkeVerw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZZN4i1h5df6NE3VdhrnC6YhxA3aRbbUL+FzTxDKFSGsqvTuYPfOMXE0qaaEXATyqW
         ap+1xGwrPm5x+lOMpdaXQ5m+bVOE3bXCPJ06lTANv0QXlNOR9e3WaCkudEvwXaV/TS
         SnvgJDb+mBDSl36arj0UyEUr+S0JRqmScytqqvnM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 37/71] ipv4: Fix data-races around sysctl_ip_dynaddr.
Date:   Tue, 19 Jul 2022 13:54:00 +0200
Message-Id: <20220719114555.869977812@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220719114552.477018590@linuxfoundation.org>
References: <20220719114552.477018590@linuxfoundation.org>
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
index f60d4159fff4..787a9c077ef1 100644
--- a/Documentation/networking/ip-sysctl.txt
+++ b/Documentation/networking/ip-sysctl.txt
@@ -953,7 +953,7 @@ ip_nonlocal_bind - BOOLEAN
 	which can be quite useful - but may break some applications.
 	Default: 0
 
-ip_dynaddr - BOOLEAN
+ip_dynaddr - INTEGER
 	If set non-zero, enables support for dynamic addresses.
 	If set to a non-zero value larger than 1, a kernel log
 	message will be printed when dynamic address rewriting
diff --git a/net/ipv4/af_inet.c b/net/ipv4/af_inet.c
index a7a6b1adb698..9ab73fcc7411 100644
--- a/net/ipv4/af_inet.c
+++ b/net/ipv4/af_inet.c
@@ -1215,7 +1215,7 @@ static int inet_sk_reselect_saddr(struct sock *sk)
 	if (new_saddr == old_saddr)
 		return 0;
 
-	if (sock_net(sk)->ipv4.sysctl_ip_dynaddr > 1) {
+	if (READ_ONCE(sock_net(sk)->ipv4.sysctl_ip_dynaddr) > 1) {
 		pr_info("%s(): shifting inet->saddr from %pI4 to %pI4\n",
 			__func__, &old_saddr, &new_saddr);
 	}
@@ -1270,7 +1270,7 @@ int inet_sk_rebuild_header(struct sock *sk)
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



