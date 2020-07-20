Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8327D226547
	for <lists+stable@lfdr.de>; Mon, 20 Jul 2020 17:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731356AbgGTPwZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 11:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731323AbgGTPwZ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 Jul 2020 11:52:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2180F2064B;
        Mon, 20 Jul 2020 15:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595260344;
        bh=Ha27OoJsTOQOL01Z4waSg8KdBzez44H6nXY3En0tDMs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UJTLxVyffisE8j2Dwcw/3NRU0PlNuls479fBzVM9Uu3x09l9e6ru5gP+qB39nh8/8
         pIh9JSb8X5hrYQkawnXnCf3y3eZtUB2NZYHHMfOts4mlqMN80qeUjk967u2h9XEDNJ
         sao1PG2I8lSDiD+W51qKeuHwi78QNGb6gW0LUyg8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 039/133] net: dsa: bcm_sf2: Fix node reference count
Date:   Mon, 20 Jul 2020 17:36:26 +0200
Message-Id: <20200720152805.608409123@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200720152803.732195882@linuxfoundation.org>
References: <20200720152803.732195882@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Florian Fainelli <f.fainelli@gmail.com>

[ Upstream commit 8dbe4c5d5e40fe140221024f7b16bec9f310bf70 ]

of_find_node_by_name() will do an of_node_put() on the "from" argument.
With CONFIG_OF_DYNAMIC enabled which checks for device_node reference
counts, we would be getting a warning like this:

[    6.347230] refcount_t: increment on 0; use-after-free.
[    6.352498] WARNING: CPU: 3 PID: 77 at lib/refcount.c:156
refcount_inc_checked+0x38/0x44
[    6.360601] Modules linked in:
[    6.363661] CPU: 3 PID: 77 Comm: kworker/3:1 Tainted: G        W
5.4.46-gb78b3e9956e6 #13
[    6.372546] Hardware name: BCM97278SV (DT)
[    6.376649] Workqueue: events deferred_probe_work_func
[    6.381796] pstate: 60000005 (nZCv daif -PAN -UAO)
[    6.386595] pc : refcount_inc_checked+0x38/0x44
[    6.391133] lr : refcount_inc_checked+0x38/0x44
...
[    6.478791] Call trace:
[    6.481243]  refcount_inc_checked+0x38/0x44
[    6.485433]  kobject_get+0x3c/0x4c
[    6.488840]  of_node_get+0x24/0x34
[    6.492247]  of_irq_find_parent+0x3c/0xe0
[    6.496263]  of_irq_parse_one+0xe4/0x1d0
[    6.500191]  irq_of_parse_and_map+0x44/0x84
[    6.504381]  bcm_sf2_sw_probe+0x22c/0x844
[    6.508397]  platform_drv_probe+0x58/0xa8
[    6.512413]  really_probe+0x238/0x3fc
[    6.516081]  driver_probe_device+0x11c/0x12c
[    6.520358]  __device_attach_driver+0xa8/0x100
[    6.524808]  bus_for_each_drv+0xb4/0xd0
[    6.528650]  __device_attach+0xd0/0x164
[    6.532493]  device_initial_probe+0x24/0x30
[    6.536682]  bus_probe_device+0x38/0x98
[    6.540524]  deferred_probe_work_func+0xa8/0xd4
[    6.545061]  process_one_work+0x178/0x288
[    6.549078]  process_scheduled_works+0x44/0x48
[    6.553529]  worker_thread+0x218/0x270
[    6.557285]  kthread+0xdc/0xe4
[    6.560344]  ret_from_fork+0x10/0x18
[    6.563925] ---[ end trace 68f65caf69bb152a ]---

Fix this by adding a of_node_get() to increment the reference count
prior to the call.

Fixes: afa3b592953b ("net: dsa: bcm_sf2: Ensure correct sub-node is parsed")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index ccba648452c42..c0bba680d4a88 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1078,6 +1078,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	set_bit(0, priv->cfp.used);
 	set_bit(0, priv->cfp.unique);
 
+	/* Balance of_node_put() done by of_find_node_by_name() */
+	of_node_get(dn);
 	ports = of_find_node_by_name(dn, "ports");
 	if (ports) {
 		bcm_sf2_identify_ports(priv, ports);
-- 
2.25.1



