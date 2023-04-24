Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A91D76ECEBB
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 15:35:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232383AbjDXNe5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 09:34:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232568AbjDXNej (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 09:34:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19F737A8A
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 06:34:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 264E4623AE
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 13:34:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BB9AC4339E;
        Mon, 24 Apr 2023 13:34:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1682343251;
        bh=/J507QCAFVVzTtwGBdEzknNMFhoPPZ/DxeE79rPHVZw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=YlJxRTZd9y0xihHzsv+qoveJ6K5puIdRSDFTcao14JEZ+jlF+1V0C7d7NHifvTEo8
         jOgcVA5PCFMh6EdHVyxOma9bKttWnSIHxwVUgDUrFp1akfjoj77RPAJgzgAZg3u2D0
         chfUAD5iwwBkg8Y5hNUSMKwLXwh1cB3Fmc7rdyf4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Jonathan Cooper <jonathan.s.cooper@amd.com>,
        Martin Habets <habetsm.xilinx@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 09/68] sfc: Split STATE_READY in to STATE_NET_DOWN and STATE_NET_UP.
Date:   Mon, 24 Apr 2023 15:17:40 +0200
Message-Id: <20230424131128.037540328@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230424131127.653885914@linuxfoundation.org>
References: <20230424131127.653885914@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jonathan Cooper <jonathan.s.cooper@amd.com>

[ Upstream commit 813cf9d1e753e1e0a247d3d685212a06141b483e ]

This patch splits the READY state in to NET_UP and NET_DOWN. This
is to prepare for future work to delay resource allocation until
interface up so that we can use resources more efficiently in
SRIOV environments, and also to lay the ground work for an extra
PROBED state where we don't create a network interface,
for VDPA operation.

Signed-off-by: Jonathan Cooper <jonathan.s.cooper@amd.com>
Acked-by: Martin Habets <habetsm.xilinx@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: a80bb8e7233b ("sfc: Fix use-after-free due to selftest_work")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/sfc/ef100_netdev.c   |  6 ++-
 drivers/net/ethernet/sfc/efx.c            | 29 ++++++-------
 drivers/net/ethernet/sfc/efx_common.c     | 10 ++---
 drivers/net/ethernet/sfc/efx_common.h     |  6 +--
 drivers/net/ethernet/sfc/ethtool_common.c |  2 +-
 drivers/net/ethernet/sfc/net_driver.h     | 50 +++++++++++++++++++++--
 6 files changed, 72 insertions(+), 31 deletions(-)

diff --git a/drivers/net/ethernet/sfc/ef100_netdev.c b/drivers/net/ethernet/sfc/ef100_netdev.c
index 63a44ee763be7..b9429e8faba1e 100644
--- a/drivers/net/ethernet/sfc/ef100_netdev.c
+++ b/drivers/net/ethernet/sfc/ef100_netdev.c
@@ -96,6 +96,8 @@ static int ef100_net_stop(struct net_device *net_dev)
 	efx_mcdi_free_vis(efx);
 	efx_remove_interrupts(efx);
 
+	efx->state = STATE_NET_DOWN;
+
 	return 0;
 }
 
@@ -172,6 +174,8 @@ static int ef100_net_open(struct net_device *net_dev)
 		efx_link_status_changed(efx);
 	mutex_unlock(&efx->mac_lock);
 
+	efx->state = STATE_NET_UP;
+
 	return 0;
 
 fail:
@@ -272,7 +276,7 @@ int ef100_register_netdev(struct efx_nic *efx)
 	/* Always start with carrier off; PHY events will detect the link */
 	netif_carrier_off(net_dev);
 
-	efx->state = STATE_READY;
+	efx->state = STATE_NET_DOWN;
 	rtnl_unlock();
 	efx_init_mcdi_logging(efx);
 
diff --git a/drivers/net/ethernet/sfc/efx.c b/drivers/net/ethernet/sfc/efx.c
index c069659c9e2d0..5f064f185d553 100644
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -105,14 +105,6 @@ static int efx_xdp(struct net_device *dev, struct netdev_bpf *xdp);
 static int efx_xdp_xmit(struct net_device *dev, int n, struct xdp_frame **xdpfs,
 			u32 flags);
 
