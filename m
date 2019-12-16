Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 341BA121616
	for <lists+stable@lfdr.de>; Mon, 16 Dec 2019 19:27:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731226AbfLPSQl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Dec 2019 13:16:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:39510 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731573AbfLPSQj (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Dec 2019 13:16:39 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E6AF220717;
        Mon, 16 Dec 2019 18:16:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576520198;
        bh=D9BzyQy5ZzPaglJk39CSdueO88kTdIsmK1/C+xN29lg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=S20wfiD9cMa9+kLZGUX8QyET0ve3/u3phUtBd+4TZ3iJJHGriIB6rIrfjx792Ko50
         M5uFSycpCqfaWDGgyhTPgPAsgh6l6l0c6G9Tu45BH9SvFgGf59/jaFyKJqPhWdlezk
         5TaikdpNZkg00kqKLyRph+6CYXM6dwYT80y8zd/4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Taehee Yoo <ap420073@gmail.com>,
        Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 5.4 057/177] virt_wifi: fix use-after-free in virt_wifi_newlink()
Date:   Mon, 16 Dec 2019 18:48:33 +0100
Message-Id: <20191216174831.081261216@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191216174811.158424118@linuxfoundation.org>
References: <20191216174811.158424118@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Taehee Yoo <ap420073@gmail.com>

commit bc71d8b580ba81b55b6e15b1c0320632515b4bac upstream.

When virt_wifi interface is created, virt_wifi_newlink() is called and
it calls register_netdevice().
if register_netdevice() fails, it internally would call
->priv_destructor(), which is virt_wifi_net_device_destructor() and
it frees netdev. but virt_wifi_newlink() still use netdev.
So, use-after-free would occur in virt_wifi_newlink().

Test commands:
    ip link add dummy0 type dummy
    modprobe bonding
    ip link add bonding_masters link dummy0 type virt_wifi

Splat looks like:
[  202.220554] BUG: KASAN: use-after-free in virt_wifi_newlink+0x88b/0x9a0 [virt_wifi]
[  202.221659] Read of size 8 at addr ffff888061629cb8 by task ip/852

[  202.222896] CPU: 1 PID: 852 Comm: ip Not tainted 5.4.0-rc5 #3
[  202.223765] Hardware name: innotek GmbH VirtualBox/VirtualBox, BIOS VirtualBox 12/01/2006
[  202.225073] Call Trace:
[  202.225532]  dump_stack+0x7c/0xbb
[  202.226869]  print_address_description.constprop.5+0x1be/0x360
[  202.229362]  __kasan_report+0x12a/0x16f
[  202.230714]  kasan_report+0xe/0x20
[  202.232595]  virt_wifi_newlink+0x88b/0x9a0 [virt_wifi]
[  202.233370]  __rtnl_newlink+0xb9f/0x11b0
[  202.244909]  rtnl_newlink+0x65/0x90
[ ... ]

Cc: stable@vger.kernel.org
Fixes: c7cdba31ed8b ("mac80211-next: rtnetlink wifi simulation device")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Link: https://lore.kernel.org/r/20191121122645.9355-1-ap420073@gmail.com
[trim stack dump a bit]
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/wireless/virt_wifi.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/net/wireless/virt_wifi.c
+++ b/drivers/net/wireless/virt_wifi.c
@@ -450,7 +450,6 @@ static void virt_wifi_net_device_destruc
 	 */
 	kfree(dev->ieee80211_ptr);
 	dev->ieee80211_ptr = NULL;
-	free_netdev(dev);
 }
 
 /* No lock interaction. */
@@ -458,7 +457,7 @@ static void virt_wifi_setup(struct net_d
 {
 	ether_setup(dev);
 	dev->netdev_ops = &virt_wifi_ops;
-	dev->priv_destructor = virt_wifi_net_device_destructor;
+	dev->needs_free_netdev  = true;
 }
 
 /* Called in a RCU read critical section from netif_receive_skb */
@@ -544,6 +543,7 @@ static int virt_wifi_newlink(struct net
 		goto unregister_netdev;
 	}
 
+	dev->priv_destructor = virt_wifi_net_device_destructor;
 	priv->being_deleted = false;
 	priv->is_connected = false;
 	priv->is_up = false;


