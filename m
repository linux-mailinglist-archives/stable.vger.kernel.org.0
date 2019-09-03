Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E3BF6A6699
	for <lists+stable@lfdr.de>; Tue,  3 Sep 2019 12:36:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728490AbfICKf7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Sep 2019 06:35:59 -0400
Received: from smtprelay-out1.synopsys.com ([198.182.47.102]:57250 "EHLO
        smtprelay-out1.synopsys.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727077AbfICKf7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Sep 2019 06:35:59 -0400
Received: from mailhost.synopsys.com (mdc-mailhost2.synopsys.com [10.225.0.210])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by smtprelay-out1.synopsys.com (Postfix) with ESMTPS id 7111CC0C4A;
        Tue,  3 Sep 2019 10:35:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=synopsys.com; s=mail;
        t=1567506958; bh=hzEcIxH9OkYzQ2wF2QX+ihkL5mVW4n1QxZ4evCVUErM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:In-Reply-To:
         References:From;
        b=Nw2gFNkDwaEHAvmWI6x6vWdrQ+2sCSutk1yItj7eStLFz29/9Aic6KJrZmXntJ1tS
         dP3psLh3BYBZZEBjrxf4cYyDhPh7IJVP26+yVDfRZpnF84y99v+xq+s5svc3tHIg5d
         6lVvgWuL2plWUz0CtnqXlAMw7Hh5lEC8t81i41PSUBh3vobRVvkri8D1ftjdBzGJUZ
         B4259R+uU+Rce3JpnM8YD99d9OorlOjGwYsUENqlG92tENtxU5rEyoP+cWYPobyZ6O
         BkJDKq67/4lPPH+D6U7f/AqfPQUvXp1JpIC4Q6aJ0VNd5upXvux1kJeQTx+S8GLQuC
         w1Gr53HDwUwmA==
Received: from de02.synopsys.com (germany.internal.synopsys.com [10.225.17.21])
        by mailhost.synopsys.com (Postfix) with ESMTP id CD0EEA0069;
        Tue,  3 Sep 2019 10:35:56 +0000 (UTC)
Received: from de02dwia024.internal.synopsys.com (de02dwia024.internal.synopsys.com [10.225.19.81])
        by de02.synopsys.com (Postfix) with ESMTP id B455F3C0D7;
        Tue,  3 Sep 2019 12:35:56 +0200 (CEST)
From:   Vitor Soares <Vitor.Soares@synopsys.com>
To:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        linux-i3c@lists.infradead.org
Cc:     bbrezillon@kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        pgaj@cadence.com, Joao.Pinto@synopsys.com,
        Vitor Soares <Vitor.Soares@synopsys.com>,
        stable@vger.kernel.org
Subject: [PATCH v2 2/5] i3c: master: make sure ->boardinfo is initialized in add_i3c_dev_locked()
Date:   Tue,  3 Sep 2019 12:35:51 +0200
Message-Id: <d8db2c6d6ebb5c1dc577593b353847bd312fd6c0.1567437955.git.vitor.soares@synopsys.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <cover.1567437955.git.vitor.soares@synopsys.com>
References: <cover.1567437955.git.vitor.soares@synopsys.com>
In-Reply-To: <cover.1567437955.git.vitor.soares@synopsys.com>
References: <cover.1567437955.git.vitor.soares@synopsys.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The newdev->boardinfo assignment was missing in
i3c_master_add_i3c_dev_locked() and hence the ->of_node info isn't
propagated to  i3c_dev_desc.

Fix this by trying to initialize device i3c_dev_boardinfo if available.

Cc: <stable@vger.kernel.org>
Fixes: 3a379bbcea0a ("i3c: Add core I3C infrastructure")
Signed-off-by: Vitor Soares <vitor.soares@synopsys.com>
---
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

