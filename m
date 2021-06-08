Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E43083A0058
	for <lists+stable@lfdr.de>; Tue,  8 Jun 2021 20:46:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234440AbhFHSmB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Jun 2021 14:42:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:38042 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234703AbhFHSkJ (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 8 Jun 2021 14:40:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5A44D61376;
        Tue,  8 Jun 2021 18:34:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1623177284;
        bh=40UckIG/hTA33cHCVkjJr9xGKhAF0c6vkKl9E1HvmuM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CTdK7ro0CLBCVupcaZB7IHjLT9iXzAfxPGt11eaMnqpg9e3bv3XcZmhXsPHri3QNy
         IVKUkiptqTsqIvoa5O/WkFzI9GTWGYBjYX8BzUY2agOhXJqBI3TjNtMb4k7+XomM18
         8V88AMvWwcg26bA5Up0iXOS7shAyZfgH9VOCFMTE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, step-ali <sunmooon15@gmail.com>,
        Charles Stanhope <charles.stanhope@gmail.com>,
        Paulo Nascimento <paulo.ulusu@googlemail.com>,
        David Purton <dcpurton@marshwiggle.net>,
        Adam Harvey <adam@adamharvey.name>,
        Zhang Rui <rui.zhang@intel.com>,
        Jean-Marc Lenoir <archlinux@jihemel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        =?UTF-8?q?Lauren=C8=9Biu=20P=C4=83ncescu?= <lpancescu@gmail.com>,
        Salvatore Bonaccorso <carnil@debian.org>
Subject: [PATCH 4.19 56/58] ACPI: EC: Look for ECDT EC after calling acpi_load_tables()
Date:   Tue,  8 Jun 2021 20:27:37 +0200
Message-Id: <20210608175934.124213090@linuxfoundation.org>
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

From: Rafael J. Wysocki <rafael.j.wysocki@intel.com>

commit b1c0330823fe842dbb34641f1410f0afa51c29d3 upstream.

Some systems have had functional issues since commit 5a8361f7ecce
(ACPICA: Integrate package handling with module-level code) that,
among other things, changed the initial values of the
acpi_gbl_group_module_level_code and acpi_gbl_parse_table_as_term_list
global flags in ACPICA which implicitly caused acpi_ec_ecdt_probe() to
be called before acpi_load_tables() on the vast majority of platforms.

Namely, before commit 5a8361f7ecce, acpi_load_tables() was called from
acpi_early_init() if acpi_gbl_parse_table_as_term_list was FALSE and
acpi_gbl_group_module_level_code was TRUE, which almost always was
the case as FALSE and TRUE were their initial values, respectively.
The acpi_gbl_parse_table_as_term_list value would be changed to TRUE
for a couple of platforms in acpi_quirks_dmi_table[], but it remained
FALSE in the vast majority of cases.

After commit 5a8361f7ecce, the initial values of the two flags have
been reversed, so in effect acpi_load_tables() has not been called
from acpi_early_init() any more.  That, in turn, affects
acpi_ec_ecdt_probe() which is invoked before acpi_load_tables() now
and it is not possible to evaluate the _REG method for the EC address
space handler installed by it.  That effectively causes the EC address
space to be inaccessible to AML on platforms with an ECDT matching the
EC device definition in the DSDT and functional problems ensue in
there.

Because the default behavior before commit 5a8361f7ecce was to call
acpi_ec_ecdt_probe() after acpi_load_tables(), it should be safe to
do that again.  Moreover, the EC address space handler installed by
acpi_ec_ecdt_probe() is only needed for AML to be able to access the
EC address space and the only AML that can run during acpi_load_tables()
is module-level code which only is allowed to access address spaces
with default handlers (memory, I/O and PCI config space).

For this reason, move the acpi_ec_ecdt_probe() invocation back to
acpi_bus_init(), from where it was taken away by commit d737f333b211
(ACPI: probe ECDT before loading AML tables regardless of module-level
code flag), and put it after the invocation of acpi_load_tables() to
restore the original code ordering from before commit 5a8361f7ecce.

Fixes: 5a8361f7ecce ("ACPICA: Integrate package handling with module-level code")
Link: https://bugzilla.kernel.org/show_bug.cgi?id=199981
Reported-by: step-ali <sunmooon15@gmail.com>
Reported-by: Charles Stanhope <charles.stanhope@gmail.com>
Tested-by: Charles Stanhope <charles.stanhope@gmail.com>
Reported-by: Paulo Nascimento <paulo.ulusu@googlemail.com>
Reported-by: David Purton <dcpurton@marshwiggle.net>
Reported-by: Adam Harvey <adam@adamharvey.name>
Reported-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Zhang Rui <rui.zhang@intel.com>
Tested-by: Jean-Marc Lenoir <archlinux@jihemel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Cc: Laurențiu Păncescu <lpancescu@gmail.com>
Cc: Salvatore Bonaccorso <carnil@debian.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/acpi/bus.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/acpi/bus.c
+++ b/drivers/acpi/bus.c
@@ -1054,18 +1054,6 @@ void __init acpi_early_init(void)
 		goto error0;
 	}
 
-	/*
-	 * ACPI 2.0 requires the EC driver to be loaded and work before
-	 * the EC device is found in the namespace (i.e. before
-	 * acpi_load_tables() is called).
-	 *
-	 * This is accomplished by looking for the ECDT table, and getting
-	 * the EC parameters out of that.
-	 *
-	 * Ignore the result. Not having an ECDT is not fatal.
-	 */
-	status = acpi_ec_ecdt_probe();
-
 #ifdef CONFIG_X86
 	if (!acpi_ioapic) {
 		/* compatible (0) means level (3) */
@@ -1142,6 +1130,18 @@ static int __init acpi_bus_init(void)
 		goto error1;
 	}
 
+	/*
+	 * ACPI 2.0 requires the EC driver to be loaded and work before the EC
+	 * device is found in the namespace.
+	 *
+	 * This is accomplished by looking for the ECDT table and getting the EC
+	 * parameters out of that.
+	 *
+	 * Do that before calling acpi_initialize_objects() which may trigger EC
+	 * address space accesses.
+	 */
+	acpi_ec_ecdt_probe();
+
 	status = acpi_enable_subsystem(ACPI_NO_ACPI_ENABLE);
 	if (ACPI_FAILURE(status)) {
 		printk(KERN_ERR PREFIX


