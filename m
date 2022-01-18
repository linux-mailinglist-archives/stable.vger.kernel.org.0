Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 74236491815
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:44:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345899AbiARCoT (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:44:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346650AbiARCjj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:39:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F859C0619D2;
        Mon, 17 Jan 2022 18:36:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B9D486127D;
        Tue, 18 Jan 2022 02:36:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35610C36AEF;
        Tue, 18 Jan 2022 02:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473368;
        bh=b1kuycPtIuGNh9eiV5SiIWKNRLWLaFZgezxgdv7TYmM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Szgn+gYWmFXdpGYAuCm0V5VLKIWmPc4NEzaBylAz6J6ad6uF+ceGtxm5jaW104ZuR
         DOHAS5Lq2p7xgMgemWiQe97069cQgxOZN1Jz6PgK2c8T5eGoT1KWFrqBxwqoceBzaM
         BycufcnsSlTPM7RiAlKPpMPx8AaOcj19NlTOwgpna07s8gyjKWZfNa19Tq1BYoAWnB
         OogL7kzjx1PSlOqx5TIBGruPej7WEMHlXU0J2DGP121TKs9eI/jAC5+QE3H+M0tMS1
         atN4zsT3GHwNMWtoxkYuVPdxcwrlYOMBsNth1Oq8EwVpceEjA5eT9dplKjtH8BF5Kw
         erR9AZlLabklQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, andreas.noever@gmail.com,
        michael.jamet@intel.com, YehezkelShB@gmail.com,
        linux-usb@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 088/188] thunderbolt: Runtime PM activate both ends of the device link
Date:   Mon, 17 Jan 2022 21:30:12 -0500
Message-Id: <20220118023152.1948105-88-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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

