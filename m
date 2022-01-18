Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15E8E491A44
	for <lists+stable@lfdr.de>; Tue, 18 Jan 2022 03:59:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348015AbiARC7C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 17 Jan 2022 21:59:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343987AbiARCq5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 17 Jan 2022 21:46:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89ABEC06127A;
        Mon, 17 Jan 2022 18:38:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2870961157;
        Tue, 18 Jan 2022 02:38:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FBA7C36AEB;
        Tue, 18 Jan 2022 02:38:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642473522;
        bh=85cJDV/o2+Z3jQM6ldwt74lf45PeDAeWsiVekjqwv4Y=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AGfK64IeRMfM737f3c/EHxb/qL9TPjCO0q1iRDAjnYfn44HD5UZoTHDzOfY9PWsoA
         P48bhn4y1y20llV/cUC17JutB6Xh1DnnU7FS3ByIqEKH169TMlPwc+YTV2P06rhOit
         aoCZLtw8cKZzccka2ckhGLntzwlSAMmHJV/d6yLUDR4OU7PHDNSTRL2uChs2D/jCAx
         jvmWXWaY5nVErNR4ZwLWgO9D9wM++uEW7ArCmzvszNQ4/SCppE8aqhrxkAbYDdQkSc
         V+YMx+xKlyM3aRce++Pmx5nr4LuwVJkt4SnJ76U7Z1uQlgFXl7p2tkfyGdtDsDt7/h
         P7W3jCGawbSjg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>, johan.hedberg@gmail.com,
        luiz.dentz@gmail.com, linux-bluetooth@vger.kernel.org
Subject: [PATCH AUTOSEL 5.15 147/188] Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader
Date:   Mon, 17 Jan 2022 21:31:11 -0500
Message-Id: <20220118023152.1948105-147-sashal@kernel.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220118023152.1948105-1-sashal@kernel.org>
References: <20220118023152.1948105-1-sashal@kernel.org>
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
index f1705b46fc889..91dab2fdb916c 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2329,10 +2329,14 @@ static int btintel_setup_combined(struct hci_dev *hdev)
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
@@ -2344,6 +2348,20 @@ static int btintel_setup_combined(struct hci_dev *hdev)
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

