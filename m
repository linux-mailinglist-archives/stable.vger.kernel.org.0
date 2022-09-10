Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71D7E5B4928
	for <lists+stable@lfdr.de>; Sat, 10 Sep 2022 23:17:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229925AbiIJVRi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 10 Sep 2022 17:17:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229918AbiIJVRM (ORCPT
        <rfc822;stable@vger.kernel.org>); Sat, 10 Sep 2022 17:17:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C557A36DD0;
        Sat, 10 Sep 2022 14:16:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D06D9B8093B;
        Sat, 10 Sep 2022 21:16:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7DA2C43470;
        Sat, 10 Sep 2022 21:16:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662844608;
        bh=A1g0Ic9PM5dTsnBfy4geYgcgyJ4UvSzheMVF6DJzDP0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Ngc2URd6IzfHOAvRM+urkUTIwsw6p3lcyCzlbYA0tub8mVAgij2zLfMJsF/ESmrmy
         YTQ4b7lrE7AJO8b5Dne02AnpBoIjbDMooLUHCs9zD3+I2BWDQB9Die0jAJ/1eMhoYH
         DgdDXc866tP1fveyFsKOovtXqXe2JowaP2sHYf0cqwyQZoMI1fmBfYVbViDRkcJuS6
         2pXibNp5F+9EpZ31Htn0h7JVVd6iNC6c5hzjdRPPxvdFV72TAUTrnKxga5mNVXBrmj
         iLDpHUCET+vfSPo3k40RtnR0Y9BieF5u7ch5aNzonxBEI5ztyjFTUxDesGnt/JJeqB
         /mI8tUFgwDqtg==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Steev Klimaszewski <steev@kali.org>, Jiri Kosina <jkosina@suse.cz>,
        Sasha Levin <sashal@kernel.org>, jikos@kernel.org,
        benjamin.tissoires@redhat.com, linux-input@vger.kernel.org
Subject: [PATCH AUTOSEL 5.19 14/38] HID: add Lenovo Yoga C630 battery quirk
Date:   Sat, 10 Sep 2022 17:15:59 -0400
Message-Id: <20220910211623.69825-14-sashal@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220910211623.69825-1-sashal@kernel.org>
References: <20220910211623.69825-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

From: Steev Klimaszewski <steev@kali.org>

[ Upstream commit 3a47fa7b14c7d9613909a844aba27f99d3c58634 ]

Similar to the Surface Go devices, the Elantech touchscreen/digitizer in
the Lenovo Yoga C630 mistakenly reports the battery of the stylus, and
always reports an empty battery.

Apply the HID_BATTERY_QUIRK_IGNORE quirk to ignore this battery and
prevent the erroneous low battery warnings.

Signed-off-by: Steev Klimaszewski <steev@kali.org>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 9c4e92a9c6460..f7e4a0d06fb85 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -414,6 +414,7 @@
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
 #define I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN	0x2A1C
+#define I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN	0x279F
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 48c1c02c69f4e..17a453bb09a2d 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -383,6 +383,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_LENOVO_YOGA_C630_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.35.1

