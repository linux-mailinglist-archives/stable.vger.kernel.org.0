Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6E0D27022
	for <lists+stable@lfdr.de>; Wed, 22 May 2019 22:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728734AbfEVUBh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 May 2019 16:01:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:43052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730431AbfEVTWW (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 May 2019 15:22:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A3D6B2186A;
        Wed, 22 May 2019 19:22:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558552942;
        bh=1d31qTszdi2fYP3Hw1CE8fO2rZYLUMSnRKtGironcDA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1QV0bJsv4Mn/IlCGsE/NexPoF82rM6HcGX+OgbJ99q8Ak/TIk120U9Q27VR5XdOax
         ldFDrrJhLljJGLBG5EEbBFugCkN4StEluPYTbhYkXg8lQfmNk4SCvNB5uxLIPULTD6
         T0eUOM+e4IsPhXmhlrb3M83D0iJ6HQTL2mt+L640=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.1 042/375] ACPI / property: fix handling of data_nodes in acpi_get_next_subnode()
Date:   Wed, 22 May 2019 15:15:42 -0400
Message-Id: <20190522192115.22666-42-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20190522192115.22666-1-sashal@kernel.org>
References: <20190522192115.22666-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>

[ Upstream commit 23583f7795025e3c783b680d906509366b0906ad ]

When the DSDT tables expose devices with subdevices and a set of
hierarchical _DSD properties, the data returned by
acpi_get_next_subnode() is incorrect, with the results suggesting a bad
pointer assignment. The parser works fine with device_nodes or
data_nodes, but not with a combination of the two.

The problem is traced to an invalid pointer used when jumping from
handling device_nodes to data nodes. The existing code looks for data
nodes below the last subdevice found instead of the common root. Fix
by forcing the acpi_device pointer to be derived from the same fwnode
for the two types of subnodes.

This same problem of handling device and data nodes was already fixed
in a similar way by 'commit bf4703fdd166 ("ACPI / property: fix data
node parsing in acpi_get_next_subnode()")' but broken later by 'commit
34055190b19 ("ACPI / property: Add fwnode_get_next_child_node()")', so
this should probably go to linux-stable all the way to 4.12

Signed-off-by: Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/property.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/acpi/property.c b/drivers/acpi/property.c
index 77abe0ec40431..bd533f68b1dec 100644
--- a/drivers/acpi/property.c
+++ b/drivers/acpi/property.c
@@ -1031,6 +1031,14 @@ struct fwnode_handle *acpi_get_next_subnode(const struct fwnode_handle *fwnode,
 		const struct acpi_data_node *data = to_acpi_data_node(fwnode);
 		struct acpi_data_node *dn;
 
+		/*
+		 * We can have a combination of device and data nodes, e.g. with
+		 * hierarchical _DSD properties. Make sure the adev pointer is
+		 * restored before going through data nodes, otherwise we will
+		 * be looking for data_nodes below the last device found instead
+		 * of the common fwnode shared by device_nodes and data_nodes.
+		 */
+		adev = to_acpi_device_node(fwnode);
 		if (adev)
 			head = &adev->data.subnodes;
 		else if (data)
-- 
2.20.1

