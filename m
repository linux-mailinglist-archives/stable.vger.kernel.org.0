Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F5744523EE
	for <lists+stable@lfdr.de>; Tue, 16 Nov 2021 02:32:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243177AbhKPBfa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 15 Nov 2021 20:35:30 -0500
Received: from mail.kernel.org ([198.145.29.99]:42476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242070AbhKOSdQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 15 Nov 2021 13:33:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id BCBEF63463;
        Mon, 15 Nov 2021 18:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1636999214;
        bh=1LAbinY4XrJhR0cGZxRyou3TsQQ45yvGzggk2EyJ6nI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XKJL8vcl0UKB11hJnA1yYju52AKjootioTnj+OabmIArnc1S3RCqEUfDKTLRq7BY3
         x6F7PnPaoeiHYKVXlfuis4bXxH1gerWo+wnHWPD6ZVZZf9GOCgmSwpvvwaA/x4L/HO
         GvlB6As7dxMi7AHR5da2usVyFzQZ02j1bqQ8xMqQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Manuel Krause <manuelkrause@netscape.net>,
        Hui Wang <hui.wang@canonical.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 218/849] ACPI: resources: Add DMI-based legacy IRQ override quirk
Date:   Mon, 15 Nov 2021 17:55:01 +0100
Message-Id: <20211115165427.594054107@linuxfoundation.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <20211115165419.961798833@linuxfoundation.org>
References: <20211115165419.961798833@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



