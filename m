Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7ECC449157B
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:28:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343951AbiARC2U (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:28:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245077AbiARC0T (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:26:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55259C061746;
        Mon, 17 Jan 2022 18:24:59 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07C43B81240;
        Tue, 18 Jan 2022 02:24:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A2EC36B07;
        Tue, 18 Jan 2022 02:24:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472696;
        bh=b1kuycPtIuGNh9eiV5SiIWKNRLWLaFZgezxgdv7TYmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UCq9Ii7DF17MTy1CUpmn+ABB15uxiQeiYnHffoj5pWMFrbL7OD+bkgNwKcylAp1FZ
         LuJnOWAlrwzNN8w2NpK4bwq+0+ihDd3hYrR4HUooLlc6AIF0u4WNuVRjH6hn5wkEVE
         Tb4jhqRrENpMciXDlNkN4jca/aYurZLGEaqIQRk15mifyr1G+KMoxeL3Z5KQtDiIv+
         Y2bAiPxrj4yh1ta2YbDG3J5TW3kSvILPMr0cuZcTO9vDdOOYV4to4oB4BxVcJsuejt
         FBD3r9jpDeTVdl6TFNAlAGsMHkMq3M3XacpyyIKWSsdV/YZthCvmgT96SpkcJJVZ4p
         z7ppp9n+gQ/FQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, andreas.noever@gmail.com,
        michael.jamet@intel.com, YehezkelShB@gmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 102/217] thunderbolt: Runtime PM activate both ends of the device link
Date:   Mon, 17 Jan 2022 21:17:45 -0500
Message-Id: <20220118021940.1942199-102-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mika Westerberg <mika.westerberg@linux.intel.com>

[ Upstream commit f3380cac0c0b3a6f49ab161e2a057c363962f48d ]

If protocol tunnels are already up when the driver is loaded, for
instance if the boot firmware implements connection manager of its own,
runtime PM reference count of the consumer devices behind the tunnel
might have been increased already before the device link is created but
the supplier device runtime PM reference count is not. This leads to a
situation where the supplier (the Thunderbolt driver) can runtime
suspend even if it should not because the corresponding protocol tunnel
needs to be up causing the devices to be removed from the corresponding
native bus.

Prevent this from happening by making both sides of the link runtime PM
active briefly. The pm_runtime_put() for the consumer (PCIe
root/downstream port, xHCI) then allows it to runtime suspend again but
keeps the supplier runtime resumed the whole time it is runtime active.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/thunderbolt/acpi.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/thunderbolt/acpi.c b/drivers/thunderbolt/acpi.c
index b67e72d5644b3..7c9597a339295 100644
--- a/drivers/thunderbolt/acpi.c
+++ b/drivers/thunderbolt/acpi.c
@@ -7,6 +7,7 @@
  */
 
 #include <linux/acpi.h>
+#include <linux/pm_runtime.h>
 
 #include "tb.h"
 
@@ -74,8 +75,18 @@ static acpi_status tb_acpi_add_link(acpi_handle handle, u32 level, void *data,
 		 pci_pcie_type(pdev) == PCI_EXP_TYPE_DOWNSTREAM))) {
 		const struct device_link *link;
 
+		/*
+		 * Make them both active first to make sure the NHI does
+		 * not runtime suspend before the consumer. The
+		 * pm_runtime_put() below then allows the consumer to
+		 * runtime suspend again (which then allows NHI runtime
+		 * suspend too now that the device link is established).
+		 */
+		pm_runtime_get_sync(&pdev->dev);
+
 		link = device_link_add(&pdev->dev, &nhi->pdev->dev,
 				       DL_FLAG_AUTOREMOVE_SUPPLIER |
+				       DL_FLAG_RPM_ACTIVE |
 				       DL_FLAG_PM_RUNTIME);
 		if (link) {
 			dev_dbg(&nhi->pdev->dev, "created link from %s\n",
@@ -84,6 +95,8 @@ static acpi_status tb_acpi_add_link(acpi_handle handle, u32 level, void *data,
 			dev_warn(&nhi->pdev->dev, "device link creation from %s failed\n",
 				 dev_name(&pdev->dev));
 		}
+
+		pm_runtime_put(&pdev->dev);
 	}
 
 out_put:
-- 
2.34.1

