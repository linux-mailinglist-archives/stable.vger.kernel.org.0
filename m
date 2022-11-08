Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0A98621327
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 14:47:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234502AbiKHNrU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 08:47:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234562AbiKHNrT (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 08:47:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 236C25986B
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 05:47:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CBF75B81AF4
        for <stable@vger.kernel.org>; Tue,  8 Nov 2022 13:47:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29A1C433D7;
        Tue,  8 Nov 2022 13:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1667915236;
        bh=pcwYCcHp1F2nlPx0ZHtK8KuH4q/blx8O+3O0+fbRhfU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CiQA9hUa5XDp6W6tclpprIUGuxIZCKqP/AvMpAkv66paCV7SYsfADcRQYjQCrkKxi
         S+Izt5DcofApfEVSqZgr/v/gzI2lgrGFTxG3PKxmNizRVF/Y+3qlyUxh8umIRN9k5z
         jPRonRa9crKfmm7AWDa+ngwlkK98I/R8a80hR4I0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Samuel Bailey <samuel.bailey1@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/48] HID: saitek: add madcatz variant of MMO7 mouse device ID
Date:   Tue,  8 Nov 2022 14:39:13 +0100
Message-Id: <20221108133330.521353504@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133329.533809494@linuxfoundation.org>
References: <20221108133329.533809494@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Samuel Bailey <samuel.bailey1@gmail.com>

[ Upstream commit 79425b297f56bd481c6e97700a9a4e44c7bcfa35 ]

The MadCatz variant of the MMO7 mouse has the ID 0738:1713 and the same
quirks as the Saitek variant.

Signed-off-by: Samuel Bailey <samuel.bailey1@gmail.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h    | 1 +
 drivers/hid/hid-quirks.c | 1 +
 drivers/hid/hid-saitek.c | 2 ++
 3 files changed, 4 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 70079d29822b..00943ddbe417 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -793,6 +793,7 @@
 #define USB_DEVICE_ID_MADCATZ_BEATPAD	0x4540
 #define USB_DEVICE_ID_MADCATZ_RAT5	0x1705
 #define USB_DEVICE_ID_MADCATZ_RAT9	0x1709
+#define USB_DEVICE_ID_MADCATZ_MMO7  0x1713
 
 #define USB_VENDOR_ID_MCC		0x09db
 #define USB_DEVICE_ID_MCC_PMD1024LS	0x0076
diff --git a/drivers/hid/hid-quirks.c b/drivers/hid/hid-quirks.c
index c1b76ba85fb4..8de294aa3184 100644
--- a/drivers/hid/hid-quirks.c
+++ b/drivers/hid/hid-quirks.c
@@ -620,6 +620,7 @@ static const struct hid_device_id hid_have_special_driver[] = {
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_RAT5) },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_RAT9) },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_MMO7) },
 #endif
 #if IS_ENABLED(CONFIG_HID_SAMSUNG)
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAMSUNG, USB_DEVICE_ID_SAMSUNG_IR_REMOTE) },
diff --git a/drivers/hid/hid-saitek.c b/drivers/hid/hid-saitek.c
index 683861f324e3..95e004d9b110 100644
--- a/drivers/hid/hid-saitek.c
+++ b/drivers/hid/hid-saitek.c
@@ -191,6 +191,8 @@ static const struct hid_device_id saitek_devices[] = {
 		.driver_data = SAITEK_RELEASE_MODE_RAT7 },
 	{ HID_USB_DEVICE(USB_VENDOR_ID_SAITEK, USB_DEVICE_ID_SAITEK_MMO7),
 		.driver_data = SAITEK_RELEASE_MODE_MMO7 },
+	{ HID_USB_DEVICE(USB_VENDOR_ID_MADCATZ, USB_DEVICE_ID_MADCATZ_MMO7),
+		.driver_data = SAITEK_RELEASE_MODE_MMO7 },
 	{ }
 };
 
-- 
2.35.1



