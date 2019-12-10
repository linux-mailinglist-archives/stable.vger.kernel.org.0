Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A38841198B4
	for <lists+stable@lfdr.de>; Tue, 10 Dec 2019 22:45:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729926AbfLJVeF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 10 Dec 2019 16:34:05 -0500
Received: from mail.kernel.org ([198.145.29.99]:38766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729908AbfLJVeC (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 10 Dec 2019 16:34:02 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DFF59214AF;
        Tue, 10 Dec 2019 21:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576013641;
        bh=3890q/UFuIjArfkRPaMmNRfZ1FgV2b4RJ8Fxxgr9zS8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ZJyFoc0H4CKMQV9YPpwDNcuBCzq1KwsKzx4ymGa+BKfnxdvh641VbC8X0wLGVi4j0
         qXVSRJxYT8vT//wsNHE4LmQk1RWR6eNelAAl5brQa++TfA3P5EFwVIMl/WeEkEtRAt
         dWdw+FEr7dTPhLRfxEbtbra+kbRYw9pgNWivIQUg=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 081/177] ACPI: button: Add DMI quirk for Medion Akoya E2215T
Date:   Tue, 10 Dec 2019 16:30:45 -0500
Message-Id: <20191210213221.11921-81-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191210213221.11921-1-sashal@kernel.org>
References: <20191210213221.11921-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 932e1ba486117de2fcea3df27ad8218ad6c11470 ]

The Medion Akoya E2215T's ACPI _LID implementation is quite broken:

 1. For notifications it uses an ActiveLow Edge GpioInt, rather then
    an ActiveBoth one, meaning that the device is only notified when the
    lid is closed, not when it is opened.

2. Matching with this its _LID method simply always returns 0 (closed)

  In order for the Linux LID code to work properly with this implementation,
  the lid_init_state selection needs to be set to ACPI_BUTTON_LID_INIT_OPEN.

This commit adds a DMI quirk for this.

Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index a19ff3977ac4a..870eb5c7516a5 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -91,6 +91,17 @@ static const struct dmi_system_id lid_blacklst[] = {
 			DMI_MATCH(DMI_BIOS_VERSION, "BYT70A.YNCHENG.WIN.007"),
 		},
 	},
+	{
+		/*
+		 * Medion Akoya E2215T, notification of the LID device only
+		 * happens on close, not on open and _LID always returns closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E2215T MD60198"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
 	{}
 };
 
-- 
2.20.1

