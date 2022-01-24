Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9414E49A421
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:08:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2369316AbiAYABa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 19:01:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1847701AbiAXXUX (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 18:20:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC4CCC028BE4;
        Mon, 24 Jan 2022 13:28:31 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4996D614DD;
        Mon, 24 Jan 2022 21:28:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2DA93C340E5;
        Mon, 24 Jan 2022 21:28:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643059710;
        bh=S3oWCTD/UPBgHiBeKcRHNlnH9qKO6/9FriHWj32grDE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jTuBxhcbIv9cIuCyHfTebxWS5HhMnY88IoQhs/NwHmdeDAXwZZFLpadRSvHZFhf43
         1piDxRoY4aNWOCCWiJsTAFzt9E45qILz1lvyT/F2QZ193YUz1F00g9DR5O5E0R44TG
         itFjqPp6DyfwwQ9D5YDwIJ6k4wiEkT9NdxeWIquI=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Tedd Ho-Jeong An <tedd.an@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Marcel Holtmann <marcel@holtmann.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0690/1039] Bluetooth: btintel: Add missing quirks and msft ext for legacy bootloader
Date:   Mon, 24 Jan 2022 19:41:19 +0100
Message-Id: <20220124184148.539751242@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index b11567b0fd9ab..851a0c9b8fae5 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2493,10 +2493,14 @@ static int btintel_setup_combined(struct hci_dev *hdev)
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
@@ -2508,6 +2512,20 @@ static int btintel_setup_combined(struct hci_dev *hdev)
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



