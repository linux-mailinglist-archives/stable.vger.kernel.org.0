Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AE70C3CEF9F
	for <lists+stable@lfdr.de>; Tue, 20 Jul 2021 01:15:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241111AbhGSWS6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 18:18:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60696 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346539AbhGSUPS (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 19 Jul 2021 16:15:18 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B944BC061762;
        Mon, 19 Jul 2021 13:54:17 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id p4-20020a17090a9304b029016f3020d867so996093pjo.3;
        Mon, 19 Jul 2021 13:55:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9XC1U01PZSZTEYtwmGzB+/FSp9gyv7FlSh+467nObk=;
        b=aG/6shL9LTqm2pl+TFGNYDVOdqwlnLv9VZlMQTjYjOx1n52kowKRgdRmtM5Xwb59U/
         HURFdosEYqp8cnGqQQp2VRxXqmTM1bftN7g0nY/SOe8jCYaZDfNP4oWU9bfMtIlwKRi/
         f8I2sYU7Q7eGJmsRzBmZLKULcHkIalnBa3zqbBP+5b1MJ2hlbhhuQsBOv6i28lmY1OSf
         elGsZMlZZqaT8UNo72PLH4wDpQQVu1/0NqpSFaUrTwk1RqXzfHLyT1S9wYelWCkQ2/n9
         tCOF+Crhk+/iq/lmLsfwu8GHyuA6t3uA++GsvIyYqg9Q2tyDCqJrj5mSfgGIKEFpNisL
         tfbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=u9XC1U01PZSZTEYtwmGzB+/FSp9gyv7FlSh+467nObk=;
        b=Um92DUOIQHkaUH9Zh4wChFx7ZD0dDwsXtAwPUzzU4gfhBsksrD1dPauA7tPeGdw1xe
         IhrzbD+2eepewIM3vz7p5HUc4Sm3myOWkYwDzUUObhjl4X30qfmTmQVD/QcSilqZPzIo
         qk0cMskA/9s+m66AkQIPhqluFe2qSs7i3dIsNBqyeJVOzCqcY/8qPHkLF5f8b96cWhTE
         vHtrwDyoJ5raPUQvO+iymCcN0ITSeE3kK+jhsa2tRfL/fNaTPsxei5hZ1ZH3Pp+ap3Za
         jZYJN0Tu1GTTEh+zjLShwgu5sJy4pGhzlLEXSkMBRoZqJMttvMeW3mouMiB7fwValRf9
         rWzg==
X-Gm-Message-State: AOAM532+DXT36tLgLGyVZVXo0EaLF8TDRio834xh6NVkUjVluhNXFaaN
        vX6Oo4gB6515oKp7pLpfBPmDT1Ndeho4qg==
X-Google-Smtp-Source: ABdhPJz0kP/3R5tJiG/EF/VpmbfPdaT2p8ywtwP5dnOzYubGCzEuw5iXwslEPXSTuv4a4rrYKTwOZA==
X-Received: by 2002:a17:90a:6d63:: with SMTP id z90mr27576948pjj.177.1626728142836;
        Mon, 19 Jul 2021 13:55:42 -0700 (PDT)
Received: from horus.lan (71-34-86-28.ptld.qwest.net. [71.34.86.28])
        by smtp.gmail.com with ESMTPSA id y82sm21451233pfb.121.2021.07.19.13.55.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 19 Jul 2021 13:55:42 -0700 (PDT)
From:   Jason Gerecke <killertofu@gmail.com>
X-Google-Original-From: Jason Gerecke <jason.gerecke@wacom.com>
To:     linux-input@vger.kernel.org, Jiri Kosina <jikos@kernel.org>,
        Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Ping Cheng <pinglinux@gmail.com>,
        Jason Gerecke <jason.gerecke@wacom.com>,
        stable@vger.kernel.org, Ping Cheng <ping.cheng@wacom.com>
Subject: [PATCH 1/6] HID: wacom: Re-enable touch by default for Cintiq 24HDT / 27QHDT
Date:   Mon, 19 Jul 2021 13:55:28 -0700
Message-Id: <20210719205533.2189804-1-jason.gerecke@wacom.com>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Commit 670e90924bfe ("HID: wacom: support named keys on older devices")
added support for sending named events from the soft buttons on the
24HDT and 27QHDT. In the process, however, it inadvertantly disabled the
touchscreen of the 24HDT and 27QHDT by default. The
`wacom_set_shared_values` function would normally enable touch by default
but because it checks the state of the non-shared `has_mute_touch_switch`
flag and `wacom_setup_touch_input_capabilities` sets the state of the
/shared/ version, touch ends up being disabled by default.

This patch sets the non-shared flag, letting `wacom_set_shared_values`
take care of copying the value over to the shared version and setting
the default touch state to "on".

Fixes: 670e90924bfe ("HID: wacom: support named keys on older devices")
CC: stable@vger.kernel.org # 5.4+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Reviewed-by: Ping Cheng <ping.cheng@wacom.com>
---
 drivers/hid/wacom_wac.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hid/wacom_wac.c b/drivers/hid/wacom_wac.c
index 81d7d12bcf34..496a000ef862 100644
--- a/drivers/hid/wacom_wac.c
+++ b/drivers/hid/wacom_wac.c
@@ -3831,7 +3831,7 @@ int wacom_setup_touch_input_capabilities(struct input_dev *input_dev,
 		    wacom_wac->shared->touch->product == 0xF6) {
 			input_dev->evbit[0] |= BIT_MASK(EV_SW);
 			__set_bit(SW_MUTE_DEVICE, input_dev->swbit);
-			wacom_wac->shared->has_mute_touch_switch = true;
+			wacom_wac->has_mute_touch_switch = true;
 		}
 		fallthrough;
 
-- 
2.32.0

