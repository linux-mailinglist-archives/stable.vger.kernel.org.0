Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAA4A2927DC
	for <lists+stable@lfdr.de>; Mon, 19 Oct 2020 15:05:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727554AbgJSNFk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Oct 2020 09:05:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgJSNFk (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Oct 2020 09:05:40 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12DAAC0613CE;
        Mon, 19 Oct 2020 06:05:39 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id y20so12827897iod.5;
        Mon, 19 Oct 2020 06:05:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MXf5jVQAsxMLYqB9MCmwjJXhebTabJAJXVmudW/Ft+M=;
        b=EhrnQqyVLCVUon+4dGW21HTh/v5pcAHVhjkcS3+WCo8qPu7NJlYHFfA3p7UMGW48xw
         PYOIFz08LpDBZN5A8J3QXIo8EptcinJhVmhFwE+BpNDgJ5X4Wi7JCmxCPgM+71p75kjz
         6sZIEhAI7e/cARAA5al7tSVThw2/2cG161cFaRzMa2cLNo30ZfXrLXSVhFO8yNg2qZ/M
         pRj+K/+05lY1AOxemEuwlZbC7+cFDtNXXssB94LhCQDY+7Q/HVyVwfzmFEsaSvcWLHZj
         z9A8NSLCbwUjFS3lh2XJiB5+w7SRyMirHl+JH7PVBH/WD4mjvpzwtP+9aKJYRfFB1qGg
         RduQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=MXf5jVQAsxMLYqB9MCmwjJXhebTabJAJXVmudW/Ft+M=;
        b=nDCHiEWZ0vS9BNoYS2+DPIxE4EYGqAnemirX0UCgCnu35vuiD/KsSM6+rG9MT0AVQZ
         z81SKBz8akZsJzBwq0Lfi/RnyDZRmB91mIrD2nSc3h+3m8LpCbQGt+yr8/5rxQoukFcs
         MFv9LO+yLC4yOjIvyuF99NezoJ/cDGAAYGn6eQgFBFDN95Be7Wfpfdw6YApXyGlGQbj0
         U/VeEIICOLOeirRCxhPbSLHcIR03SZ/+2SHtpcpll9TW0KuSr1sKSM2JKi3bESU5W4AW
         SzVyD0eboFwBL92/W3fb6W2j0TGelTn96pAMIUCOKGgo5Y19kAhHyICwtUxGpOcN63iQ
         ihLw==
X-Gm-Message-State: AOAM533GGaRZPlPsMIcllBvCSjaaQdP4E+ilJgxNXBPP/ChAAeHTCxrX
        cZyWP8AICTLYVWxhtp6yvEJwCW0/OE0=
X-Google-Smtp-Source: ABdhPJxfOZzjXsWxny6Tl9+XSGZI0/Jg7KdsoLc9Kye0B+8n1REt9t8iAUBSGpQNx9qNOE9Xq/Lx/w==
X-Received: by 2002:a5e:8347:: with SMTP id y7mr10734827iom.1.1603112738278;
        Mon, 19 Oct 2020 06:05:38 -0700 (PDT)
Received: from pm2-ws13.praxislan02.com ([2001:470:8:67e:ba27:ebff:fee8:ce27])
        by smtp.gmail.com with ESMTPSA id r3sm10235551iog.55.2020.10.19.06.05.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Oct 2020 06:05:37 -0700 (PDT)
From:   Jason Andryuk <jandryuk@gmail.com>
To:     Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>,
        Henrik Rydberg <rydberg@bitmath.org>
Cc:     Jason Andryuk <jandryuk@gmail.com>, stable@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] hid-mt: Fix Cirque 121f touch release
Date:   Mon, 19 Oct 2020 09:05:32 -0400
Message-Id: <20201019130532.19959-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We're seeing the touchpad not send all the touch release events.  This
can result in the cursor getting stuck generating scroll events instead
of cursor movement for single finger motion.  With the cursor not
moving, users think the trackpad is broken.  With libinput-record, you
can see that it doesn't always get to a neutral state when there are no
fingers on the touchpad.

MT_QUIRK_STICKY_FINGERS was insufficient alone.  The timer often didn't
fire to release all the contacts.  MT_QUIRK_NOT_SEEN_MEANS_UP seems to
help with tracking the touches, and allows the timer to fire properly
when needed.

