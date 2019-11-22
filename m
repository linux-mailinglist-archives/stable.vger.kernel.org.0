Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F290D106C70
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 11:52:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729253AbfKVKwG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:52:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:35344 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729772AbfKVKwF (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:52:05 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B55C820637;
        Fri, 22 Nov 2019 10:52:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574419924;
        bh=zqd0Xs81UrAk7v3S1WB4SCmtWVy6g8W6FdI68lwJIk0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u4AjR9dGWu98woiQrr5Wmfc0TvzetWT+gaqchk5Csc5+YkI7WoaJQ4AIc1/eMiVpb
         IO52Cn8SC5RFplMeO4ObsK46VoTgMtJLKkssLpwFb+NfKsTdx4OPAINKORwo/y3eIV
         0P8dtWM3k8RxvLs7kSx/WmNgFHktYuAe0whQUEw0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Erik Schmauss <erik.schmauss@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 055/122] ACPICA: Never run _REG on system_memory and system_IO
Date:   Fri, 22 Nov 2019 11:28:28 +0100
Message-Id: <20191122100759.517468019@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100722.177052205@linuxfoundation.org>
References: <20191122100722.177052205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



