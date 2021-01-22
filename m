Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06573300566
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:29:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728567AbhAVO2d (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:28:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:41932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728692AbhAVOZR (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:25:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AB00E23BCB;
        Fri, 22 Jan 2021 14:19:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325169;
        bh=A/r+AcGraVw8hP+vQ68mDozUUG4oDRBbK2nFjHIMzWk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mkBnZLLuc5shda3ahanfVhQ/Ct8Wm0e8ehTQwP2B8NjkAccCbZlIsyc6iYwv/KE5P
         U1biJxKlW2xcWuHeMtLDMGc8Yti7ZerNEjeFTiQsLe64NgjfcT1ZYowPkVFSAaLhLN
         11V9Gk7wcLZmSEL8o3BrmgYblKwczsWudoRf/d2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 40/43] net: dsa: unbind all switches from tree when DSA master unbinds
Date:   Fri, 22 Jan 2021 15:12:56 +0100
Message-Id: <20210122135737.288169851@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

commit 07b90056cb15ff9877dca0d8f1b6583d1051f724 upstream.

Currently the following happens when a DSA master driver unbinds while
there are DSA switches attached to it:

$ echo 0000:00:00.5 > /sys/bus/pci/drivers/mscc_felix/unbind
------------[ cut here ]------------
WARNING: CPU: 0 PID: 392 at net/core/dev.c:9507
Call trace:
 rollback_registered_many+0x5fc/0x688
 unregister_netdevice_queue+0x98/0x120
 dsa_slave_destroy+0x4c/0x88
 dsa_port_teardown.part.16+0x78/0xb0
 dsa_tree_teardown_switches+0x58/0xc0
 dsa_unregister_switch+0x104/0x1b8
 felix_pci_remove+0x24/0x48
 pci_device_remove+0x48/0xf0
 device_release_driver_internal+0x118/0x1e8
 device_driver_detach+0x28/0x38
 unbind_store+0xd0/0x100

Located at the above location is this WARN_ON:

	/* Notifier chain MUST detach us all upper devices. */
	WARN_ON(netdev_has_any_upper_dev(dev));

Other stacked interfaces, like VLAN, do indeed listen for
NETDEV_UNREGISTER on the real_dev and also unregister themselves at that
time, which is clearly the behavior that rollback_registered_many
expects. But DSA interfaces are not VLAN. They have backing hardware
(platform devices, PCI devices, MDIO, SPI etc) which have a life cycle
of their own and we can't just trigger an unregister from the DSA
framework when we receive a netdev notifier that the master unregisters.

Luckily, there is something we can do, and that is to inform the driver
core that we have a runtime dependency to the DSA master interface's
device, and create a device link where that is the supplier and we are
the consumer. Having this device link will make the DSA switch unbind
before the DSA master unbinds, which is enough to avoid the WARN_ON from
rollback_registered_many.

Note that even before the blamed commit, DSA did nothing intelligent
when the master interface got unregistered either. See the discussion
here:
https://lore.kernel.org/netdev/20200505210253.20311-1-f.fainelli@gmail.com/
But this time, at least the WARN_ON is loud enough that the
upper_dev_link commit can be blamed.

The advantage with this approach vs dev_hold(master) in the attached
link is that the latter is not meant for long term reference counting.
With dev_hold, the only thing that will happen is that when the user
attempts an unbind of the DSA master, netdev_wait_allrefs will keep
waiting and waiting, due to DSA keeping the refcount forever. DSA would
not access freed memory corresponding to the master interface, but the
unbind would still result in a freeze. Whereas with device links,
graceful teardown is ensured. It even works with cascaded DSA trees.

$ echo 0000:00:00.2 > /sys/bus/pci/drivers/fsl_enetc/unbind
[ 1818.797546] device swp0 left promiscuous mode
[ 1819.301112] sja1105 spi2.0: Link is Down
[ 1819.307981] DSA: tree 1 torn down
[ 1819.312408] device eno2 left promiscuous mode
[ 1819.656803] mscc_felix 0000:00:00.5: Link is Down
[ 1819.667194] DSA: tree 0 torn down
[ 1819.711557] fsl_enetc 0000:00:00.2 eno2: Link is Down

This approach allows us to keep the DSA framework absolutely unchanged,
and the driver core will just know to unbind us first when the master
goes away - as opposed to the large (and probably impossible) rework
required if attempting to listen for NETDEV_UNREGISTER.

As per the documentation at Documentation/driver-api/device_link.rst,
specifying the DL_FLAG_AUTOREMOVE_CONSUMER flag causes the device link
to be automatically purged when the consumer fails to probe or later
unbinds. So we don't need to keep the consumer_link variable in struct
dsa_switch.

Fixes: 2f1e8ea726e9 ("net: dsa: link interfaces with the DSA master to get rid of lockdep warnings")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Tested-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20210111230943.3701806-1-olteanv@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 net/dsa/master.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/net/dsa/master.c
+++ b/net/dsa/master.c
@@ -308,8 +308,18 @@ static struct lock_class_key dsa_master_
 
 int dsa_master_setup(struct net_device *dev, struct dsa_port *cpu_dp)
 {
+	struct dsa_switch *ds = cpu_dp->ds;
+	struct device_link *consumer_link;
 	int ret;
 
+	/* The DSA master must use SET_NETDEV_DEV for this to work. */
+	consumer_link = device_link_add(ds->dev, dev->dev.parent,
+					DL_FLAG_AUTOREMOVE_CONSUMER);
+	if (!consumer_link)
+		netdev_err(dev,
+			   "Failed to create a device link to DSA switch %s\n",
+			   dev_name(ds->dev));
+
 	rtnl_lock();
 	ret = dev_set_mtu(dev, ETH_DATA_LEN + cpu_dp->tag_ops->overhead);
 	rtnl_unlock();


