Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 14FD918B581
	for <lists+stable@lfdr.de>; Thu, 19 Mar 2020 14:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729855AbgCSNTP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 19 Mar 2020 09:19:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:42290 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729851AbgCSNTO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 19 Mar 2020 09:19:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B81FD206D7;
        Thu, 19 Mar 2020 13:19:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584623954;
        bh=iwSf164ZWuYorTV8H+dpSCOMv0N/SJ224TWmg2A97cM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jVYXIuk6oXaCmVnf07QqOCl3W27oUh2GMwJmzA5rgVTBkhL8ha+QWNCAj8WT3q/Cl
         hNcQq0tIsZium+QxRvCUolFydzaDOypGgS7Wjcl3UeRSV0So5Ct0NWO1r3y80qnWec
         pZ/o5iHUV0PrTNZWdkZ7YX109zC+jn3uUwUlZXMo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jean Delvare <jdelvare@suse.de>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 10/48] ACPI: watchdog: Allow disabling WDAT at boot
Date:   Thu, 19 Mar 2020 14:03:52 +0100
Message-Id: <20200319123906.381733092@linuxfoundation.org>
X-Mailer: git-send-email 2.25.2
In-Reply-To: <20200319123902.941451241@linuxfoundation.org>
References: <20200319123902.941451241@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jean Delvare <jdelvare@suse.de>

[ Upstream commit 3f9e12e0df012c4a9a7fd7eb0d3ae69b459d6b2c ]

In case the WDAT interface is broken, give the user an option to
ignore it to let a native driver bind to the watchdog device instead.

Signed-off-by: Jean Delvare <jdelvare@suse.de>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Documentation/admin-guide/kernel-parameters.txt |  4 ++++
 drivers/acpi/acpi_watchdog.c                    | 12 +++++++++++-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/admin-guide/kernel-parameters.txt b/Documentation/admin-guide/kernel-parameters.txt
index 8bf0c0532046f..1a5101b7e853c 100644
--- a/Documentation/admin-guide/kernel-parameters.txt
+++ b/Documentation/admin-guide/kernel-parameters.txt
@@ -136,6 +136,10 @@
 			dynamic table installation which will install SSDT
 			tables to /sys/firmware/acpi/tables/dynamic.
 
+	acpi_no_watchdog	[HW,ACPI,WDT]
+			Ignore the ACPI-based watchdog interface (WDAT) and let
+			a native driver control the watchdog device instead.
+
 	acpi_rsdp=	[ACPI,EFI,KEXEC]
 			Pass the RSDP address to the kernel, mostly used
 			on machines running EFI runtime service to boot the
diff --git a/drivers/acpi/acpi_watchdog.c b/drivers/acpi/acpi_watchdog.c
index 23cde3d8e8fbb..0bd1899a287f3 100644
--- a/drivers/acpi/acpi_watchdog.c
+++ b/drivers/acpi/acpi_watchdog.c
@@ -58,12 +58,14 @@ static bool acpi_watchdog_uses_rtc(const struct acpi_table_wdat *wdat)
 }
 #endif
 
+static bool acpi_no_watchdog;
+
 static const struct acpi_table_wdat *acpi_watchdog_get_wdat(void)
 {
 	const struct acpi_table_wdat *wdat = NULL;
 	acpi_status status;
 
-	if (acpi_disabled)
+	if (acpi_disabled || acpi_no_watchdog)
 		return NULL;
 
 	status = acpi_get_table(ACPI_SIG_WDAT, 0,
@@ -91,6 +93,14 @@ bool acpi_has_watchdog(void)
 }
 EXPORT_SYMBOL_GPL(acpi_has_watchdog);
 
+/* ACPI watchdog can be disabled on boot command line */
+static int __init disable_acpi_watchdog(char *str)
+{
+	acpi_no_watchdog = true;
+	return 1;
+}
+__setup("acpi_no_watchdog", disable_acpi_watchdog);
+
 void __init acpi_watchdog_init(void)
 {
 	const struct acpi_wdat_entry *entries;
-- 
2.20.1



