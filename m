Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84B58605123
	for <lists+stable@lfdr.de>; Wed, 19 Oct 2022 22:15:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230461AbiJSUPR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 19 Oct 2022 16:15:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbiJSUPP (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 19 Oct 2022 16:15:15 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0798B118741;
        Wed, 19 Oct 2022 13:15:06 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id x13so11488083qkg.11;
        Wed, 19 Oct 2022 13:15:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=P6ehJmZtaKjHfWDooxLByyg7Qm8nO8821wCtlJKz2+4=;
        b=TybltSlWY2qkowVbGkbhGUhl8GW5569umxbF7Wp6iG+ZXAuhuOylG8yjLXPo43vTZA
         dAabbW135Irpmk/ZJVBz1w3a4szDvKd7Dqfim+MtPKw7HA6Q6rElVHH1UEeH+Bwq16qk
         qtW6K4LiAVNCwVj+YAVZK2AVdn05XYfHM+5Zisi1UnbBb4mgqL/djqPx60S1WgFMFGxf
         DT8E7ijLIq5TjewGJ6yZvF33qampqKD28bJPN/sHzTIgAu7pKWqfOL0WwZGdiC77iomF
         uV6PwFQBRaOKse1ujXcu1EBwRjxIiPRbXDvBDCURMMUnwQne/kqKCqQ443yFSL/XonOU
         vKcA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P6ehJmZtaKjHfWDooxLByyg7Qm8nO8821wCtlJKz2+4=;
        b=OJhk5LFjxE3jj6DE/fBEBzVbtLWdj/gNptX5PwYI12o77EF3pP1CUJ3MHLkPBCq3wU
         kW9A0vMUlcv5l2TFgEjX36sKH1aFfHV58Sf45mWTSw9Loe/jwWbPjmZnYr1e3j828OFH
         DNdYWaweiZj8JmlXkS+WKnvEk+oO7bd5IJ4zygFCaaIgayspVuWfbwFe/QCRL5E+en2g
         tmNeTTMiN9lnJ4MIYyzYI6tqnqB+8lGSueCvDJI8ty1F+LZJRrTVtipkE9HyOew18+LL
         9ugaQAvE1EexNTGMJle46J4ShVnxGYugNVUpYQNZFOEvv4F1Hj5T/hLGf1HPvoQ8LOIm
         Z54A==
X-Gm-Message-State: ACrzQf12LKkUiVZteGdV8rpj9fdgY6vzzhDpUZU5jf4rdNzQqcSHilOX
        L9FgC48/MTlO4K9PbQctLdlJwAL9MdQ=
X-Google-Smtp-Source: AMsMyM4ZHmOVoj5agvIt9yLlHK+ps82y567FzoPncwvnc5+QX6N88fZlpsF0dCXNDa/n+eOBD4dBCg==
X-Received: by 2002:a05:620a:3708:b0:6ee:d16f:b780 with SMTP id de8-20020a05620a370800b006eed16fb780mr6861107qkb.144.1666210505337;
        Wed, 19 Oct 2022 13:15:05 -0700 (PDT)
Received: from pm2-ws13.praxislan02.com ([2001:470:8:67e:ba27:ebff:fee8:ce27])
        by smtp.gmail.com with ESMTPSA id bj3-20020a05620a190300b006eeca296c00sm5813448qkb.104.2022.10.19.13.15.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 19 Oct 2022 13:15:04 -0700 (PDT)
From:   Jason Andryuk <jandryuk@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     xen-devel@lists.xenproject.org, Jason Andryuk <jandryuk@gmail.com>,
        Phillip Susi <phill@thesusis.net>, stable@vger.kernel.org,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Subject: [PATCH] Input: xen-kbdfront - drop keys to shrink modalias
Date:   Wed, 19 Oct 2022 16:14:57 -0400
Message-Id: <20221019201458.21803-1-jandryuk@gmail.com>
X-Mailer: git-send-email 2.37.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

xen kbdfront registers itself as being able to deliver *any* key since
it doesn't know what keys the backend may produce.

Unfortunately, the generated modalias gets too large and uevent creation
fails with -ENOMEM.

This can lead to gdm not using the keyboard since there is no seat
associated [1] and the debian installer crashing [2].

Trim the ranges of key capabilities by removing some BTN_* ranges.
While doing this, some neighboring undefined ranges are removed to trim
it further.

This removes:
BTN_DPAD_UP(0x220)..BTN_DPAD_RIGHT(0x223)
Empty space 0x224..0x229

Emtpy space 0x2bd..0x2bf
BTN_TRIGGER_HAPPY(0x2c0)..BTN_TRIGGER_HAPPY40(0x2e7)
Empty space 0x2e8..0x2ff

The modalias shrinks from 2082 to 1754 bytes.

[1] https://github.com/systemd/systemd/issues/22944
[2] https://lore.kernel.org/xen-devel/87o8dw52jc.fsf@vps.thesusis.net/T/

Cc: Phillip Susi <phill@thesusis.net>
Cc: stable@vger.kernel.org
Signed-off-by: Jason Andryuk <jandryuk@gmail.com>
---
 drivers/input/misc/xen-kbdfront.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/input/misc/xen-kbdfront.c b/drivers/input/misc/xen-kbdfront.c
index 8d8ebdc2039b..23f37211be78 100644
--- a/drivers/input/misc/xen-kbdfront.c
+++ b/drivers/input/misc/xen-kbdfront.c
@@ -256,7 +256,14 @@ static int xenkbd_probe(struct xenbus_device *dev,
 		__set_bit(EV_KEY, kbd->evbit);
 		for (i = KEY_ESC; i < KEY_UNKNOWN; i++)
 			__set_bit(i, kbd->keybit);
-		for (i = KEY_OK; i < KEY_MAX; i++)
+		/* In theory we want to go KEY_OK..KEY_MAX, but that grows the
+		 * modalias line too long.  KEY_KBD_LCD_MENU5 is the last
+		 * defined non-button key. There is a gap of buttons from
+		 * BTN_DPAD_UP..BTN_DPAD_RIGHT and KEY_ALS_TOGGLE is the next
+		 * defined. */
+		for (i = KEY_OK; i < BTN_DPAD_UP; i++)
+			__set_bit(i, kbd->keybit);
+		for (i = KEY_ALS_TOGGLE; i <= KEY_KBD_LCD_MENU5; i++)
 			__set_bit(i, kbd->keybit);
 
 		ret = input_register_device(kbd);
-- 
2.37.3

