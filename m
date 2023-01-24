Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89B836799F4
	for <lists+stable@lfdr.de>; Tue, 24 Jan 2023 14:43:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234324AbjAXNnf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Jan 2023 08:43:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234379AbjAXNnJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 24 Jan 2023 08:43:09 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63ED645BEA;
        Tue, 24 Jan 2023 05:42:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EC55FB811CF;
        Tue, 24 Jan 2023 13:42:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1998AC4339B;
        Tue, 24 Jan 2023 13:42:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674567750;
        bh=B72S5VWd/wgzN597sQph6obxVoFBTazs1YiraxLgGDk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o8tXOIxDPqRu7ExYS8RizyNujebhvFHHB92r0rS0M+8W8Z6iGXfUCMj0Tgv9ovzSu
         pKvRADFQhBaG8ZLyhfwF7yGLRWd09wlU2cdlMC1j/7yV0XKGI05sFBh3fzWP5Yccso
         KqIfew8Cc1+g4kGRakF7i/FHJaCKbQ9k5adBfU6ITXuHly4fvnQvilW2oLICfDutib
         zWy2euoz/2pIIJDYaNSs6dvduXykUpy5IDLE2OnfTpA/DL1EyRvVYMvDt9YUjxr5Y3
         pXOHZJztiWu33WGLTvUUTcm5L2dmvyepjq+pBoysVRXBdP4n5VM0snefzC6pYjED4w
         VN2XH8IyhihwA==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     =?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
        Mark Waddoups <mwaddoups@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 6.1 21/35] HID: uclogic: Add support for XP-PEN Deco 01 V2
Date:   Tue, 24 Jan 2023 08:41:17 -0500
Message-Id: <20230124134131.637036-21-sashal@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230124134131.637036-1-sashal@kernel.org>
References: <20230124134131.637036-1-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit febb2c0d7c69c0396aa32d5ab425a4163473961a ]

The XP-PEN Deco 01 V2 is a UGEE v2 device with a frame with 8 buttons.
Its pen has 2 buttons, supports tilt and pressure.

Add its ID in order to support the device.

Link: https://gitlab.freedesktop.org/libinput/libinput/-/issues/839
Tested-by: Mark Waddoups <mwaddoups@gmail.com>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h            | 1 +
 drivers/hid/hid-uclogic-core.c   | 2 ++
 drivers/hid/hid-uclogic-params.c | 2 ++
 3 files changed, 5 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 82713ef3aaa6..9ca471faab65 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -1295,6 +1295,7 @@
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_G540	0x0075
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_G640	0x0094
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01	0x0042
+#define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2	0x0905
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L	0x0935
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_PRO_S	0x0909
 #define USB_DEVICE_ID_UGEE_XPPEN_TABLET_STAR06	0x0078
diff --git a/drivers/hid/hid-uclogic-core.c b/drivers/hid/hid-uclogic-core.c
index 7fa6fe04f1b2..cfbbc39807a6 100644
--- a/drivers/hid/hid-uclogic-core.c
+++ b/drivers/hid/hid-uclogic-core.c
@@ -525,6 +525,8 @@ static const struct hid_device_id uclogic_devices[] = {
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_G640) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
+				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
 				USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_UGEE,
diff --git a/drivers/hid/hid-uclogic-params.c b/drivers/hid/hid-uclogic-params.c
index cd1233d7e253..3c5eea3df328 100644
--- a/drivers/hid/hid-uclogic-params.c
+++ b/drivers/hid/hid-uclogic-params.c
@@ -1655,6 +1655,8 @@ int uclogic_params_init(struct uclogic_params *params,
 		break;
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_PARBLO_A610_PRO):
+	case VID_PID(USB_VENDOR_ID_UGEE,
+		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO01_V2):
 	case VID_PID(USB_VENDOR_ID_UGEE,
 		     USB_DEVICE_ID_UGEE_XPPEN_TABLET_DECO_L):
 	case VID_PID(USB_VENDOR_ID_UGEE,
-- 
2.39.0

