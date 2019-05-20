Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 107B323679
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:46:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389214AbfETM0A (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:26:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:41264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388503AbfETMZ5 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 20 May 2019 08:25:57 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3089F21479;
        Mon, 20 May 2019 12:25:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558355156;
        bh=kYit0N1s3XyiwEJ9BAPv+JHUmMpjAlox7xrrRbfxqOI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XrHHa80+GiUQX7Fwhho+e87iqtHiwjmCW9vG6GKwzmrda061wLFNkFUNd6ZAWahXI
         MtKwNwevoDaUMR966OztgqozBNB4PetJFtI9ik4Rh/2g+bTf9jLELdpNTvY7evx9k7
         b6FvRpT1s6n7jgKSSv+LOwmGrC7rAkj45f954vmU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.0 013/123] power: supply: axp288_fuel_gauge: Add ACEPC T8 and T11 mini PCs to the blacklist
Date:   Mon, 20 May 2019 14:13:13 +0200
Message-Id: <20190520115245.968557214@linuxfoundation.org>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190520115245.439864225@linuxfoundation.org>
References: <20190520115245.439864225@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

commit 9274c78305e12c5f461bec15f49c38e0f32ca705 upstream.

The ACEPC T8 and T11 Cherry Trail Z8350 mini PCs use an AXP288 and as PCs,
rather then portables, they does not have a battery. Still for some
reason the AXP288 not only thinks there is a battery, it actually
thinks it is discharging while the PC is running, slowly going to
0% full, causing userspace to shutdown the system due to the battery
being critically low after a while.

This commit adds the ACEPC T8 and T11 to the axp288 fuel-gauge driver
blacklist, so that we stop reporting bogus battery readings on this device.

BugLink: https://bugzilla.redhat.com/show_bug.cgi?id=1690852
Cc: stable@vger.kernel.org
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/power/supply/axp288_fuel_gauge.c |   20 ++++++++++++++++++++
 1 file changed, 20 insertions(+)

--- a/drivers/power/supply/axp288_fuel_gauge.c
+++ b/drivers/power/supply/axp288_fuel_gauge.c
@@ -696,6 +696,26 @@ intr_failed:
  */
 static const struct dmi_system_id axp288_fuel_gauge_blacklist[] = {
 	{
+		/* ACEPC T8 Cherry Trail Z8350 mini PC */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "To be filled by O.E.M."),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "T8"),
+			/* also match on somewhat unique bios-version */
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
+		},
+	},
+	{
+		/* ACEPC T11 Cherry Trail Z8350 mini PC */
+		.matches = {
+			DMI_EXACT_MATCH(DMI_BOARD_VENDOR, "To be filled by O.E.M."),
+			DMI_EXACT_MATCH(DMI_BOARD_NAME, "Cherry Trail CR"),
+			DMI_EXACT_MATCH(DMI_PRODUCT_SKU, "T11"),
+			/* also match on somewhat unique bios-version */
+			DMI_EXACT_MATCH(DMI_BIOS_VERSION, "1.000"),
+		},
+	},
+	{
 		/* Intel Cherry Trail Compute Stick, Windows version */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "Intel Corporation"),


