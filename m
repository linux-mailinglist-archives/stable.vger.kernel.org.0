Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59911582C96
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240494AbiG0QsT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:48:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240426AbiG0Qri (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:47:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2CB860681;
        Wed, 27 Jul 2022 09:32:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8EABBB821BA;
        Wed, 27 Jul 2022 16:32:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF53FC43140;
        Wed, 27 Jul 2022 16:32:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939526;
        bh=aHDCADhnQ+avDxQmnvKD7ddWwLgr3eiYoNbq4ql06Vs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E2PYVq5ie380HImDpGcbFx0QTyr26vZDKwNEXNVLGVsaXMgzoqvAimX/nL4QhqYUg
         EsO+Q3poEe3irrw4ZYD6uxDHk2TSHV3lyoOJbo/BdhnziwGd5XjKNFTbBgMbPKxRuj
         WuPCrqm21ptGWpDGsAnhtiB3ozCZ2+Hn4LPAc2zo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 013/105] net: inline rollback_registered()
Date:   Wed, 27 Jul 2022 18:09:59 +0200
Message-Id: <20220727161012.595366208@linuxfoundation.org>
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

commit 037e56bd965e1bc72c2fa9684ac25b56839a338e upstream.

rollback_registered() is a local helper, it's common for driver
code to call unregister_netdevice_queue(dev, NULL) when they
want to unregister netdevices under rtnl_lock. Inline
rollback_registered() and adjust the only remaining caller.

Reviewed-by: Edwin Peer <edwin.peer@broadcom.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   17 ++++++-----------
 1 file changed, 6 insertions(+), 11 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9601,15 +9601,6 @@ static void rollback_registered_many(str
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
@@ -10148,7 +10139,7 @@ int register_netdevice(struct net_device
 	if (ret) {
 		/* Expect explicit free_netdev() on failure */
 		dev->needs_free_netdev = false;
-		rollback_registered(dev);
+		unregister_netdevice_queue(dev, NULL);
 		goto out;
 	}
 	/*
@@ -10755,7 +10746,11 @@ void unregister_netdevice_queue(struct n
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


