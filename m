Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A575291CA
	for <lists+stable@lfdr.de>; Mon, 16 May 2022 22:49:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343560AbiEPUJQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 May 2022 16:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350665AbiEPUBb (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 May 2022 16:01:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9503242ED6;
        Mon, 16 May 2022 12:55:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 24C8960EC4;
        Mon, 16 May 2022 19:55:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14230C385AA;
        Mon, 16 May 2022 19:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1652730928;
        bh=LqkDsgdTaIFoFd0GGkpTz8fb4vKyWu5c885Nl+Bs2eA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o9RwB7X7DzPy1SQY6PaChY57NsjuelNCEhs7VM49IcGRtW64T3j6+IL27sohn4m5V
         dzujchRAElz8wSABYb7go2YnfUfGRcwzY/AMYRR7BHregkFINlj0sAtekZ9vupsTsB
         R6Hr96APj/D2HOJ4VeSid54eTvMqDLXJS+vrQWlE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Maksym Yaremchuk <maksymy@nvidia.com>,
        Amit Cohen <amcohen@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>,
        Paolo Abeni <pabeni@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 042/114] mlxsw: Avoid warning during ip6gre device removal
Date:   Mon, 16 May 2022 21:36:16 +0200
Message-Id: <20220516193626.702488609@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220516193625.489108457@linuxfoundation.org>
References: <20220516193625.489108457@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Amit Cohen <amcohen@nvidia.com>

[ Upstream commit 810c2f0a3f86158c1e02e74947b66d811473434a ]

IPv6 addresses which are used for tunnels are stored in a hash table
with reference counting. When a new GRE tunnel is configured, the driver
is notified and configures it in hardware.

Currently, any change in the tunnel is not applied in the driver. It
means that if the remote address is changed, the driver is not aware of
this change and the first address will be used.

This behavior results in a warning [1] in scenarios such as the
following:

 # ip link add name gre1 type ip6gre local 2000::3 remote 2000::fffe tos inherit ttl inherit
 # ip link set name gre1 type ip6gre local 2000::3 remote 2000::ffff ttl inherit
 # ip link delete gre1

The change of the address is not applied in the driver. Currently, the
driver uses the remote address which is stored in the 'parms' of the
overlay device. When the tunnel is removed, the new IPv6 address is
used, the driver tries to release it, but as it is not aware of the
change, this address is not configured and it warns about releasing non
existing IPv6 address.

Fix it by using the IPv6 address which is cached in the IPIP entry, this
address is the last one that the driver used, so even in cases such the
above, the first address will be released, without any warning.

[1]:

WARNING: CPU: 1 PID: 2197 at drivers/net/ethernet/mellanox/mlxsw/spectrum.c:2920 mlxsw_sp_ipv6_addr_put+0x146/0x220 [mlxsw_spectrum]
...
CPU: 1 PID: 2197 Comm: ip Not tainted 5.17.0-rc8-custom-95062-gc1e5ded51a9a #84
Hardware name: Mellanox Technologies Ltd. MSN4700/VMOD0010, BIOS 5.11 07/12/2021
RIP: 0010:mlxsw_sp_ipv6_addr_put+0x146/0x220 [mlxsw_spectrum]
...
Call Trace:
 <TASK>
 mlxsw_sp2_ipip_rem_addr_unset_gre6+0xf1/0x120 [mlxsw_spectrum]
 mlxsw_sp_netdevice_ipip_ol_event+0xdb/0x640 [mlxsw_spectrum]
 mlxsw_sp_netdevice_event+0xc4/0x850 [mlxsw_spectrum]
 raw_notifier_call_chain+0x3c/0x50
 call_netdevice_notifiers_info+0x2f/0x80
 unregister_netdevice_many+0x311/0x6d0
 rtnl_dellink+0x136/0x360
 rtnetlink_rcv_msg+0x12f/0x380
 netlink_rcv_skb+0x49/0xf0
 netlink_unicast+0x233/0x340
 netlink_sendmsg+0x202/0x440
 ____sys_sendmsg+0x1f3/0x220
 ___sys_sendmsg+0x70/0xb0
 __sys_sendmsg+0x54/0xa0
 do_syscall_64+0x35/0x80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Fixes: e846efe2737b ("mlxsw: spectrum: Add hash table for IPv6 address mapping")
Reported-by: Maksym Yaremchuk <maksymy@nvidia.com>
Signed-off-by: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Link: https://lore.kernel.org/r/20220511115747.238602-1-idosch@nvidia.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
index 01cf5a6a26bd..a2ee695a3f17 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum_ipip.c
@@ -568,10 +568,8 @@ static int
 mlxsw_sp2_ipip_rem_addr_set_gre6(struct mlxsw_sp *mlxsw_sp,
 				 struct mlxsw_sp_ipip_entry *ipip_entry)
 {
-	struct __ip6_tnl_parm parms6;
-
-	parms6 = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
-	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp, &parms6.raddr,
+	return mlxsw_sp_ipv6_addr_kvdl_index_get(mlxsw_sp,
+						 &ipip_entry->parms.daddr.addr6,
 						 &ipip_entry->dip_kvdl_index);
 }
 
@@ -579,10 +577,7 @@ static void
 mlxsw_sp2_ipip_rem_addr_unset_gre6(struct mlxsw_sp *mlxsw_sp,
 				   const struct mlxsw_sp_ipip_entry *ipip_entry)
 {
-	struct __ip6_tnl_parm parms6;
-
-	parms6 = mlxsw_sp_ipip_netdev_parms6(ipip_entry->ol_dev);
-	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &parms6.raddr);
+	mlxsw_sp_ipv6_addr_put(mlxsw_sp, &ipip_entry->parms.daddr.addr6);
 }
 
 static const struct mlxsw_sp_ipip_ops mlxsw_sp2_ipip_gre6_ops = {
-- 
2.35.1



