Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 165DD68D8AE
	for <lists+stable@lfdr.de>; Tue,  7 Feb 2023 14:11:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232527AbjBGNLq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Feb 2023 08:11:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232291AbjBGNL2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Feb 2023 08:11:28 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E323C289
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 05:10:40 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 16166B8198E
        for <stable@vger.kernel.org>; Tue,  7 Feb 2023 13:10:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28F40C433D2;
        Tue,  7 Feb 2023 13:10:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675775436;
        bh=uRjtyO4j07J5l4XRzZHwbY5V0dkF2U/++5iYmH2kLLE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dqqm5B1K+VnRcYXslPublkiCXLHenBAIpy/LVeyESHtCcSJ/U3ayYBWug2/SYTD0X
         qcUUHZR1lCjVNwlSwRKpFqo3pYOxyYF44mYrkEKswfHrfBbKF2xn61CHCtcFurxOjA
         p8ynl2pWDNOkDYzhw79CxCvFn+lmP7wYULroklEA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 038/120] ip/ip6_gre: Fix changing addr gen mode not generating IPv6 link local address
Date:   Tue,  7 Feb 2023 13:56:49 +0100
Message-Id: <20230207125620.400329718@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230207125618.699726054@linuxfoundation.org>
References: <20230207125618.699726054@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>

[ Upstream commit 23ca0c2c93406bdb1150659e720bda1cec1fad04 ]

For our point-to-point GRE tunnels, they have IN6_ADDR_GEN_MODE_NONE
when they are created then we set IN6_ADDR_GEN_MODE_EUI64 when they
come up to generate the IPv6 link local address for the interface.
Recently we found that they were no longer generating IPv6 addresses.
This issue would also have affected SIT tunnels.

Commit e5dd729460ca changed the code path so that GRE tunnels
generate an IPv6 address based on the tunnel source address.
It also changed the code path so GRE tunnels don't call addrconf_addr_gen
in addrconf_dev_config which is called by addrconf_sysctl_addr_gen_mode
when the IN6_ADDR_GEN_MODE is changed.

This patch aims to fix this issue by moving the code in addrconf_notify
which calls the addr gen for GRE and SIT into a separate function
and calling it in the places that expect the IPv6 address to be
generated.

The previous addrconf_dev_config is renamed to addrconf_eth_config
since it only expected eth type interfaces and follows the
addrconf_gre/sit_config format.

A part of this changes means that the loopback address will be
attempted to be configured when changing addr_gen_mode for lo.
This should not be a problem because the address should exist anyway
and if does already exist then no error is produced.

Fixes: e5dd729460ca ("ip/ip6_gre: use the same logic as SIT interfaces when computing v6LL address")
Signed-off-by: Thomas Winter <Thomas.Winter@alliedtelesis.co.nz>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 49 +++++++++++++++++++++++++--------------------
 1 file changed, 27 insertions(+), 22 deletions(-)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index 8800987fdb40..cc1c94bc5b0e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -3447,6 +3447,30 @@ static void addrconf_gre_config(struct net_device *dev)
 }
 #endif
 
+static void addrconf_init_auto_addrs(struct net_device *dev)
+{
+	switch (dev->type) {
+#if IS_ENABLED(CONFIG_IPV6_SIT)
+	case ARPHRD_SIT:
+		addrconf_sit_config(dev);
+		break;
+#endif
+#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
+	case ARPHRD_IP6GRE:
+	case ARPHRD_IPGRE:
+		addrconf_gre_config(dev);
+		break;
+#endif
+	case ARPHRD_LOOPBACK:
+		init_loopback(dev);
+		break;
+
+	default:
+		addrconf_dev_config(dev);
+		break;
+	}
+}
+
 static int fixup_permanent_addr(struct net *net,
 				struct inet6_dev *idev,
 				struct inet6_ifaddr *ifp)
@@ -3611,26 +3635,7 @@ static int addrconf_notify(struct notifier_block *this, unsigned long event,
 			run_pending = 1;
 		}
 
-		switch (dev->type) {
-#if IS_ENABLED(CONFIG_IPV6_SIT)
-		case ARPHRD_SIT:
-			addrconf_sit_config(dev);
-			break;
-#endif
-#if IS_ENABLED(CONFIG_NET_IPGRE) || IS_ENABLED(CONFIG_IPV6_GRE)
-		case ARPHRD_IP6GRE:
-		case ARPHRD_IPGRE:
-			addrconf_gre_config(dev);
-			break;
-#endif
-		case ARPHRD_LOOPBACK:
-			init_loopback(dev);
-			break;
-
-		default:
-			addrconf_dev_config(dev);
-			break;
-		}
+		addrconf_init_auto_addrs(dev);
 
 		if (!IS_ERR_OR_NULL(idev)) {
 			if (run_pending)
@@ -6385,7 +6390,7 @@ static int addrconf_sysctl_addr_gen_mode(struct ctl_table *ctl, int write,
 
 			if (idev->cnf.addr_gen_mode != new_val) {
 				idev->cnf.addr_gen_mode = new_val;
-				addrconf_dev_config(idev->dev);
+				addrconf_init_auto_addrs(idev->dev);
 			}
 		} else if (&net->ipv6.devconf_all->addr_gen_mode == ctl->data) {
 			struct net_device *dev;
@@ -6396,7 +6401,7 @@ static int addrconf_sysctl_addr_gen_mode(struct ctl_table *ctl, int write,
 				if (idev &&
 				    idev->cnf.addr_gen_mode != new_val) {
 					idev->cnf.addr_gen_mode = new_val;
-					addrconf_dev_config(idev->dev);
+					addrconf_init_auto_addrs(idev->dev);
 				}
 			}
 		}
-- 
2.39.0



