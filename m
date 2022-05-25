Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 750E25346E5
	for <lists+stable@lfdr.de>; Thu, 26 May 2022 01:08:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344940AbiEYXIv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 25 May 2022 19:08:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230474AbiEYXIv (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 25 May 2022 19:08:51 -0400
Received: from mail-wr1-x42e.google.com (mail-wr1-x42e.google.com [IPv6:2a00:1450:4864:20::42e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DD7066ADA;
        Wed, 25 May 2022 16:08:50 -0700 (PDT)
Received: by mail-wr1-x42e.google.com with SMTP id s28so46064wrb.7;
        Wed, 25 May 2022 16:08:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+b9gdnTinL6wrIHBf3f+AZedWLGvYQrCm3phP+L7gc=;
        b=SbRB6SK8sQPWbrRGSU761H8nBWHJsfx8Bg9QcJ51xiDXODS7GffWQW83pCHPUbK4cd
         JW7zAE5piQLv+h+UYcyqjP3uVLqTsdAG/Y69LhJjZqC7Hr0QD8vbC5jHkbWUKH8NnjKv
         /kYrponui1LJNLNKmTzdqpMCf+y/BTlvfHUo/ZCNCYo8m5BKHYEM3fWlL4AzyR4h2+CG
         T/GrXrvy6kDgv5sUmM0q1QfPo3Ig4ukwfwpNDTGzfPllUTSIHuD0RNsqyFe96rwccxdB
         3LMU5/1t+94vFUJ8CnEnkqjMDkcLq3nyWrGqDm99zf6HLQdxDrmKAsyHOQXZf1dFR3KV
         J4tg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=w+b9gdnTinL6wrIHBf3f+AZedWLGvYQrCm3phP+L7gc=;
        b=QagwPMhI8dsf9PKRjp5MURSLucsNx9WIHZKykP0j1fRXWwQeHy0bZ63YBsOpXb5M60
         2AlIL64ukIODKW4bKVLs/dDtk3aa/1vjz+dDT4k6LTkR7ARdyfzWbl8Pw7iO/0ZQo05g
         KfI6pHC77muZeJEUB1OspsJRoVKjsVJa+caLceM7RZ98HcU4xFrCFioJpXwW0BNHVtaS
         HnMrPKLpcpe26+16ewxKCZZvWuy5/LI7/3V8Rp/fnNvW0Qc9gimDULyiwkMEB3I3apho
         aBpNmNqOknZ1NxvVPp1UzGOWCtJgsEFvPpsdsDJmvBqiurXXpNKFygxMFI8Vo0smkX9j
         fOHw==
X-Gm-Message-State: AOAM530/aLjU1auEALEBiYnXa33E/TpeSNf9ODGR0F1QQAYLfN3jdGem
        qGD6NA1PjuMraaGKQOOxyZ8=
X-Google-Smtp-Source: ABdhPJwfE6vKfOV8ZO5UcmyYQlQzCwmf+EHSy8a8/Hu3S3epV571AJEfewLyUGlpgX20HaW8HMTgLw==
X-Received: by 2002:a5d:47ce:0:b0:20f:d6b5:4648 with SMTP id o14-20020a5d47ce000000b0020fd6b54648mr16009719wrc.73.1653520127956;
        Wed, 25 May 2022 16:08:47 -0700 (PDT)
Received: from xws.localdomain (pd9e5a94a.dip0.t-ipconnect.de. [217.229.169.74])
        by smtp.gmail.com with ESMTPSA id i7-20020adff307000000b0020fe280aa96sm112627wro.107.2022.05.25.16.08.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 25 May 2022 16:08:47 -0700 (PDT)
From:   Maximilian Luz <luzmaximilian@gmail.com>
To:     Jiri Kosina <jikos@kernel.org>
Cc:     Maximilian Luz <luzmaximilian@gmail.com>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: [PATCH] HID: hid-input: add Surface Go battery quirk
Date:   Thu, 26 May 2022 01:08:27 +0200
Message-Id: <20220525230827.1019662-1-luzmaximilian@gmail.com>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Similar to the Surface Go (1), the (Elantech) touchscreen/digitizer in
the Surface Go 2 mistakenly reports the battery of the stylus. Instead
of over the touchscreen device, battery information is provided via
bluetooth and the touchscreen device reports an empty battery.

Apply the HID_BATTERY_QUIRK_IGNORE quirk to ignore this battery and
prevent the erroneous low battery warnings.

Cc: stable@vger.kernel.org
Signed-off-by: Maximilian Luz <luzmaximilian@gmail.com>
---
 drivers/hid/hid-ids.h   | 1 +
 drivers/hid/hid-input.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index d9eb676abe96..9c4e92a9c646 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -413,6 +413,7 @@
 #define USB_DEVICE_ID_ASUS_UX550VE_TOUCHSCREEN	0x2544
 #define USB_DEVICE_ID_ASUS_UX550_TOUCHSCREEN	0x2706
 #define I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN	0x261A
+#define I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN	0x2A1C
 
 #define USB_VENDOR_ID_ELECOM		0x056e
 #define USB_DEVICE_ID_ELECOM_BM084	0x0061
diff --git a/drivers/hid/hid-input.c b/drivers/hid/hid-input.c
index c6b27aab9041..48c1c02c69f4 100644
--- a/drivers/hid/hid-input.c
+++ b/drivers/hid/hid-input.c
@@ -381,6 +381,8 @@ static const struct hid_device_id hid_battery_quirks[] = {
 	  HID_BATTERY_QUIRK_IGNORE },
 	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO_TOUCHSCREEN),
 	  HID_BATTERY_QUIRK_IGNORE },
+	{ HID_I2C_DEVICE(USB_VENDOR_ID_ELAN, I2C_DEVICE_ID_SURFACE_GO2_TOUCHSCREEN),
+	  HID_BATTERY_QUIRK_IGNORE },
 	{}
 };
 
-- 
2.36.1

