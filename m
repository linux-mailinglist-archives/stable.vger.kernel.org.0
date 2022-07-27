Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E8996582C9E
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240529AbiG0Qsg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240353AbiG0QsC (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:48:02 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD65D4E857;
        Wed, 27 Jul 2022 09:32:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B0EDB821BA;
        Wed, 27 Jul 2022 16:32:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8739CC433D6;
        Wed, 27 Jul 2022 16:32:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939532;
        bh=4huGB46LmSsHX4JtpKQZ9/mpKisqQh47RLLpIwT9ZiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YemiIuqWC2tws+Jeyqo7Q2/zvypHJPRlQmSlXKSghYpVf4RMc5kQWoNPIYELaWxQj
         /XbiwIpfaZgSgAYjcPgNQH9+6gQ/z/T214MQROH0kVoPBHr3YWlPFPNuw+JNEFMgpl
         XEjulldRd1UyRCs3/KKAIajr/TRsZndjPVH6K54o=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Edwin Peer <edwin.peer@broadcom.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 015/105] net: inline rollback_registered_many()
Date:   Wed, 27 Jul 2022 18:10:01 +0200
Message-Id: <20220727161012.679225466@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   22 ++++++++--------------
 1 file changed, 8 insertions(+), 14 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -5750,7 +5750,7 @@ static void flush_all_backlogs(void)
 	}
 
 	/* we can have in flight packet[s] on the cpus we are not flushing,
-	 * synchronize_net() in rollback_registered_many() will take care of
+	 * synchronize_net() in unregister_netdevice_many() will take care of
 	 * them
 	 */
 	for_each_cpu(cpu, &flush_cpus)
@@ -10633,8 +10633,6 @@ void synchronize_net(void)
 }
 EXPORT_SYMBOL(synchronize_net);
 
-static void rollback_registered_many(struct list_head *head);
-
 /**
  *	unregister_netdevice_queue - remove device from the kernel
  *	@dev: device
@@ -10658,8 +10656,7 @@ void unregister_netdevice_queue(struct n
 		LIST_HEAD(single);
 
 		list_add(&dev->unreg_list, &single);
-		rollback_registered_many(&single);
-		list_del(&single);
+		unregister_netdevice_many(&single);
 	}
 }
 EXPORT_SYMBOL(unregister_netdevice_queue);
@@ -10673,21 +10670,15 @@ EXPORT_SYMBOL(unregister_netdevice_queue
  */
 void unregister_netdevice_many(struct list_head *head)
 {
-	if (!list_empty(head)) {
-		rollback_registered_many(head);
-		list_del(head);
-	}
-}
-EXPORT_SYMBOL(unregister_netdevice_many);
-
-static void rollback_registered_many(struct list_head *head)
-{
 	struct net_device *dev, *tmp;
 	LIST_HEAD(close_head);
 
 	BUG_ON(dev_boot_phase);
 	ASSERT_RTNL();
 
+	if (list_empty(head))
+		return;
+
 	list_for_each_entry_safe(dev, tmp, head, unreg_list) {
 		/* Some devices call without registering
 		 * for initialization unwind. Remove those
@@ -10771,7 +10762,10 @@ static void rollback_registered_many(str
 		dev_put(dev);
 		net_set_todo(dev);
 	}
+
+	list_del(head);
 }
+EXPORT_SYMBOL(unregister_netdevice_many);
 
 /**
  *	unregister_netdev - remove device from the kernel


