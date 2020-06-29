Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C64620E723
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404638AbgF2Vxf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:53:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:56788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726581AbgF2Sfd (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:33 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0CFFA2417C;
        Mon, 29 Jun 2020 15:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593443948;
        bh=8Q9utLRDcnT3OfTmE6oq5FQ33PyN3Sqn6OmCDvz+lGA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dIVmGak2VoWWIkFcMX3MCvfMfcUZmzRTAJfklwIWtMxqIF4lL2keJLnMMGlAxMDys
         JOM9WeQFKeD1iKtK1z4S/cmP3HStY40DJc6EpzRHKvJ6pnSa1XxU82MjLT/xuFmT31
         pxqbE4WXJ8zUhrLZJGNWZcIbwCpRbX17X0/1yXjI=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 050/265] net: dsa: bcm_sf2: Fix node reference count
Date:   Mon, 29 Jun 2020 11:14:43 -0400
Message-Id: <20200629151818.2493727-51-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/dsa/bcm_sf2.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index c7ac63f419184..946e41f020a56 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -1147,6 +1147,8 @@ static int bcm_sf2_sw_probe(struct platform_device *pdev)
 	set_bit(0, priv->cfp.used);
 	set_bit(0, priv->cfp.unique);
 
+	/* Balance of_node_put() done by of_find_node_by_name() */
+	of_node_get(dn);
 	ports = of_find_node_by_name(dn, "ports");
 	if (ports) {
 		bcm_sf2_identify_ports(priv, ports);
-- 
2.25.1

