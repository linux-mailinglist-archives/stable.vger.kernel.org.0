Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C297406B96
	for <lists+stable@lfdr.de>; Fri, 10 Sep 2021 14:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233425AbhIJMco (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Sep 2021 08:32:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:50088 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233416AbhIJMcm (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 10 Sep 2021 08:32:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 46140611C8;
        Fri, 10 Sep 2021 12:31:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1631277091;
        bh=iGBWs8eZx6iMBITm5sk4wbZ5cYOTzTSsVuetQpDVX+E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=i6Mh4W2VA8gbnudxyLWUEjuI/dQGwfYqDSbT+EKBeTRxMI1yQYFs7pn8fckhEfKpI
         n2LxbfYMJlnECPyhbRy/m5y74iTPikEdB4+/kZS5WJ9W6IseZU6UVrEoFskRPL6qF9
         FFJeyzIJ9w8girniaUjHesKrJxfDKQ3RYzai6suw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Alison Schofield <alison.schofield@intel.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.14 23/23] cxl/acpi: Do not add DSDT disabled ACPI0016 host bridge ports
Date:   Fri, 10 Sep 2021 14:30:13 +0200
Message-Id: <20210910122916.744559067@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210910122916.022815161@linuxfoundation.org>
References: <20210910122916.022815161@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alison Schofield <alison.schofield@intel.com>

commit a7bfaad54b8b9cf06041528988d6b75b4b921546 upstream.

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
Link: https://lore.kernel.org/r/163072203957.2250120.2178685721061002124.stgit@dwillia2-desk3.amr.corp.intel.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/cxl/acpi.c |   12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

--- a/drivers/cxl/acpi.c
+++ b/drivers/cxl/acpi.c
@@ -243,6 +243,9 @@ static struct acpi_device *to_cxl_host_b
 {
 	struct acpi_device *adev = to_acpi_device(dev);
 
+	if (!acpi_pci_find_root(adev->handle))
+		return NULL;
+
 	if (strcmp(acpi_device_hid(adev), "ACPI0016") == 0)
 		return adev;
 	return NULL;
@@ -266,10 +269,6 @@ static int add_host_bridge_uport(struct
 	if (!bridge)
 		return 0;
 
-	pci_root = acpi_pci_find_root(bridge->handle);
-	if (!pci_root)
-		return -ENXIO;
-
 	dport = find_dport_by_dev(root_port, match);
 	if (!dport) {
 		dev_dbg(host, "host bridge expected and not found\n");
@@ -282,6 +281,11 @@ static int add_host_bridge_uport(struct
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


