Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC4A2B62B7
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:32:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731487AbgKQNaz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 08:30:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:40190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731968AbgKQNaz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 08:30:55 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BBFA221534;
        Tue, 17 Nov 2020 13:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605619855;
        bh=ICD/pBlfF/1rrGnZ09oLzE5jQcCl5c5B1IAhUkLiBMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JUOMnmJdSrMB1hs+4gN/4RinUlokzc5Aejd/zCgonw2paFFyWfuNLCwiwoX2UwBjb
         bJqetb4Y3fXOREpzGZs5qsg9g9SRy3pTmYTQfyerL6eOQkrndCpDaGnFwh7pQ2dDoY
         nVudQ6tBhfLoCc0s4wbn1QntdWJAJ9u97/uHBPSk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Nicolas Dichtel <nicolas.dichtel@6wind.com>,
        Xin Long <lucien.xin@gmail.com>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.9 006/255] xfrm: interface: fix the priorities for ipip and ipv6 tunnels
Date:   Tue, 17 Nov 2020 14:02:26 +0100
Message-Id: <20201117122139.243792790@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201117122138.925150709@linuxfoundation.org>
References: <20201117122138.925150709@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>

[ Upstream commit 7fe94612dd4cfcd35fe0ec87745fb31ad2be71f8 ]

As Nicolas noticed in his case, when xfrm_interface module is installed
the standard IP tunnels will break in receiving packets.

This is caused by the IP tunnel handlers with a higher priority in xfrm
interface processing incoming packets by xfrm_input(), which would drop
the packets and return 0 instead when anything wrong happens.

Rather than changing xfrm_input(), this patch is to adjust the priority
for the IP tunnel handlers in xfrm interface, so that the packets would
go to xfrmi's later than the others', as the others' would not drop the
packets when the handlers couldn't process them.

Note that IPCOMP also defines its own IPIP tunnel handler and it calls
xfrm_input() as well, so we must make its priority lower than xfrmi's,
which means having xfrmi loaded would still break IPCOMP. We may seek
another way to fix it in xfrm_input() in the future.

Reported-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Tested-by: Nicolas Dichtel <nicolas.dichtel@6wind.com>
Fixes: da9bbf0598c9 ("xfrm: interface: support IPIP and IPIP6 tunnels processing with .cb_handler")
FIxes: d7b360c2869f ("xfrm: interface: support IP6IP6 and IP6IP tunnels processing with .cb_handler")
Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/xfrm4_tunnel.c   | 4 ++--
 net/ipv6/xfrm6_tunnel.c   | 4 ++--
 net/xfrm/xfrm_interface.c | 8 ++++----
 3 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/net/ipv4/xfrm4_tunnel.c b/net/ipv4/xfrm4_tunnel.c
index dc19aff7c2e00..fb0648e7fb32f 100644
--- a/net/ipv4/xfrm4_tunnel.c
+++ b/net/ipv4/xfrm4_tunnel.c
@@ -64,14 +64,14 @@ static int xfrm_tunnel_err(struct sk_buff *skb, u32 info)
 static struct xfrm_tunnel xfrm_tunnel_handler __read_mostly = {
 	.handler	=	xfrm_tunnel_rcv,
 	.err_handler	=	xfrm_tunnel_err,
-	.priority	=	3,
+	.priority	=	4,
 };
 
 #if IS_ENABLED(CONFIG_IPV6)
 static struct xfrm_tunnel xfrm64_tunnel_handler __read_mostly = {
 	.handler	=	xfrm_tunnel_rcv,
 	.err_handler	=	xfrm_tunnel_err,
-	.priority	=	2,
+	.priority	=	3,
 };
 #endif
 
diff --git a/net/ipv6/xfrm6_tunnel.c b/net/ipv6/xfrm6_tunnel.c
index 25b7ebda2fabf..f696d46e69100 100644
--- a/net/ipv6/xfrm6_tunnel.c
+++ b/net/ipv6/xfrm6_tunnel.c
@@ -303,13 +303,13 @@ static const struct xfrm_type xfrm6_tunnel_type = {
 static struct xfrm6_tunnel xfrm6_tunnel_handler __read_mostly = {
 	.handler	= xfrm6_tunnel_rcv,
 	.err_handler	= xfrm6_tunnel_err,
-	.priority	= 2,
+	.priority	= 3,
 };
 
 static struct xfrm6_tunnel xfrm46_tunnel_handler __read_mostly = {
 	.handler	= xfrm6_tunnel_rcv,
 	.err_handler	= xfrm6_tunnel_err,
-	.priority	= 2,
+	.priority	= 3,
 };
 
 static int __net_init xfrm6_tunnel_net_init(struct net *net)
diff --git a/net/xfrm/xfrm_interface.c b/net/xfrm/xfrm_interface.c
index a8f66112c52b4..0bb7963b9f6bc 100644
--- a/net/xfrm/xfrm_interface.c
+++ b/net/xfrm/xfrm_interface.c
@@ -830,14 +830,14 @@ static struct xfrm6_tunnel xfrmi_ipv6_handler __read_mostly = {
 	.handler	=	xfrmi6_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 
 static struct xfrm6_tunnel xfrmi_ip6ip_handler __read_mostly = {
 	.handler	=	xfrmi6_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi6_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 #endif
 
@@ -875,14 +875,14 @@ static struct xfrm_tunnel xfrmi_ipip_handler __read_mostly = {
 	.handler	=	xfrmi4_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
-	.priority	=	-1,
+	.priority	=	3,
 };
 
 static struct xfrm_tunnel xfrmi_ipip6_handler __read_mostly = {
 	.handler	=	xfrmi4_rcv_tunnel,
 	.cb_handler	=	xfrmi_rcv_cb,
 	.err_handler	=	xfrmi4_err,
-	.priority	=	-1,
+	.priority	=	2,
 };
 #endif
 
-- 
2.27.0



