Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C3543F6414
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:00:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235291AbhHXRAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:38972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238897AbhHXQ7M (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:59:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 259446142A;
        Tue, 24 Aug 2021 16:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824251;
        bh=bNXmRj4lhQHqq3AH5PhKAvWbdLxKyLKJmVnBVcs8F0U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iy8A4hwh3RWqZ3Ha87A3Y9KqyRWbwedzyZf4hHQnD1bccrH0T+2XCtHwimFUzP7ie
         ZTur7FR1D3sQBh/wKwUv3FT03GhkZmNgJ3jMBWgl6QBMhYjPbXySmlqH7vnhSCqaSL
         X4ziUxUqCdQVGPj4ueeg2Vrvk2j2DGCrOcqQ753gBrNS1NaSSDU5YX4kOLQFrHxRl/
         +wi788Ea8jremSBL9ar0gMtk+qmh6vIZEzGs+QQqHak2/rLR6v6dvXoR+34+1hSz+0
         txfIhB1fg6KnuHAPYo/tjnhZRKF60dN8IKXYi/WBeKeMcaFoJDppqAbLWp54MzO2pi
         7WJr2bQIfkvmw==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Ioana Ciornei <ioana.ciornei@nxp.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 084/127] net: dpaa2-switch: disable the control interface on error path
Date:   Tue, 24 Aug 2021 12:55:24 -0400
Message-Id: <20210824165607.709387-85-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824165607.709387-1-sashal@kernel.org>
References: <20210824165607.709387-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.13.13-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.13.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.13.13-rc1
X-KernelTest-Deadline: 2021-08-26T16:55+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit cd0a719fbd702eb4b455a6ad986483750125588a ]

Currently dpaa2_switch_takedown has a funny name and does not do the
opposite of dpaa2_switch_init, which makes probing fail when we need to
handle an -EPROBE_DEFER.

A sketch of what dpaa2_switch_init does:

	dpsw_open

	dpaa2_switch_detect_features

	dpsw_reset

	for (i = 0; i < ethsw->sw_attr.num_ifs; i++) {
		dpsw_if_disable

		dpsw_if_set_stp

		dpsw_vlan_remove_if_untagged

		dpsw_if_set_tci

		dpsw_vlan_remove_if
	}

	dpsw_vlan_remove

	alloc_ordered_workqueue

	dpsw_fdb_remove

	dpaa2_switch_ctrl_if_setup

When dpaa2_switch_takedown is called from the error path of
dpaa2_switch_probe(), the control interface, enabled by
dpaa2_switch_ctrl_if_setup from dpaa2_switch_init, remains enabled,
because dpaa2_switch_takedown does not call
dpaa2_switch_ctrl_if_teardown.

Since dpaa2_switch_probe might fail due to EPROBE_DEFER of a PHY, this
means that a second probe of the driver will happen with the control
interface directly enabled.

This will trigger a second error:

[   93.273528] fsl_dpaa2_switch dpsw.0: dpsw_ctrl_if_set_pools() failed
[   93.281966] fsl_dpaa2_switch dpsw.0: fsl_mc_driver_probe failed: -13
[   93.288323] fsl_dpaa2_switch: probe of dpsw.0 failed with error -13

Which if we investigate the /dev/dpaa2_mc_console log, we find out is
caused by:

[E, ctrl_if_set_pools:2211, DPMNG]  ctrl_if must be disabled

So make dpaa2_switch_takedown do the opposite of dpaa2_switch_init (in
reasonable limits, no reason to change STP state, re-add VLANs etc), and
rename it to something more conventional, like dpaa2_switch_teardown.

Fixes: 613c0a5810b7 ("staging: dpaa2-switch: enable the control interface")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Ioana Ciornei <ioana.ciornei@nxp.com>
Link: https://lore.kernel.org/r/20210819141755.1931423-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/freescale/dpaa2/dpaa2-switch.c   | 36 +++++++++----------
 1 file changed, 18 insertions(+), 18 deletions(-)

diff --git a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
index 87321b7239cf..58964d22cb17 100644
--- a/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
+++ b/drivers/net/ethernet/freescale/dpaa2/dpaa2-switch.c
@@ -3038,26 +3038,30 @@ static int dpaa2_switch_port_init(struct ethsw_port_priv *port_priv, u16 port)
 	return err;
 }
 
-static void dpaa2_switch_takedown(struct fsl_mc_device *sw_dev)
+static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
+{
+	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
+	dpaa2_switch_free_dpio(ethsw);
+	dpaa2_switch_destroy_rings(ethsw);
+	dpaa2_switch_drain_bp(ethsw);
+	dpaa2_switch_free_dpbp(ethsw);
+}
+
+static void dpaa2_switch_teardown(struct fsl_mc_device *sw_dev)
 {
 	struct device *dev = &sw_dev->dev;
 	struct ethsw_core *ethsw = dev_get_drvdata(dev);
 	int err;
 
+	dpaa2_switch_ctrl_if_teardown(ethsw);
+
+	destroy_workqueue(ethsw->workqueue);
+
 	err = dpsw_close(ethsw->mc_io, 0, ethsw->dpsw_handle);
 	if (err)
 		dev_warn(dev, "dpsw_close err %d\n", err);
 }
 
-static void dpaa2_switch_ctrl_if_teardown(struct ethsw_core *ethsw)
-{
-	dpsw_ctrl_if_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
-	dpaa2_switch_free_dpio(ethsw);
-	dpaa2_switch_destroy_rings(ethsw);
-	dpaa2_switch_drain_bp(ethsw);
-	dpaa2_switch_free_dpbp(ethsw);
-}
-
 static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 {
 	struct ethsw_port_priv *port_priv;
@@ -3068,8 +3072,6 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	dev = &sw_dev->dev;
 	ethsw = dev_get_drvdata(dev);
 
-	dpaa2_switch_ctrl_if_teardown(ethsw);
-
 	dpaa2_switch_teardown_irqs(sw_dev);
 
 	dpsw_disable(ethsw->mc_io, 0, ethsw->dpsw_handle);
@@ -3084,9 +3086,7 @@ static int dpaa2_switch_remove(struct fsl_mc_device *sw_dev)
 	kfree(ethsw->acls);
 	kfree(ethsw->ports);
 
-	dpaa2_switch_takedown(sw_dev);
-
-	destroy_workqueue(ethsw->workqueue);
+	dpaa2_switch_teardown(sw_dev);
 
 	fsl_mc_portal_free(ethsw->mc_io);
 
@@ -3199,7 +3199,7 @@ static int dpaa2_switch_probe(struct fsl_mc_device *sw_dev)
 			       GFP_KERNEL);
 	if (!(ethsw->ports)) {
 		err = -ENOMEM;
-		goto err_takedown;
+		goto err_teardown;
 	}
 
 	ethsw->fdbs = kcalloc(ethsw->sw_attr.num_ifs, sizeof(*ethsw->fdbs),
@@ -3270,8 +3270,8 @@ err_free_fdbs:
 err_free_ports:
 	kfree(ethsw->ports);
 
-err_takedown:
-	dpaa2_switch_takedown(sw_dev);
+err_teardown:
+	dpaa2_switch_teardown(sw_dev);
 
 err_free_cmdport:
 	fsl_mc_portal_free(ethsw->mc_io);
-- 
2.30.2

