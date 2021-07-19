Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51E13CD946
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243013AbhGSO2A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 10:28:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:40420 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243483AbhGSO00 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:26:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 955CC61166;
        Mon, 19 Jul 2021 15:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626707225;
        bh=lxopFPDHC6mOd/aY5hyhvyn8ruVz09GjuJa7/oI9518=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KbEWVTkADd/+CzzZOvxo0dAGh8tPumPyzFac6UWqeASJA0G5esJmhFWb5kHkmkSv4
         iDtgE3uuPA5ij7OjpI29CChH+0PL681Gr5pSwjY7pKBkWJn8LuKYu/mWyqBgObtmgh
         KLGsQIkTIuXkHRVkhrDkaw21H7Z8zZ0DCrs4S5ao=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 077/245] RDMA/rxe: Fix failure during driver load
Date:   Mon, 19 Jul 2021 16:50:19 +0200
Message-Id: <20210719144942.900148335@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144940.288257948@linuxfoundation.org>
References: <20210719144940.288257948@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kamal Heib <kamalheib1@gmail.com>

[ Upstream commit 32a25f2ea690dfaace19f7a3a916f5d7e1ddafe8 ]

To avoid the following failure when trying to load the rdma_rxe module
while IPv6 is disabled, add a check for EAFNOSUPPORT and ignore the
failure, also delete the needless debug print from rxe_setup_udp_tunnel().

$ modprobe rdma_rxe
modprobe: ERROR: could not insert 'rdma_rxe': Operation not permitted

Fixes: dfdd6158ca2c ("IB/rxe: Fix kernel panic in udp_setup_tunnel")
Link: https://lore.kernel.org/r/20210603090112.36341-1-kamalheib1@gmail.com
Reported-by: Yi Zhang <yi.zhang@redhat.com>
Signed-off-by: Kamal Heib <kamalheib1@gmail.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index e39261234528..f431cecd8b56 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -259,10 +259,8 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 
 	/* Create UDP socket */
 	err = udp_sock_create(net, &udp_cfg, &sock);
-	if (err < 0) {
-		pr_err("failed to create udp socket. err = %d\n", err);
+	if (err < 0)
 		return ERR_PTR(err);
-	}
 
 	tnl_cfg.encap_type = 1;
 	tnl_cfg.encap_rcv = rxe_udp_encap_recv;
@@ -665,6 +663,12 @@ int rxe_net_ipv6_init(void)
 
 	recv_sockets.sk6 = rxe_setup_udp_tunnel(&init_net,
 						htons(ROCE_V2_UDP_DPORT), true);
+	if (PTR_ERR(recv_sockets.sk6) == -EAFNOSUPPORT) {
+		recv_sockets.sk6 = NULL;
+		pr_warn("IPv6 is not supported, can not create a UDPv6 socket\n");
+		return 0;
+	}
+
 	if (IS_ERR(recv_sockets.sk6)) {
 		recv_sockets.sk6 = NULL;
 		pr_err("Failed to create IPv6 UDP tunnel\n");
-- 
2.30.2



