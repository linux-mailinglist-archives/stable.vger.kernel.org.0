Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAFDD63583F
	for <lists+stable@lfdr.de>; Wed, 23 Nov 2022 10:54:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237161AbiKWJxJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Nov 2022 04:53:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238298AbiKWJv4 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Nov 2022 04:51:56 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4530A2B197
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 01:49:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2DBF61A02
        for <stable@vger.kernel.org>; Wed, 23 Nov 2022 09:49:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDBA8C433C1;
        Wed, 23 Nov 2022 09:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1669196944;
        bh=mqABDUEpmVXQk3MWnYnRKuFUkhc3NLgO8zY8dNWPb4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BPJAqPB7xJV+uN3OW7lUO0fHY9y/LL6hVwsKbWTXTnW3ndXxdJaj/sRyRKuWBifLS
         gd7lwfi2JxheraJs2Z/QWXO0+LkXoKuYU6Fm+Kr3kMSCsUPsLSFVtWQCvmkS5rO+Nl
         cgtGvHKjrU3UXJZ1jREGueHytFkk0S53B+Jw2ZBI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Chuang Wang <nashuiliang@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 157/314] net: macvlan: Use built-in RCU list checking
Date:   Wed, 23 Nov 2022 09:50:02 +0100
Message-Id: <20221123084632.678330160@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084625.457073469@linuxfoundation.org>
References: <20221123084625.457073469@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Chuang Wang <nashuiliang@gmail.com>

[ Upstream commit 5df1341ea822292275c56744aab9c536d75c33be ]

hlist_for_each_entry_rcu() has built-in RCU and lock checking.

Pass cond argument to hlist_for_each_entry_rcu() to silence false
lockdep warning when CONFIG_PROVE_RCU_LIST is enabled.

Execute as follow:

 ip link add link eth0 type macvlan mode source macaddr add <MAC-ADDR>

The rtnl_lock is held when macvlan_hash_lookup_source() or
macvlan_fill_info_macaddr() are called in the non-RCU read side section.
So, pass lockdep_rtnl_is_held() to silence false lockdep warning.

Fixes: 79cf79abce71 ("macvlan: add source mode")
Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macvlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/macvlan.c b/drivers/net/macvlan.c
index 9983d37ee87d..059e4ff0e510 100644
--- a/drivers/net/macvlan.c
+++ b/drivers/net/macvlan.c
@@ -141,7 +141,7 @@ static struct macvlan_source_entry *macvlan_hash_lookup_source(
 	u32 idx = macvlan_eth_hash(addr);
 	struct hlist_head *h = &vlan->port->vlan_source_hash[idx];
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (ether_addr_equal_64bits(entry->addr, addr) &&
 		    entry->vlan == vlan)
 			return entry;
@@ -1647,7 +1647,7 @@ static int macvlan_fill_info_macaddr(struct sk_buff *skb,
 	struct hlist_head *h = &vlan->port->vlan_source_hash[i];
 	struct macvlan_source_entry *entry;
 
-	hlist_for_each_entry_rcu(entry, h, hlist) {
+	hlist_for_each_entry_rcu(entry, h, hlist, lockdep_rtnl_is_held()) {
 		if (entry->vlan != vlan)
 			continue;
 		if (nla_put(skb, IFLA_MACVLAN_MACADDR, ETH_ALEN, entry->addr))
-- 
2.35.1



