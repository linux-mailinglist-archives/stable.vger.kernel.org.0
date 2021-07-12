Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E1A843C5604
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351131AbhGLINF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 04:13:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:35762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhGLIK0 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 04:10:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BDD82613E5;
        Mon, 12 Jul 2021 08:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626077253;
        bh=rHMgeEThFU7Asacvj0hdBeeV4VGoqioVnetuaFcfwyo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wrt4zUZrzbZmqmtAAHsr65nn3FG3Czj0eH8O798oKWCscfSgmD9bF6oC6NAPIDARc
         RNcAd0JvjrCW4iq0OxHERcFGjYlGmR0/3Eue53700gG660Z4xu2p2Sx+oWSP/qbhOo
         /HPHe/5njq5NRYf60wGw+SInbtUoYPHzMg8laT2Q=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Zhang Rui <rui.zhang@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, Chen <leo881003@gmail.com>
Subject: [PATCH 5.13 250/800] ACPI: EC: trust DSDT GPE for certain HP laptop
Date:   Mon, 12 Jul 2021 08:04:33 +0200
Message-Id: <20210712060948.999333757@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060912.995381202@linuxfoundation.org>
References: <20210712060912.995381202@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit 4370cbf350dbaca984dbda9f9ce3fac45d6949d5 ]

On HP Pavilion Gaming Laptop 15-cx0xxx, the ECDT EC and DSDT EC share
the same port addresses but different GPEs. And the DSDT GPE is the
right one to use.

The current code duplicates DSDT EC with ECDT EC if the port addresses
are the same, and uses ECDT GPE as a result, which breaks this machine.

Introduce a new quirk for the HP laptop to trust the DSDT GPE,
and avoid duplicating even if the port addresses are the same.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=209989
Reported-and-tested-by: Shao Fu, Chen <leo881003@gmail.com>
Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/ec.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/ec.c b/drivers/acpi/ec.c
index e8c5da2b964a..87c3b4a099b9 100644
--- a/drivers/acpi/ec.c
+++ b/drivers/acpi/ec.c
@@ -183,6 +183,7 @@ static struct workqueue_struct *ec_query_wq;
 
 static int EC_FLAGS_CORRECT_ECDT; /* Needs ECDT port address correction */
 static int EC_FLAGS_IGNORE_DSDT_GPE; /* Needs ECDT GPE as correction setting */
+static int EC_FLAGS_TRUST_DSDT_GPE; /* Needs DSDT GPE as correction setting */
 static int EC_FLAGS_CLEAR_ON_RESUME; /* Needs acpi_ec_clear() on boot/resume */
 
 /* --------------------------------------------------------------------------
@@ -1593,7 +1594,8 @@ static int acpi_ec_add(struct acpi_device *device)
 		}
 
 		if (boot_ec && ec->command_addr == boot_ec->command_addr &&
-		    ec->data_addr == boot_ec->data_addr) {
+		    ec->data_addr == boot_ec->data_addr &&
+		    !EC_FLAGS_TRUST_DSDT_GPE) {
 			/*
 			 * Trust PNP0C09 namespace location rather than
 			 * ECDT ID. But trust ECDT GPE rather than _GPE
@@ -1816,6 +1818,18 @@ static int ec_correct_ecdt(const struct dmi_system_id *id)
 	return 0;
 }
 
+/*
+ * Some ECDTs contain wrong GPE setting, but they share the same port addresses
+ * with DSDT EC, don't duplicate the DSDT EC with ECDT EC in this case.
+ * https://bugzilla.kernel.org/show_bug.cgi?id=209989
+ */
+static int ec_honor_dsdt_gpe(const struct dmi_system_id *id)
+{
+	pr_debug("Detected system needing DSDT GPE setting.\n");
+	EC_FLAGS_TRUST_DSDT_GPE = 1;
+	return 0;
+}
+
 /*
  * Some DSDTs contain wrong GPE setting.
  * Asus FX502VD/VE, GL702VMK, X550VXK, X580VD
@@ -1870,6 +1884,11 @@ static const struct dmi_system_id ec_dmi_table[] __initconst = {
 	DMI_MATCH(DMI_SYS_VENDOR, "ASUSTeK COMPUTER INC."),
 	DMI_MATCH(DMI_PRODUCT_NAME, "X580VD"),}, NULL},
 	{
+	/* https://bugzilla.kernel.org/show_bug.cgi?id=209989 */
+	ec_honor_dsdt_gpe, "HP Pavilion Gaming Laptop 15-cx0xxx", {
+	DMI_MATCH(DMI_SYS_VENDOR, "HP"),
+	DMI_MATCH(DMI_PRODUCT_NAME, "HP Pavilion Gaming Laptop 15-cx0xxx"),}, NULL},
+	{
 	ec_clear_on_resume, "Samsung hardware", {
 	DMI_MATCH(DMI_SYS_VENDOR, "SAMSUNG ELECTRONICS CO., LTD.")}, NULL},
 	{},
-- 
2.30.2



