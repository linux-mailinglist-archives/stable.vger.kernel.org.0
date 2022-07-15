Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66B3E57653C
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232992AbiGOQ1f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:27:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233137AbiGOQ1f (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:27:35 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6C8F5E314
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:27:34 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 2747B40755EB;
        Fri, 15 Jul 2022 16:27:33 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH 5.10 7/7] net: inline rollback_registered_many()
Date:   Fri, 15 Jul 2022 19:26:32 +0300
Message-Id: <20220715162632.332718-8-pchelkin@ispras.ru>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220715162632.332718-1-pchelkin@ispras.ru>
References: <20220715162632.332718-1-pchelkin@ispras.ru>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>

commit 0cbe1e57a7b93517100b0eb63d8e445cfbeb630c upstream.

Similar to the change for rollback_registered() -
rollback_registered_many() was a part of unregister_netdevice_many()
minus the net_set_todo(), which is no longer needed.

Functionally this patch moves the list_empty() check back after:

	BUG_ON(dev_boot_phase);
	ASSERT_RTNL();

but I can't find any reason why that would be an issue.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/core/dev.c | 22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 1fb99ae8cc22..00f970ba0248 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5709,7 +5709,7 @@ static void flush_all_backlogs(void)
 	}
 
 	/* we can have in flight packet[s] on the cpus we are not flushing,
-	 * synchronize_net() in rollback_registered_many() will take care of
+	 * synchronize_net() in unregister_netdevice_many() will take care of
 	 * them
 	 */
 	for_each_cpu(cpu, &flush_cpus)
@@ -10610,8 +10610,6 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
-static void rollback_registered_many(struct list_head *head);
-
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10635,8 +10633,7 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 		LIST_HEAD(single);
 
 		list_add(&dev->unreg_list, &single);
-		rollback_registered_many(&single);
-		list_del(&single);
+		unregister_netdevice_many(&single);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
@@ -10649,15 +10646,6 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
  *  we force a list_del() to make sure stack wont be corrupted later.
  */
 void unregister_netdevice_many(struct list_head *head)
-{
-	if (!list_empty(head)) {
-		rollback_registered_many(head);
-		list_del(head);
-	}
-}
-EXPORT_SYMBOL(unregister_netdevice_many);
-
-static void rollback_registered_many(struct list_head *head)
 {
 	struct net_device *dev, *tmp;
 	LIST_HEAD(close_head);
@@ -10665,6 +10653,9 @@ static void rollback_registered_many(struct list_head *head)
 	BUG_ON(dev_boot_phase);
 	ASSERT_RTNL();
 
+	if (list_empty(head))
+		return;
+
 	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
 		/* Some devices call without registering
 		 * for initialization unwind. Remove those
@@ -10748,7 +10739,10 @@ static void rollback_registered_many(struct list_head *head)
 		dev_put(dev);
 		net_set_todo(dev);
 	}
+
+	list_del(head);
 }
+EXPORT_SYMBOL(unregister_netdevice_many);
 
 /**
  *	unregister_netdev - remove device from the kernel
-- 
2.25.1

