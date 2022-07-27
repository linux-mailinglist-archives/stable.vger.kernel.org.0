Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9021B583042
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 19:35:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242415AbiG0RfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 13:35:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242732AbiG0Rew (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 13:34:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A3983F07;
        Wed, 27 Jul 2022 09:49:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C7AA1B821D2;
        Wed, 27 Jul 2022 16:49:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3456AC433D6;
        Wed, 27 Jul 2022 16:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658940559;
        bh=yO/lDs1tzTNDuRJk8SFnUSVSSqM3pggkSXFLZ0ov0Aw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=SIgdBk4ijfd3LABkUzBuiwoJIxSh83iEqKsCSHkJ4+bTh0xaBVDr6fcJ986yqIqDZ
         AuYRotU+tOmhjQSMs92rY0V+q+Bcb3RMT53HdSt9p9jKc1nI5RW2H5kXAZD3uHzxNG
         At7vletW1LWxGbCS4/hF2dDE6jGEYgSP7MNKGTH0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 036/158] ip: Fix data-races around sysctl_ip_nonlocal_bind.
Date:   Wed, 27 Jul 2022 18:11:40 +0200
Message-Id: <20220727161022.924691668@linuxfoundation.org>
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

[ Upstream commit 289d3b21fb0bfc94c4e98f10635bba1824e5f83c ]

While reading sysctl_ip_nonlocal_bind, it can be changed concurrently.
Thus, we need to add READ_ONCE() to its readers.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/inet_sock.h | 2 +-
 net/sctp/protocol.c     | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/net/inet_sock.h b/include/net/inet_sock.h
index 48e4c59d85e2..2f6b715acc15 100644
--- a/include/net/inet_sock.h
+++ b/include/net/inet_sock.h
@@ -373,7 +373,7 @@ static inline bool inet_get_convert_csum(struct sock *sk)
 static inline bool inet_can_nonlocal_bind(struct net *net,
 					  struct inet_sock *inet)
 {
-	return net->ipv4.sysctl_ip_nonlocal_bind ||
+	return READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind) ||
 		inet->freebind || inet->transparent;
 }
 
diff --git a/net/sctp/protocol.c b/net/sctp/protocol.c
index 35928fefae33..1a094b087d88 100644
--- a/net/sctp/protocol.c
+++ b/net/sctp/protocol.c
@@ -358,7 +358,7 @@ static int sctp_v4_available(union sctp_addr *addr, struct sctp_sock *sp)
 	if (addr->v4.sin_addr.s_addr != htonl(INADDR_ANY) &&
 	   ret != RTN_LOCAL &&
 	   !sp->inet.freebind &&
-	   !net->ipv4.sysctl_ip_nonlocal_bind)
+	    !READ_ONCE(net->ipv4.sysctl_ip_nonlocal_bind))
 		return 0;
 
 	if (ipv6_only_sock(sctp_opt2sk(sp)))
-- 
2.35.1



