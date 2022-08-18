Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A53F5987B7
	for <lists+stable@lfdr.de>; Thu, 18 Aug 2022 17:45:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235036AbiHRPo3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Aug 2022 11:44:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343725AbiHRPoX (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Aug 2022 11:44:23 -0400
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51AD399B53;
        Thu, 18 Aug 2022 08:44:22 -0700 (PDT)
Received: by mail-ej1-x631.google.com with SMTP id k26so3976018ejx.5;
        Thu, 18 Aug 2022 08:44:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc;
        bh=+KEQEXdVW07odh0Ewbkh0xV5rBKsuf8MuFMSnAKQKbE=;
        b=ZZjyx+D9DN6ssFXGJ5HD58G+rcfwNlAA9vrfHBeqSb1oLIzSq7ZPW47iLkbOV4NUfQ
         zxibJcS763VR0bu8GOLhYWeRygz4vWkZzDxr0iO8k6GGq2yAQ8gojaL9EV3g+dzB2ACH
         8DcDhVFUzDhn17nq9j8EuV8XNfmKECk6quErNku8B7knXDEMdA3MIyerktfw/kZs+j7l
         Hp7A41hp0tBDzakFl3jV94+onZXcalPWGwkejpxPK+7KPMvpyEjl22vK9cSAKy3YkZh2
         RR+rilZ1x82cRqBNDqHOftCjManh9ZQYJJWxlrWwcQkGNFis7iciZ6w2kK4kXIKV2rgX
         l7rA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc;
        bh=+KEQEXdVW07odh0Ewbkh0xV5rBKsuf8MuFMSnAKQKbE=;
        b=Ny6hoaUMsKUyGXMG/+2LBgmoGV2MExuWoUUoiSGKd9FhkhCDdAtaWZGNqYcJPq7hWv
         s9wkJniCO3LzhyeV6tPbBswV01lDzHt2kICuZ8H7OqHw9iVxEaPo9uWYZYr1cWsFeSc3
         E+HiQYwiWIBm0SFXPf3kfyslN9GSpKvwiIHKLSkA0VL5DBU4d+P9/patVxn0yvJ4sys7
         ONl1xdHe+9+L0vSOTjERGXLNIKV7h48slwDPrwNPQS+6GXYcM+8NU6aBmQ/n1zIwQBbF
         Kzr8wU8/ItOHhzS/6iKb8iaVuKjqs9Lhc0OvxDaBPfwDlKra3YauxSdp3aaYw8I+lAXP
         m11g==
X-Gm-Message-State: ACgBeo3DC4dWKwRnUjOPJ1AEiUX+zYy50x/GLmUticUh1ycLO6gCTar+
        EiK9RlrRxWeAb02uLj5PyOWE5VFmX2wLBw==
X-Google-Smtp-Source: AA6agR4qur4O1WJBCwc6VHF2vXdtKJWbXP6y8sNLOPr8jf/JTTg+lpj7s4z6/0o6/W9KmP2/71hYKQ==
X-Received: by 2002:a17:906:7950:b0:730:f098:86ce with SMTP id l16-20020a170906795000b00730f09886cemr2170428ejo.390.1660837460713;
        Thu, 18 Aug 2022 08:44:20 -0700 (PDT)
Received: from deepwhite.fritz.box ([2001:9e8:220d:e00:f78b:3e64:f8af:69ef])
        by smtp.gmail.com with ESMTPSA id v1-20020a170906292100b0073a62f3b447sm997486ejd.44.2022.08.18.08.44.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 08:44:20 -0700 (PDT)
From:   Pavel Rojtberg <rojtberg@gmail.com>
X-Google-Original-From: Pavel Rojtberg < rojtberg@gmail.com >
To:     linux-input@vger.kernel.org, dmitry.torokhov@gmail.com,
        gregkh@linuxfoundation.org
Cc:     Cameron Gutman <aicommander@gmail.com>, stable@vger.kernel.org,
        Pavel Rojtberg <rojtberg@gmail.com>
Subject: [PATCH v2 2/4] Input: xpad - fix wireless 360 controller breaking after suspend
Date:   Thu, 18 Aug 2022 17:44:09 +0200
Message-Id: <20220818154411.510308-3-rojtberg@gmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220818154411.510308-1-rojtberg@gmail.com>
References: <20220818154411.510308-1-rojtberg@gmail.com>
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

From: Cameron Gutman <aicommander@gmail.com>

Suspending and resuming the system can sometimes cause the out
URB to get hung after a reset_resume. This causes LED setting
and force feedback to break on resume. To avoid this, just drop
the reset_resume callback so the USB core rebinds xpad to the
wireless pads on resume if a reset happened.

A nice side effect of this change is the LED ring on wireless
controllers is now set correctly on system resume.

Cc: stable@vger.kernel.org
Fixes: 4220f7db1e42 ("Input: xpad - workaround dead irq_out after suspend/ resume")
Signed-off-by: Cameron Gutman <aicommander@gmail.com>
Signed-off-by: Pavel Rojtberg <rojtberg@gmail.com>
---
 drivers/input/joystick/xpad.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/input/joystick/xpad.c b/drivers/input/joystick/xpad.c
index 629646b..4e01056 100644
--- a/drivers/input/joystick/xpad.c
+++ b/drivers/input/joystick/xpad.c
@@ -1991,7 +1991,6 @@ static struct usb_driver xpad_driver = {
 	.disconnect	= xpad_disconnect,
 	.suspend	= xpad_suspend,
 	.resume		= xpad_resume,
-	.reset_resume	= xpad_resume,
 	.id_table	= xpad_table,
 };
 
-- 
2.34.1

