Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B6CB62D5057
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 02:26:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732545AbgLJB0v (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 9 Dec 2020 20:26:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44514 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729003AbgLJB0u (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 9 Dec 2020 20:26:50 -0500
Received: from [123.114.42.209] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1knAie-0003jt-AR; Thu, 10 Dec 2020 01:26:09 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
Cc:     lenb@kernel.org, stable@vger.kernel.org
Subject: [PATCH v2] ACPI / PNP: check the string length of pnp device id in matching_id
Date:   Thu, 10 Dec 2020 09:25:39 +0800
Message-Id: <20201210012539.5747-1-hui.wang@canonical.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Recently we met a touchscreen problem on some Thinkpad machines, the
touchscreen driver (i2c-hid) is not loaded and the touchscreen can't
work.

An i2c ACPI device with the name WACF2200 is defined in the BIOS, with
the current ACPI PNP matching rule, this device will be regarded as
a PNP device since there is WACFXXX in the acpi_pnp_device_ids[] and
this PNP device is attached to the acpi device as the 1st
physical_node, this will make the i2c bus match fail when i2c bus
calls acpi_companion_match() to match the acpi_id_table in the i2c-hid
driver.

An ACPI PNP device's id has fixed format and its string length equals
7, after adding this check in the matching_id, the touchscreen could
work.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/acpi/acpi_pnp.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 4ed755a963aa..5ce711b9b070 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -319,6 +319,10 @@ static bool matching_id(const char *idstr, const char *list_id)
 {
 	int i;
 
+	/* a pnp device id has CCCdddd format (C character, d digit), strlen should be 7 */
+	if (strlen(idstr) != 7)
+		return false;
+
 	if (memcmp(idstr, list_id, 3))
 		return false;
 
-- 
2.25.1

