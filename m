Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2DE766A8B7D
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 23:06:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229486AbjCBWGy (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 2 Mar 2023 17:06:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229854AbjCBWGt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 2 Mar 2023 17:06:49 -0500
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B21E59E71
        for <stable@vger.kernel.org>; Thu,  2 Mar 2023 14:06:46 -0800 (PST)
Received: by mail-qt1-x834.google.com with SMTP id l18so970224qtp.1
        for <stable@vger.kernel.org>; Thu, 02 Mar 2023 14:06:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1677794805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=595Lzrfk9ZZdyXMZyGBrATdXcUsn/JJF/BAGuFzsFec=;
        b=q9WuQVRcQGJLXY3BAu1UJSkTSvvF1INVr1jkwYHInIoJV+Uqtz8CGfN1RJSrewwQyY
         TnagFtJVhOawMjgbufAar2d6mWYxR2ajsOuPVjIKJUAYydnhR2KGNo1xMi/oT1MsfRHK
         uam8jWsm0vRXugto4GCeO6FPz5gJtoqfC6tNnN7IcRGZF3vKhORpPi9jDH9uBYqhXIIo
         97GsyuCMlV5WVhB7bS3a2FIoOddClAuFAE8UeExs/scG80bhGu1TNbYmmZIlrurJlpHX
         zXLRy6x8NDzI14OVLEJJw7zVESq3wvmcY3IJjwMdKlzvsdwijOAnjHZ/Ti2eARtO7oze
         2t8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677794805;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=595Lzrfk9ZZdyXMZyGBrATdXcUsn/JJF/BAGuFzsFec=;
        b=jWMUVYuZ6+/iskhdXomIrzjFYm2UHAS3jiRfzlmwXfR2Xi+fr4hFV+6YMFxklw70I8
         Lo+Jsb11hK7nIRfOtQmXbTTqg2vS63zRFI41mHOtiLxDbH3JReCuHMIe2DveilZgbOTT
         Wpxxbd0P1fT1vXPVAyUn0sYD2fxdxk1Oq0c98Qt48P/DLrTNBzMgyajJEKYpYhlNnlpA
         NGhPtHGarowGcKXItosv0XkXYYqo3xZWvSfTESxNrLzH/2g+15jzQtTIUVvCrrUAlaBo
         H4nwMVdxkvbzHgAMj/udlpPeRFasrsnxtN7+DxZdHY0aATcPlz9CzYRf+NDrp6Br+0Va
         FZ3g==
X-Gm-Message-State: AO0yUKVLJdScodW5aHTzRdruYGXt37xD3SwPZzXghP4vVJ/BtZXA3qwu
        BknB4UQ7IRZBervRmwZ65yFBNlv89PP/XpTT
X-Google-Smtp-Source: AK7set/9MBtd+iJjRd54/HRa57T4mYovpBo3CmEJtLHoI+UdeNKSex3laftnTdJhaGJtNjJcjmVNRQ==
X-Received: by 2002:ac8:5b10:0:b0:3a9:818f:db3d with SMTP id m16-20020ac85b10000000b003a9818fdb3dmr19779078qtw.53.1677794805636;
        Thu, 02 Mar 2023 14:06:45 -0800 (PST)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id g5-20020ac87d05000000b003b68d445654sm527483qtb.91.2023.03.02.14.06.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Mar 2023 14:06:45 -0800 (PST)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linus.walleij@linaro.org, brgl@bgdev.pl
Cc:     linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org,
        techsupport@winsystems.com, stable@vger.kernel.org,
        William Breathitt Gray <william.gray@linaro.org>,
        Paul Demetrotion <pdemetrotion@winsystems.com>
Subject: [PATCH] gpio: ws16c48: Fix off-by-one error in WS16C48 resource region extent
Date:   Tue, 28 Feb 2023 03:11:26 -0500
Message-Id: <20230228081126.94280-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The WinSystems WS16C48 I/O address region spans offsets 0x0 through 0xA,
which is a total of 11 bytes. Fix the WS16C48_EXTENT define to the
correct value of 11 so that access to necessary device registers is
properly requested in the ws16c48_probe() callback by the
devm_request_region() function call.

Fixes: 2c05a0f29f41 ("gpio: ws16c48: Implement and utilize register structures")
Cc: Paul Demetrotion <pdemetrotion@winsystems.com>
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/gpio/gpio-ws16c48.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpio/gpio-ws16c48.c b/drivers/gpio/gpio-ws16c48.c
index e73885a4dc32..afb42a8e916f 100644
--- a/drivers/gpio/gpio-ws16c48.c
+++ b/drivers/gpio/gpio-ws16c48.c
@@ -18,7 +18,7 @@
 #include <linux/spinlock.h>
 #include <linux/types.h>
 
-#define WS16C48_EXTENT 10
+#define WS16C48_EXTENT 11
 #define MAX_NUM_WS16C48 max_num_isa_dev(WS16C48_EXTENT)
 
 static unsigned int base[MAX_NUM_WS16C48];

base-commit: 4827aae061337251bb91801b316157a78b845ec7
-- 
2.39.2

