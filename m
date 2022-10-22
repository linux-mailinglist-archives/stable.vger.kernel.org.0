Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EFC8608914
	for <lists+stable@lfdr.de>; Sat, 22 Oct 2022 10:31:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229921AbiJVIbN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 22 Oct 2022 04:31:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230445AbiJVI2i (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 22 Oct 2022 04:28:38 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7057F22E8FA;
        Sat, 22 Oct 2022 01:01:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E6C3960B09;
        Sat, 22 Oct 2022 08:01:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09143C433D6;
        Sat, 22 Oct 2022 08:01:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1666425665;
        bh=td0Bgb5k/mqBqt6ZeCIVd7jIB7tIe/i82PmDKrXTogw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hXZxQuyHjh1o51StCJCIcvCXIC5Oi8KsFtx1m0VFRcmJadRXuNLbFUfR4VqagzthO
         5lfEoI4vrFYZZ+UEYzqe51faAzlZFpmn4hzi9Cx7UZhyUlXyj3A3Hm7YQOHO1pLSWz
         xYt+djKeROEwaawVhg8bFmtcdu5kF+o6f7S9aOmE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kiran K <kiran.k@intel.com>,
        Chethan T N <chethan.tumkur.narayan@intel.com>,
        Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.19 575/717] Bluetooth: btintel: Mark Intel controller to support LE_STATES quirk
Date:   Sat, 22 Oct 2022 09:27:34 +0200
Message-Id: <20221022072523.850735102@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221022072415.034382448@linuxfoundation.org>
References: <20221022072415.034382448@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kiran K <kiran.k@intel.com>

[ Upstream commit dd0a1794f4334ddbf9b7c5e7d642aaffff38c69b ]

HarrrisonPeak, CyclonePeak, SnowFieldPeak and SandyPeak controllers
are marked to support HCI_QUIRK_LE_STATES.

Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Chethan T N <chethan.tumkur.narayan@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/bluetooth/btintel.c | 17 ++++++++---------
 1 file changed, 8 insertions(+), 9 deletions(-)

diff --git a/drivers/bluetooth/btintel.c b/drivers/bluetooth/btintel.c
index 818681c89db8..d44a96667517 100644
--- a/drivers/bluetooth/btintel.c
+++ b/drivers/bluetooth/btintel.c
@@ -2439,15 +2439,20 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 					       INTEL_ROM_LEGACY_NO_WBS_SUPPORT))
 				set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 					&hdev->quirks);
+			if (ver.hw_variant == 0x08 && ver.fw_variant == 0x22)
+				set_bit(HCI_QUIRK_VALID_LE_STATES,
+					&hdev->quirks);
 
 			err = btintel_legacy_rom_setup(hdev, &ver);
 			break;
 		case 0x0b:      /* SfP */
-		case 0x0c:      /* WsP */
 		case 0x11:      /* JfP */
 		case 0x12:      /* ThP */
 		case 0x13:      /* HrP */
 		case 0x14:      /* CcP */
+			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+			fallthrough;
+		case 0x0c:	/* WsP */
 			/* Apply the device specific HCI quirks
 			 *
 			 * All Legacy bootloader devices support WBS
@@ -2455,11 +2460,6 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 			set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED,
 				&hdev->quirks);
 
-			/* Valid LE States quirk for JfP/ThP familiy */
-			if (ver.hw_variant == 0x11 || ver.hw_variant == 0x12)
-				set_bit(HCI_QUIRK_VALID_LE_STATES,
-					&hdev->quirks);
-
 			/* Setup MSFT Extension support */
 			btintel_set_msft_opcode(hdev, ver.hw_variant);
 
@@ -2530,9 +2530,8 @@ static int btintel_setup_combined(struct hci_dev *hdev)
 		 */
 		set_bit(HCI_QUIRK_WIDEBAND_SPEECH_SUPPORTED, &hdev->quirks);
 
-		/* Valid LE States quirk for JfP/ThP familiy */
-		if (ver.hw_variant == 0x11 || ver.hw_variant == 0x12)
-			set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
+		/* Set Valid LE States quirk */
+		set_bit(HCI_QUIRK_VALID_LE_STATES, &hdev->quirks);
 
 		/* Setup MSFT Extension support */
 		btintel_set_msft_opcode(hdev, ver.hw_variant);
-- 
2.35.1



