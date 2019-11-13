Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3FE92FA41B
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:16:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728570AbfKMCNl (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:13:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:50746 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728746AbfKMB5a (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 20:57:30 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 74669222D4;
        Wed, 13 Nov 2019 01:57:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610250;
        bh=zqd0Xs81UrAk7v3S1WB4SCmtWVy6g8W6FdI68lwJIk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=lqda6ELryAStnwyFi1XLW1VCKDFzjReyZJ8vD7GVtx4Ye0NtAQIavay6XpoPC1sjY
         XTUCPRJ2HOO42fe6GcLKilR73tsBmSL6G6KJl9lrXCchDJeiKFJj6f217QdesmiraC
         0Aps4O2Na3KJx7TNjSAKNTa/SwoS1DuQBjvPPNic=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        Erik Schmauss <erik.schmauss@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.14 047/115] ACPICA: Never run _REG on system_memory and system_IO
Date:   Tue, 12 Nov 2019 20:55:14 -0500
Message-Id: <20191113015622.11592-47-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015622.11592-1-sashal@kernel.org>
References: <20191113015622.11592-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bob Moore <robert.moore@intel.com>

[ Upstream commit 8b1cafdcb4b75c5027c52f1e82b47ebe727ad7ed ]

These address spaces are defined by the ACPI spec to be
"always available", and thus _REG should never be run on them.
Provides compatibility with other ACPI implementations.

Signed-off-by: Bob Moore <robert.moore@intel.com>
Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/acpica/acevents.h |  2 ++
 drivers/acpi/acpica/aclocal.h  |  2 +-
 drivers/acpi/acpica/evregion.c | 17 +++++++++++++++--
 drivers/acpi/acpica/evrgnini.c |  6 +-----
 drivers/acpi/acpica/evxfregn.c |  1 -
 5 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/drivers/acpi/acpica/acevents.h b/drivers/acpi/acpica/acevents.h
index a2adfd42f85cc..bfddcd989974f 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -245,6 +245,8 @@ acpi_ev_default_region_setup(acpi_handle handle,
 
 acpi_status acpi_ev_initialize_region(union acpi_operand_object *region_obj);
 
+u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
+
 /*
  * evsci - SCI (System Control Interrupt) handling/dispatch
  */
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 0d45b8bb16789..b10e92de7dd84 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -429,9 +429,9 @@ struct acpi_simple_repair_info {
 /* Info for running the _REG methods */
 
 struct acpi_reg_walk_info {
-	acpi_adr_space_type space_id;
 	u32 function;
 	u32 reg_run_count;
+	acpi_adr_space_type space_id;
 };
 
 /*****************************************************************************
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index 28b447ff92df6..3a3277f982923 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -677,6 +677,19 @@ acpi_ev_execute_reg_methods(struct acpi_namespace_node *node,
 
 	ACPI_FUNCTION_TRACE(ev_execute_reg_methods);
 
+	/*
+	 * These address spaces do not need a call to _REG, since the ACPI
+	 * specification defines them as: "must always be accessible". Since
+	 * they never change state (never become unavailable), no need to ever
+	 * call _REG on them. Also, a data_table is not a "real" address space,
+	 * so do not call _REG. September 2018.
+	 */
+	if ((space_id == ACPI_ADR_SPACE_SYSTEM_MEMORY) ||
+	    (space_id == ACPI_ADR_SPACE_SYSTEM_IO) ||
+	    (space_id == ACPI_ADR_SPACE_DATA_TABLE)) {
+		return_VOID;
+	}
+
 	info.space_id = space_id;
 	info.function = function;
 	info.reg_run_count = 0;
@@ -738,8 +751,8 @@ acpi_ev_reg_run(acpi_handle obj_handle,
 	}
 
 	/*
-	 * We only care about regions.and objects that are allowed to have address
-	 * space handlers
+	 * We only care about regions and objects that are allowed to have
+	 * address space handlers
 	 */
 	if ((node->type != ACPI_TYPE_REGION) && (node != acpi_gbl_root_node)) {
 		return (AE_OK);
diff --git a/drivers/acpi/acpica/evrgnini.c b/drivers/acpi/acpica/evrgnini.c
index 93ec528bcd9a9..3b48f1ecb55b1 100644
--- a/drivers/acpi/acpica/evrgnini.c
+++ b/drivers/acpi/acpica/evrgnini.c
@@ -50,9 +50,6 @@
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evrgnini")
 
-/* Local prototypes */
-static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ev_system_memory_region_setup
@@ -67,7 +64,6 @@ static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
  * DESCRIPTION: Setup a system_memory operation region
  *
  ******************************************************************************/
-
 acpi_status
 acpi_ev_system_memory_region_setup(acpi_handle handle,
 				   u32 function,
@@ -347,7 +343,7 @@ acpi_ev_pci_config_region_setup(acpi_handle handle,
  *
  ******************************************************************************/
 
-static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
+u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
 {
 	acpi_status status;
 	struct acpi_pnp_device_id *hid;
diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index beba9d56a0d87..742a9fe6e235d 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -227,7 +227,6 @@ acpi_remove_address_space_handler(acpi_handle device,
 				 */
 				region_obj =
 				    handler_obj->address_space.region_list;
-
 			}
 
 			/* Remove this Handler object from the list */
-- 
2.20.1

