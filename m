Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF20859A3E5
	for <lists+stable@lfdr.de>; Fri, 19 Aug 2022 20:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353702AbiHSQq0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Aug 2022 12:46:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1353578AbiHSQpA (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 19 Aug 2022 12:45:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9990112F85;
        Fri, 19 Aug 2022 09:11:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 278F2B8282B;
        Fri, 19 Aug 2022 16:10:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18E92C433C1;
        Fri, 19 Aug 2022 16:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1660925402;
        bh=vD0ZHQiV1yxvzaDjdwVLq9VvrFcH6EUVGuJUvCSgr0c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E7bMadhxjkw6Pagmrv4pW+QYwoC/bYSYMcutcxfH3hu/JIbUIpQ8A1JkUJQF6if0R
         E65UoPtTnRokYYXIgTjR8ZmG/arlTCTZ1wiTMNpgbc8vrxzJIHsvq5aLHByyrYde5B
         warnga/CuClJ3jalUripMdD2/s/8M+Zw3oQBxm/A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean V Kelley <sean.v.kelley@intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 481/545] PCI/ERR: Recover from RCEC AER errors
Date:   Fri, 19 Aug 2022 17:44:11 +0200
Message-Id: <20220819153850.953186682@linuxfoundation.org>
X-Mailer: git-send-email 2.37.2
In-Reply-To: <20220819153829.135562864@linuxfoundation.org>
References: <20220819153829.135562864@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean V Kelley <sean.v.kelley@intel.com>

[ Upstream commit a175102b0a82fc57853a9e611c42d1d6172e5180 ]

A Root Complex Event Collector (RCEC) collects and signals AER errors that
were detected by Root Complex Integrated Endpoints (RCiEPs), but it may
also signal errors it detects itself.  This is analogous to errors detected
and signaled by a Root Port.

Update the AER service driver to claim RCECs in addition to Root Ports.
Add support for handling RCEC-detected AER errors.  This does not
include handling RCiEP-detected errors that are signaled by the RCEC.

Note that we expect these errors only from the native AER and APEI paths,
not from DPC or EDR.

[bhelgaas: split from combined RCEC/RCiEP patch, commit log]
Signed-off-by: Sean V Kelley <sean.v.kelley@intel.com>
Signed-off-by: Bjorn Helgaas <bhelgaas@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/pcie/aer.c | 58 +++++++++++++++++++++++++++++-------------
 drivers/pci/pcie/err.c | 19 +++++++++++---
 2 files changed, 56 insertions(+), 21 deletions(-)

diff --git a/drivers/pci/pcie/aer.c b/drivers/pci/pcie/aer.c
index 72dbc193a25f..2ab708ab7218 100644
--- a/drivers/pci/pcie/aer.c
+++ b/drivers/pci/pcie/aer.c
@@ -305,7 +305,8 @@ int pci_aer_raw_clear_status(struct pci_dev *dev)
 		return -EIO;
 
 	port_type = pci_pcie_type(dev);
