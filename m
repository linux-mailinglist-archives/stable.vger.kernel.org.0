Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D9039548C36
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:12:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378175AbiFMNmE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 09:42:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379219AbiFMNkD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 09:40:03 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98D13CE1A;
        Mon, 13 Jun 2022 04:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3611F61037;
        Mon, 13 Jun 2022 11:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 459DBC34114;
        Mon, 13 Jun 2022 11:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655119821;
        bh=iEiLZMAi4r23IEn/jxT1qzEzPzoZvPtxWJI0p2hAUP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=O4feMX9mu3Pj0ROzlD2J75oG2VmH9okh5idkHfKtmyFC7j6ZRASi5jYS68Xpr1kzP
         SZeCWuk/718DSvAlpQmsV8ofkq2jdXPgWti5yvBCITY6D6lsfdncs7ELxd5VvPggy6
         RE0nty4aSuowzDJjHFtXvH4XqL8TfcfH2ChuTItg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hangbin Liu <liuhangbin@gmail.com>,
        Jonathan Toppins <jtoppins@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.18 133/339] bonding: guard ns_targets by CONFIG_IPV6
Date:   Mon, 13 Jun 2022 12:09:18 +0200
Message-Id: <20220613094930.543814055@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094926.497929857@linuxfoundation.org>
References: <20220613094926.497929857@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit c4caa500ffebf64795d1c0f6f9d6f179b502c6b7 ]

Guard ns_targets in struct bond_params by CONFIG_IPV6, which could save
256 bytes if IPv6 not configed. Also add this protection for function
bond_is_ip6_target_ok() and bond_get_targets_ip6().

Remove the IS_ENABLED() check for bond_opts[] as this will make
BOND_OPT_NS_TARGETS uninitialized if CONFIG_IPV6 not enabled. Add
a dummy bond_option_ns_ip6_targets_set() for this situation.

Fixes: 4e24be018eb9 ("bonding: add new parameter ns_targets")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jonathan Toppins <jtoppins@redhat.com>
Link: https://lore.kernel.org/r/20220531063727.224043-1-liuhangbin@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c    |  2 ++
 drivers/net/bonding/bond_options.c | 10 ++++++----
 include/net/bonding.h              |  6 ++++++
 3 files changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b5c5196e03ee..26a6573adf0f 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -6159,7 +6159,9 @@ static int bond_check_params(struct bond_params *params)
 		strscpy_pad(params->primary, primary, sizeof(params->primary));
 
 	memcpy(params->arp_targets, arp_target, sizeof(arp_target));
+#if IS_ENABLED(CONFIG_IPV6)
 	memset(params->ns_targets, 0, sizeof(struct in6_addr) * BOND_MAX_NS_TARGETS);
+#endif
 
 	return 0;
 }
diff --git a/drivers/net/bonding/bond_options.c b/drivers/net/bonding/bond_options.c
index 64f7db2627ce..1f8323ad5282 100644
--- a/drivers/net/bonding/bond_options.c
+++ b/drivers/net/bonding/bond_options.c
@@ -34,10 +34,8 @@ static int bond_option_arp_ip_target_add(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_target_rem(struct bonding *bond, __be32 target);
 static int bond_option_arp_ip_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
-#if IS_ENABLED(CONFIG_IPV6)
 static int bond_option_ns_ip6_targets_set(struct bonding *bond,
 					  const struct bond_opt_value *newval);
-#endif
 static int bond_option_arp_validate_set(struct bonding *bond,
 					const struct bond_opt_value *newval);
 static int bond_option_arp_all_targets_set(struct bonding *bond,
@@ -299,7 +297,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_arp_ip_targets_set
 	},
-#if IS_ENABLED(CONFIG_IPV6)
 	[BOND_OPT_NS_TARGETS] = {
 		.id = BOND_OPT_NS_TARGETS,
 		.name = "ns_ip6_target",
@@ -307,7 +304,6 @@ static const struct bond_option bond_opts[BOND_OPT_LAST] = {
 		.flags = BOND_OPTFLAG_RAWVAL,
 		.set = bond_option_ns_ip6_targets_set
 	},
-#endif
 	[BOND_OPT_DOWNDELAY] = {
 		.id = BOND_OPT_DOWNDELAY,
 		.name = "downdelay",
@@ -1254,6 +1250,12 @@ static int bond_option_ns_ip6_targets_set(struct bonding *bond,
 
 	return 0;
 }
+#else
+static int bond_option_ns_ip6_targets_set(struct bonding *bond,
+					  const struct bond_opt_value *newval)
+{
+	return -EPERM;
+}
 #endif
 
 static int bond_option_arp_validate_set(struct bonding *bond,
diff --git a/include/net/bonding.h b/include/net/bonding.h
index b14f4c0b4e9e..cb904d356e31 100644
--- a/include/net/bonding.h
+++ b/include/net/bonding.h
@@ -149,7 +149,9 @@ struct bond_params {
 	struct reciprocal_value reciprocal_packets_per_slave;
 	u16 ad_actor_sys_prio;
 	u16 ad_user_port_key;
+#if IS_ENABLED(CONFIG_IPV6)
 	struct in6_addr ns_targets[BOND_MAX_NS_TARGETS];
+#endif
 
 	/* 2 bytes of padding : see ether_addr_equal_64bits() */
 	u8 ad_actor_system[ETH_ALEN + 2];
@@ -503,12 +505,14 @@ static inline int bond_is_ip_target_ok(__be32 addr)
 	return !ipv4_is_lbcast(addr) && !ipv4_is_zeronet(addr);
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_is_ip6_target_ok(struct in6_addr *addr)
 {
 	return !ipv6_addr_any(addr) &&
 	       !ipv6_addr_loopback(addr) &&
 	       !ipv6_addr_is_multicast(addr);
 }
+#endif
 
 /* Get the oldest arp which we've received on this slave for bond's
  * arp_targets.
@@ -746,6 +750,7 @@ static inline int bond_get_targets_ip(__be32 *targets, __be32 ip)
 	return -1;
 }
 
+#if IS_ENABLED(CONFIG_IPV6)
 static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr *ip)
 {
 	int i;
@@ -758,6 +763,7 @@ static inline int bond_get_targets_ip6(struct in6_addr *targets, struct in6_addr
 
 	return -1;
 }
+#endif
 
 /* exported from bond_main.c */
 extern unsigned int bond_net_id;
-- 
2.35.1



