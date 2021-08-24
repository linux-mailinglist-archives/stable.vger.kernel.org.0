Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11DE43F623E
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 18:07:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229660AbhHXQIN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 12:08:13 -0400
Received: from mga05.intel.com ([192.55.52.43]:46838 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229467AbhHXQIN (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 12:08:13 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10086"; a="302926910"
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="302926910"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:29 -0700
X-IronPort-AV: E=Sophos;i="5.84,347,1620716400"; 
   d="scan'208";a="575064522"
Received: from dwillia2-desk3.jf.intel.com (HELO dwillia2-desk3.amr.corp.intel.com) ([10.54.39.25])
  by orsmga004-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Aug 2021 09:07:28 -0700
Subject: [PATCH v3 23/28] cxl/acpi: Do not add DSDT disabled ACPI0016 host
 bridge ports
From:   Dan Williams <dan.j.williams@intel.com>
To:     linux-cxl@vger.kernel.org
Cc:     Alison Schofield <alison.schofield@intel.com>,
        stable@vger.kernel.org, vishal.l.verma@intel.com,
        nvdimm@lists.linux.dev, Jonathan.Cameron@huawei.com,
        ira.weiny@intel.com, ben.widawsky@intel.com,
        vishal.l.verma@intel.com, alison.schofield@intel.com
Date:   Tue, 24 Aug 2021 09:07:28 -0700
Message-ID: <162982124835.1124374.16212896894542743429.stgit@dwillia2-desk3.amr.corp.intel.com>
In-Reply-To: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
References: <162982112370.1124374.2020303588105269226.stgit@dwillia2-desk3.amr.corp.intel.com>
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
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
---
 drivers/cxl/acpi.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/cxl/acpi.c b/drivers/cxl/acpi.c
index 8ae89273f58e..2d8f1ec1abff 100644
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
@@ -282,6 +281,7 @@ static int add_host_bridge_uport(struct device *match, void *arg)
 		return PTR_ERR(port);
 	dev_dbg(host, "%s: add: %s\n", dev_name(match), dev_name(&port->dev));
 
+	pci_root = acpi_pci_find_root(bridge->handle);
 	ctx = (struct cxl_walk_context){
 		.dev = host,
 		.root = pci_root->bus,

