Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 047F1499C80
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 23:09:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1579524AbiAXWFv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 17:05:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1577053AbiAXV5L (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:57:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68761C038AEF;
        Mon, 24 Jan 2022 12:38:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 03E9B6153D;
        Mon, 24 Jan 2022 20:38:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D66DCC340E5;
        Mon, 24 Jan 2022 20:38:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643056736;
        bh=car2GWGQ84Oqt5DZ8T8+3ao0ewMS7ZfYThhbRLWU8xk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xw/ao++DW7zB2mqItbeJVTroVh5GlQBygTRTR/iPauyw68Xb9beQQSxOQ5JVjUrZ+
         8Qdm4D2OOfOFRzw/YMjjqc8elZRwmyobfbygTE7V/3aMa5aeEtXb8h6s6lfCBqa4Zm
         0QfGk/LtyMvMeNi9/22Q5HZPGtmAvL+g17wlGpPM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 584/846] Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader
Date:   Mon, 24 Jan 2022 19:41:41 +0100
Message-Id: <20220124184121.188374566@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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
index 525be2e1fbb25..e73d4c719b0ad 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2330,10 +2330,14 @@ static int btintel_setup_combined(struct hci_dev *hdev)
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
@@ -2345,6 +2349,20 @@ static int btintel_setup_combined(struct hci_dev *hdev)
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



