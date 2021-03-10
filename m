Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CADE7333DFE
	for <lists+stable@lfdr.de>; Wed, 10 Mar 2021 14:35:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233262AbhCJNZP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 08:25:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:45716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232587AbhCJNYm (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 08:24:42 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 063A864FE8;
        Wed, 10 Mar 2021 13:24:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1615382679;
        bh=OF6GQTRwQiT5OBr9hZ6oydzM6dYeuu2v1ssyGKBZaSE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Q29kpf5umvBAwf8gNDT7TYp4S1buhnl5PN58+3zQIkdBU3mIi2ybW1UT4/iKCU+2+
         YCZAC8eo3p/R5FEOB035H59coYeA/K2NRFPhJnAxgbaV7y0r8ywd2b+wXZypeVCCXc
         2VqcyORzlS78DUnlXrPdhQgS2OHZEd6l3oV67AgE=
From:   gregkh@linuxfoundation.org
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Andy Shevchenko <andy.shevchenko@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 18/49] platform/x86: acer-wmi: Add ACER_CAP_SET_FUNCTION_MODE capability flag
Date:   Wed, 10 Mar 2021 14:23:29 +0100
Message-Id: <20210310132322.538181658@linuxfoundation.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310132321.948258062@linuxfoundation.org>
References: <20210310132321.948258062@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 82cb8a5c395ea5be20e0fe31a8fe84380a502ca5 ]

Not all devices supporting WMID_GUID3 support the wmid3_set_function_mode()
call, leading to errors like these:

[   60.138358] acer_wmi: Enabling RF Button failed: 0x1 - 0xff
[   60.140036] acer_wmi: Enabling Launch Manager failed: 0x1 - 0xff

Add an ACER_CAP_SET_FUNCTION_MODE capability flag, so that these calls
can be disabled through the new force_caps mechanism.

Reviewed-by: Andy Shevchenko <andy.shevchenko@gmail.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Link: https://lore.kernel.org/r/20201019185628.264473-5-hdegoede@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/acer-wmi.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/platform/x86/acer-wmi.c b/drivers/platform/x86/acer-wmi.c
index 74021163ca23..8662468491a3 100644
--- a/drivers/platform/x86/acer-wmi.c
+++ b/drivers/platform/x86/acer-wmi.c
@@ -211,6 +211,7 @@ struct hotkey_function_type_aa {
 #define ACER_CAP_BLUETOOTH		BIT(2)
 #define ACER_CAP_BRIGHTNESS		BIT(3)
 #define ACER_CAP_THREEG			BIT(4)
+#define ACER_CAP_SET_FUNCTION_MODE	BIT(5)
 
 /*
  * Interface type flags
@@ -2202,10 +2203,14 @@ static int __init acer_wmi_init(void)
 	if (acpi_video_get_backlight_type() != acpi_backlight_vendor)
 		interface->capability &= ~ACER_CAP_BRIGHTNESS;
 
+	if (wmi_has_guid(WMID_GUID3))
+		interface->capability |= ACER_CAP_SET_FUNCTION_MODE;
+
 	if (force_caps != -1)
 		interface->capability = force_caps;
 
-	if (wmi_has_guid(WMID_GUID3)) {
+	if (wmi_has_guid(WMID_GUID3) &&
+	    (interface->capability & ACER_CAP_SET_FUNCTION_MODE)) {
 		if (ACPI_FAILURE(acer_wmi_enable_rf_button()))
 			pr_warn("Cannot enable RF Button Driver\n");
 
-- 
2.30.1



