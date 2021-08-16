Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3A633ED4AE
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:04:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236731AbhHPNFB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:05:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:56060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235536AbhHPNEv (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 16 Aug 2021 09:04:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7EBAE632C2;
        Mon, 16 Aug 2021 13:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1629119060;
        bh=9pTxiGw05mrG7IfFk8bTz4z5VHDizJpIR3eTwhiPW2k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PiyifBiVqMcy93a37JKLXijSKefMmTwRsbd+WYxT5pXqFcbCPlFYANr87kh01LVQ0
         DVAxEOvlgNwIfDOWIPG68hCHYclYKCE3MzaMLNl3vanVCO11z/2YPyItpe+VZbaqz8
         F6ZncLL0eEq3aGm0CZPGHfixkW8WblI8C7sPLqxI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Geert Uytterhoeven <geert+renesas@glider.be>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Willy Tarreau <w@1wt.eu>, Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/62] net: linkwatch: fix failure to restore device state across suspend/resume
Date:   Mon, 16 Aug 2021 15:02:07 +0200
Message-Id: <20210816125429.395859863@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210816125428.198692661@linuxfoundation.org>
References: <20210816125428.198692661@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Willy Tarreau <w@1wt.eu>

[ Upstream commit 6922110d152e56d7569616b45a1f02876cf3eb9f ]

After migrating my laptop from 4.19-LTS to 5.4-LTS a while ago I noticed
that my Ethernet port to which a bond and a VLAN interface are attached
appeared to remain up after resuming from suspend with the cable unplugged
(and that problem still persists with 5.10-LTS).

It happens that the following happens:

  - the network driver (e1000e here) prepares to suspend, calls e1000e_down()
    which calls netif_carrier_off() to signal that the link is going down.
  - netif_carrier_off() adds a link_watch event to the list of events for
    this device
  - the device is completely stopped.
  - the machine suspends
  - the cable is unplugged and the machine brought to another location
  - the machine is resumed
  - the queued linkwatch events are processed for the device
  - the device doesn't yet have the __LINK_STATE_PRESENT bit and its events
    are silently dropped
  - the device is resumed with its link down
  - the upper VLAN and bond interfaces are never notified that the link had
    been turned down and remain up
  - the only way to provoke a change is to physically connect the machine
    to a port and possibly unplug it.

The state after resume looks like this:
  $ ip -br li | egrep 'bond|eth'
  bond0            UP             e8:6a:64:64:64:64 <BROADCAST,MULTICAST,MASTER,UP,LOWER_UP>
  eth0             DOWN           e8:6a:64:64:64:64 <NO-CARRIER,BROADCAST,MULTICAST,SLAVE,UP>
  eth0.2@eth0      UP             e8:6a:64:64:64:64 <BROADCAST,MULTICAST,SLAVE,UP,LOWER_UP>

Placing an explicit call to netdev_state_change() either in the suspend
or the resume code in the NIC driver worked around this but the solution
is not satisfying.

The issue in fact really is in link_watch that loses events while it
ought not to. It happens that the test for the device being present was
added by commit 124eee3f6955 ("net: linkwatch: add check for netdevice
being present to linkwatch_do_dev") in 4.20 to avoid an access to
devices that are not present.

Instead of dropping events, this patch proceeds slightly differently by
postponing their handling so that they happen after the device is fully
resumed.

Fixes: 124eee3f6955 ("net: linkwatch: add check for netdevice being present to linkwatch_do_dev")
Link: https://lists.openwall.net/netdev/2018/03/15/62
Cc: Heiner Kallweit <hkallweit1@gmail.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: Willy Tarreau <w@1wt.eu>
Link: https://lore.kernel.org/r/20210809160628.22623-1-w@1wt.eu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/link_watch.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/net/core/link_watch.c b/net/core/link_watch.c
index f153e0601838..35b0e39030da 100644
--- a/net/core/link_watch.c
+++ b/net/core/link_watch.c
@@ -150,7 +150,7 @@ static void linkwatch_do_dev(struct net_device *dev)
 	clear_bit(__LINK_STATE_LINKWATCH_PENDING, &dev->state);
 
 	rfc2863_policy(dev);
-	if (dev->flags & IFF_UP && netif_device_present(dev)) {
+	if (dev->flags & IFF_UP) {
 		if (netif_carrier_ok(dev))
 			dev_activate(dev);
 		else
@@ -196,7 +196,8 @@ static void __linkwatch_run_queue(int urgent_only)
 		dev = list_first_entry(&wrk, struct net_device, link_watch_list);
 		list_del_init(&dev->link_watch_list);
 
-		if (urgent_only && !linkwatch_urgent_event(dev)) {
+		if (!netif_device_present(dev) ||
+		    (urgent_only && !linkwatch_urgent_event(dev))) {
 			list_add_tail(&dev->link_watch_list, &lweventlist);
 			continue;
 		}
-- 
2.30.2



