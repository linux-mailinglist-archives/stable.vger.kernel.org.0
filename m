Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7522E3C4E00
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240400AbhGLHQW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:16:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:46854 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241729AbhGLHPY (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:15:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5BAD2610D1;
        Mon, 12 Jul 2021 07:11:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626073915;
        bh=JaEEkSWd8TPseL/G8wxu4i/rEARwjJTc5tQFmUBi95Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S7QcCzlLzaASTKMosxbWJl/rjGrcIjkhy54qCibk2EMjtFFuhE041M5SM3tuGxUYG
         sr2uPfLuDGwcg9j8IrGFgrKzpC5cqXKXlcAijnHRp02t+wKkZL+c7wj4y173Be2HDD
         nVCsvApovIdK366K+h350qJgZWa6ZcwVRD1WDOAw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yi Zhang <yi.zhang@redhat.com>,
        Kamal Heib <kamalheib1@gmail.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 395/700] RDMA/rxe: Fix failure during driver load
Date:   Mon, 12 Jul 2021 08:07:58 +0200
Message-Id: <20210712061018.416076474@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
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
index 01662727dca0..fc1ba4904279 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -207,10 +207,8 @@ static struct socket *rxe_setup_udp_tunnel(struct net *net, __be16 port,
 
 	/* Create UDP socket */
 	err = udp_sock_create(net, &udp_cfg, &sock);
-	if (err < 0) {
-		pr_err("failed to create udp socket. err = %d\n", err);
+	if (err < 0)
 		return ERR_PTR(err);
-	}
 
 	tnl_cfg.encap_type = 1;
 	tnl_cfg.encap_rcv = rxe_udp_encap_recv;
@@ -619,6 +617,12 @@ static int rxe_net_ipv6_init(void)
 
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



