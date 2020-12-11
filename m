Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E82112D6DFA
	for <lists+stable@lfdr.de>; Fri, 11 Dec 2020 03:09:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389080AbgLKCH4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 21:07:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58388 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388867AbgLKCHy (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 10 Dec 2020 21:07:54 -0500
Received: from [123.114.42.209] (helo=localhost.localdomain)
        by youngberry.canonical.com with esmtpsa (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.86_2)
        (envelope-from <hui.wang@canonical.com>)
        id 1knXpv-0000lm-Hd; Fri, 11 Dec 2020 02:07:12 +0000
From:   Hui Wang <hui.wang@canonical.com>
To:     linux-acpi@vger.kernel.org, rafael.j.wysocki@intel.com
Cc:     lenb@kernel.org, stable@vger.kernel.org
Subject: [PATCH v3] ACPI / PNP: compare the string length in the matching_id
Date:   Fri, 11 Dec 2020 10:07:02 +0800
Message-Id: <20201211020702.35576-1-hui.wang@canonical.com>
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
the current rule in matching_id(), this device will be regarded as
a PNP device since there is WACFXXX in the acpi_pnp_device_ids[] and
this PNP device is attached to the acpi device as the 1st
physical_node, this will make the i2c bus match fail when i2c bus
calls acpi_companion_match() to match the acpi_id_table in the i2c-hid
driver.

WACF2200 is an i2c device instead of a PNP device, after adding the
string length comparing, the matching_id() will return false when
matching WACF2200 and WACFXXX, and it is reasonable to compare the
string lenth when matching two ids.

Cc: stable@vger.kernel.org
Signed-off-by: Hui Wang <hui.wang@canonical.com>
---
 drivers/acpi/acpi_pnp.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/acpi/acpi_pnp.c b/drivers/acpi/acpi_pnp.c
index 4ed755a963aa..8f2dc176bb41 100644
--- a/drivers/acpi/acpi_pnp.c
+++ b/drivers/acpi/acpi_pnp.c
@@ -319,6 +319,9 @@ static bool matching_id(const char *idstr, const char *list_id)
 {
 	int i;
 
+	if (strlen(idstr) != strlen(list_id))
+		return false;
+
 	if (memcmp(idstr, list_id, 3))
 		return false;
 
-- 
2.25.1

