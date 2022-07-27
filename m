Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5353A582C93
	for <lists+stable@lfdr.de>; Wed, 27 Jul 2022 18:48:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240315AbiG0QsC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 27 Jul 2022 12:48:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240314AbiG0QrE (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 27 Jul 2022 12:47:04 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5663952E52;
        Wed, 27 Jul 2022 09:32:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DEBA4B821BE;
        Wed, 27 Jul 2022 16:32:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C3BFC433C1;
        Wed, 27 Jul 2022 16:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1658939520;
        bh=VmvQaZowy1d0aqIWB3OQ1GQv0t682IOsWS1iF7J5FK0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JDhZ/m2HUQvxcM2nscczvut5ShelFugvn2uy0adWwN3m6QOu57QxPKNZqnZdhMDBP
         Tpr8yJkRGTQu5MyN84ErgR/gSLwW7w05KNQXXpXXCsXD8FWnsH9etHSR8mjapMWfRj
         PElZyTkVVQz78hwsWVfBifjjAHeKtUuC+iy0v7/k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Yang Yingliang <yangyingliang@huawei.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.10 011/105] net: make sure devices go through netdev_wait_all_refs
Date:   Wed, 27 Jul 2022 18:09:57 +0200
Message-Id: <20220727161012.515394196@linuxfoundation.org>
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
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   14 ++++----------
 1 file changed, 4 insertions(+), 10 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -10144,17 +10144,11 @@ int register_netdevice(struct net_device
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


