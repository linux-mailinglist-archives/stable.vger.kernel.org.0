Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4CC1582C97
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240484AbiG0QsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240486AbiG0QrL (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:47:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A037552443;
        Wed, 27 Jul 2022 09:32:04 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 120C461A69;
        Wed, 27 Jul 2022 16:32:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 199BEC433C1;
        Wed, 27 Jul 2022 16:32:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939523;
        bh=uOdU3fehE3mcaQzsyVAblZ2pH7AkrvkxKU5xEx7Ng0k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EN6flW48QRjy8LXjZa+SnKcQG6nKreXP3AQOqynLaspQEqj2PWxspCYz327XD3G4K
         zTFG43GKmaoUeSE8J2bykWfd6Je/AZgterxHNgAZ7lI4S8wVAD8obuEuJesVB6kmpJ
         JNt8+ciePvOFyy7grfDHEsPrsN9cnfXU95fYFOgA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 012/105] net: move net_set_todo inside rollback_registered()
Date:   Wed, 27 Jul 2022 18:09:58 +0200
Message-Id: <20220727161012.556160686@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -9595,8 +9595,10 @@ static void rollback_registered_many(str
 
 	synchronize_net();
 
-	list_for_each_entry(dev, head, unreg_list)
+	list_for_each_entry(dev, head, unreg_list) {
 		dev_put(dev);
+		net_set_todo(dev);
+	}
 }
 
 static void rollback_registered(struct net_device *dev)
@@ -10147,7 +10149,6 @@ int register_netdevice(struct net_device
 		/* Expect explicit free_netdev() on failure */
 		dev->needs_free_netdev = false;
 		rollback_registered(dev);
-		net_set_todo(dev);
 		goto out;
 	}
 	/*
@@ -10755,8 +10756,6 @@ void unregister_netdevice_queue(struct n
 		list_move_tail(&dev->unreg_list, head);
 	} else {
 		rollback_registered(dev);
-		/* Finish processing unregister after unlock */
-		net_set_todo(dev);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
@@ -10770,12 +10769,8 @@ EXPORT_SYMBOL(unregister_netdevice_queue
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


