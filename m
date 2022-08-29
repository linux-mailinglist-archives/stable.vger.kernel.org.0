Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF3D15A4897
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:12:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbiH2LMv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:12:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231226AbiH2LMO (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:12:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAF6F61D84;
        Mon, 29 Aug 2022 04:08:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 70B2CB80F98;
        Mon, 29 Aug 2022 11:07:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC2ADC433C1;
        Mon, 29 Aug 2022 11:07:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771264;
        bh=uMRB23unHmTqcawSbCqlYIwEgqixTCYXTgtjzWJQvl4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MCScNTAgtv09GjiaJAi67LvAtQJUpv5wTh2w6T4OMCD42vdYXUu2Y57aGsI/WpB7G
         jRNnsajHoksVkUpKyrfLGYeSp0zcnuu2z7knPPq6qeptqfBvXrHbP6hniJ5FQGynbj
         f+sCbnSW7dxHVClyllUJIwswIdLsl2gXL7RZEyQM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 085/136] net: Fix data-races around sysctl_devconf_inherit_init_net.
Date:   Mon, 29 Aug 2022 12:59:12 +0200
Message-Id: <20220829105808.143229770@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220829105804.609007228@linuxfoundation.org>
References: <20220829105804.609007228@linuxfoundation.org>
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
index f9ed41ca7ac6d..3b97438afe3e2 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -636,6 +636,15 @@ static inline bool net_has_fallback_tunnels(const struct net *net)
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
index 4744c7839de53..9ac41ffdc6344 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2673,23 +2673,27 @@ static __net_init int devinet_init_net(struct net *net)
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
index 6dcf034835ecd..8800987fdb402 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7128,9 +7128,8 @@ static int __net_init addrconf_init_net(struct net *net)
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



