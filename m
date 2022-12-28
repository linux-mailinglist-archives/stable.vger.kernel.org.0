Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C302965810B
	for <lists+stable@lfdr.de>; Wed, 28 Dec 2022 17:25:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233279AbiL1QYh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 28 Dec 2022 11:24:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234733AbiL1QXx (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 28 Dec 2022 11:23:53 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8030D1A201
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 08:20:38 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18EB6B81887
        for <stable@vger.kernel.org>; Wed, 28 Dec 2022 16:20:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C03CC433EF;
        Wed, 28 Dec 2022 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1672244435;
        bh=O4cQUMK7hWJ+FXEHEO6/mZRPa3tQuqcXw+rM/CzyI4U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xUZm0hyh7XwHKRmX+DFpL9iPlwULu0XPLKOrTuZaIMgZMFfVcEJpzcUd0M44v1rlR
         EZS+Xb433ZMWh46sB+lnZDlwqYVqdhIlnY/GclXrl4Z5g0YlzN4aOnD8PMiaF+W7hb
         UN+f5+1FYgOBi9eW6cY2OrSiofIgkrJ/JaUuPSFc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        Nirmal Patel <nirmal.patel@linux.intel.com>,
        Jonathan Derrick <jonathan.derrick@linux.dev>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0669/1146] PCI: vmd: Fix secondary bus reset for Intel bridges
Date:   Wed, 28 Dec 2022 15:36:48 +0100
Message-Id: <20221228144348.322067537@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>

[ Upstream commit 0a584655ef89541dae4d48d2c523b1480ae80284 ]

The reset was never applied in the current implementation because Intel
Bridges owned by VMD are parentless. Internally, pci_reset_bus() applies
a reset to the parent of the PCI device supplied as argument, but in this
case it failed because there wasn't a parent.

In more detail, this change allows the VMD driver to enumerate NVMe devices
in pass-through configurations when guest reboots are performed. There was
an attempted to fix this, but later we discovered that the code inside
pci_reset_bus() wasn’t triggering secondary bus resets. Therefore, we
updated the parameters passed to it, and now NVMe SSDs attached to VMD
bridges are properly enumerated in VT-d pass-through scenarios.

Link: https://lore.kernel.org/r/20221206001637.4744-1-francisco.munoz.ruiz@linux.intel.com
Fixes: 6aab5622296b ("PCI: vmd: Clean up domain before enumeration")
Signed-off-by: Francisco Munoz <francisco.munoz.ruiz@linux.intel.com>
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Reviewed-by: Nirmal Patel <nirmal.patel@linux.intel.com>
Reviewed-by: Jonathan Derrick <jonathan.derrick@linux.dev>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pci/controller/vmd.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/drivers/pci/controller/vmd.c b/drivers/pci/controller/vmd.c
index 98e0746e681c..769eedeb8802 100644
--- a/drivers/pci/controller/vmd.c
+++ b/drivers/pci/controller/vmd.c
@@ -719,6 +719,7 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 	resource_size_t offset[2] = {0};
 	resource_size_t membar2_offset = 0x2000;
 	struct pci_bus *child;
+	struct pci_dev *dev;
 	int ret;
 
 	/*
@@ -859,8 +860,25 @@ static int vmd_enable_domain(struct vmd_dev *vmd, unsigned long features)
 
 	pci_scan_child_bus(vmd->bus);
 	vmd_domain_reset(vmd);
-	list_for_each_entry(child, &vmd->bus->children, node)
-		pci_reset_bus(child->self);
+
+	/* When Intel VMD is enabled, the OS does not discover the Root Ports
+	 * owned by Intel VMD within the MMCFG space. pci_reset_bus() applies
+	 * a reset to the parent of the PCI device supplied as argument. This
+	 * is why we pass a child device, so the reset can be triggered at
+	 * the Intel bridge level and propagated to all the children in the
+	 * hierarchy.
+	 */
+	list_for_each_entry(child, &vmd->bus->children, node) {
+		if (!list_empty(&child->devices)) {
+			dev = list_first_entry(&child->devices,
+					       struct pci_dev, bus_list);
+			if (pci_reset_bus(dev))
+				pci_warn(dev, "can't reset device: %d\n", ret);
+
+			break;
+		}
+	}
+
 	pci_assign_unassigned_bus_resources(vmd->bus);
 
 	/*
-- 
2.35.1



