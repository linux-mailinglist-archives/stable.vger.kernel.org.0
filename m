Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4E73576536
	for <lists+stable@lfdr.de>; Fri, 15 Jul 2022 18:27:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232537AbiGOQ1U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 15 Jul 2022 12:27:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229787AbiGOQ1U (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 15 Jul 2022 12:27:20 -0400
Received: from mail.ispras.ru (mail.ispras.ru [83.149.199.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF6C6564CA
        for <stable@vger.kernel.org>; Fri, 15 Jul 2022 09:27:18 -0700 (PDT)
Received: from localhost.localdomain (unknown [83.149.199.65])
        by mail.ispras.ru (Postfix) with ESMTPSA id 5006A40755C7;
        Fri, 15 Jul 2022 16:27:17 +0000 (UTC)
From:   Fedor Pchelkin <pchelkin@ispras.ru>
To:     stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Fedor Pchelkin <pchelkin@ispras.ru>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexey Khoroshilov <khoroshilov@ispras.ru>
Subject: [PATCH 5.10 1/7] docs: net: explain struct net_device lifetime
Date:   Fri, 15 Jul 2022 19:26:26 +0300
Message-Id: <20220715162632.332718-2-pchelkin@ispras.ru>
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

commit 2b446e650b418f9a9e75f99852e2f2560cabfa17 upstream.

Explain the two basic flows of struct net_device's operation.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
---
 Documentation/networking/netdevices.rst | 171 +++++++++++++++++++++++-
 net/core/rtnetlink.c                    |   2 +-
 2 files changed, 166 insertions(+), 7 deletions(-)

diff --git a/Documentation/networking/netdevices.rst b/Documentation/networking/netdevices.rst
index e65665c5ab50..17bdcb746dcf 100644
--- a/Documentation/networking/netdevices.rst
+++ b/Documentation/networking/netdevices.rst
@@ -10,18 +10,177 @@ Introduction
 The following is a random collection of documentation regarding
 network devices.
 
-struct net_device allocation rules
-==================================
+struct net_device lifetime rules
+================================
 Network device structures need to persist even after module is unloaded and
 must be allocated with alloc_netdev_mqs() and friends.
 If device has registered successfully, it will be freed on last use
-by free_netdev(). This is required to handle the pathologic case cleanly
-(example: rmmod mydriver </sys/class/net/myeth/mtu )
+by free_netdev(). This is required to handle the pathological case cleanly
+(example: ``rmmod mydriver </sys/class/net/myeth/mtu``)
 
-alloc_netdev_mqs()/alloc_netdev() reserve extra space for driver
+alloc_netdev_mqs() / alloc_netdev() reserve extra space for driver
 private data which gets freed when the network device is freed. If
 separately allocated data is attached to the network device
-(netdev_priv(dev)) then it is up to the module exit handler to free that.
+(netdev_priv()) then it is up to the module exit handler to free that.
+
+There are two groups of APIs for registering struct net_device.
+First group can be used in normal contexts where ``rtnl_lock`` is not already
+held: register_netdev(), unregister_netdev().
+Second group can be used when ``rtnl_lock`` is already held:
+register_netdevice(), unregister_netdevice(), free_netdevice().
+
+Simple drivers
+--------------
+
+Most drivers (especially device drivers) handle lifetime of struct net_device
+in context where ``rtnl_lock`` is not held (e.g. driver probe and remove paths).
+
+In that case the struct net_device registration is done using
+the register_netdev(), and unregister_netdev() functions:
+
+.. code-block:: c
+
+  int probe()
+  {
+    struct my_device_priv *priv;
+    int err;
+
+    dev = alloc_netdev_mqs(...);
+    if (!dev)
+      return -ENOMEM;
+    priv = netdev_priv(dev);
+
+    /* ... do all device setup before calling register_netdev() ...
+     */
+
+    err = register_netdev(dev);
+    if (err)
+      goto err_undo;
+
+    /* net_device is visible to the user! */
+
+  err_undo:
+    /* ... undo the device setup ... */
+    free_netdev(dev);
+    return err;
+  }
+
+  void remove()
+  {
+    unregister_netdev(dev);
+    free_netdev(dev);
+  }
+
+Note that after calling register_netdev() the device is visible in the system.
+Users can open it and start sending / receiving traffic immediately,
+or run any other callback, so all initialization must be done prior to
+registration.
+
+unregister_netdev() closes the device and waits for all users to be done
+with it. The memory of struct net_device itself may still be referenced
+by sysfs but all operations on that device will fail.
+
+free_netdev() can be called after unregister_netdev() returns on when
+register_netdev() failed.
+
+Device management under RTNL
+----------------------------
+
+Registering struct net_device while in context which already holds
+the ``rtnl_lock`` requires extra care. In those scenarios most drivers
+will want to make use of struct net_device's ``needs_free_netdev``
+and ``priv_destructor`` members for freeing of state.
+
+Example flow of netdev handling under ``rtnl_lock``:
+
+.. code-block:: c
+
+  static void my_setup(struct net_device *dev)
+  {
+    dev->needs_free_netdev = true;
+  }
+
+  static void my_destructor(struct net_device *dev)
+  {
+    some_obj_destroy(priv->obj);
+    some_uninit(priv);
+  }
+
+  int create_link()
+  {
+    struct my_device_priv *priv;
+    int err;
+
+    ASSERT_RTNL();
+
+    dev = alloc_netdev(sizeof(*priv), "net%d", NET_NAME_UNKNOWN, my_setup);
+    if (!dev)
+      return -ENOMEM;
+    priv = netdev_priv(dev);
+
+    /* Implicit constructor */
+    err = some_init(priv);
+    if (err)
+      goto err_free_dev;
+
+    priv->obj = some_obj_create();
+    if (!priv->obj) {
+      err = -ENOMEM;
+      goto err_some_uninit;
+    }
+    /* End of constructor, set the destructor: */
+    dev->priv_destructor = my_destructor;
+
+    err = register_netdevice(dev);
+    if (err)
+      /* register_netdevice() calls destructor on failure */
+      goto err_free_dev;
+
+    /* If anything fails now unregister_netdevice() (or unregister_netdev())
+     * will take care of calling my_destructor and free_netdev().
+     */
+
+    return 0;
+
+  err_some_uninit:
+    some_uninit(priv);
+  err_free_dev:
+    free_netdev(dev);
+    return err;
+  }
+
+If struct net_device.priv_destructor is set it will be called by the core
+some time after unregister_netdevice(), it will also be called if
+register_netdevice() fails. The callback may be invoked with or without
+``rtnl_lock`` held.
+
+There is no explicit constructor callback, driver "constructs" the private
+netdev state after allocating it and before registration.
+
+Setting struct net_device.needs_free_netdev makes core call free_netdevice()
+automatically after unregister_netdevice() when all references to the device
+are gone. It only takes effect after a successful call to register_netdevice()
+so if register_netdevice() fails driver is responsible for calling
+free_netdev().
+
+free_netdev() is safe to call on error paths right after unregister_netdevice()
+or when register_netdevice() fails. Parts of netdev (de)registration process
+happen after ``rtnl_lock`` is released, therefore in those cases free_netdev()
+will defer some of the processing until ``rtnl_lock`` is released.
+
+Devices spawned from struct rtnl_link_ops should never free the
+struct net_device directly.
+
+.ndo_init and .ndo_uninit
+~~~~~~~~~~~~~~~~~~~~~~~~~
+
+``.ndo_init`` and ``.ndo_uninit`` callbacks are called during net_device
+registration and de-registration, under ``rtnl_lock``. Drivers can use
+those e.g. when parts of their init process need to run under ``rtnl_lock``.
+
+``.ndo_init`` runs before device is visible in the system, ``.ndo_uninit``
+runs during de-registering after device is closed but other subsystems
+may still have outstanding references to the netdevice.
 
 MTU
 ===
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index bb0596c41b3e..79f514afb17d 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3441,7 +3441,7 @@ static int __rtnl_newlink(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 	if (ops->newlink) {
 		err = ops->newlink(link_net ? : net, dev, tb, data, extack);
-		/* Drivers should call free_netdev() in ->destructor
+		/* Drivers should set dev->needs_free_netdev
 		 * and unregister it on failure after registration
 		 * so that device could be finally freed in rtnl_unlock.
 		 */
-- 
2.25.1

