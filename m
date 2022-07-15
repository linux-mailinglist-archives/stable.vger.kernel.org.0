Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2A6CD576539
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233015AbiGOQ1c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:27:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiGOQ1b (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:27:31 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08630564CA
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:27:31 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 5EF4B40755CF;
        Fri, 15 Jul 2022 16:27:29 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH 5.10 4/7] net: move net_set_todo inside rollback_registered()
Date:   Fri, 15 Jul 2022 19:26:29 +0300
Message-Id: <20220715162632.332718-5-pchelkin@ispras.ru>
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

commit 2014beea7eb165c745706b13659a0f1d0a9a2a61 upstream.

Commit 93ee31f14f6f ("[NET]: Fix free_netdev on register_netdev
failure.") moved net_set_todo() outside of rollback_registered()
so that rollback_registered() can be used in the failure path of
register_netdevice() but without risking a double free.

Since commit cf124db566e6 ("net: Fix inconsistent teardown and
release of private netdev state."), however, we have a better
way of handling that condition, since destructors don't call
free_netdev() directly.

After the change in commit c269a24ce057 ("net: make free_netdev()
more lenient with unregistering devices") we can now move
net_set_todo() back.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/core/dev.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 07a0347c33fb..9476edf70264 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9546,8 +9546,10 @@ static void rollback_registered_many(struct list_head *head)
 
 	synchronize_net();
 
-	list_for_each_entry(dev, head, unreg_list)
+	list_for_each_entry(dev, head, unreg_list) {
 		dev_put(dev);
+		net_set_todo(dev);
+	}
 }
 
 static void rollback_registered(struct net_device *dev)
@@ -10109,7 +10111,6 @@ int register_netdevice(struct net_device *dev)
 		/* Expect explicit free_netdev() on failure */
 		dev->needs_free_netdev = false;
 		rollback_registered(dev);
-		net_set_todo(dev);
 		goto out;
 	}
 	/*
@@ -10732,8 +10733,6 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 		list_move_tail(&dev->unreg_list, head);
 	} else {
 		rollback_registered(dev);
-		/* Finish processing unregister after unlock */
-		net_set_todo(dev);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
@@ -10747,12 +10746,8 @@ EXPORT_SYMBOL(unregister_netdevice_queue);
  */
 void unregister_netdevice_many(struct list_head *head)
 {
-	struct net_device *dev;
-
 	if (!list_empty(head)) {
 		rollback_registered_many(head);
-		list_for_each_entry(dev, head, unreg_list)
-			net_set_todo(dev);
 		list_del(head);
 	}
 }
-- 
2.25.1

