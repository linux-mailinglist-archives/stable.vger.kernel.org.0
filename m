Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 368D63739E0
	for <lists+stable@lfdr.de>; Wed,  5 May 2021 14:05:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233202AbhEEMGH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 5 May 2021 08:06:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:43442 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232147AbhEEMF7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 5 May 2021 08:05:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id BC5B2613BA;
        Wed,  5 May 2021 12:05:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620216302;
        bh=uZgXQwgvXVFwWOdUdcXQ7x3oGi5AFaREVkONHDEeoEo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tmDrUPZL1RIWRSHi9/PzvdNYGJd33upc8zWE2bZoqbgBZiHMfFQqQne217/oCVlY7
         sudMFoBDSBVxgWedzdtWmfYHwJU4EePTGGhT4yP289O5Xj6jwaxNH2MxVkj7w+atEv
         h0/NFhqH8hHL+zVUW6dYHuu1zJ0/suQCWObgNbw8=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Mark Pearson <markpearson@lenovo.com>,
        Hans de Goede <hdegoede@redhat.com>
Subject: [PATCH 5.4 18/21] platform/x86: thinkpad_acpi: Correct thermal sensor allocation
Date:   Wed,  5 May 2021 14:04:32 +0200
Message-Id: <20210505112325.327212141@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210505112324.729798712@linuxfoundation.org>
References: <20210505112324.729798712@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Pearson <markpearson@lenovo.com>

commit 6759e18e5cd8745a5dfc5726e4a3db5281ec1639 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/platform/x86/thinkpad_acpi.c |   31 ++++++++++++++++++++++---------
 1 file changed, 22 insertions(+), 9 deletions(-)

--- a/drivers/platform/x86/thinkpad_acpi.c
+++ b/drivers/platform/x86/thinkpad_acpi.c
@@ -6284,6 +6284,7 @@ enum thermal_access_mode {
 enum { /* TPACPI_THERMAL_TPEC_* */
 	TP_EC_THERMAL_TMP0 = 0x78,	/* ACPI EC regs TMP 0..7 */
 	TP_EC_THERMAL_TMP8 = 0xC0,	/* ACPI EC regs TMP 8..15 */
+	TP_EC_FUNCREV      = 0xEF,      /* ACPI EC Functional revision */
 	TP_EC_THERMAL_TMP_NA = -128,	/* ACPI EC sensor not available */
 
 	TPACPI_THERMAL_SENSOR_NA = -128000, /* Sensor not available */
@@ -6482,7 +6483,7 @@ static const struct attribute_group ther
 
 static int __init thermal_init(struct ibm_init_struct *iibm)
 {
-	u8 t, ta1, ta2;
+	u8 t, ta1, ta2, ver = 0;
 	int i;
 	int acpi_tmp7;
 	int res;
@@ -6497,7 +6498,14 @@ static int __init thermal_init(struct ib
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
@@ -6507,11 +6515,13 @@ static int __init thermal_init(struct ib
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
@@ -6524,9 +6534,12 @@ static int __init thermal_init(struct ib
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


