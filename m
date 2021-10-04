Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B17B420F28
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:30:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237093AbhJDNbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:43148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236307AbhJDN34 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:29:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D91163226;
        Mon,  4 Oct 2021 13:13:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353207;
        bh=gbzeM37Zhas7eRYhP+wau5J9CfcGmKSSSDNQGx29buo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eTWT1FKsuXB3Awkl1qhh9rJG7juu+37COohuSg+iTdQjNAtcpLMy18oVKXLCBZN/1
         Mb2E8WlFYj2I/IgEutJRwwHT7lD6Uz7yHiu9tiEoJT/jWvOwaHO5wfmV1OR/za9nmu
         bANGWgFVJiveyIH3AZh+FwAMWrrsYiKUWbJECfh0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Dan Williams <dan.j.williams@intel.com>,
        Jia He <justin.he@arm.com>
Subject: [PATCH 5.14 038/172] ACPI: NFIT: Use fallback node id when numa info in NFIT table is incorrect
Date:   Mon,  4 Oct 2021 14:51:28 +0200
Message-Id: <20211004125046.212942681@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jia He <justin.he@arm.com>

commit f060db99374e80e853ac4916b49f0a903f65e9dc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/nfit/core.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/acpi/nfit/core.c
+++ b/drivers/acpi/nfit/core.c
@@ -3007,6 +3007,18 @@ static int acpi_nfit_register_region(str
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


