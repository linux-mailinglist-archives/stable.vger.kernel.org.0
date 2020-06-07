Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA3751F0FF9
	for <lists+stable@lfdr.de>; Sun,  7 Jun 2020 23:25:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727794AbgFGVZb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 7 Jun 2020 17:25:31 -0400
Received: from mga06.intel.com ([134.134.136.31]:41756 "EHLO mga06.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726093AbgFGVZb (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 7 Jun 2020 17:25:31 -0400
IronPort-SDR: aNsrH7JFU+5CFnxQpCQ5dLXZenOEiieAjvDNhHRz7n6DPUMoAGRnPleDDr0Pr1HDoSCYt2maG1
 B5/wRiC3YB7A==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 07 Jun 2020 14:25:30 -0700
IronPort-SDR: kIuXvujiVBRu8DPzrjhtSBz9LifRZZM00MPAOqrF3ms14XUfOuHxSwOJD1CYGHK2vOPNnn7JzU
 VjGSA7YyL1oA==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,485,1583222400"; 
   d="scan'208";a="270317164"
Received: from ideak-desk.fi.intel.com ([10.237.72.183])
  by orsmga003.jf.intel.com with ESMTP; 07 Jun 2020 14:25:28 -0700
From:   Imre Deak <imre.deak@intel.com>
To:     intel-gfx@lists.freedesktop.org
Cc:     dri-devel@lists.freedesktop.org, stable@vger.kernel.org
Subject: [PATCH 2/3] drm/dp_mst: Fix the DDC I2C device registration of an MST port
Date:   Mon,  8 Jun 2020 00:25:21 +0300
Message-Id: <20200607212522.16935-2-imre.deak@intel.com>
X-Mailer: git-send-email 2.23.1
In-Reply-To: <20200607212522.16935-1-imre.deak@intel.com>
References: <20200607212522.16935-1-imre.deak@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

During the initial MST probing an MST port's I2C device will be
registered using the kdev of the DRM device as a parent. Later after MST
Connection Status Notifications this I2C device will be re-registered
with the kdev of the port's connector. This will also move
inconsistently the I2C device's sysfs entry from the DRM device's sysfs
dir to the connector's dir.

Fix the above by keeping the DRM kdev as the parent of the I2C device.

Ideally the connector's kdev would be used as a parent, similarly to
non-MST connectors, however that needs some more refactoring to ensure
the connector's kdev is already available early enough. So keep the
existing (initial) behavior for now.

Cc: <stable@vger.kernel.org>
Signed-off-by: Imre Deak <imre.deak@intel.com>
---
 drivers/gpu/drm/drm_dp_mst_topology.c | 28 +++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c b/drivers/gpu/drm/drm_dp_mst_topology.c
index 02c800b8199f..083255c33ee0 100644
--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -88,8 +88,8 @@ static int drm_dp_send_enum_path_resources(struct drm_dp_mst_topology_mgr *mgr,
 static bool drm_dp_validate_guid(struct drm_dp_mst_topology_mgr *mgr,
 				 u8 *guid);
 
-static int drm_dp_mst_register_i2c_bus(struct drm_dp_aux *aux);
-static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_aux *aux);
+static int drm_dp_mst_register_i2c_bus(struct drm_dp_mst_port *port);
+static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_mst_port *port);
 static void drm_dp_mst_kick_tx(struct drm_dp_mst_topology_mgr *mgr);
 
 #define DBG_PREFIX "[dp_mst]"
@@ -1993,7 +1993,7 @@ drm_dp_port_set_pdt(struct drm_dp_mst_port *port, u8 new_pdt,
 			}
 
 			/* remove i2c over sideband */
-			drm_dp_mst_unregister_i2c_bus(&port->aux);
+			drm_dp_mst_unregister_i2c_bus(port);
 		} else {
 			mutex_lock(&mgr->lock);
 			drm_dp_mst_topology_put_mstb(port->mstb);
@@ -2008,7 +2008,7 @@ drm_dp_port_set_pdt(struct drm_dp_mst_port *port, u8 new_pdt,
 	if (port->pdt != DP_PEER_DEVICE_NONE) {
 		if (drm_dp_mst_is_end_device(port->pdt, port->mcs)) {
 			/* add i2c over sideband */
-			ret = drm_dp_mst_register_i2c_bus(&port->aux);
+			ret = drm_dp_mst_register_i2c_bus(port);
 		} else {
 			lct = drm_dp_calculate_rad(port, rad);
 			mstb = drm_dp_add_mst_branch_device(lct, rad);
@@ -5375,22 +5375,26 @@ static const struct i2c_algorithm drm_dp_mst_i2c_algo = {
 
 /**
  * drm_dp_mst_register_i2c_bus() - register an I2C adapter for I2C-over-AUX
- * @aux: DisplayPort AUX channel
+ * @port: The port to add the I2C bus on
  *
  * Returns 0 on success or a negative error code on failure.
  */
-static int drm_dp_mst_register_i2c_bus(struct drm_dp_aux *aux)
+static int drm_dp_mst_register_i2c_bus(struct drm_dp_mst_port *port)
 {
+	struct drm_dp_aux *aux = &port->aux;
+	struct device *parent_dev = port->mgr->dev->dev;
+
 	aux->ddc.algo = &drm_dp_mst_i2c_algo;
 	aux->ddc.algo_data = aux;
 	aux->ddc.retries = 3;
 
 	aux->ddc.class = I2C_CLASS_DDC;
 	aux->ddc.owner = THIS_MODULE;
-	aux->ddc.dev.parent = aux->dev;
-	aux->ddc.dev.of_node = aux->dev->of_node;
+	/* FIXME: set the kdev of the port's connector as parent */
+	aux->ddc.dev.parent = parent_dev;
+	aux->ddc.dev.of_node = parent_dev->of_node;
 
-	strlcpy(aux->ddc.name, aux->name ? aux->name : dev_name(aux->dev),
+	strlcpy(aux->ddc.name, aux->name ? aux->name : dev_name(parent_dev),
 		sizeof(aux->ddc.name));
 
 	return i2c_add_adapter(&aux->ddc);
@@ -5398,11 +5402,11 @@ static int drm_dp_mst_register_i2c_bus(struct drm_dp_aux *aux)
 
 /**
  * drm_dp_mst_unregister_i2c_bus() - unregister an I2C-over-AUX adapter
- * @aux: DisplayPort AUX channel
+ * @port: The port to remove the I2C bus from
  */
-static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_aux *aux)
+static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_mst_port *port)
 {
-	i2c_del_adapter(&aux->ddc);
+	i2c_del_adapter(&port->aux.ddc);
 }
 
 /**
-- 
2.23.1

