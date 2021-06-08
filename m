Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE0B23A0053
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235166AbhFHSlu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:38012 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234992AbhFHSkF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3E1361431;
        Tue,  8 Jun 2021 18:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177282;
        bh=ktYLYuoRoAEez/WUzBLMjmNRLkIJzzILQ6ei3vA66fE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eq3zdy1rI1jd4+KDeEGap8Q6EGMO2mCR4r1P95BwPrSPoNzna78J36BykWj4E6gRS
         qhgOrDsK5yoOua0w7K3QEKoBeOiDaNhdsJTy1WGxZWMmwe+BebnQfgLwLPdk23olva
         D6j3RX8AaA0t8zBgtMRgdY1YFiGgE1/6K32MmbFo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Erik Schmauss <erik.schmauss@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?UTF-8?q?Lauren=C8=9Biu=20P=C4=83ncescu?= <lpancescu@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.19 55/58] ACPI: probe ECDT before loading AML tables regardless of module-level code flag
Date:   Tue,  8 Jun 2021 20:27:36 +0200
Message-Id: <20210608175934.090869155@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210608175932.263480586@linuxfoundation.org>
References: <20210608175932.263480586@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Erik Schmauss <erik.schmauss@intel.com>

commit d737f333b211361b6e239fc753b84c3be2634aaa upstream.

It was discovered that AML tables were loaded before or after the
ECDT depending on acpi_gbl_execute_tables_as_methods. According to
the ACPI spec, the ECDT should be loaded before the namespace is
populated by loading AML tables (DSDT and SSDT). Since the ECDT
should be loaded early in the boot process, this change moves the
ECDT probing to acpi_early_init.

Signed-off-by: Erik Schmauss <erik.schmauss@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Laurențiu Păncescu <lpancescu@gmail.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/bus.c |   44 ++++++++++++++++----------------------------
 1 file changed, 16 insertions(+), 28 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1054,15 +1054,17 @@ void __init acpi_early_init(void)
 		goto error0;
 	}
 
-	if (!acpi_gbl_execute_tables_as_methods &&
-	    acpi_gbl_group_module_level_code) {
-		status = acpi_load_tables();
-		if (ACPI_FAILURE(status)) {
-			printk(KERN_ERR PREFIX
-			       "Unable to load the System Description Tables\n");
-			goto error0;
-		}
-	}
+	/*
+	 * ACPI 2.0 requires the EC driver to be loaded and work before
+	 * the EC device is found in the namespace (i.e. before
+	 * acpi_load_tables() is called).
+	 *
+	 * This is accomplished by looking for the ECDT table, and getting
+	 * the EC parameters out of that.
+	 *
+	 * Ignore the result. Not having an ECDT is not fatal.
+	 */
+	status = acpi_ec_ecdt_probe();
 
 #ifdef CONFIG_X86
 	if (!acpi_ioapic) {
@@ -1133,25 +1135,11 @@ static int __init acpi_bus_init(void)
 
 	acpi_os_initialize1();
 
-	/*
-	 * ACPI 2.0 requires the EC driver to be loaded and work before
-	 * the EC device is found in the namespace (i.e. before
-	 * acpi_load_tables() is called).
-	 *
-	 * This is accomplished by looking for the ECDT table, and getting
-	 * the EC parameters out of that.
-	 */
-	status = acpi_ec_ecdt_probe();
-	/* Ignore result. Not having an ECDT is not fatal. */
-
-	if (acpi_gbl_execute_tables_as_methods ||
-	    !acpi_gbl_group_module_level_code) {
-		status = acpi_load_tables();
-		if (ACPI_FAILURE(status)) {
-			printk(KERN_ERR PREFIX
-			       "Unable to load the System Description Tables\n");
-			goto error1;
-		}
+	status = acpi_load_tables();
+	if (ACPI_FAILURE(status)) {
+		printk(KERN_ERR PREFIX
+		       "Unable to load the System Description Tables\n");
+		goto error1;
 	}
 
 	status = acpi_enable_subsystem(ACPI_NO_ACPI_ENABLE);


