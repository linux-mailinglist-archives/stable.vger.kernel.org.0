Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C3F9649C9D
	for <lists+stable@lfdr.de>; Mon, 12 Dec 2022 11:43:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231843AbiLLKnR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Dec 2022 05:43:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232090AbiLLKlN (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 12 Dec 2022 05:41:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 897F2EE34;
        Mon, 12 Dec 2022 02:36:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2330460F75;
        Mon, 12 Dec 2022 10:36:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 950CDC433D2;
        Mon, 12 Dec 2022 10:36:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670841383;
        bh=0U40LY099EWIZto4Id3wYEV3ISa+bQfPG+k0FwdkC40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qS3Qlv7R7EmSxEUYDubxNCls2PXZpZIcfpCrbVyww0sDA6KGjegoWb2Nkr1YbvRCw
         N1/GaBHB9K04x+/v73E7aVIALzvV7aHJNHt/KiyRGt1XZ9okGwelMJjQqn4vZNJ/UL
         S80LV9KKGcxAjjTRe2w4TS3PjTei9anH4AbH1QtUeNbpZ0cVibnc3LnN6sX4R2D4ND
         Tbm7ibHqbXVEvQ+f1PGCDRS8sGUgrmCnmM6KusTuIHctNF63LV62CRJcTs33S8PkXT
         a40KITAtErz+8AScm6sfPPp5lf7HQzHFTG8O2JU1ltl+EkH77H6E7IdarBYUCBPdUZ
         AaDIzicCONcCg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Hans de Goede <hdegoede@redhat.com>,
        Rudolf Polzer <rpolzer@google.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.10 3/7] HID: ite: Enable QUIRK_TOUCHPAD_ON_OFF_REPORT on Acer Aspire Switch V 10
Date:   Mon, 12 Dec 2022 05:36:11 -0500
Message-Id: <20221212103616.300049-3-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20221212103616.300049-1-sashal@kernel.org>
References: <20221212103616.300049-1-sashal@kernel.org>
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
index 6ba318a49e44..f479e7e92de8 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1150,6 +1150,7 @@
 #define USB_DEVICE_ID_SYNAPTICS_TP_V103	0x5710
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1002	0x73f4
 #define USB_DEVICE_ID_SYNAPTICS_ACER_ONE_S1003	0x73f5
+#define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5_017	0x73f6
 #define USB_DEVICE_ID_SYNAPTICS_ACER_SWITCH5	0x81a7
 
 #define USB_VENDOR_ID_TEXAS_INSTRUMENTS	0x2047
diff --git a/drivers/hid/hid-ite.c b/drivers/hid/hid-ite.c
index 14fc068affad..b8cce9c196d8 100644
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

