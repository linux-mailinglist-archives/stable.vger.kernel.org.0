Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1D1D24BE29
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 15:21:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728367AbgHTNU2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 09:20:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728471AbgHTJee (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 05:34:34 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 35F4022BEB;
        Thu, 20 Aug 2020 09:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597916073;
        bh=Y1i4DF6BcOshXWHpxWKBz010ViC4i7Ok0SjzYrZZI7Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GWdCHs5iV3E+SpdR20KKxcdXPnti8UCH/5JxG8tDobZUY1tfA2qVMO60REN7aaPTY
         PIAyZRrzNHYCWazJcrKxir1ZKbPxGc6FmeVXjsm1HSOB20/Yl/1OUXIl5QJJoIGFbK
         Xm/x3/nv9iR7tbqhG0SgjQ/rnPiGH2nDfebusj98=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Imre Deak <imre.deak@intel.com>,
        Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>,
        Lyude Paul <lyude@redhat.com>
Subject: [PATCH 5.8 223/232] drm/dp_mst: Fix the DDC I2C device registration of an MST port
Date:   Thu, 20 Aug 2020 11:21:14 +0200
Message-Id: <20200820091623.582896325@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091612.692383444@linuxfoundation.org>
References: <20200820091612.692383444@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Imre Deak <imre.deak@intel.com>

commit d8bd15b37d328a935a4fc695fed8b19157503950 upstream.

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
Reviewed-by: Stanislav Lisovskiy <stanislav.lisovskiy@intel.com>
Reviewed-by: Lyude Paul <lyude@redhat.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20200607212522.16935-2-imre.deak@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/gpu/drm/drm_dp_mst_topology.c |   28 ++++++++++++++++------------
 1 file changed, 16 insertions(+), 12 deletions(-)

--- a/drivers/gpu/drm/drm_dp_mst_topology.c
+++ b/drivers/gpu/drm/drm_dp_mst_topology.c
@@ -88,8 +88,8 @@ static int drm_dp_send_enum_path_resourc
 static bool drm_dp_validate_guid(struct drm_dp_mst_topology_mgr *mgr,
 				 u8 *guid);
 
-static int drm_dp_mst_register_i2c_bus(struct drm_dp_aux *aux);
-static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_aux *aux);
+static int drm_dp_mst_register_i2c_bus(struct drm_dp_mst_port *port);
+static void drm_dp_mst_unregister_i2c_bus(struct drm_dp_mst_port *port);
 static void drm_dp_mst_kick_tx(struct drm_dp_mst_topology_mgr *mgr);
 
 #define DBG_PREFIX "[dp_mst]"
@@ -1966,7 +1966,7 @@ drm_dp_port_set_pdt(struct drm_dp_mst_po
 			}
 
 			/* remove i2c over sideband */
-			drm_dp_mst_unregister_i2c_bus(&port->aux);
+			drm_dp_mst_unregister_i2c_bus(port);
 		} else {
 			mutex_lock(&mgr->lock);
 			drm_dp_mst_topology_put_mstb(port->mstb);
@@ -1981,7 +1981,7 @@ drm_dp_port_set_pdt(struct drm_dp_mst_po
 	if (port->pdt != DP_PEER_DEVICE_NONE) {
 		if (drm_dp_mst_is_end_device(port->pdt, port->mcs)) {
 			/* add i2c over sideband */
-			ret = drm_dp_mst_register_i2c_bus(&port->aux);
+			ret = drm_dp_mst_register_i2c_bus(port);
 		} else {
 			lct = drm_dp_calculate_rad(port, rad);
 			mstb = drm_dp_add_mst_branch_device(lct, rad);
@@ -5346,22 +5346,26 @@ static const struct i2c_algorithm drm_dp
 
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
@@ -5369,11 +5373,11 @@ static int drm_dp_mst_register_i2c_bus(s
 
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