-	if (port_type == PCI_EXP_TYPE_ROOT_PORT) {
+	if (port_type == PCI_EXP_TYPE_ROOT_PORT ||
+	    port_type == PCI_EXP_TYPE_RC_EC) {
 		pci_read_config_dword(dev, aer + PCI_ERR_ROOT_STATUS, &status);
 		pci_write_config_dword(dev, aer + PCI_ERR_ROOT_STATUS, status);
 	}
@@ -600,7 +601,8 @@ static umode_t aer_stats_attrs_are_visible(struct kobject *kobj,
 	if ((a == &dev_attr_aer_rootport_total_err_cor.attr ||
 	     a == &dev_attr_aer_rootport_total_err_fatal.attr ||
 	     a == &dev_attr_aer_rootport_total_err_nonfatal.attr) &&
-	    pci_pcie_type(pdev) != PCI_EXP_TYPE_ROOT_PORT)
+	    ((pci_pcie_type(pdev) != PCI_EXP_TYPE_ROOT_PORT) &&
+	     (pci_pcie_type(pdev) != PCI_EXP_TYPE_RC_EC)))
 		return 0;
 
 	return a->mode;
@@ -1211,6 +1213,7 @@ static int set_device_error_reporting(struct pci_dev *dev, void *data)
 	int type = pci_pcie_type(dev);
 
 	if ((type == PCI_EXP_TYPE_ROOT_PORT) ||
+	    (type == PCI_EXP_TYPE_RC_EC) ||
 	    (type == PCI_EXP_TYPE_UPSTREAM) ||
 	    (type == PCI_EXP_TYPE_DOWNSTREAM)) {
 		if (enable)
@@ -1335,6 +1338,11 @@ static int aer_probe(struct pcie_device *dev)
 	struct device *device = &dev->device;
 	struct pci_dev *port = dev->port;
 
+	/* Limit to Root Ports or Root Complex Event Collectors */
+	if ((pci_pcie_type(port) != PCI_EXP_TYPE_RC_EC) &&
+	    (pci_pcie_type(port) != PCI_EXP_TYPE_ROOT_PORT))
+		return -ENODEV;
+
 	rpc = devm_kzalloc(device, sizeof(struct aer_rpc), GFP_KERNEL);
 	if (!rpc)
 		return -ENOMEM;
@@ -1356,36 +1364,52 @@ static int aer_probe(struct pcie_device *dev)
 }
 
 /**
- * aer_root_reset - reset link on Root Port
- * @dev: pointer to Root Port's pci_dev data structure
+ * aer_root_reset - reset Root Port hierarchy or RCEC
+ * @dev: pointer to Root Port or RCEC
  *
- * Invoked by Port Bus driver when performing link reset at Root Port.
+ * Invoked by Port Bus driver when performing reset.
  */
 static pci_ers_result_t aer_root_reset(struct pci_dev *dev)
 {
-	int aer = dev->aer_cap;
+	int type = pci_pcie_type(dev);
+	struct pci_dev *root;
+	int aer;
+	struct pci_host_bridge *host = pci_find_host_bridge(dev->bus);
 	u32 reg32;
 	int rc;
 
-	if (pcie_aer_is_native(dev)) {
+	root = dev;	/* device with Root Error registers */
+	aer = root->aer_cap;
+
+	if ((host->native_aer || pcie_ports_native) && aer) {
 		/* Disable Root's interrupt in response to error messages */
-		pci_read_config_dword(dev, aer + PCI_ERR_ROOT_COMMAND, &reg32);
+		pci_read_config_dword(root, aer + PCI_ERR_ROOT_COMMAND, &reg32);
 		reg32 &= ~ROOT_PORT_INTR_ON_MESG_MASK;
-		pci_write_config_dword(dev, aer + PCI_ERR_ROOT_COMMAND, reg32);
+		pci_write_config_dword(root, aer + PCI_ERR_ROOT_COMMAND, reg32);
 	}
 
-	rc = pci_bus_error_reset(dev);
-	pci_info(dev, "Root Port link has been reset (%d)\n", rc);
+	if (type == PCI_EXP_TYPE_RC_EC) {
+		if (pcie_has_flr(dev)) {
+			rc = pcie_flr(dev);
+			pci_info(dev, "has been reset (%d)\n", rc);
+		} else {
+			pci_info(dev, "not reset (no FLR support)\n");
+			rc = -ENOTTY;
+		}
+	} else {
+		rc = pci_bus_error_reset(dev);
+		pci_info(dev, "Root Port link has been reset (%d)\n", rc);
+	}
 
-	if (pcie_aer_is_native(dev)) {
+	if ((host->native_aer || pcie_ports_native) && aer) {
 		/* Clear Root Error Status */
-		pci_read_config_dword(dev, aer + PCI_ERR_ROOT_STATUS, &reg32);
-		pci_write_config_dword(dev, aer + PCI_ERR_ROOT_STATUS, reg32);
+		pci_read_config_dword(root, aer + PCI_ERR_ROOT_STATUS, &reg32);
+		pci_write_config_dword(root, aer + PCI_ERR_ROOT_STATUS, reg32);
 
 		/* Enable Root Port's interrupt in response to error messages */
-		pci_read_config_dword(dev, aer + PCI_ERR_ROOT_COMMAND, &reg32);
+		pci_read_config_dword(root, aer + PCI_ERR_ROOT_COMMAND, &reg32);
 		reg32 |= ROOT_PORT_INTR_ON_MESG_MASK;
-		pci_write_config_dword(dev, aer + PCI_ERR_ROOT_COMMAND, reg32);
+		pci_write_config_dword(root, aer + PCI_ERR_ROOT_COMMAND, reg32);
 	}
 
 	return rc ? PCI_ERS_RESULT_DISCONNECT : PCI_ERS_RESULT_RECOVERED;
@@ -1393,7 +1417,7 @@ static pci_ers_result_t aer_root_reset(struct pci_dev *dev)
 
 static struct pcie_port_service_driver aerdriver = {
 	.name		= "aer",
-	.port_type	= PCI_EXP_TYPE_ROOT_PORT,
+	.port_type	= PCIE_ANY_PORT,
 	.service	= PCIE_PORT_SERVICE_AER,
 
 	.probe		= aer_probe,
diff --git a/drivers/pci/pcie/err.c b/drivers/pci/pcie/err.c
index 8b53aecdb43d..d89d7ed70768 100644
--- a/drivers/pci/pcie/err.c
+++ b/drivers/pci/pcie/err.c
@@ -148,13 +148,16 @@ static int report_resume(struct pci_dev *dev, void *data)
 
 /**
  * pci_walk_bridge - walk bridges potentially AER affected
- * @bridge:	bridge which may be a Port
+ * @bridge:	bridge which may be a Port or an RCEC
  * @cb:		callback to be called for each device found
  * @userdata:	arbitrary pointer to be passed to callback
  *
  * If the device provided is a bridge, walk the subordinate bus, including
  * any bridged devices on buses under this bus.  Call the provided callback
  * on each device found.
+ *
+ * If the device provided has no subordinate bus, e.g., an RCEC, call the
+ * callback on the device itself.
  */
 static void pci_walk_bridge(struct pci_dev *bridge,
 			    int (*cb)(struct pci_dev *, void *),
@@ -162,6 +165,8 @@ static void pci_walk_bridge(struct pci_dev *bridge,
 {
 	if (bridge->subordinate)
 		pci_walk_bus(bridge->subordinate, cb, userdata);
+	else
+		cb(bridge, userdata);
 }
 
 pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
@@ -173,11 +178,17 @@ pci_ers_result_t pcie_do_recovery(struct pci_dev *dev,
 	pci_ers_result_t status = PCI_ERS_RESULT_CAN_RECOVER;
 
 	/*
-	 * Error recovery runs on all subordinates of the bridge.  If the
-	 * bridge detected the error, it is cleared at the end.
+	 * If the error was detected by a Root Port, Downstream Port, or
+	 * RCEC, recovery runs on the device itself.  For Ports, that also
+	 * includes any subordinate devices.
+	 *
+	 * If it was detected by another device (Endpoint, etc), recovery
+	 * runs on the device and anything else under the same Port, i.e.,
+	 * everything under "bridge".
 	 */
 	if (type == PCI_EXP_TYPE_ROOT_PORT ||
-	    type == PCI_EXP_TYPE_DOWNSTREAM)
+	    type == PCI_EXP_TYPE_DOWNSTREAM ||
+	    type == PCI_EXP_TYPE_RC_EC)
 		bridge = dev;
 	else
 		bridge = pci_upstream_bridge(dev);
-- 
2.35.1



