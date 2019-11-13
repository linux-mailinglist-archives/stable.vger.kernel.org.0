Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D77CAFA31E
	for <lists+stable@lfdr.de>; Wed, 13 Nov 2019 03:08:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728813AbfKMCH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Nov 2019 21:07:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:55302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730444AbfKMCAM (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 12 Nov 2019 21:00:12 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1A0A722467;
        Wed, 13 Nov 2019 02:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1573610411;
        bh=0lcDox0pzW+j0DkcAwN8jvU/lx22Ypx2/yL4h5meA2Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AV4vGSATmMQwVRFhmFGrl0TiVMfxcwoqSAYRkfAb/STl3fDSG0vT7SGsDRvmEwqJ8
         eOubgsO9+W2jvS6luQwltMv8CTqGYfyU4CEZ6/gMr7Aeu57fZX6uvqgd/T/xCWerZJ
         //1Fb3hiJ2Z4wq5eTZhZtzPUczjNyzTehnTvOS+I=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Bob Moore <robert.moore@intel.com>,
        Erik Schmauss <erik.schmauss@intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org,
        devel@acpica.org
Subject: [PATCH AUTOSEL 4.9 25/68] ACPICA: Never run _REG on system_memory and system_IO
Date:   Tue, 12 Nov 2019 20:58:49 -0500
Message-Id: <20191113015932.12655-25-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191113015932.12655-1-sashal@kernel.org>
References: <20191113015932.12655-1-sashal@kernel.org>
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
index 92fa47c6498cd..20fd17aaa9189 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -247,6 +247,8 @@ acpi_status
 acpi_ev_initialize_region(union acpi_operand_object *region_obj,
 			  u8 acpi_ns_locked);
 
+u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
+
 /*
  * evsci - SCI (System Control Interrupt) handling/dispatch
  */
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index dff1207a60788..219bc576d1270 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -428,9 +428,9 @@ struct acpi_simple_repair_info {
 /* Info for running the _REG methods */
 
 struct acpi_reg_walk_info {
-	acpi_adr_space_type space_id;
 	u32 function;
 	u32 reg_run_count;
+	acpi_adr_space_type space_id;
 };
 
 /*****************************************************************************
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index 4c6f795140402..9cb60fdc77e50 100644
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
index 75ddd160a716f..c8646c3977865 100644
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
index d2743067126af..f87d59a05c681 100644
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

