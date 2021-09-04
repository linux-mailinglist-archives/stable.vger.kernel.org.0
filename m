Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96C7C40094A
	for <lists+stable@lfdr.de>; Sat,  4 Sep 2021 04:23:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236264AbhIDCVl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Sep 2021 22:21:41 -0400
Received: from mga11.intel.com ([192.55.52.93]:3753 "EHLO mga11.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231389AbhIDCVl (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 3 Sep 2021 22:21:41 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10096"; a="216417485"
X-IronPort-AV: E=Sophos;i="5.85,267,1624345200"; 
   d="scan'208";a="216417485"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga102.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 19:20:40 -0700
X-IronPort-AV: E=Sophos;i="5.85,267,1624345200"; 
   d="scan'208";a="447819801"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga002-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Sep 2021 19:20:40 -0700
Subject: [PATCH 1/6] cxl/acpi: Do not add DSDT disabled ACPI0016 host bridge
 ports
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Alison Schofield <alison.schofield@intel.com>,
        stable@vger.kernel.org,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        ben.widawsky@intel.com, Jonathan.Cameron@huawei.com
Date:   Fri, 03 Sep 2021 19:20:39 -0700
Message-ID: <163072203957.2250120.2178685721061002124.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <163072203373.2250120.8373702699578427249.stgit@dwillia2-desk3.amr.corp.intel.com>
User-Agent: StGit/0.18-3-g996c
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

During CXL ACPI probe, host bridge ports are discovered by scanning
the ACPI0017 root port for ACPI0016 host bridge devices. The scan
matches on the hardware id of "ACPI0016". An issue occurs when an
ACPI0016 device is defined in the DSDT yet disabled on the platform.
Attempts by the cxl_acpi driver to add host bridge ports using a
disabled device fails, and the entire cxl_acpi probe fails.

The DSDT table includes an _STA method that sets the status and the
ACPI subsystem has checks available to examine it. One such check is
in the acpi_pci_find_root() path. Move the call to acpi_pci_find_root()
to the matching function to prevent this issue when adding either
upstream or downstream ports.

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Alison Schofield <alison.schofield@intel.com>
Fixes: 7d4b5ca2e2cb ("cxl/acpi: Add downstream port data to cxl_port instances")
Cc: <stable@vger.kernel.org>
Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 8ae89273f58e..54e9d4d2cf5f 100644
--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -243,6 +243,9 @@ static struct acpi_device *to_cxl_host_bridge(struct device *dev)
 {
 	struct acpi_device *adev = to_acpi_device(dev);
 
+	if (!acpi_pci_find_root(adev->handle))
+		return NULL;
+
 	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
 		return adev;
 	return NULL;
@@ -266,10 +269,6 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 	if (!bridge)
 		return 0;
 
-	pci_root = acpi_pci_find_root(bridge->handle);
-	if (!pci_root)
-		return -ENXIO;
-
 	dport = find_dport_by_dev(root_port, match);
 	if (!dport) {
 		dev_dbg(host, "host bridge expected and not found\n");
@@ -282,6 +281,11 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 		return PTR_ERR(port);
 	dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
 
+	/*
+	 * Note that this lookup already succeeded in
+	 * to_cxl_host_bridge(), so no need to check for failure here
+	 */
+	pci_root = acpi_pci_find_root(bridge->handle);
 	ctx = (struct cxl_walk_context){
 		.dev = host,
 		.root = pci_root->bus,