-#define EFX_ASSERT_RESET_SERIALISED(efx)		\
-	do {						\
-		if ((efx->state == STATE_READY) ||	\
-		    (efx->state == STATE_RECOVERY) ||	\
-		    (efx->state == STATE_DISABLED))	\
-			ASSERT_RTNL();			\
-	} while (0)
-
 /**************************************************************************
  *
  * Port handling
@@ -377,6 +369,8 @@ static int efx_probe_all(struct efx_nic *efx)
 	if (rc)
 		goto fail5;
 
+	efx->state = STATE_NET_DOWN;
+
 	return 0;
 
  fail5:
@@ -543,6 +537,9 @@ int efx_net_open(struct net_device *net_dev)
 	efx_start_all(efx);
 	if (efx->state == STATE_DISABLED || efx->reset_pending)
 		netif_device_detach(efx->net_dev);
+	else
+		efx->state = STATE_NET_UP;
+
 	efx_selftest_async_start(efx);
 	return 0;
 }
@@ -721,8 +718,6 @@ static int efx_register_netdev(struct efx_nic *efx)
 	 * already requested.  If so, the NIC is probably hosed so we
 	 * abort.
 	 */
-	efx->state = STATE_READY;
-	smp_mb(); /* ensure we change state before checking reset_pending */
 	if (efx->reset_pending) {
 		netif_err(efx, probe, efx->net_dev,
 			  "aborting probe due to scheduled reset\n");
@@ -750,6 +745,8 @@ static int efx_register_netdev(struct efx_nic *efx)
 
 	efx_associate(efx);
 
+	efx->state = STATE_NET_DOWN;
+
 	rtnl_unlock();
 
 	rc = device_create_file(&efx->pci_dev->dev, &dev_attr_phy_type);
@@ -851,7 +848,7 @@ static void efx_pci_remove_main(struct efx_nic *efx)
 	/* Flush reset_work. It can no longer be scheduled since we
 	 * are not READY.
 	 */
-	BUG_ON(efx->state == STATE_READY);
+	WARN_ON(efx_net_active(efx->state));
 	efx_flush_reset_workqueue(efx);
 
 	efx_disable_interrupts(efx);
@@ -1196,13 +1193,13 @@ static int efx_pm_freeze(struct device *dev)
 
 	rtnl_lock();
 
-	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_UNINIT;
-
+	if (efx_net_active(efx->state)) {
 		efx_device_detach_sync(efx);
 
 		efx_stop_all(efx);
 		efx_disable_interrupts(efx);
+
+		efx->state = efx_freeze(efx->state);
 	}
 
 	rtnl_unlock();
@@ -1217,7 +1214,7 @@ static int efx_pm_thaw(struct device *dev)
 
 	rtnl_lock();
 
-	if (efx->state != STATE_DISABLED) {
+	if (efx_frozen(efx->state)) {
 		rc = efx_enable_interrupts(efx);
 		if (rc)
 			goto fail;
@@ -1230,7 +1227,7 @@ static int efx_pm_thaw(struct device *dev)
 
 		efx_device_attach_if_not_resetting(efx);
 
-		efx->state = STATE_READY;
+		efx->state = efx_thaw(efx->state);
 
 		efx->type->resume_wol(efx);
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.c b/drivers/net/ethernet/sfc/efx_common.c
index de797e1ac5a98..1527678b241cf 100644
--- a/drivers/net/ethernet/sfc/efx_common.c
+++ b/drivers/net/ethernet/sfc/efx_common.c
@@ -897,7 +897,7 @@ static void efx_reset_work(struct work_struct *data)
 	 * have changed by now.  Now that we have the RTNL lock,
 	 * it cannot change again.
 	 */
-	if (efx->state == STATE_READY)
+	if (efx_net_active(efx->state))
 		(void)efx_reset(efx, method);
 
 	rtnl_unlock();
@@ -907,7 +907,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 {
 	enum reset_type method;
 
-	if (efx->state == STATE_RECOVERY) {
+	if (efx_recovering(efx->state)) {
 		netif_dbg(efx, drv, efx->net_dev,
 			  "recovering: skip scheduling %s reset\n",
 			  RESET_TYPE(type));
@@ -942,7 +942,7 @@ void efx_schedule_reset(struct efx_nic *efx, enum reset_type type)
 	/* If we're not READY then just leave the flags set as the cue
 	 * to abort probing or reschedule the reset later.
 	 */
-	if (READ_ONCE(efx->state) != STATE_READY)
+	if (!efx_net_active(READ_ONCE(efx->state)))
 		return;
 
 	/* efx_process_channel() will no longer read events once a
@@ -1214,7 +1214,7 @@ static pci_ers_result_t efx_io_error_detected(struct pci_dev *pdev,
 	rtnl_lock();
 
 	if (efx->state != STATE_DISABLED) {
-		efx->state = STATE_RECOVERY;
+		efx->state = efx_recover(efx->state);
 		efx->reset_pending = 0;
 
 		efx_device_detach_sync(efx);
@@ -1268,7 +1268,7 @@ static void efx_io_resume(struct pci_dev *pdev)
 		netif_err(efx, hw, efx->net_dev,
 			  "efx_reset failed after PCI error (%d)\n", rc);
 	} else {
-		efx->state = STATE_READY;
+		efx->state = efx_recovered(efx->state);
 		netif_dbg(efx, hw, efx->net_dev,
 			  "Done resetting and resuming IO after PCI error.\n");
 	}
diff --git a/drivers/net/ethernet/sfc/efx_common.h b/drivers/net/ethernet/sfc/efx_common.h
index 65513fd0cf6c4..c72e819da8fd3 100644
--- a/drivers/net/ethernet/sfc/efx_common.h
+++ b/drivers/net/ethernet/sfc/efx_common.h
@@ -45,9 +45,7 @@ int efx_reconfigure_port(struct efx_nic *efx);
 
 #define EFX_ASSERT_RESET_SERIALISED(efx)		\
 	do {						\
-		if ((efx->state == STATE_READY) ||	\
-		    (efx->state == STATE_RECOVERY) ||	\
-		    (efx->state == STATE_DISABLED))	\
+		if (efx->state != STATE_UNINIT)		\
 			ASSERT_RTNL();			\
 	} while (0)
 
@@ -64,7 +62,7 @@ void efx_port_dummy_op_void(struct efx_nic *efx);
 
 static inline int efx_check_disabled(struct efx_nic *efx)
 {
-	if (efx->state == STATE_DISABLED || efx->state == STATE_RECOVERY) {
+	if (efx->state == STATE_DISABLED || efx_recovering(efx->state)) {
 		netif_err(efx, drv, efx->net_dev,
 			  "device is disabled due to earlier errors\n");
 		return -EIO;
diff --git a/drivers/net/ethernet/sfc/ethtool_common.c b/drivers/net/ethernet/sfc/ethtool_common.c
index bd552c7dffcb1..3846b76b89720 100644
--- a/drivers/net/ethernet/sfc/ethtool_common.c
+++ b/drivers/net/ethernet/sfc/ethtool_common.c
@@ -137,7 +137,7 @@ void efx_ethtool_self_test(struct net_device *net_dev,
 	if (!efx_tests)
 		goto fail;
 
-	if (efx->state != STATE_READY) {
+	if (!efx_net_active(efx->state)) {
 		rc = -EBUSY;
 		goto out;
 	}
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index 8aecb4bd2c0d5..39f97929b3ffe 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -627,12 +627,54 @@ enum efx_int_mode {
 #define EFX_INT_MODE_USE_MSI(x) (((x)->interrupt_mode) <= EFX_INT_MODE_MSI)
 
 enum nic_state {
-	STATE_UNINIT = 0,	/* device being probed/removed or is frozen */
-	STATE_READY = 1,	/* hardware ready and netdev registered */
-	STATE_DISABLED = 2,	/* device disabled due to hardware errors */
-	STATE_RECOVERY = 3,	/* device recovering from PCI error */
+	STATE_UNINIT = 0,	/* device being probed/removed */
+	STATE_NET_DOWN,		/* hardware probed and netdev registered */
+	STATE_NET_UP,		/* ready for traffic */
+	STATE_DISABLED,		/* device disabled due to hardware errors */
+
+	STATE_RECOVERY = 0x100,/* recovering from PCI error */
+	STATE_FROZEN = 0x200,	/* frozen by power management */
 };
 
+static inline bool efx_net_active(enum nic_state state)
+{
+	return state == STATE_NET_DOWN || state == STATE_NET_UP;
+}
+
+static inline bool efx_frozen(enum nic_state state)
+{
+	return state & STATE_FROZEN;
+}
+
+static inline bool efx_recovering(enum nic_state state)
+{
+	return state & STATE_RECOVERY;
+}
+
+static inline enum nic_state efx_freeze(enum nic_state state)
+{
+	WARN_ON(!efx_net_active(state));
+	return state | STATE_FROZEN;
+}
+
+static inline enum nic_state efx_thaw(enum nic_state state)
+{
+	WARN_ON(!efx_frozen(state));
+	return state & ~STATE_FROZEN;
+}
+
+static inline enum nic_state efx_recover(enum nic_state state)
+{
+	WARN_ON(!efx_net_active(state));
+	return state | STATE_RECOVERY;
+}
+
+static inline enum nic_state efx_recovered(enum nic_state state)
+{
+	WARN_ON(!efx_recovering(state));
+	return state & ~STATE_RECOVERY;
+}
+
 /* Forward declaration */
 struct efx_nic;
 
-- 
2.39.2



