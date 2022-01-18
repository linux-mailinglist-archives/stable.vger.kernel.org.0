Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E886491622
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:33:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245306AbiARCc6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:32:58 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:42018 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343707AbiARC3O (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:29:14 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E981B81249;
        Tue, 18 Jan 2022 02:29:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EFF54C36AF4;
        Tue, 18 Jan 2022 02:29:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642472951;
        bh=GV/7FD4SRn+k6luiTgkJqWYlvOif5E5cRv+WgmQ03uk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gga7so8tmglX9XFtJk6M/6XRpS/Rw6B8hgNdmhveSWvsM1jZ1Qf0NW0S03y3aSvm3
         0LJFQW4nq/FiPxOjZCo9SYBnYbQX1j9Yr4DaVtedUBwvS7u8/ZVrsYd+gc8CsZvSGP
         h6h/7VjVpRfsCgUdGcwkJH3NE0AsRdggvjs53ESeRI5vAwthij4rBZIiwY8UZiiuGn
         tBlyj6g+wfJohfg7qh7Q+uATwTr/KDEI+8cmAN9E5ejS98dIVAEHS2RwG0D6dukxIB
         CDFHxaTpA3Ic+tLCnhaBbbkf4uWWNUiokt/8LhVvClP8WXRJPu0e1ylqAz0XfvGSNA
         obHXmwle5Dk6w==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.16 173/217] Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader
Date:   Mon, 17 Jan 2022 21:18:56 -0500
Message-Id: <20220118021940.1942199-173-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118021940.1942199-1-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tedd Ho-Jeong An <tedd.an@intel.com>

[ Upstream commit 3547a008c8962df2175db1e78b80f27e027ec549 ]

This patch add missing HCI quirks and MSFT extension for legacy
bootloader when it is running in the operational firmware.

Signed-off-by: Tedd Ho-Jeong An <tedd.an@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 26 ++++++++++++++++++++++----
 1 file changed, 22 insertions(+), 4 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 9359bff472965..8b3583f1cdf92 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2492,10 +2492,14 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 	case 0x12:      /* ThP */
 	case 0x13:      /* HrP */
 	case 0x14:      /* CcP */
-		/* Some legacy bootloader devices from JfP supports both old
-		 * and TLV based HCI_Intel_Read_Version command. But we don't
-		 * want to use the TLV based setup routines for those legacy
-		 * bootloader device.
+		/* Some legacy bootloader devices starting from JfP,
+		 * the operational firmware supports both old and TLV based
+		 * HCI_Intel_Read_Version command based on the command
+		 * parameter.
+		 *
+		 * For upgrading firmware case, the TLV based version cannot
+		 * be used because the firmware filename for legacy bootloader
+		 * is based on the old format.
 		 *
 		 * Also, it is not easy to convert TLV based version from the
 		 * legacy version format.
@@ -2507,6 +2511,20 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		err = btintel_read_version(hdev, &ver);
 		if (err)
 			return err;
+
+		/* Apply the device specific HCI quirks
+		 *
+		 * All Legacy bootloader devices support WBS
+		 */
+		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
+
+		/* Valid LE States quirk for JfP/ThP familiy */
+		if (ver.hw_variant == 0x11 || ver.hw_variant == 0x12)
+			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+
+		/* Setup MSFT Extension support */
+		btintel_set_msft_opcode(hdev, ver.hw_variant);
+
 		err = btintel_bootloader_setup(hdev, &ver);
 		break;
 	case 0x17:
-- 
2.34.1

