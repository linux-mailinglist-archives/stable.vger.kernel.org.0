Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49BB54E7748
	for <lists+stable@lfdr.de>; Fri, 25 Mar 2022 16:26:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1376528AbiCYP1q (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 25 Mar 2022 11:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1377941AbiCYPYo (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 25 Mar 2022 11:24:44 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61BB0EAC92;
        Fri, 25 Mar 2022 08:19:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BA176B82865;
        Fri, 25 Mar 2022 15:19:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05CDAC340E9;
        Fri, 25 Mar 2022 15:19:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648221560;
        bh=JdQzAi/hwTPPFKOBVImriiqmuLWSX3nkNyNbJttnU+o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rw7CDsXLMYuaKqfy9eikk4WyaAxC0IeOUBLLkL2907Cpznf4sJ+w9vNdpUEiK0acq
         vkTndj5ocrXg2Fbbwq+X/fHtTEcuhv7Oqg5mIqu1YitxKYkcum4fTdBJHJ69aQlHDP
         m4rgpqcTdL2P3vFMXLeZNpjSQ88wadWaEpCOgWQ4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hans de Goede <hdegoede@redhat.com>,
        =?UTF-8?q?Gonzalo=20Tornar=C3=ADa?= <tornaria@cmat.edu.uy>,
        Mateus Lemos <lemonsmateus@gmail.com>,
        Ismael Ferreras Morezuelas <swyterzone@gmail.com>,
        Marcel Holtmann <marcel@holtmann.org>
Subject: [PATCH 5.17 28/39] Bluetooth: btusb: Use quirk to skip HCI_FLT_CLEAR_ALL on fake CSR controllers
Date:   Fri, 25 Mar 2022 16:14:43 +0100
Message-Id: <20220325150421.047518443@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220325150420.245733653@linuxfoundation.org>
References: <20220325150420.245733653@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Ismael Ferreras Morezuelas <swyterzone@gmail.com>

commit b3cf94c8b6b2f1a2b94825a025db291da2b151fd upstream.

Another subset of the more recent batch of Chinese clones aren't
specs-compliant and seem to lock up whenever they receive a
HCI_OP_SET_EVENT_FLT with flt_type set to zero/HCI_FLT_CLEAR_ALL,
which on Linux (until the recent HCI state-machine refactor) happened
right at BR/EDR setup. As there are other less-straightforward ways
of reaching those operations, this patch is still relevant.

So, while all the previous efforts to wrangle the herd of fake CSRs
seem to be paying off (and these also get detected as such) we
still need to take care of this quirk; testers seem to agree
that these dongles tend to work well enough afterwards.

>From some cursory USB packet capture on Windows it seems like
that driver doesn't appear to use this clear-all functionality at all.

This patch was tested on some really popular AliExpress-style
dongles, in my case marked as "V5.0". Chip markings: UG8413,
the backside of the PCB says "USB Dangel" (sic).

Here is the `hciconfig -a` output; for completeness:

hci0:	Type: Primary  Bus: USB
	BD Address: 00:1A:7D:DA:7X:XX  ACL MTU: 679:8  SCO MTU: 48:16
	UP RUNNING PSCAN ISCAN
	Features: 0xbf 0x3e 0x4d 0xfa 0xdb 0x3d 0x7b 0xc7
	Packet type: DM1 DM3 DM5 DH1 DH3 DH5 HV1 HV2 HV3
	Link policy: RSWITCH SNIFF
	Link mode: PERIPHERAL ACCEPT
	Name: 'CSR8510 A10.'
	Class: 0x7c0104
	Service Classes: Rendering, Capturing, Object Transfer, Audio, Telephony
	Device Class: Computer, Desktop workstation
	HCI Version: 4.0 (0x6)  Revision: 0x3120
	LMP Version: 4.0 (0x6)  Subversion: 0x22bb
	Manufacturer: Cambridge Silicon Radio (10)

As well as the `lsusb -vv -d 0a12:0001`:

ID 0a12:0001 Cambridge Silicon Radio, Ltd Bluetooth Dongle (HCI mode)
Device Descriptor:
  bLength                18
  bDescriptorType         1
  bcdUSB               2.00
  bDeviceClass          224 Wireless
  bDeviceSubClass         1 Radio Frequency
  bDeviceProtocol         1 Bluetooth
  bMaxPacketSize0        64
  idVendor           0x0a12 Cambridge Silicon Radio, Ltd
  idProduct          0x0001 Bluetooth Dongle (HCI mode)
  bcdDevice           88.91
  iManufacturer           0
  iProduct                2 BT DONGLE10
  iSerial                 0
  bNumConfigurations      1

Also, changed the benign dmesg print that shows up whenever the
generic force-suspend fails from bt_dev_err to bt_dev_warn;
it's okay and done on a best-effort basis, not a problem
if that does not work.

Also, swapped the HCI subver and LMP subver numbers for the Barrot
in the comment, which I copied wrong the last time around.

Fixes: 81cac64ba258a ("Bluetooth: Deal with USB devices that are faking CSR vendor")
Fixes: cde1a8a992875 ("Bluetooth: btusb: Fix and detect most of the Chinese Bluetooth controllers")
Fixes: d74e0ae7e0303 ("Bluetooth: btusb: Fix detection of some fake CSR controllers with a bcdDevice val of 0x0134")
Fixes: 0671c0662383e ("Bluetooth: btusb: Add workaround for remote-wakeup issues with Barrot 8041a02 fake CSR controllers")
Fixes: f4292e2faf522 ("Bluetooth: btusb: Make the CSR clone chip force-suspend workaround more generic")

Link: https://bugzilla.kernel.org/show_bug.cgi?id=60824
Link: https://gist.github.com/nevack/6b36b82d715dc025163d9e9124840a07

Cc: stable@vger.kernel.org
Cc: Hans de Goede <hdegoede@redhat.com>
Tested-by: Gonzalo Tornaría <tornaria@cmat.edu.uy>
Tested-by: Mateus Lemos <lemonsmateus@gmail.com>
Tested-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Signed-off-by: Ismael Ferreras Morezuelas <swyterzone@gmail.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Marcel Holtmann <marcel@holtmann.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btusb.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/drivers/bluetooth/btusb.c
+++ b/drivers/bluetooth/btusb.c
@@ -2045,6 +2045,8 @@ static int btusb_setup_csr(struct hci_de
 		 */
 		set_bit(HCI_QUIRK_BROKEN_STORED_LINK_KEY, &hdev->quirks);
 		set_bit(HCI_QUIRK_BROKEN_ERR_DATA_REPORTING, &hdev->quirks);
+		set_bit(HCI_QUIRK_BROKEN_FILTER_CLEAR_ALL, &hdev->quirks);
+		set_bit(HCI_QUIRK_NO_SUSPEND_NOTIFIER, &hdev->quirks);
 
 		/* Clear the reset quirk since this is not an actual
 		 * early Bluetooth 1.1 device from CSR.
@@ -2055,7 +2057,7 @@ static int btusb_setup_csr(struct hci_de
 		/*
 		 * Special workaround for these BT 4.0 chip clones, and potentially more:
 		 *
-		 * - 0x0134: a Barrot 8041a02                 (HCI rev: 0x1012 sub: 0x0810)
+		 * - 0x0134: a Barrot 8041a02                 (HCI rev: 0x0810 sub: 0x1012)
 		 * - 0x7558: IC markings FR3191AHAL 749H15143 (HCI rev/sub-version: 0x0709)
 		 *
 		 * These controllers are really messed-up.
@@ -2084,7 +2086,7 @@ static int btusb_setup_csr(struct hci_de
 		if (ret >= 0)
 			msleep(200);
 		else
-			bt_dev_err(hdev, "CSR: Failed to suspend the device for our Barrot 8041a02 receive-issue workaround");
+			bt_dev_warn(hdev, "CSR: Couldn't suspend the device for our Barrot 8041a02 receive-issue workaround");
 
 		pm_runtime_forbid(&data->udev->dev);
 


