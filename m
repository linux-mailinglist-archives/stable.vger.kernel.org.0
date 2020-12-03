Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id ACB692CDB95
	for <lists+stable@lfdr.de>; Thu,  3 Dec 2020 17:51:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729228AbgLCQv0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 3 Dec 2020 11:51:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:53642 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728734AbgLCQv0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 3 Dec 2020 11:51:26 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 295D8AC2E;
        Thu,  3 Dec 2020 16:50:45 +0000 (UTC)
From:   Mian Yousaf Kaukab <ykaukab@suse.de>
To:     lorenzo.pieralisi@arm.com, tjoseph@cadence.com
Cc:     robh@kernel.org, bhelgaas@google.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, kishon@ti.com,
        Mian Yousaf Kaukab <ykaukab@suse.de>, stable@vger.kernel.org
Subject: [PATCH] PCI: cadence: Fix cdns_pcie_host_setup() error path
Date:   Thu,  3 Dec 2020 17:49:44 +0100
Message-Id: <20201203164944.2257-1-ykaukab@suse.de>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 19abcd790b51 ("PCI: cadence: Fix cdns_pcie_{host|ep}_setup() error
path") removed pm_runtime_put_sync() call from the error path in
cdns_pcie_{host|ep}_setup(). However, the hunk in cdns_pcie_host_setup()
got lost.

Fix error path in cdns_pcie_host_setup() by removing pm_runtime_put_sync()
call.

Fixes: 24344226f66b ("PCI: cadence: Use struct pci_host_bridge.windows list directly")
Cc: stable@vger.kernel.org
Signed-off-by: Mian Yousaf Kaukab <ykaukab@suse.de>
---
 drivers/pci/controller/cadence/pcie-cadence-host.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/pci/controller/cadence/pcie-cadence-host.c b/drivers/pci/controller/cadence/pcie-cadence-host.c
index 811c1cb2e8de..6e2557653943 100644
--- a/drivers/pci/controller/cadence/pcie-cadence-host.c
+++ b/drivers/pci/controller/cadence/pcie-cadence-host.c
@@ -471,14 +471,5 @@ int cdns_pcie_host_setup(struct cdns_pcie_rc *rc)
 	if (!bridge->ops)
 		bridge->ops = &cdns_pcie_host_ops;
 
-	ret = pci_host_probe(bridge);
-	if (ret < 0)
-		goto err_init;
-
-	return 0;
-
- err_init:
-	pm_runtime_put_sync(dev);
-
-	return ret;
+	return pci_host_probe(bridge);
 }
-- 
2.26.2

