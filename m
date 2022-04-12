Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF4394FD3C8
	for <lists+stable@lfdr.de>; Tue, 12 Apr 2022 11:59:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354150AbiDLHvN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 12 Apr 2022 03:51:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1357042AbiDLHjn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 12 Apr 2022 03:39:43 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1D68F165A5;
        Tue, 12 Apr 2022 00:10:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C8EC2B81895;
        Tue, 12 Apr 2022 07:10:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 291E9C385A1;
        Tue, 12 Apr 2022 07:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1649747454;
        bh=75XHWw54css5obuqON8cmpEPngRNcXM5PRhjE/n61S0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehsqCT31AYccLV1qEKz3UcsrcmwFLWOqWvnQy+kd43AHZ9i1B5ZiWjcUFV2lBB6r2
         2RXSudOH51y1HTKjDfRvwYa71QUdlwg3HwvBz1+w948C2/FQH/eiEASxI+Ik5kZdyq
         cma1pjZKY5ewLZTEfnzFGtAjnKqoNH/U4+S5saF0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.17 085/343] HID: apple: Report Magic Keyboard 2021 with fingerprint reader battery over USB
Date:   Tue, 12 Apr 2022 08:28:23 +0200
Message-Id: <20220412062953.552831502@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220412062951.095765152@linuxfoundation.org>
References: <20220412062951.095765152@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit cbfcfbfc384890a062a5d0cc4792df094a6cc7a8 ]

Like the Apple Magic Keyboard 2015, when connected over USB, the 2021
version with fingerprint reader registers 2 different interfaces. One of
them is used to report the battery level.

However, unlike when connected over Bluetooth, the battery level is not
reported automatically and it is required to fetch it manually.

Add the APPLE_RDESC_BATTERY quirk to fix the battery report descriptor
and manually fetch the battery level.

Tested with the ANSI variant of the keyboard with and without numpad.

Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-apple.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hid/hid-apple.c b/drivers/hid/hid-apple.c
index 18de4ccb0fb2..590376d776a1 100644
--- a/drivers/hid/hid-apple.c
+++ b/drivers/hid/hid-apple.c
@@ -752,11 +752,11 @@ static const struct hid_device_id apple_devices[] = {
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021),
-		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK | APPLE_RDESC_BATTERY },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_FINGERPRINT_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021),
-		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
+		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK | APPLE_RDESC_BATTERY },
 	{ HID_BLUETOOTH_DEVICE(BT_VENDOR_ID_APPLE, USB_DEVICE_ID_APPLE_MAGIC_KEYBOARD_NUMPAD_2021),
 		.driver_data = APPLE_HAS_FN | APPLE_ISO_TILDE_QUIRK },
 
-- 
2.35.1



