Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 314AD649C68
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232154AbiLLKln (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:41:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231653AbiLLKkt (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:40:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0ECDEE03;
        Mon, 12 Dec 2022 02:35:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA3A3B80BA6;
        Mon, 12 Dec 2022 10:35:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7D1C433D2;
        Mon, 12 Dec 2022 10:35:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841307;
        bh=yjH8wmZxCoUG84ricBifB0MoW2if5/EMgSiP12K/d10=;
        h=From:To:Cc:Subject:Date:From;
        b=IyoDxxyEcSnBbYP3yrmaTybzpQNBRTPrLxHh5+v0Pe4cLWywBSYOLP4OeqL+cv3MW
         75Pm8nAzzTxht4WXpLD8rTQDLKEXLDa4sb8P47RduifgqdnseawTfPLF52XGWp+4QS
         6VgrSAYlAdIvAWJRPiWPrbEncUGCfInulHrJRcsACcuA6bniGA/uBnerezYk1MwLR2
         sljBHPmLkvrqaQWyDv6gYkjRHdnWqlUY/PS9dU82+LqUrvCHBCiwZn0Kxa1Nh5TnQi
         pSv1o/TMpA9sbT0awGHw5ZXklSaSuaZPwrYwqMraBRQp8cWoNQvEnN6pKSngvl+2be
         2p7ERIqslj3wg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Rudolf Polzer <rpolzer@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.0 1/7] HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10
Date:   Mon, 12 Dec 2022 05:34:57 -0500
Message-Id: <20221212103504.299281-1-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hans de Goede <hdegoede@redhat.com>

[ Upstream commit 9ad6645a9dce4d0e42daca6ebf32a154401c59d3 ]

The Acer Aspire Switch V 10 (SW5-017)'s keyboard-dock uses the same
ITE controller setup as other Acer Switch 2-in-1's.

This needs special handling for the wifi on/off toggle hotkey as well as
to properly report touchpad on/off keypresses.

Add the USB-ids for the SW5-017's keyboard-dock with a quirk setting of
QUIRK_TOUCHPAD_ON_OFF_REPORT to fix both issues.

Cc: Rudolf Polzer <rpolzer@google.com>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h | 1 +
 drivers/hid/hid-ite.c | 5 +++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 256795ed6247..a5d24633a509 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1215,6 +1215,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_DELL_K15A	0x6e21
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
+#define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017	0x73f6
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 430fa4f52ed3..75ebfcf31889 100644
--- a/drivers/hid/hid-ite.c
+++ b/drivers/hid/hid-ite.c
@@ -121,6 +121,11 @@ static const struct hid_device_id ite_devices[] = {
 		     USB_VENDOR_ID_SYNAPTICS,
 		     USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003),
 	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
+	/* ITE8910 USB kbd ctlr, with Synaptics touchpad connected to it. */
+	{ HID_DEVICE(BUS_USB, HID_GROUP_GENERIC,
+		     USB_VENDOR_ID_SYNAPTICS,
+		     USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017),
+	  .driver_data = QUIRK_TOUCHPAD_ON_OFF_REPORT },
 	{ }
 };
 MODULE_DEVICE_TABLE(hid, ite_devices);
-- 
2.35.1

