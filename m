Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 47F5012C5BD
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 18:42:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729185AbfL2Rkj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:40:39 -0500
Received: from mail.kernel.org ([198.145.29.99]:58762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729162AbfL2Rb1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:31:27 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A49D5222C4;
        Sun, 29 Dec 2019 17:31:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577640687;
        bh=JL/ghQOl4XYT1DM+fszLCvjX29XWG3MhLGbwTOZyPEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=LfMN4MarONVT/7SrqF8bpiBK51YTSMG9a1deFkFNzZMSv5Sv8G3p0qNsXzGzYSOcC
         k/MciqQDQs9OASIWc1Dzlu4f2YH8OCPEujq7PRGdWARQujnZkseVVZcDJ7B9W/j99l
         bkwAMDp20CERXQQ5De8jFHzvTFLq12oAe+kG46rE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 098/219] ACPI: button: Add DMI quirk for Medion Akoya E2215T
Date:   Sun, 29 Dec 2019 18:18:20 +0100
Message-Id: <20191229162522.801968948@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229162508.458551679@linuxfoundation.org>
References: <20191229162508.458551679@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index a19ff3977ac4..870eb5c7516a 100644
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



