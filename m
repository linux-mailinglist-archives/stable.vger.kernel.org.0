Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BC0144A0FE
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 02:04:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239616AbhKIBGu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 8 Nov 2021 20:06:50 -0500
Received: from mail.kernel.org ([198.145.29.99]:59938 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239118AbhKIBEw (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 8 Nov 2021 20:04:52 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 275C5619F6;
        Tue,  9 Nov 2021 01:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636419716;
        bh=1LAbinY4XrJhR0cGZxRyou3TsQQ45yvGzggk2EyJ6nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=aJp+qh5Bnbgm0tKA/BSu4YkfCT11pRoxwx+0PZpYDBzvjPcovQfO6vDSOLjpsegp6
         FmCUCAjVDJSh8qkYrvZrGBd5orObvzXHuQ11DY93TUPNHeVS+7exr1ewi4yk8cnOoC
         GcwYK4I4JLUEMR2IXVZU9ir8FCNw15uCPjluMN5vqF3nBrHBcCbFs0aXr5pW/U1UkI
         zmna6IkBbAbJB/1qLeHf6ecq6bkY6M/X3GVY4k+hgovV2dXFuuIbCv57o9GiElLF00
         vts8HDuAGnxI0q3UuV0C1aR9EwtN9seurnMN/L1gxJ5QGiCdp3GqHyrMONhLWDepqa
         CWxMuKEOWl5oQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hui Wang <hui.wang@canonical.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Manuel Krause <manuelkrause@netscape.net>,
        Sasha Levin <sashal@kernel.org>, rafael@kernel.org,
        linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 5.14 014/138] ACPI: resources: Add DMI-based legacy IRQ override quirk
Date:   Mon,  8 Nov 2021 12:44:40 -0500
Message-Id: <20211108174644.1187889-14-sashal@kernel.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211108174644.1187889-1-sashal@kernel.org>
References: <20211108174644.1187889-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hui Wang <hui.wang@canonical.com>

[ Upstream commit 892a012699fc0b91a2ed6309078936191447f480 ]

After the commit 0ec4e55e9f57 ("ACPI: resources: Add checks for ACPI
IRQ override") is reverted, the keyboard on Medion laptops can't
work again.

To fix the keyboard issue, add a DMI-based override check that will
not affect other machines along the lines of prt_quirks[] in
drivers/acpi/pci_irq.c.

If similar issues are seen on other platforms, the quirk table could
be expanded in the future.

BugLink: https://bugzilla.kernel.org/show_bug.cgi?id=213031
BugLink: http://bugs.launchpad.net/bugs/1909814
Suggested-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Reported-by: Manuel Krause <manuelkrause@netscape.net>
Tested-by: Manuel Krause <manuelkrause@netscape.net>
Signed-off-by: Hui Wang <hui.wang@canonical.com>
[ rjw: Subject and changelog edits ]
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/resource.c | 49 +++++++++++++++++++++++++++++++++++++++--
 1 file changed, 47 insertions(+), 2 deletions(-)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index ee78a210c6068..7bf38652e6aca 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -16,6 +16,7 @@
 #include <linux/ioport.h>
 #include <linux/slab.h>
 #include <linux/irq.h>
+#include <linux/dmi.h>
 
 #ifdef CONFIG_X86
 #define valid_IRQ(i) (((i) != 0) && ((i) != 2))
@@ -380,9 +381,51 @@ unsigned int acpi_dev_get_irq_type(int triggering, int polarity)
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_irq_type);
 
+static const struct dmi_system_id medion_laptop[] = {
+	{
+		.ident = "MEDION P15651",
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_BOARD_NAME, "M15T"),
+		},
+	},
+	{ }
+};
+
+struct irq_override_cmp {
+	const struct dmi_system_id *system;
+	unsigned char irq;
+	unsigned char triggering;
+	unsigned char polarity;
+	unsigned char shareable;
+};
+
+static const struct irq_override_cmp skip_override_table[] = {
+	{ medion_laptop, 1, ACPI_LEVEL_SENSITIVE, ACPI_ACTIVE_LOW, 0 },
+};
+
+static bool acpi_dev_irq_override(u32 gsi, u8 triggering, u8 polarity,
+				  u8 shareable)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(skip_override_table); i++) {
+		const struct irq_override_cmp *entry = &skip_override_table[i];
+
+		if (dmi_check_system(entry->system) &&
+		    entry->irq == gsi &&
+		    entry->triggering == triggering &&
+		    entry->polarity == polarity &&
+		    entry->shareable == shareable)
+			return false;
+	}
+
+	return true;
+}
+
 static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
 				     u8 triggering, u8 polarity, u8 shareable,
-				     bool legacy)
+				     bool check_override)
 {
 	int irq, p, t;
 
@@ -401,7 +444,9 @@ static void acpi_dev_get_irqresource(struct resource *res, u32 gsi,
 	 * using extended IRQ descriptors we take the IRQ configuration
 	 * from _CRS directly.
 	 */
-	if (legacy && !acpi_get_override_irq(gsi, &t, &p)) {
+	if (check_override &&
+	    acpi_dev_irq_override(gsi, triggering, polarity, shareable) &&
+	    !acpi_get_override_irq(gsi, &t, &p)) {
 		u8 trig = t ? ACPI_LEVEL_SENSITIVE : ACPI_EDGE_SENSITIVE;
 		u8 pol = p ? ACPI_ACTIVE_LOW : ACPI_ACTIVE_HIGH;
 
-- 
2.33.0

