Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 773555A49FA
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:31:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232495AbiH2Lbk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:31:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232319AbiH2LaL (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:30:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 464D97C1EC;
        Mon, 29 Aug 2022 04:18:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 87D64611DA;
        Mon, 29 Aug 2022 11:15:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 797C4C433D6;
        Mon, 29 Aug 2022 11:15:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771750;
        bh=F9CMrlLKuDuW/PSzOwejgDCrb0NKteycphC9H61ILMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=WOG/fpWB173qNRMcFFWSVPCzZ3PIPi0bvKapyDCKqfCqmoIhH4gPPsEntHBfBHK3k
         /3DVgB3XlbK6BdOgTvLTKlY+s8XA1ZDnNcxV7Rxf+53IyiEOCscJPHV6DfbmnhNxqA
         pNeZjkhZHJYUWZsoQYHAn5j4vFJiUwVhTh70eDuw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 078/158] net: Fix data-races around sysctl_devconf_inherit_init_net.
Date:   Mon, 29 Aug 2022 12:58:48 +0200
Message-Id: <20220829105812.310428515@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105808.828227973@linuxfoundation.org>
References: <20220829105808.828227973@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit a5612ca10d1aa05624ebe72633e0c8c792970833 ]

While reading sysctl_devconf_inherit_init_net, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 856c395cfa63 ("net: introduce a knob to control whether to inherit devconf config")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h |  9 +++++++++
 net/ipv4/devinet.c        | 16 ++++++++++------
 net/ipv6/addrconf.c       |  5 ++---
 3 files changed, 21 insertions(+), 9 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 78dd63a5c7c80..db40bc62213bd 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -650,6 +650,15 @@ static inline bool net_has_fallback_tunnels(const struct net *net)
 #endif
 }
 
+static inline int net_inherit_devconf(void)
+{
+#if IS_ENABLED(CONFIG_SYSCTL)
+	return READ_ONCE(sysctl_devconf_inherit_init_net);
+#else
+	return 0;
+#endif
+}
+
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
 {
 #if defined(CONFIG_XPS) && defined(CONFIG_NUMA)
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index b2366ad540e62..787a44e3222db 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2682,23 +2682,27 @@ static __net_init int devinet_init_net(struct net *net)
 #endif
 
 	if (!net_eq(net, &init_net)) {
-		if (IS_ENABLED(CONFIG_SYSCTL) &&
-		    sysctl_devconf_inherit_init_net == 3) {
+		switch (net_inherit_devconf()) {
+		case 3:
 			/* copy from the current netns */
 			memcpy(all, current->nsproxy->net_ns->ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
 			memcpy(dflt,
 			       current->nsproxy->net_ns->ipv4.devconf_dflt,
 			       sizeof(ipv4_devconf_dflt));
-		} else if (!IS_ENABLED(CONFIG_SYSCTL) ||
-			   sysctl_devconf_inherit_init_net != 2) {
-			/* inherit == 0 or 1: copy from init_net */
+			break;
+		case 0:
+		case 1:
+			/* copy from init_net */
 			memcpy(all, init_net.ipv4.devconf_all,
 			       sizeof(ipv4_devconf));
 			memcpy(dflt, init_net.ipv4.devconf_dflt,
 			       sizeof(ipv4_devconf_dflt));
+			break;
+		case 2:
+			/* use compiled values */
+			break;
 		}
-		/* else inherit == 2: use compiled values */
 	}
 
 #ifdef CONFIG_SYSCTL
diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 49cc6587dd771..b738eb7e1cae8 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7158,9 +7158,8 @@ static int __net_init addrconf_init_net(struct net *net)
 	if (!dflt)
 		goto err_alloc_dflt;
 
-	if (IS_ENABLED(CONFIG_SYSCTL) &&
-	    !net_eq(net, &init_net)) {
-		switch (sysctl_devconf_inherit_init_net) {
+	if (!net_eq(net, &init_net)) {
+		switch (net_inherit_devconf()) {
 		case 1:  /* copy from init_net */
 			memcpy(all, init_net.ipv6.devconf_all,
 			       sizeof(ipv6_devconf));
-- 
2.35.1



