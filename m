Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2CFC370CEC
	for <lists+stable@lfdr.de>; Sun,  2 May 2021 16:10:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232682AbhEBOH7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 2 May 2021 10:07:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:51294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232374AbhEBOHM (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 2 May 2021 10:07:12 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D0A5F613C4;
        Sun,  2 May 2021 14:06:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619964361;
        bh=vvbbqBiNXJSta4bu/zxbbbE7y5vPOvkX+r2onTimAqo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Mj/KEDOgoRbPanXlVj48+AEyBYOoR7HKyKOeDqUGrp2PrSq36zONqjctojW26aoxu
         pGy1xzKF5g1CY8U7sJ65RAz7aRM0l6yMWKiu4kMnqoRqyHKWrfRt42u95YaX206oQz
         CufvN6Lb1BVe3qLvVcFJet3J2xKYO6wEhTrsRtb7Ir+qU9ub+dfpL6RqpBX3qBQkSm
         c3rEGq5pDxQKsyGn7Bmt8w9RsE/b8soqZIDEmAv/lIE40pJnRb94HgT+wNQQJ3Un9a
         /BHADOSNvLfjLY1NHEvvuKfJjnOqjtCPbfa7uK1ggYQmc4fjmt2n6Dh9H4KS/PYt82
         HOq59m10JvyBQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Sasha Levin <sashal@kernel.org>,
        ibm-acpi-devel@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org
Subject: [PATCH AUTOSEL 4.14 13/16] platform/x86: thinkpad_acpi: Correct thermal sensor allocation
Date:   Sun,  2 May 2021 10:05:41 -0400
Message-Id: <20210502140544.2720138-13-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210502140544.2720138-1-sashal@kernel.org>
References: <20210502140544.2720138-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

[ Upstream commit 6759e18e5cd8745a5dfc5726e4a3db5281ec1639 ]

On recent Thinkpad platforms it was reported that temp sensor 11 was
always incorrectly displaying 66C. It turns out the reason for this is
that this location in EC RAM is not a temperature sensor but is the
power supply ID (offset 0xC2).

Based on feedback from the Lenovo firmware team the EC RAM version can
be determined and for the current version (3) only the 0x78 to 0x7F
range is used for temp sensors. I don't have any details for earlier
versions so I have left the implementation unaltered there.

Note - in this block only 0x78 and 0x79 are officially designated (CPU &
GPU sensors). The use of the other locations in the block will vary from
platform to platform; but the existing logic to detect a sensor presence
holds.

Signed-off-by: Mark Pearson <markpearson@lenovo.com>
Link: https://lore.kernel.org/r/20210407212015.298222-1-markpearson@lenovo.com
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/thinkpad_acpi.c | 31 ++++++++++++++++++++--------
 1 file changed, 22 insertions(+), 9 deletions(-)

diff --git a/drivers/platform/x86/thinkpad_acpi.c b/drivers/platform/x86/thinkpad_acpi.c
index 30bfd51c0e58..30bc952ea552 100644
--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6162,6 +6162,7 @@ enum thermal_access_mode {
 enum { /* TPACPI_THERMAL_TPEC_* */
 	TP_EC_THERMAL_TMP0 = 0x78,	/* ACPI EC regs TMP 0..7 */
 	TP_EC_THERMAL_TMP8 = 0xC0,	/* ACPI EC regs TMP 8..15 */
+	TP_EC_FUNCREV      = 0xEF,      /* ACPI EC Functional revision */
 	TP_EC_THERMAL_TMP_NA = -128,	/* ACPI EC sensor not available */
 
 	TPACPI_THERMAL_SENSOR_NA = -128000, /* Sensor not available */
@@ -6360,7 +6361,7 @@ static const struct attribute_group thermal_temp_input8_group = {
 
 static int __init thermal_init(struct ibm_init_struct *iibm)
 {
-	u8 t, ta1, ta2;
+	u8 t, ta1, ta2, ver = 0;
 	int i;
 	int acpi_tmp7;
 	int res;
@@ -6375,7 +6376,14 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 		 * 0x78-0x7F, 0xC0-0xC7.  Registers return 0x00 for
 		 * non-implemented, thermal sensors return 0x80 when
 		 * not available
+		 * The above rule is unfortunately flawed. This has been seen with
+		 * 0xC2 (power supply ID) causing thermal control problems.
+		 * The EC version can be determined by offset 0xEF and at least for
+		 * version 3 the Lenovo firmware team confirmed that registers 0xC0-0xC7
+		 * are not thermal registers.
 		 */
+		if (!acpi_ec_read(TP_EC_FUNCREV, &ver))
+			pr_warn("Thinkpad ACPI EC unable to access EC version\n");
 
 		ta1 = ta2 = 0;
 		for (i = 0; i < 8; i++) {
@@ -6385,11 +6393,13 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 				ta1 = 0;
 				break;
 			}
-			if (acpi_ec_read(TP_EC_THERMAL_TMP8 + i, &t)) {
-				ta2 |= t;
-			} else {
-				ta1 = 0;
-				break;
+			if (ver < 3) {
+				if (acpi_ec_read(TP_EC_THERMAL_TMP8 + i, &t)) {
+					ta2 |= t;
+				} else {
+					ta1 = 0;
+					break;
+				}
 			}
 		}
 		if (ta1 == 0) {
@@ -6402,9 +6412,12 @@ static int __init thermal_init(struct ibm_init_struct *iibm)
 				thermal_read_mode = TPACPI_THERMAL_NONE;
 			}
 		} else {
-			thermal_read_mode =
-			    (ta2 != 0) ?
-			    TPACPI_THERMAL_TPEC_16 : TPACPI_THERMAL_TPEC_8;
+			if (ver >= 3)
+				thermal_read_mode = TPACPI_THERMAL_TPEC_8;
+			else
+				thermal_read_mode =
+					(ta2 != 0) ?
+					TPACPI_THERMAL_TPEC_16 : TPACPI_THERMAL_TPEC_8;
 		}
 	} else if (acpi_tmp7) {
 		if (tpacpi_is_ibm() &&
-- 
2.30.2

