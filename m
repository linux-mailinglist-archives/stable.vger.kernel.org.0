Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B230A42018E
	for <lists+stable@lfdr.de>; Sun,  3 Oct 2021 14:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230235AbhJCM0f (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 3 Oct 2021 08:26:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:53496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229786AbhJCM0f (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 3 Oct 2021 08:26:35 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8F42561A0A;
        Sun,  3 Oct 2021 12:24:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633263888;
        bh=Ys12kolmI2d56/1FVmwZDM3jdL47PvSwlwB8AFvUTMo=;
        h=Subject:To:Cc:From:Date:From;
        b=yLOKeK7cATP4KKBmnn+fQOkkFU1PkfgdKbAr58PQcQdqASTFhpcvFHLQ/UdrrRxi/
         xBDR8UmLO1PVs6BMiWrrYIxUOKNfnpA3w3oWBmKrOy6VEzOjkoARO8SV4JLrN8Y8ED
         4Ak3bP50w4wcDHiGqqhSnqK/X2VKioftEZ49Qr8Q=
Subject: FAILED: patch "[PATCH] ACPI: NFIT: Use fallback node id when numa info in NFIT table" failed to apply to 5.4-stable tree
To:     justin.he@arm.com, dan.j.williams@intel.com, stable@vger.kernel.org
Cc:     <stable@vger.kernel.org>
From:   <gregkh@linuxfoundation.org>
Date:   Sun, 03 Oct 2021 14:24:45 +0200
Message-ID: <1633263885139135@kroah.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch below does not apply to the 5.4-stable tree.
If someone wants it applied there, or to any other stable or longterm
tree, then please email the backport, including the original git commit
id to <stable@vger.kernel.org>.

thanks,

greg k-h

------------------ original commit in Linus's tree ------------------

From f060db99374e80e853ac4916b49f0a903f65e9dc Mon Sep 17 00:00:00 2001
From: Jia He <justin.he@arm.com>
Date: Wed, 22 Sep 2021 23:29:19 +0800
Subject: [PATCH] ACPI: NFIT: Use fallback node id when numa info in NFIT table
 is incorrect

When ACPI NFIT table is failing to populate correct numa information
on arm64, dax_kmem will get NUMA_NO_NODE from the NFIT driver.

Without this patch, pmem can't be probed as RAM devices on arm64 guest:
  $ndctl create-namespace -fe namespace0.0 --mode=devdax --map=dev -s 1g -a 128M
  kmem dax0.0: rejecting DAX region [mem 0x240400000-0x2bfffffff] with invalid node: -1
  kmem: probe of dax0.0 failed with error -22

Suggested-by: Dan Williams <dan.j.williams@intel.com>
Signed-off-by: Jia He <justin.he@arm.com>
Cc: <stable@vger.kernel.org>
Fixes: c221c0b0308f ("device-dax: "Hotplug" persistent memory for use like normal RAM")
Link: https://lore.kernel.org/r/20210922152919.6940-1-justin.he@arm.com
Signed-off-by: Dan Williams <dan.j.williams@intel.com>

diff --git a/drivers/acpi/nfit/core.c b/drivers/acpi/nfit/core.c
index a3ef6cce644c..7dd80acf92c7 100644
--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3007,6 +3007,18 @@ static int acpi_nfit_register_region(struct acpi_nfit_desc *acpi_desc,
 		ndr_desc->target_node = NUMA_NO_NODE;
 	}
 
+	/* Fallback to address based numa information if node lookup failed */
+	if (ndr_desc->numa_node == NUMA_NO_NODE) {
+		ndr_desc->numa_node = memory_add_physaddr_to_nid(spa->address);
+		dev_info(acpi_desc->dev, "changing numa node from %d to %d for nfit region [%pa-%pa]",
+			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+	}
+	if (ndr_desc->target_node == NUMA_NO_NODE) {
+		ndr_desc->target_node = phys_to_target_node(spa->address);
+		dev_info(acpi_desc->dev, "changing target node from %d to %d for nfit region [%pa-%pa]",
+			NUMA_NO_NODE, ndr_desc->numa_node, &res.start, &res.end);
+	}
+
 	/*
 	 * Persistence domain bits are hierarchical, if
 	 * ACPI_NFIT_CAPABILITY_CACHE_FLUSH is set then

