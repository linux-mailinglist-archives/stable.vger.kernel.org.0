Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C9602488F09
	for <lists+stable@lfdr.de>; Mon, 10 Jan 2022 04:51:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238401AbiAJDvc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 9 Jan 2022 22:51:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232923AbiAJDvc (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 9 Jan 2022 22:51:32 -0500
Received: from mail-io1-xd35.google.com (mail-io1-xd35.google.com [IPv6:2607:f8b0:4864:20::d35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11960C06173F;
        Sun,  9 Jan 2022 19:51:32 -0800 (PST)
Received: by mail-io1-xd35.google.com with SMTP id y11so15805695iod.6;
        Sun, 09 Jan 2022 19:51:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNBC/oa1C06atiUI8JoU3/mwMH2He5G7E5WhcwLerxg=;
        b=HkKhjvlX14bIovxZd+pmez8zuae9mDQaQO+RG3wAwv3RzBZGr04xgntkmcrYG7lEFN
         goo+DdEVw9YPK+JpkiqTLvRF3Qwes3kAWZeoLI9NCwWdtRnrzholOPV7aEEhMEpmdQfE
         hnh31lyyPO/it2i565Ko+HGz+EOjc9egiGm2pcA5s1yhAAy8KqnEXWposlVLKmeHXlZF
         sQcmpBQtUmn48jhgBw1d3hjfqv2yTNI+ypwt3c/QOF6CdiljPg4jv0MSSdk6nnb6bSRW
         mw+GhhnSnz6UOl2Ir5Sf9PzBOSug8fr5Erv64IL/lMODD0O7BdN1PRt09RyiLb200sO+
         OQsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pNBC/oa1C06atiUI8JoU3/mwMH2He5G7E5WhcwLerxg=;
        b=drinUdsM0EIjlbr+D7jfs1Y4mlqFD0e3mePYLXVR2kaHEiHuH0t8DjXA7PtzZcWGZX
         rFNZSOdtgFU7Yr0gtoVg3kKjLFE4+wWeHfLuLa45YVJiKgcFfRbu2HHBlUQUIWGXfH66
         rADPi2CEOdBq3faUZZQawphbyF8s0aytzE5zgjY7838jNsDC0lNYGenQc2UQkV5f082W
         cTqyoAvmsTGCR2wWZvsSF/ezOGHbuK099RndSrHH2viBIBc540Sm4tKD/vOdHzB+z+x+
         AeybTtWt+Ky5Bv+6s5yMQ3nflz/BHtCEN8M2dKUfHML+gmA8nhzBaA34TEIgMoFxDNxD
         T3ow==
X-Gm-Message-State: AOAM5327FfFOhw5NPXzGQgiqT6O/SwPBB1gOuNP6rq1bgHskZyP3z8py
        oNgRGmAru+cHo+aHr6Zc23rO9i2KAcU=
X-Google-Smtp-Source: ABdhPJzaKs5mQg0z2k9usWK8CBOb8QPBDkauwThYV2HjrU9gp83Mq4ytVf8TavBfwivmvPW4QamPwA==
X-Received: by 2002:a02:cf39:: with SMTP id s25mr32394962jar.17.1641786691172;
        Sun, 09 Jan 2022 19:51:31 -0800 (PST)
Received: from speedbean.monkey.lan ([2601:282:8100:7:fcb0:7ceb:152:3c49])
        by smtp.gmail.com with ESMTPSA id c18sm3761372iod.18.2022.01.09.19.51.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 09 Jan 2022 19:51:30 -0800 (PST)
From:   Karl Kurbjun <kkurbjun@gmail.com>
To:     linux-input@vger.kernel.org
Cc:     Jiri Kosina <jkosina@suse.cz>, stable@vger.kernel.org,
        Karl Kurbjun <kkurbjun@gmail.com>
Subject: [PATCH] HID: Ignore battery for Elan touchscreen on HP Envy X360 15t-dr100
Date:   Sun,  9 Jan 2022 20:49:35 -0700
Message-Id: <20220110034935.15623-1-kkurbjun@gmail.com>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Battery status on Elan tablet driver is reported for the HP ENVY x360
15t-dr100. There is no separate battery for the Elan controller resulting
in a battery level report of 0% or 1% depending on whether a stylus has
interacted with the screen. These low battery level reports causes a
variety of bad behavior in desktop environments. This patch adds the
appropriate quirk to indicate that the batery status is unused for this
target.

Signed-off-by: Karl Kurbjun <kkurbjun@gmail.com>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 19da07777d62..a5a5a64c7abc 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -398,6 +398,7 @@
 #define USB_DEVICE_ID_HP_X2		0x074d
 #define USB_DEVICE_ID_HP_X2_10_COVER	0x0755
 #define I2C_DEVICE_ID_HP_ENVY_X360_15	0x2d05
+#define I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100	0x29CF
 #define I2C_DEVICE_ID_HP_SPECTRE_X360_15	0x2817
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index 03f994541981..ca47682cc730 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -329,6 +329,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_ENVY_X360_15T_DR100),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_HP_SPECTRE_X360_15),
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
-- 
2.34.1

