Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EADF057653A
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:27:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233019AbiGOQ1d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:27:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232992AbiGOQ1c (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:27:32 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D502564CA
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:27:32 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 94A3140755E7;
        Fri, 15 Jul 2022 16:27:30 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>,
        Edwin Peer <edwin.peer@broadcom.com>
Subject: [PATCH 5.10 5/7] net: inline rollback_registered()
Date:   Fri, 15 Jul 2022 19:26:30 +0300
Message-Id: <20220715162632.332718-6-pchelkin@ispras.ru>
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

commit 037e56bd965e1bc72c2fa9684ac25b56839a338e upstream.

rollback_registered() is a local helper, it's common for driver
code to call unregister_netdevice_queue(dev, NULL) when they
want to unregister netdevices under rtnl_lock. Inline
rollback_registered() and adjust the only remaining caller.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 net/core/dev.c | 17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index 9476edf70264..9a147142c477 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9552,15 +9552,6 @@ static void rollback_registered_many(struct list_head *head)
 	}
 }
 
-static void rollback_registered(struct net_device *dev)
-{
-	LIST_HEAD(single);
-
-	list_add(&dev->unreg_list, &single);
-	rollback_registered_many(&single);
-	list_del(&single);
-}
-
 static netdev_features_t netdev_sync_upper_features(struct net_device *lower,
 	struct net_device *upper, netdev_features_t features)
 {
@@ -10110,7 +10101,7 @@ int register_netdevice(struct net_device *dev)
 	if (ret) {
 		/* Expect explicit free_netdev() on failure */
 		dev->needs_free_netdev = false;
-		rollback_registered(dev);
+		unregister_netdevice_queue(dev, NULL);
 		goto out;
 	}
 	/*
@@ -10732,7 +10723,11 @@ void unregister_netdevice_queue(struct net_device *dev, struct list_head *head)
 	if (head) {
 		list_move_tail(&dev->unreg_list, head);
 	} else {
-		rollback_registered(dev);
+		LIST_HEAD(single);
+
+		list_add(&dev->unreg_list, &single);
+		rollback_registered_many(&single);
+		list_del(&single);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
-- 
2.25.1

