Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F05AEA9F1E
	for <lists+stable@lfdr.de>; Thu,  5 Sep 2019 12:01:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387707AbfIEKAw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Sep 2019 06:00:52 -0400
Received: from dc8-smtprelay2.synopsys.com ([198.182.47.102]:44204 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2387592AbfIEKAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Sep 2019 06:00:52 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 47DFFC0DD6;
        Thu,  5 Sep 2019 10:00:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567677651; bh=Ni9sjBFke5ST6exyzATqN84XzCCoj9ceZGLl4BFE4IY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=MIlLrbgSmKUQ05aYWhiOIFaTIOXKQm/drAB6X9hpRl+V3B4CPuBaGcv/fWmlMcdLi
         iyZCfvdyfk6AVxSNZ1qlC8Dji5jM9rMbWu2YsceW0Q8DvHtlckMTPzGk9JuufZG3J0
         oxGSUOZb4jtOnRulUBFS+MaqedwCqVfWFo+VRoltCTKUmI66dygQWGMfzZn9zy3uQB
         CjBHm3Es5P2CFlZf5rMYcLQmWOMNCmpmX8/zQomBTWKA5iojltBZmo1kCYLmOnMzkM
         rqr8aklEq+maiYWIipu/XoWHdNEayEA4ihb348I14qBzMZNdExjsgN/jrB28AqSA3n
         fV5AZoZEybQ1g==
Received: from de02.synopsys.com (de02.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id 7B74CA005E;
        Thu,  5 Sep 2019 10:00:49 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id 5E1AC3F3B5;
        Thu,  5 Sep 2019 12:00:49 +0200 (CEST)
From:   Vitor Soares <Vitor.Soares@synopsys.com>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-i3c@lists.infradead.org
Cc:     bbrezillon@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        pgaj@cadence.com, Joao.Pinto@synopsys.com,
        Vitor Soares <Vitor.Soares@synopsys.com>,
        stable@vger.kernel.org
Subject: [PATCH v3 2/5] i3c: master: make sure ->boardinfo is initialized in add_i3c_dev_locked()
Date:   Thu,  5 Sep 2019 12:00:35 +0200
Message-Id: <ed18fd927b5759a6a1edb351113ceca615283189.1567608245.git.vitor.soares@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567608245.git.vitor.soares@synopsys.com>
References: <cover.1567608245.git.vitor.soares@synopsys.com>
In-Reply-To: <cover.1567608245.git.vitor.soares@synopsys.com>
References: <cover.1567608245.git.vitor.soares@synopsys.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The newdev->boardinfo assignment was missing in
i3c_master_add_i3c_dev_locked() and hence the ->of_node info isn't
propagated to i3c_dev_desc.

Fix this by trying to initialize device i3c_dev_boardinfo if available.

Cc: <stable@vger.kernel.org>
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
---
Change in v3:
  - None

Changes in v2:
  - Change commit message
  - Change i3c_master_search_i3c_boardinfo(newdev) to
  i3c_master_init_i3c_dev_boardinfo(newdev)
  - Add fixes, stable tags

 drivers/i3c/master.c | 27 +++++++++++++++++++++++++--
 1 file changed, 25 insertions(+), 2 deletions(-)

diff --git a/drivers/i3c/master.c b/drivers/i3c/master.c
index 586e34f..9fb99bc 100644
--- a/drivers/i3c/master.c
+++ b/drivers/i3c/master.c
@@ -1798,6 +1798,22 @@ i3c_master_search_i3c_dev_duplicate(struct i3c_dev_desc *refdev)
 	return NULL;
 }
 
+static void i3c_master_init_i3c_dev_boardinfo(struct i3c_dev_desc *dev)
+{
+	struct i3c_master_controller *master = i3c_dev_get_master(dev);
+	struct i3c_dev_boardinfo *boardinfo;
+
+	if (dev->boardinfo)
+		return;
+
+	list_for_each_entry(boardinfo, &master->boardinfo.i3c, node) {
+		if (dev->info.pid == boardinfo->pid) {
+			dev->boardinfo = boardinfo;
+			return;
+		}
+	}
+}
+
 /**
  * i3c_master_add_i3c_dev_locked() - add an I3C slave to the bus
  * @master: master used to send frames on the bus
@@ -1818,8 +1834,9 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 				  u8 addr)
 {
 	struct i3c_device_info info = { .dyn_addr = addr };
-	struct i3c_dev_desc *newdev, *olddev;
 	u8 old_dyn_addr = addr, expected_dyn_addr;
+	enum i3c_addr_slot_status addrstatus;
+	struct i3c_dev_desc *newdev, *olddev;
 	struct i3c_ibi_setup ibireq = { };
 	bool enable_ibi = false;
 	int ret;
@@ -1878,6 +1895,8 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 	if (ret)
 		goto err_detach_dev;
 
+	i3c_master_init_i3c_dev_boardinfo(newdev);
+
 	/*
 	 * Depending on our previous state, the expected dynamic address might
 	 * differ:
@@ -1895,7 +1914,11 @@ int i3c_master_add_i3c_dev_locked(struct i3c_master_controller *master,
 	else
 		expected_dyn_addr = newdev->info.dyn_addr;
 
-	if (newdev->info.dyn_addr != expected_dyn_addr) {
+	addrstatus = i3c_bus_get_addr_slot_status(&master->bus,
+						  expected_dyn_addr);
+
+	if (newdev->info.dyn_addr != expected_dyn_addr &&
+	    addrstatus == I3C_ADDR_SLOT_FREE) {
 		/*
 		 * Try to apply the expected dynamic address. If it fails, keep
 		 * the address assigned by the master.
-- 
2.7.4

