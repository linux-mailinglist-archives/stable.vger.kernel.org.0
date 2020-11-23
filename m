Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA70E2C0B03
	for <lists+stable@lfdr.de>; Mon, 23 Nov 2020 14:55:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731511AbgKWMfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 23 Nov 2020 07:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:47166 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731490AbgKWMfM (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 23 Nov 2020 07:35:12 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E567B20721;
        Mon, 23 Nov 2020 12:35:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1606134911;
        bh=ThyePWmfWXh0B2ZGeYNJ1P9kd2DwgM5TA8mdBLBk+xQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h+bNgzxEh360zQbAcdj+WOHhruur+eQ7M7FSkXTCpBgdTsLv18cBsZrj2aQ1FP268
         iOqZNMPBrx+27qBVAzKwcHfJ+LFaZCte4r8jyfWhiPtyZmbV+ODlI3fcnpqYaiFd3J
         gTeu+205FhgnZI86oxAsQIntccoudyqVAwJAk/7k=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 037/158] ACPI: button: Add DMI quirk for Medion Akoya E2228T
Date:   Mon, 23 Nov 2020 13:21:05 +0100
Message-Id: <20201123121821.728118932@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201123121819.943135899@linuxfoundation.org>
References: <20201123121819.943135899@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 690bfe67e643d..ee7a7da276ddf 100644
--- a/drivers/acpi/button.c
+++ b/drivers/acpi/button.c
@@ -85,7 +85,18 @@ static const struct dmi_system_id lid_blacklst[] = {
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



