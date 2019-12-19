Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C5B9126C4F
	for <lists+stable@lfdr.de>; Thu, 19 Dec 2019 20:03:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727680AbfLSTDH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Dec 2019 14:03:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:41958 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729296AbfLSSsq (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Dec 2019 13:48:46 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE49324679;
        Thu, 19 Dec 2019 18:48:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576781325;
        bh=vnlyVA6cwn8a4mK17bHZcZzqJtKoVj/dJH//7UygEPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ub3+Xcp8m5jBE8Cq556akESvFBhsvKjzauTIjImPiFS+/D0nf6PIhagKHd4d8QjI8
         NaIc6f7qRuVqSEMhR0IBODObCtyGjU3tDRmu0sjog10LxVPZ//cmxHQY81JDxS72eU
         cDA6+/s7o+CJjixy184jITmnfVJFja5SrTs1dXHw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com,
        Nikolay Aleksandrov <nikolay@cumulusnetworks.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.9 176/199] net: bridge: deny dev_set_mac_address() when unregistering
Date:   Thu, 19 Dec 2019 19:34:18 +0100
Message-Id: <20191219183225.312964208@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191219183214.629503389@linuxfoundation.org>
References: <20191219183214.629503389@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

[ Upstream commit c4b4c421857dc7b1cf0dccbd738472360ff2cd70 ]

We have an interesting memory leak in the bridge when it is being
unregistered and is a slave to a master device which would change the
mac of its slaves on unregister (e.g. bond, team). This is a very
unusual setup but we do end up leaking 1 fdb entry because
dev_set_mac_address() would cause the bridge to insert the new mac address
into its table after all fdbs are flushed, i.e. after dellink() on the
bridge has finished and we call NETDEV_UNREGISTER the bond/team would
release it and will call dev_set_mac_address() to restore its original
address and that in turn will add an fdb in the bridge.
One fix is to check for the bridge dev's reg_state in its
ndo_set_mac_address callback and return an error if the bridge is not in
NETREG_REGISTERED.

Easy steps to reproduce:
 1. add bond in mode != A/B
 2. add any slave to the bond
 3. add bridge dev as a slave to the bond
 4. destroy the bridge device

Trace:
 unreferenced object 0xffff888035c4d080 (size 128):
   comm "ip", pid 4068, jiffies 4296209429 (age 1413.753s)
   hex dump (first 32 bytes):
     41 1d c9 36 80 88 ff ff 00 00 00 00 00 00 00 00  A..6............
     d2 19 c9 5e 3f d7 00 00 00 00 00 00 00 00 00 00  ...^?...........
   backtrace:
     [<00000000ddb525dc>] kmem_cache_alloc+0x155/0x26f
     [<00000000633ff1e0>] fdb_create+0x21/0x486 [bridge]
     [<0000000092b17e9c>] fdb_insert+0x91/0xdc [bridge]
     [<00000000f2a0f0ff>] br_fdb_change_mac_address+0xb3/0x175 [bridge]
     [<000000001de02dbd>] br_stp_change_bridge_id+0xf/0xff [bridge]
     [<00000000ac0e32b1>] br_set_mac_address+0x76/0x99 [bridge]
     [<000000006846a77f>] dev_set_mac_address+0x63/0x9b
     [<00000000d30738fc>] __bond_release_one+0x3f6/0x455 [bonding]
     [<00000000fc7ec01d>] bond_netdev_event+0x2f2/0x400 [bonding]
     [<00000000305d7795>] notifier_call_chain+0x38/0x56
     [<0000000028885d4a>] call_netdevice_notifiers+0x1e/0x23
     [<000000008279477b>] rollback_registered_many+0x353/0x6a4
     [<0000000018ef753a>] unregister_netdevice_many+0x17/0x6f
     [<00000000ba854b7a>] rtnl_delete_link+0x3c/0x43
     [<00000000adf8618d>] rtnl_dellink+0x1dc/0x20a
     [<000000009b6395fd>] rtnetlink_rcv_msg+0x23d/0x268

Fixes: 43598813386f ("bridge: add local MAC address to forwarding table (v2)")
Reported-by: syzbot+2add91c08eb181fea1bf@syzkaller.appspotmail.com
Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_device.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/net/bridge/br_device.c
+++ b/net/bridge/br_device.c
@@ -210,6 +210,12 @@ static int br_set_mac_address(struct net
 	if (!is_valid_ether_addr(addr->sa_data))
 		return -EADDRNOTAVAIL;
 
+	/* dev_set_mac_addr() can be called by a master device on bridge's
+	 * NETDEV_UNREGISTER, but since it's being destroyed do nothing
+	 */
+	if (dev->reg_state != NETREG_REGISTERED)
+		return -EBUSY;
+
 	spin_lock_bh(&br->lock);
 	if (!ether_addr_equal(dev->dev_addr, addr->sa_data)) {
 		/* Mac address will be changed in br_stp_change_bridge_id(). */


