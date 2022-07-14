Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8282575280
	for <lists+stable@lfdr.de>; Thu, 14 Jul 2022 18:12:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238463AbiGNQMt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 14 Jul 2022 12:12:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229578AbiGNQMs (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 14 Jul 2022 12:12:48 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2156564EE
        for <stable@vger.kernel.org>; Thu, 14 Jul 2022 09:12:47 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 5710A40755C7;
        Thu, 14 Jul 2022 16:12:46 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 5.10 3/3] net: make sure devices go through netdev_wait_all_refs
Date:   Thu, 14 Jul 2022 19:11:34 +0300
Message-Id: <20220714161134.95034-4-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220714161134.95034-1-pchelkin@ispras.ru>
References: <20220714161134.95034-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 766b0515d5bec4b780750773ed3009b148df8c0a upstream.

If register_netdevice() fails at the very last stage - the
notifier call - some subsystems may have already seen it and
grabbed a reference. struct net_device can't be freed right
away without calling netdev_wait_all_refs().

Now that we have a clean interface in form of dev->needs_free_netdev
and lenient free_netdev() we can undo what commit 93ee31f14f6f ("[NET]:
Fix free_netdev on register_netdev failure.") has done and complete
the unregistration path by bringing the net_set_todo() call back.

After registration fails user is still expected to explicitly
free the net_device, so make sure ->needs_free_netdev is cleared,
otherwise rolling back the registration will cause the old double
free for callers who release rtnl_lock before the free.

This also solves the problem of priv_destructor not being called
on notifier error.

net_set_todo() will be moved back into unregister_netdevice_queue()
in a follow up.

Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
---
 net/core/dev.c | 14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index adde93cbca9f..0071a11a6dc3 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10077,17 +10077,11 @@ int register_netdevice(struct net_device *dev)
 	ret = call_netdevice_notifiers(NETDEV_REGISTER, dev);
 	ret = notifier_to_errno(ret);
 	if (ret) {
+		/* Expect explicit free_netdev() on failure */
+		dev->needs_free_netdev = false;
 		rollback_registered(dev);
-		rcu_barrier();
-
-		dev->reg_state = NETREG_UNREGISTERED;
-		/* We should put the kobject that hold in
-		 * netdev_unregister_kobject(), otherwise
-		 * the net device cannot be freed when
-		 * driver calls free_netdev(), because the
-		 * kobject is being hold.
-		 */
-		kobject_put(&dev->dev.kobj);
+		net_set_todo(dev);
+		goto out;
 	}
 	/*
 	 *	Prevent userspace races by waiting until the network
-- 
2.25.1

