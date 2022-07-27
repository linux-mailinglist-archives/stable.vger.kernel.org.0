Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E261E582C8F
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240163AbiG0Qrv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:47:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240058AbiG0Qq7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:46:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AE3852DFD;
        Wed, 27 Jul 2022 09:32:00 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 14E1AB821BA;
        Wed, 27 Jul 2022 16:31:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F5DC433D6;
        Wed, 27 Jul 2022 16:31:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939517;
        bh=htyf8dAJwRiQSesYEE98VZHxac6Wn8C8lGyj2NnpPXs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=V6apZ4crY5cQCt0bJ4N3PUwk7XBT98FL/ho28gE+2DHOrZxEZ2P2KmtZ9KcyZ18P4
         pO7NlrxZaFix0aCUhSdfa++EXaEn3jMuRM1CIepuYtjaLlvAxbi69Ouj81+v7iyB3W
         a9bVghNeeQhmiS0lP5Fgy6FhhYn3mFcLwd0lOLvY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 010/105] net: make free_netdev() more lenient with unregistering devices
Date:   Wed, 27 Jul 2022 18:09:56 +0200
Message-Id: <20220727161012.480155559@linuxfoundation.org>
X-Mailer: git-send-email 2.37.1
In-Reply-To: <20220727161012.056867467@linuxfoundation.org>
References: <20220727161012.056867467@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Fedor Pchelkin <pchelkin@ispras.ru>

From: Jakub Kicinski <kuba@kernel.org>

commit c269a24ce057abfc31130960e96ab197ef6ab196 upstream.

There are two flavors of handling netdev registration:
 - ones called without holding rtnl_lock: register_netdev() and
   unregister_netdev(); and
 - those called with rtnl_lock held: register_netdevice() and
   unregister_netdevice().

While the semantics of the former are pretty clear, the same can't
be said about the latter. The netdev_todo mechanism is utilized to
perform some of the device unregistering tasks and it hooks into
rtnl_unlock() so the locked variants can't actually finish the work.
In general free_netdev() does not mix well with locked calls. Most
drivers operating under rtnl_lock set dev->needs_free_netdev to true
and expect core to make the free_netdev() call some time later.

The part where this becomes most problematic is error paths. There is
no way to unwind the state cleanly after a call to register_netdevice(),
since unreg can't be performed fully without dropping locks.

Make free_netdev() more lenient, and defer the freeing if device
is being unregistered. This allows error paths to simply call
free_netdev() both after register_netdevice() failed, and after
a call to unregister_netdevice() but before dropping rtnl_lock.

Simplify the error paths which are currently doing gymnastics
around free_netdev() handling.

Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.c     |    4 +---
 net/core/dev.c       |   11 +++++++++++
 net/core/rtnetlink.c |   23 ++++++-----------------
 3 files changed, 18 insertions(+), 20 deletions(-)

--- a/net/8021q/vlan.c
+++ b/net/8021q/vlan.c
@@ -278,9 +278,7 @@ static int register_vlan_device(struct n
 	return 0;
 
 out_free_newdev:
-	if (new_dev->reg_state == NETREG_UNINITIALIZED ||
-	    new_dev->reg_state == NETREG_UNREGISTERED)
-		free_netdev(new_dev);
+	free_netdev(new_dev);
 	return err;
 }
 
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10683,6 +10683,17 @@ void free_netdev(struct net_device *dev)
 	struct napi_struct *p, *n;
 
 	might_sleep();
+
+	/* When called immediately after register_netdevice() failed the unwind
+	 * handling may still be dismantling the device. Handle that case by
+	 * deferring the free.
+	 */
+	if (dev->reg_state == NETREG_UNREGISTERING) {
+		ASSERT_RTNL();
+		dev->needs_free_netdev = true;
+		return;
+	}
+
 	netif_free_tx_queues(dev);
 	netif_free_rx_queues(dev);
 
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -3442,26 +3442,15 @@ replay:
 
 	dev->ifindex = ifm->ifi_index;
 
-	if (ops->newlink) {
+	if (ops->newlink)
 		err = ops->newlink(link_net ? : net, dev, tb, data, extack);
-		/* Drivers should set dev->needs_free_netdev
-		 * and unregister it on failure after registration
-		 * so that device could be finally freed in rtnl_unlock.
-		 */
-		if (err < 0) {
-			/* If device is not registered at all, free it now */
-			if (dev->reg_state == NETREG_UNINITIALIZED ||
-			    dev->reg_state == NETREG_UNREGISTERED)
-				free_netdev(dev);
-			goto out;
-		}
-	} else {
+	else
 		err = register_netdevice(dev);
-		if (err < 0) {
-			free_netdev(dev);
-			goto out;
-		}
+	if (err < 0) {
+		free_netdev(dev);
+		goto out;
 	}
+
 	err = rtnl_configure_link(dev, ifm);
 	if (err < 0)
 		goto out_unregister;


