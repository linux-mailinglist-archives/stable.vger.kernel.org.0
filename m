Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1799F6C724
	for <lists+stable@lfdr.de>; Thu, 18 Jul 2019 05:22:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390689AbfGRDVs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Jul 2019 23:21:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:42184 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390439AbfGRDJe (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 17 Jul 2019 23:09:34 -0400
Received: from localhost (115.42.148.210.bf.2iij.net [210.148.42.115])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9E03C2173E;
        Thu, 18 Jul 2019 03:09:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1563419373;
        bh=Z19F6dIFva6wO8YOEqkB/IQngl30hrlIzSWm5TdpYRg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=e0Q6+DTzfw/C2P+VcLYjT2DMHS1m8AjrFCGc0A/9Dndw+oQ1NwHa8s0qUrULOXvys
         pJr25DOo7ACIg6UNyaXjP3bk/MG712IuItXxfaoJ5BPpkA+YZrjlLNVSPyVKqF1nRZ
         ZtQJwHFgHqS4aJw+cWuKU/f/O8v0RdP1+aMMIxLQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 20/80] can: af_can: Fix error path of can_init()
Date:   Thu, 18 Jul 2019 12:01:11 +0900
Message-Id: <20190718030100.413550821@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190718030058.615992480@linuxfoundation.org>
References: <20190718030058.615992480@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit c5a3aed1cd3152429348ee1fe5cdcca65fe901ce ]

This patch add error path for can_init() to avoid possible crash if some
error occurs.

Fixes: 0d66548a10cb ("[CAN]: Add PF_CAN core module")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/af_can.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/net/can/af_can.c b/net/can/af_can.c
index 9de9678fa7d0..46c85731d16f 100644
--- a/net/can/af_can.c
+++ b/net/can/af_can.c
@@ -959,6 +959,8 @@ static struct pernet_operations can_pernet_ops __read_mostly = {
 
 static __init int can_init(void)
 {
+	int err;
+
 	/* check for correct padding to be able to use the structs similarly */
 	BUILD_BUG_ON(offsetof(struct can_frame, can_dlc) !=
 		     offsetof(struct canfd_frame, len) ||
@@ -972,15 +974,31 @@ static __init int can_init(void)
 	if (!rcv_cache)
 		return -ENOMEM;
 
-	register_pernet_subsys(&can_pernet_ops);
+	err = register_pernet_subsys(&can_pernet_ops);
+	if (err)
+		goto out_pernet;
 
 	/* protocol register */
-	sock_register(&can_family_ops);
-	register_netdevice_notifier(&can_netdev_notifier);
+	err = sock_register(&can_family_ops);
+	if (err)
+		goto out_sock;
+	err = register_netdevice_notifier(&can_netdev_notifier);
+	if (err)
+		goto out_notifier;
+
 	dev_add_pack(&can_packet);
 	dev_add_pack(&canfd_packet);
 
 	return 0;
+
+out_notifier:
+	sock_unregister(PF_CAN);
+out_sock:
+	unregister_pernet_subsys(&can_pernet_ops);
+out_pernet:
+	kmem_cache_destroy(rcv_cache);
+
+	return err;
 }
 
 static __exit void can_exit(void)
-- 
2.20.1



