Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D936F29B34B
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 15:55:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1766301AbgJ0OsD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 27 Oct 2020 10:48:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:47988 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1766290AbgJ0OsB (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 27 Oct 2020 10:48:01 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9FE3F206E5;
        Tue, 27 Oct 2020 14:47:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603810080;
        bh=xOhvEwLou3Vv7HjQdwN3HxdbE+oa2xt8Fu5K3Fw+P3o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LmWwWTZVre9TXCNPQ5XNh8dzskwqQDSBSdf2//NxgY+msvwj1O1Ml0A5Kz183Eh2q
         xTkZKsrd1vib7q4NDQH0/NBVrkTeZc2XxiEo/Rzufl4PoGq0vbMOc0o6U+unSmpDJf
         czLOXFzX7nEvxafASFP9h9I4RkmjA07V6F8ljKI4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Christian Eggers <ceggers@arri.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.8 006/633] net: dsa: microchip: fix race condition
Date:   Tue, 27 Oct 2020 14:45:49 +0100
Message-Id: <20201027135522.977104950@linuxfoundation.org>
X-Mailer: git-send-email 2.29.1
In-Reply-To: <20201027135522.655719020@linuxfoundation.org>
References: <20201027135522.655719020@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Christian Eggers <ceggers@arri.de>

[ Upstream commit 8098bd69bc4e925070313b1b95d03510f4f24738 ]

Between queuing the delayed work and finishing the setup of the dsa
ports, the process may sleep in request_module() (via
phy_device_create()) and the queued work may be executed prior to the
switch net devices being registered. In ksz_mib_read_work(), a NULL
dereference will happen within netof_carrier_ok(dp->slave).

Not queuing the delayed work in ksz_init_mib_timer() makes things even
worse because the work will now be queued for immediate execution
(instead of 2000 ms) in ksz_mac_link_down() via
dsa_port_link_register_of().

Call tree:
ksz9477_i2c_probe()
\--ksz9477_switch_register()
   \--ksz_switch_register()
      +--dsa_register_switch()
      |  \--dsa_switch_probe()
      |     \--dsa_tree_setup()
      |        \--dsa_tree_setup_switches()
      |           +--dsa_switch_setup()
      |           |  +--ksz9477_setup()
      |           |  |  \--ksz_init_mib_timer()
      |           |  |     |--/* Start the timer 2 seconds later. */
      |           |  |     \--schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
      |           |  \--__mdiobus_register()
      |           |     \--mdiobus_scan()
      |           |        \--get_phy_device()
      |           |           +--get_phy_id()
      |           |           \--phy_device_create()
      |           |              |--/* sleeping, ksz_mib_read_work() can be called meanwhile */
      |           |              \--request_module()
      |           |
      |           \--dsa_port_setup()
      |              +--/* Called for non-CPU ports */
      |              +--dsa_slave_create()
      |              |  +--/* Too late, ksz_mib_read_work() may be called beforehand */
      |              |  \--port->slave = ...
      |             ...
      |              +--Called for CPU port */
      |              \--dsa_port_link_register_of()
      |                 \--ksz_mac_link_down()
      |                    +--/* mib_read must be initialized here */
      |                    +--/* work is already scheduled, so it will be executed after 2000 ms */
      |                    \--schedule_delayed_work(&dev->mib_read, 0);
      \-- /* here port->slave is setup properly, scheduling the delayed work should be safe */

Solution:
1. Do not queue (only initialize) delayed work in ksz_init_mib_timer().
2. Only queue delayed work in ksz_mac_link_down() if init is completed.
3. Queue work once in ksz_switch_register(), after dsa_register_switch()
has completed.

Fixes: 7c6ff470aa86 ("net: dsa: microchip: add MIB counter reading support")
Signed-off-by: Christian Eggers <ceggers@arri.de>
Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/microchip/ksz_common.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/dsa/microchip/ksz_common.c
+++ b/drivers/net/dsa/microchip/ksz_common.c
@@ -103,14 +103,8 @@ void ksz_init_mib_timer(struct ksz_devic
 
 	INIT_DELAYED_WORK(&dev->mib_read, ksz_mib_read_work);
 
-	/* Read MIB counters every 30 seconds to avoid overflow. */
-	dev->mib_read_interval = msecs_to_jiffies(30000);
-
 	for (i = 0; i < dev->mib_port_cnt; i++)
 		dev->dev_ops->port_init_cnt(dev, i);
-
-	/* Start the timer 2 seconds later. */
-	schedule_delayed_work(&dev->mib_read, msecs_to_jiffies(2000));
 }
 EXPORT_SYMBOL_GPL(ksz_init_mib_timer);
 
@@ -144,7 +138,9 @@ void ksz_adjust_link(struct dsa_switch *
 	/* Read all MIB counters when the link is going down. */
 	if (!phydev->link) {
 		p->read = true;
-		schedule_delayed_work(&dev->mib_read, 0);
+		/* timer started */
+		if (dev->mib_read_interval)
+			schedule_delayed_work(&dev->mib_read, 0);
 	}
 	mutex_lock(&dev->dev_mutex);
 	if (!phydev->link)
@@ -460,6 +456,12 @@ int ksz_switch_register(struct ksz_devic
 		return ret;
 	}
 
+	/* Read MIB counters every 30 seconds to avoid overflow. */
+	dev->mib_read_interval = msecs_to_jiffies(30000);
+
+	/* Start the MIB timer. */
+	schedule_delayed_work(&dev->mib_read, 0);
+
 	return 0;
 }
 EXPORT_SYMBOL(ksz_switch_register);


