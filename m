Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 285341EADF1
	for <lists+stable@lfdr.de>; Mon,  1 Jun 2020 20:50:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730021AbgFASGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Jun 2020 14:06:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:52218 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730471AbgFASGe (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Jun 2020 14:06:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 82AE6207D0;
        Mon,  1 Jun 2020 18:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1591034793;
        bh=wLx6y1eN3MJhuBtGGAOWlU3fPBUosU6LRb4T/jZ0e38=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=mFCSeEe0+lQun4gREWfzgiHPNPeuX52e/NpN0D8Fkxps/MIgKq3NSKeNE87NI204t
         OO6eA9CvaKc6jrXXxts+57a4V+5oiHiwNLj4upuQPdtg1fvyVE/4PgwNLzjPAPUMyf
         X2UgR+ZZBptwcCPkqxHONM5OQmhsgnI8UcBYF9So=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Vladimir Oltean <vladimir.oltean@nxp.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 002/142] dpaa_eth: fix usage as DSA master, try 3
Date:   Mon,  1 Jun 2020 19:52:40 +0200
Message-Id: <20200601174038.257610173@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200601174037.904070960@linuxfoundation.org>
References: <20200601174037.904070960@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5d14c304bfc14b4fd052dc83d5224376b48f52f0 ]

The dpaa-eth driver probes on compatible string for the MAC node, and
the fman/mac.c driver allocates a dpaa-ethernet platform device that
triggers the probing of the dpaa-eth net device driver.

All of this is fine, but the problem is that the struct device of the
dpaa_eth net_device is 2 parents away from the MAC which can be
referenced via of_node. So of_find_net_device_by_node can't find it, and
DSA switches won't be able to probe on top of FMan ports.

It would be a bit silly to modify a core function
(of_find_net_device_by_node) to look for dev->parent->parent->of_node
just for one driver. We're just 1 step away from implementing full
recursion.

Actually there have already been at least 2 previous attempts to make
this work:
- Commit a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
- One or more of the patches in "[v3,0/6] adapt DPAA drivers for DSA":
  https://patchwork.ozlabs.org/project/netdev/cover/1508178970-28945-1-git-send-email-madalin.bucur@nxp.com/
  (I couldn't really figure out which one was supposed to solve the
  problem and how).

Point being, it looks like this is still pretty much a problem today.
On T1040, the /sys/class/net/eth0 symlink currently points to

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/dpaa-ethernet.0/net/eth0

which pretty much illustrates the problem. The closest of_node we've got
is the "fsl,fman-memac" at /soc@ffe000000/fman@400000/ethernet@e6000,
which is what we'd like to be able to reference from DSA as host port.

For of_find_net_device_by_node to find the eth0 port, we would need the
parent of the eth0 net_device to not be the "dpaa-ethernet" platform
device, but to point 1 level higher, aka the "fsl,fman-memac" node
directly. The new sysfs path would look like this:

../../devices/platform/ffe000000.soc/ffe400000.fman/ffe4e6000.ethernet/net/eth0

And this is exactly what SET_NETDEV_DEV does. It sets the parent of the
net_device. The new parent has an of_node associated with it, and
of_dev_node_match already checks for the of_node of the device or of its
parent.

Fixes: a1a50c8e4c24 ("fsl/man: Inherit parent device and of_node")
Fixes: c6e26ea8c893 ("dpaa_eth: change device used")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/freescale/dpaa/dpaa_eth.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
+++ b/drivers/net/ethernet/freescale/dpaa/dpaa_eth.c
@@ -2802,7 +2802,7 @@ static int dpaa_eth_probe(struct platfor
 	}
 
 	/* Do this here, so we can be verbose early */
-	SET_NETDEV_DEV(net_dev, dev);
+	SET_NETDEV_DEV(net_dev, dev->parent);
 	dev_set_drvdata(dev, net_dev);
 
 	priv = netdev_priv(net_dev);


