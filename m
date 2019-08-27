Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA4649E1AD
	for <lists+stable@lfdr.de>; Tue, 27 Aug 2019 10:14:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731103AbfH0IOH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Aug 2019 04:14:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:49010 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729861AbfH0H4x (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Aug 2019 03:56:53 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A57F9206BF;
        Tue, 27 Aug 2019 07:56:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1566892613;
        bh=J5lnnaoGht24ngfs5Mv6fMDuHPifdiMPBV5Df3X7NiU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1VGDdiLb4cbMgYk8OFNkr3cHBKfcjqPMyYcwsaCirBTAW6yz0zpxuB3etKLFp2nc5
         zKvABZGeiV6K5V1WHCHSimgf+/GKfenPCzIKg4nZJO9HFqeIkpzFPWv6QVHO3G15fe
         FymBo/O6EFSQAHUC5uddo7pwwAXxB6oefNX+5tAU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, YueHaibing <yuehaibing@huawei.com>,
        Oliver Hartkopp <socketcan@hartkopp.net>,
        Marc Kleine-Budde <mkl@pengutronix.de>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 13/98] can: gw: Fix error path of cgw_module_init
Date:   Tue, 27 Aug 2019 09:49:52 +0200
Message-Id: <20190827072719.033233455@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190827072718.142728620@linuxfoundation.org>
References: <20190827072718.142728620@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit b7a14297f102b6e2ce6f16feffebbb9bde1e9b55 ]

This patch add error path for cgw_module_init to avoid possible crash if
some error occurs.

Fixes: c1aabdf379bc ("can-gw: add netlink based CAN routing")
Signed-off-by: YueHaibing <yuehaibing@huawei.com>
Acked-by: Oliver Hartkopp <socketcan@hartkopp.net>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/can/gw.c | 48 +++++++++++++++++++++++++++++++++---------------
 1 file changed, 33 insertions(+), 15 deletions(-)

diff --git a/net/can/gw.c b/net/can/gw.c
index 53859346dc9a9..bd2161470e456 100644
--- a/net/can/gw.c
+++ b/net/can/gw.c
@@ -1046,32 +1046,50 @@ static __init int cgw_module_init(void)
 	pr_info("can: netlink gateway (rev " CAN_GW_VERSION ") max_hops=%d\n",
 		max_hops);
 
-	register_pernet_subsys(&cangw_pernet_ops);
+	ret = register_pernet_subsys(&cangw_pernet_ops);
+	if (ret)
+		return ret;
+
+	ret = -ENOMEM;
 	cgw_cache = kmem_cache_create("can_gw", sizeof(struct cgw_job),
 				      0, 0, NULL);
-
 	if (!cgw_cache)
-		return -ENOMEM;
+		goto out_cache_create;
 
 	/* set notifier */
 	notifier.notifier_call = cgw_notifier;
-	register_netdevice_notifier(&notifier);
+	ret = register_netdevice_notifier(&notifier);
+	if (ret)
+		goto out_register_notifier;
 
 	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_GETROUTE,
 				   NULL, cgw_dump_jobs, 0);
-	if (ret) {
-		unregister_netdevice_notifier(&notifier);
-		kmem_cache_destroy(cgw_cache);
-		return -ENOBUFS;
-	}
-
-	/* Only the first call to rtnl_register_module can fail */
-	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
-			     cgw_create_job, NULL, 0);
-	rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
-			     cgw_remove_job, NULL, 0);
+	if (ret)
+		goto out_rtnl_register1;
+
+	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_NEWROUTE,
+				   cgw_create_job, NULL, 0);
+	if (ret)
+		goto out_rtnl_register2;
+	ret = rtnl_register_module(THIS_MODULE, PF_CAN, RTM_DELROUTE,
+				   cgw_remove_job, NULL, 0);
+	if (ret)
+		goto out_rtnl_register3;
 
 	return 0;
+
+out_rtnl_register3:
+	rtnl_unregister(PF_CAN, RTM_NEWROUTE);
+out_rtnl_register2:
+	rtnl_unregister(PF_CAN, RTM_GETROUTE);
+out_rtnl_register1:
+	unregister_netdevice_notifier(&notifier);
+out_register_notifier:
+	kmem_cache_destroy(cgw_cache);
+out_cache_create:
+	unregister_pernet_subsys(&cangw_pernet_ops);
+
+	return ret;
 }
 
 static __exit void cgw_module_exit(void)
-- 
2.20.1



