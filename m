Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8A8BB4CF5FB
	for <lists+stable@lfdr.de>; Mon,  7 Mar 2022 10:31:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237207AbiCGJa4 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Mar 2022 04:30:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58276 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238790AbiCGJ3l (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 7 Mar 2022 04:29:41 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 386CB13F6C;
        Mon,  7 Mar 2022 01:28:43 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CF574B810B6;
        Mon,  7 Mar 2022 09:28:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25C85C340F4;
        Mon,  7 Mar 2022 09:28:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646645320;
        bh=qSVycF8Hlto4OvKR+716Kr/M0LMXsvxE7Nc3xlw8CVY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ka/tRpNMekN+PtDxLObNwR36Z1726DTJNvjNhRrRJKNuvgszM2MxtiPtcu/BKNIDR
         SrL09wbeSCigRC61bcs52v8s9ziQDEyqw4tjAXAUGHykuluXH0rAHqzEo1Y1cn032+
         GYM5fYfI08CkXifA8DF7yNMjvbNWtJ71FmhipkuY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Hutterer <peter.hutterer@who-t.net>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Jiri Kosina <jkosina@suse.cz>,
        =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/64] Input: clear BTN_RIGHT/MIDDLE on buttonpads
Date:   Mon,  7 Mar 2022 10:18:39 +0100
Message-Id: <20220307091639.322486194@linuxfoundation.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220307091639.136830784@linuxfoundation.org>
References: <20220307091639.136830784@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 37ef4c19b4c659926ce65a7ac709ceaefb211c40 ]

Buttonpads are expected to map the INPUT_PROP_BUTTONPAD property bit
and the BTN_LEFT key bit.

As explained in the specification, where a device has a button type
value of 0 (click-pad) or 1 (pressure-pad) there should not be
discrete buttons:
https://docs.microsoft.com/en-us/windows-hardware/design/component-guidelines/touchpad-windows-precision-touchpad-collection#device-capabilities-feature-report

However, some drivers map the BTN_RIGHT and/or BTN_MIDDLE key bits even
though the device is a buttonpad and therefore does not have those
buttons.

This behavior has forced userspace applications like libinput to
implement different workarounds and quirks to detect buttonpads and
offer to the user the right set of features and configuration options.
For more information:
https://gitlab.freedesktop.org/libinput/libinput/-/merge_requests/726

In order to avoid this issue clear the BTN_RIGHT and BTN_MIDDLE key
bits when the input device is register if the INPUT_PROP_BUTTONPAD
property bit is set.

Notice that this change will not affect udev because it does not check
for buttons. See systemd/src/udev/udev-builtin-input_id.c.

List of known affected hardware:

 - Chuwi AeroBook Plus
 - Chuwi Gemibook
 - Framework Laptop
 - GPD Win Max
 - Huawei MateBook 2020
 - Prestigio Smartbook 141 C2
 - Purism Librem 14v1
 - StarLite Mk II   - AMI firmware
 - StarLite Mk II   - Coreboot firmware
 - StarLite Mk III  - AMI firmware
 - StarLite Mk III  - Coreboot firmware
 - StarLabTop Mk IV - AMI firmware
 - StarLabTop Mk IV - Coreboot firmware
 - StarBook Mk V

Acked-by: Peter Hutterer <peter.hutterer@who-t.net>
Acked-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
Acked-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://lore.kernel.org/r/20220208174806.17183-1-jose.exposito89@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/input.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index e2eb9b9b8363d..f7398b996bacf 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -2181,6 +2181,12 @@ int input_register_device(struct input_dev *dev)
 	/* KEY_RESERVED is not supposed to be transmitted to userspace. */
 	__clear_bit(KEY_RESERVED, dev->keybit);
 
+	/* Buttonpads should not map BTN_RIGHT and/or BTN_MIDDLE. */
+	if (test_bit(INPUT_PROP_BUTTONPAD, dev->propbit)) {
+		__clear_bit(BTN_RIGHT, dev->keybit);
+		__clear_bit(BTN_MIDDLE, dev->keybit);
+	}
+
 	/* Make sure that bitmasks not mentioned in dev->evbit are clean. */
 	input_cleanse_bitmasks(dev);
 
-- 
2.34.1



