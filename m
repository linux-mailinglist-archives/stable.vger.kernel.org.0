Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F212B5FB5
	for <lists+stable@lfdr.de>; Tue, 17 Nov 2020 14:00:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727188AbgKQM5x (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 17 Nov 2020 07:57:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:54976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728747AbgKQM5v (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 17 Nov 2020 07:57:51 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 856512467A;
        Tue, 17 Nov 2020 12:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605617870;
        bh=YPGXcz0KA9IeQcBH7kA4FbLI+Tgioj/jCy3QwAFE7Xc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJF6IAwM3F8vlXzBKSKrYhDzhhEs0LK+KnYjE4FbPjhmE4Vo0zL2ZOuEUW7FnDBbO
         eTOKFEKv5v67ttZQ3GBf2oqaoEVKUfhvuNxRprpXrTz6GpDeoakW0qAU9Lx+MQTPIg
         y/9HE5LP7y3xEm30yeeZE++sQTjNR3ex8ySX78p0=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>, linux-acpi@vger.kernel.org
Subject: [PATCH AUTOSEL 4.19 4/6] ACPI: button: Add DMI quirk for Medion Akoya E2228T
Date:   Tue, 17 Nov 2020 07:57:41 -0500
Message-Id: <20201117125743.599974-4-sashal@kernel.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20201117125743.599974-1-sashal@kernel.org>
References: <20201117125743.599974-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 7daaa06357bf7f1874b62bb1ea9d66a51d4e567e ]

The Medion Akoya E2228T's ACPI _LID implementation is quite broken,
it has the same issues as the one from the Medion Akoya E2215T:

1. For notifications it uses an ActiveLow Edge GpioInt, rather then
   an ActiveBoth one, meaning that the device is only notified when the
   lid is closed, not when it is opened.

2. Matching with this its _LID method simply always returns 0 (closed)

In order for the Linux LID code to work properly with this implementation,
the lid_init_state selection needs to be set to ACPI_BUTTON_LID_INIT_OPEN,
add a DMI quirk for this.

While working on this I also found out that the MD60### part of the model
number differs per country/batch while all of the E2215T and E2228T models
have this issue, so also remove the " MD60198" part from the E2215T quirk.

Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/acpi/button.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/acpi/button.c b/drivers/acpi/button.c
index f43f5adc21b61..abf101451c929 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -98,7 +98,18 @@ static const struct dmi_system_id lid_blacklst[] = {
 		 */
 		.matches = {
 			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
-			DMI_MATCH(DMI_PRODUCT_NAME, "E2215T MD60198"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E2215T"),
+		},
+		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
+	},
+	{
+		/*
+		 * Medion Akoya E2228T, notification of the LID device only
+		 * happens on close, not on open and _LID always returns closed.
+		 */
+		.matches = {
+			DMI_MATCH(DMI_SYS_VENDOR, "MEDION"),
+			DMI_MATCH(DMI_PRODUCT_NAME, "E2228T"),
 		},
 		.driver_data = (void *)(long)ACPI_BUTTON_LID_INIT_OPEN,
 	},
-- 
2.27.0

