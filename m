Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 686102F67C
	for <lists+stable@lfdr.de>; Thu, 30 May 2019 06:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728122AbfE3E4i (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 May 2019 00:56:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:46154 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727907AbfE3DKC (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 29 May 2019 23:10:02 -0400
Received: from localhost (ip67-88-213-2.z213-88-67.customer.algx.net [67.88.213.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5AD5B244A9;
        Thu, 30 May 2019 03:10:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559185802;
        bh=2RNUE2oqUXk6JbDIODB3geUggqhl72IDzXKXwwzFYTQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=g5h529iIcU1wWVYSffvysPmgwgf3vswlv9zd3tRAs9y9qO8wyD2DqH3QpmyJ6H7ev
         iPJ125b6j4oA8QdLv3+cpf+GHKiu0as9tC/7jqWrNQHFMOdjpa5ZL/MARhaFDMU9T6
         5F1tH9qWVopPqTWaN9Sl8I4Xc7ik/9rgXAxnBZfg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Pierre-Louis Bossart <pierre-louis.bossart@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.1 082/405] ACPI / property: fix handling of data_nodes in acpi_get_next_subnode()
Date:   Wed, 29 May 2019 20:01:20 -0700
Message-Id: <20190530030545.160094086@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190530030540.291644921@linuxfoundation.org>
References: <20190530030540.291644921@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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



