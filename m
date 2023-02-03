Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4752368968E
	for <lists+stable@lfdr.de>; Fri,  3 Feb 2023 11:32:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233455AbjBCK1K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 3 Feb 2023 05:27:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233578AbjBCK0X (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 3 Feb 2023 05:26:23 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D349EE17
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 02:26:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10AF0B82A6F
        for <stable@vger.kernel.org>; Fri,  3 Feb 2023 10:26:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60D8BC433D2;
        Fri,  3 Feb 2023 10:26:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1675419961;
        bh=qKcVylxzsMcxn4O1NEHkHClE7cloRYRruBReRrf6bvE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=feI6aYWUJBPQGHiTI0iTXvQ0qwdSGBULwOessboPotmKy4KhTGVzjXA4+SlYawpPX
         Xv7izL1ITcHkwZi7/+LuEwe+ng9QKGq8PtKnedcGryepqQLnthwxYjRMhPq1gI3UkP
         3Ikq8gGb4ZOgMVEjIKzjwIL9/A5E/sFUPtQmNFIQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev,
        Christian Zigotzky <chzigotzky@xenosoft.de>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 035/134] HID: revert CHERRY_MOUSE_000C quirk
Date:   Fri,  3 Feb 2023 11:12:20 +0100
Message-Id: <20230203101025.435677355@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230203101023.832083974@linuxfoundation.org>
References: <20230203101023.832083974@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jiri Kosina <jkosina@suse.cz>

[ Upstream commit cbf44580ce6b310272a73e3e794233fd064330bd ]

This partially reverts commit f6d910a89a2391 ("HID: usbhid: Add ALWAYS_POLL quirk
for some mice"), as it turns out to break reboot on some platforms for reason
yet to be understood.

Fixes: f6d910a89a2391 ("HID: usbhid: Add ALWAYS_POLL quirk for some mice")
Reported-by: Christian Zigotzky <chzigotzky@xenosoft.de>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 -
 drivers/hid/hid-quirks.c | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 222f525c3d04..1c034c397e3e 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -259,7 +259,6 @@
 #define USB_DEVICE_ID_CH_AXIS_295	0x001c
 
 #define USB_VENDOR_ID_CHERRY		0x046a
-#define USB_DEVICE_ID_CHERRY_MOUSE_000C	0x000c
 #define USB_DEVICE_ID_CHERRY_CYMOTION	0x0023
 #define USB_DEVICE_ID_CHERRY_CYMOTION_SOLAR	0x0027
 
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index baad65fcdff7..e5dcc47586ee 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -54,7 +54,6 @@ static const struct hid_device_id hid_quirks[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_FLIGHT_SIM_YOKE), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_PEDALS), HID_QUIRK_NOGET },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CH, USB_DEVICE_ID_CH_PRO_THROTTLE), HID_QUIRK_NOGET },
-	{ HID_USB_DEVICE(USB_VENDOR_ID_CHERRY, USB_DEVICE_ID_CHERRY_MOUSE_000C), HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB), HID_QUIRK_NO_INIT_REPORTS },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K65RGB_RAPIDFIRE), HID_QUIRK_NO_INIT_REPORTS | HID_QUIRK_ALWAYS_POLL },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_CORSAIR, USB_DEVICE_ID_CORSAIR_K70RGB), HID_QUIRK_NO_INIT_REPORTS },
-- 
2.39.0