You can reproduce by touching the trackpad with 4 fingers spread out,
then pulling them all together and removing from the track pad.

libinput-record output without the patch:
  - evdev:
    - [  2, 591028,   4,   5, 2561700] # EV_MSC / MSC_TIMESTAMP        2561700
    - [  2, 591028,   0,   0,       0] # ------------ SYN_REPORT (0) ---------- +7ms
  - evdev:
    - [  2, 603307,   3,  57,      -1] # EV_ABS / ABS_MT_TRACKING_ID       -1
    - [  2, 603307,   1, 334,       1] # EV_KEY / BTN_TOOL_TRIPLETAP        1
    - [  2, 603307,   1, 335,       0] # EV_KEY / BTN_TOOL_QUADTAP          0
    - [  2, 603307,   4,   5, 2570700] # EV_MSC / MSC_TIMESTAMP        2570700
    - [  2, 603307,   0,   0,       0] # ------------ SYN_REPORT (0) ---------- +12ms

Note the lack of "# Touch device in neutral state".  There has been no
activity for 2 seconds, but the tripletap has not cleared.  If you place
a finger back on at this point, it gets interpreted as a quadtap.

With this patch:
  - evdev:
    - [1123, 442602,   3,  47,       3] # EV_ABS / ABS_MT_SLOT               3
    - [1123, 442602,   3,  54,     133] # EV_ABS / ABS_MT_POSITION_Y       133 (+4)
    - [1123, 442602,   3,  47,       2] # EV_ABS / ABS_MT_SLOT               2
    - [1123, 442602,   3,  53,     667] # EV_ABS / ABS_MT_POSITION_X       667 (-2)
    - [1123, 442602,   3,  54,     121] # EV_ABS / ABS_MT_POSITION_Y       121 (+4)
    - [1123, 442602,   3,  47,       1] # EV_ABS / ABS_MT_SLOT               1
    - [1123, 442602,   3,  57,      -1] # EV_ABS / ABS_MT_TRACKING_ID       -1
    - [1123, 442602,   1, 333,       1] # EV_KEY / BTN_TOOL_DOUBLETAP        1
    - [1123, 442602,   1, 334,       0] # EV_KEY / BTN_TOOL_TRIPLETAP        0
    - [1123, 442602,   3,   0,     667] # EV_ABS / ABS_X                   667 (+321)
    - [1123, 442602,   3,   1,     121] # EV_ABS / ABS_Y                   121 (-204)
    - [1123, 442602,   4,   5,  196500] # EV_MSC / MSC_TIMESTAMP        196500
    - [1123, 442602,   0,   0,       0] # ------------ SYN_REPORT (0) ---------- +5ms
  - evdev:
    - [1123, 544680,   3,  47,       2] # EV_ABS / ABS_MT_SLOT               2
    - [1123, 544680,   3,  57,      -1] # EV_ABS / ABS_MT_TRACKING_ID       -1
    - [1123, 544680,   3,  47,       3] # EV_ABS / ABS_MT_SLOT               3
    - [1123, 544680,   3,  57,      -1] # EV_ABS / ABS_MT_TRACKING_ID       -1
    - [1123, 544680,   1, 330,       0] # EV_KEY / BTN_TOUCH                 0
    - [1123, 544680,   1, 333,       0] # EV_KEY / BTN_TOOL_DOUBLETAP        0
    - [1123, 544680,   0,   0,       0] # ------------ SYN_REPORT (0) ---------- +102ms
                                     # Touch device in neutral state

Here the timer fired and cleared the lingering doubletap.

Create a new MT_CLS_CIRQUE by copying MT_CLS_WIN_8 and replacing
MT_QUIRK_ALWAYS_VALID with MT_QUIRK_NOT_SEEN_MEANS_UP
(MT_QUIRK_STICKY_FINGERS is already in MT_CLS_WIN_8).

Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
Cc: <stable@vger.kernel.org>

---
This is developed and tested against 5.4 and forward ported to latest
upstream.

I don't know if it needs to be quirked more specifically, but the
modalias is:
input:b0018v0488p121Fe0100-e0,1,3,4,k110,111,145,148,14A,14D,14E,14F,ra0,1,2F,35,36,37,39,m5,lsfw

