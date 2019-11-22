Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79BD2106D6B
	for <lists+stable@lfdr.de>; Fri, 22 Nov 2019 12:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730503AbfKVK77 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Nov 2019 05:59:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:51592 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728201AbfKVK76 (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Nov 2019 05:59:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6C26820721;
        Fri, 22 Nov 2019 10:59:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574420397;
        bh=B2KYIyJoPWeC/UNCnJwJ0lmKqBLfynwxhRwcJ6I1OCA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tQwN/+eViaqTndfaYBqpwYSMORPV7EH4HQ1JqKOyfXky+YsYwNG0kogksEn7UkeZn
         h7FbF3Kkj+OkuEQbLs9AppYFoIpbF/Dset5obQbG+OUNJfX5eIeOAdohPDCL7R12DV
         NpaRwCSfERp/Ahb0RNXQcDAYil5E+y+gYOiJo78A=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Bob Moore <robert.moore@intel.com>,
        Erik Schmauss <erik.schmauss@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 093/220] ACPICA: Never run _REG on system_memory and system_IO
Date:   Fri, 22 Nov 2019 11:27:38 +0100
Message-Id: <20191122100919.368561070@linuxfoundation.org>
X-Mailer: git-send-email 2.24.0
In-Reply-To: <20191122100912.732983531@linuxfoundation.org>
References: <20191122100912.732983531@linuxfoundation.org>
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
index 298180bf7e3c1..bfcc68b9f708d 100644
--- a/drivers/acpi/acpica/acevents.h
+++ b/drivers/acpi/acpica/acevents.h
@@ -230,6 +230,8 @@ acpi_ev_default_region_setup(acpi_handle handle,
 
 acpi_status acpi_ev_initialize_region(union acpi_operand_object *region_obj);
 
+u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
+
 /*
  * evsci - SCI (System Control Interrupt) handling/dispatch
  */
diff --git a/drivers/acpi/acpica/aclocal.h b/drivers/acpi/acpica/aclocal.h
index 0f28a38a43ea1..99b0da8991098 100644
--- a/drivers/acpi/acpica/aclocal.h
+++ b/drivers/acpi/acpica/aclocal.h
@@ -395,9 +395,9 @@ struct acpi_simple_repair_info {
 /* Info for running the _REG methods */
 
 struct acpi_reg_walk_info {
-	acpi_adr_space_type space_id;
 	u32 function;
 	u32 reg_run_count;
+	acpi_adr_space_type space_id;
 };
 
 /*****************************************************************************
diff --git a/drivers/acpi/acpica/evregion.c b/drivers/acpi/acpica/evregion.c
index 70c2bd169f669..49decca4e08ff 100644
--- a/drivers/acpi/acpica/evregion.c
+++ b/drivers/acpi/acpica/evregion.c
@@ -653,6 +653,19 @@ acpi_ev_execute_reg_methods(struct acpi_namespace_node *node,
 
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
@@ -714,8 +727,8 @@ acpi_ev_reg_run(acpi_handle obj_handle,
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
index 39284deedd885..17df5dacd43cf 100644
--- a/drivers/acpi/acpica/evrgnini.c
+++ b/drivers/acpi/acpica/evrgnini.c
@@ -16,9 +16,6 @@
 #define _COMPONENT          ACPI_EVENTS
 ACPI_MODULE_NAME("evrgnini")
 
-/* Local prototypes */
-static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
-
 /*******************************************************************************
  *
  * FUNCTION:    acpi_ev_system_memory_region_setup
@@ -33,7 +30,6 @@ static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node);
  * DESCRIPTION: Setup a system_memory operation region
  *
  ******************************************************************************/
-
 acpi_status
 acpi_ev_system_memory_region_setup(acpi_handle handle,
 				   u32 function,
@@ -313,7 +309,7 @@ acpi_ev_pci_config_region_setup(acpi_handle handle,
  *
  ******************************************************************************/
 
-static u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
+u8 acpi_ev_is_pci_root_bridge(struct acpi_namespace_node *node)
 {
 	acpi_status status;
 	struct acpi_pnp_device_id *hid;
diff --git a/drivers/acpi/acpica/evxfregn.c b/drivers/acpi/acpica/evxfregn.c
index 091415b14fbf1..3b3a25d9f0e6d 100644
--- a/drivers/acpi/acpica/evxfregn.c
+++ b/drivers/acpi/acpica/evxfregn.c
@@ -193,7 +193,6 @@ acpi_remove_address_space_handler(acpi_handle device,
 				 */
 				region_obj =
 				    handler_obj->address_space.region_list;
-
 			}
 
 			/* Remove this Handler object from the list */
-- 
2.20.1



