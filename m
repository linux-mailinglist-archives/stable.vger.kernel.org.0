Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 560C35A49DE
	for <lists+stable@lfdr.de>; Mon, 29 Aug 2022 13:30:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232391AbiH2Lad (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Aug 2022 07:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232717AbiH2L3p (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 29 Aug 2022 07:29:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD1E57B2BE;
        Mon, 29 Aug 2022 04:18:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B32F561202;
        Mon, 29 Aug 2022 11:17:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5D19C433D6;
        Mon, 29 Aug 2022 11:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1661771860;
        bh=6EKBDqc52IalgZq0HP2UlKus3oH3wi8p+iN3Nd5JAPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jZQPWXiNdNjVx0OLdD+yUMkuRfIngHYt+Wbz8bMIUwgDLNNNHQWbJtUmMLeOPuLcZ
         UEZ12B3KyXNvk896tIXrTM2q4l03r2nqWmneA2IQxY+s5+3ytwsOWck1jpjS3fQTRz
         U5XSME9RJebNMckHoIWzwco8AJz6aMffjUgkBrcI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kuniyuki Iwashima <kuniyu@amazon.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 077/158] net: Fix data-races around sysctl_fb_tunnels_only_for_init_net.
Date:   Mon, 29 Aug 2022 12:58:47 +0200
Message-Id: <20220829105812.263072308@linuxfoundation.org>
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

[ Upstream commit af67508ea6cbf0e4ea27f8120056fa2efce127dd ]

While reading sysctl_fb_tunnels_only_for_init_net, it can be changed
concurrently.  Thus, we need to add READ_ONCE() to its readers.

Fixes: 79134e6ce2c9 ("net: do not create fallback tunnels for non-default namespaces")
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index 2563d30736e9a..78dd63a5c7c80 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -640,9 +640,14 @@ extern int sysctl_devconf_inherit_init_net;
  */
 static inline bool net_has_fallback_tunnels(const struct net *net)
 {
-	return !IS_ENABLED(CONFIG_SYSCTL) ||
-	       !sysctl_fb_tunnels_only_for_init_net ||
-	       (net == &init_net && sysctl_fb_tunnels_only_for_init_net == 1);
+#if IS_ENABLED(CONFIG_SYSCTL)
+	int fb_tunnels_only_for_init_net = READ_ONCE(sysctl_fb_tunnels_only_for_init_net);
+
+	return !fb_tunnels_only_for_init_net ||
+		(net_eq(net, &init_net) && fb_tunnels_only_for_init_net == 1);
+#else
+	return true;
+#endif
 }
 
 static inline int netdev_queue_numa_node_read(const struct netdev_queue *q)
-- 
2.35.1