I don't know if MT_CLS_CIRQUE needs the HID_DG_CONFIDENCE change, but it
is included to keep it as close as possible to MT_CLS_WIN_8.

I opened this bug originally with some libinput debugging info:
https://gitlab.freedesktop.org/libinput/libinput/-/issues/531

This might be related:
https://bugs.launchpad.net/dell-sputnik/+bug/1651635

With this patch I occasionally see an MSC_TIMESTAMP/SYN_REPORT come
through after "# Touch device in neutral stat".  Is that a problem, or
will it just be ignored?
---
 drivers/hid/hid-ids.h        |  3 +++
 drivers/hid/hid-multitouch.c | 18 +++++++++++++++++-
 2 files changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-ids.h b/drivers/hid/hid-ids.h
index 74fc1df6e3c2..7e153cf3ab16 100644
--- a/drivers/hid/hid-ids.h
+++ b/drivers/hid/hid-ids.h
@@ -278,6 +278,9 @@
 
 #define USB_VENDOR_ID_CIDC		0x1677
 
+#define I2C_VENDOR_ID_CIRQUE		0x0488
+#define I2C_PRODUCT_ID_CIRQUE_121F	0x121F
+
 #define USB_VENDOR_ID_CJTOUCH		0x24b8
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0020	0x0020
 #define USB_DEVICE_ID_CJTOUCH_MULTI_TOUCH_0040	0x0040
diff --git a/drivers/hid/hid-multitouch.c b/drivers/hid/hid-multitouch.c
index e3152155c4b8..96e653e50e83 100644
--- a/drivers/hid/hid-multitouch.c
+++ b/drivers/hid/hid-multitouch.c
@@ -208,6 +208,7 @@ static void mt_post_parse(struct mt_device *td, struct mt_application *app);
 #define MT_CLS_GOOGLE				0x0111
 #define MT_CLS_RAZER_BLADE_STEALTH		0x0112
 #define MT_CLS_SMART_TECH			0x0113
+#define MT_CLS_CIRQUE				0x0114
 
 #define MT_DEFAULT_MAXCONTACT	10
 #define MT_MAX_MAXCONTACT	250
@@ -367,6 +368,14 @@ static const struct mt_class mt_classes[] = {
 			MT_QUIRK_CONTACT_CNT_ACCURATE |
 			MT_QUIRK_SEPARATE_APP_REPORT,
 	},
+	{ .name = MT_CLS_CIRQUE,
+		.quirks = MT_QUIRK_NOT_SEEN_MEANS_UP |
+			MT_QUIRK_IGNORE_DUPLICATES |
+			MT_QUIRK_HOVERING |
+			MT_QUIRK_CONTACT_CNT_ACCURATE |
+			MT_QUIRK_STICKY_FINGERS |
+			MT_QUIRK_WIN8_PTP_BUTTONS,
+		.export_all_inputs = true },
 	{ }
 };
 
@@ -758,7 +767,8 @@ static int mt_touch_input_mapping(struct hid_device *hdev, struct hid_input *hi,
 			MT_STORE_FIELD(inrange_state);
 			return 1;
 		case HID_DG_CONFIDENCE:
-			if (cls->name == MT_CLS_WIN_8 &&
+			if ((cls->name == MT_CLS_WIN_8 ||
+			     cls->name == MT_CLS_CIRQUE) &&
 				(field->application == HID_DG_TOUCHPAD ||
 				 field->application == HID_DG_TOUCHSCREEN))
 				app->quirks |= MT_QUIRK_CONFIDENCE;
@@ -1828,6 +1838,12 @@ static const struct hid_device_id mt_devices[] = {
 		MT_USB_DEVICE(USB_VENDOR_ID_CHUNGHWAT,
 			USB_DEVICE_ID_CHUNGHWAT_MULTITOUCH) },
 
+	/* Cirque devices */
+	{ .driver_data = MT_CLS_CIRQUE,
+		HID_DEVICE(BUS_I2C, HID_GROUP_MULTITOUCH_WIN_8,
+			I2C_VENDOR_ID_CIRQUE,
+			I2C_PRODUCT_ID_CIRQUE_121F) },
+
 	/* CJTouch panels */
 	{ .driver_data = MT_CLS_NSMU,
 		MT_USB_DEVICE(USB_VENDOR_ID_CJTOUCH,
-- 
2.26.2

