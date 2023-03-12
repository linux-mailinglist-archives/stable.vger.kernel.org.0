Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A814C6B6C72
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 00:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbjCLXQS (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 19:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229694AbjCLXQO (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 19:16:14 -0400
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C6FC26C33
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:12 -0700 (PDT)
Received: by mail-qt1-x82b.google.com with SMTP id l18so11596912qtp.1
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678662971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1ENeaBfRz6SWrwdqP2MAd7R+kpBfK8pfsSO8vxDCF0=;
        b=CfV0zlBWYVHfuG5Ac+jwlt2TyojmiibFnT65yzVqZ/bbCmqN8gjkqSx87zXSHMI7J6
         pzexBwB0OcS21QFryblC5W0RSnCK6/a3XpwlMFr3kPmFdA1NjUyMi3EO18p3Z33vRDDu
         DFE7d4afmp7NG8W6v4Ugu4zRfsTlfKCw8lK3MfvooXhZvggxf8ERYE8AskTSwJf5Rh2E
         1AmUOgdq2Qv8Md0ghQGk9kHbnfzyCuzQ/+MIznuPv9KAj3pqKFyrXxbCUT4uZVZHJOG7
         ky2xqW2wto1zSSfFCEd23y7QmAd46blC6Ssfm5c4JTGV+fWluybV7JIX1QjNfD1ums/9
         sTIA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678662971;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R1ENeaBfRz6SWrwdqP2MAd7R+kpBfK8pfsSO8vxDCF0=;
        b=b48whGUC4H1AtqUkYqDiy18sWFmEVMBK7EDgnpZtXRccM5k51c8LkkUzEa3TJNnNiB
         w+43uXSkQYMChua2iwtSb2Tls9Q8e+J66gMdFGEONppesNWVz+Zx0qRO8j098sBGbtue
         ZXiStsKrAQZQYycP9P4gPJepwWlPzvmL7BQyfBXOZVa1IVA8UEqQSRixj9d2BkOpkj7P
         zlc2OjEY6VwRWffmv0U/sZf6iDxgVpjhEVYKGpzl4+kcn+lHfHoXfGGDhlz9GjqR4JV5
         pgCUmpUvOV1OkiojRmyXCI4S7ltwRU9hwIx7CiVGr9l61LFLyMxQSRUgOZXoRj/6Y4/a
         ZTEg==
X-Gm-Message-State: AO0yUKXRS2jA4COEzTsWCJPHWn4mXTK+EsP1ltKWVItbDBOAaIKjMLcD
        6gwePa/ppAE/MB4fTuEYRjmTzw==
X-Google-Smtp-Source: AK7set9Zfnrah355ZP1Aoeye8QsXsctxC9ULMjRB5Vo95kUCOK8f40n+jxmPo1oZ4x4qKVaonfbvVA==
X-Received: by 2002:ac8:574d:0:b0:3bf:be8a:8f96 with SMTP id 13-20020ac8574d000000b003bfbe8a8f96mr15791823qtx.12.1678662971478;
        Sun, 12 Mar 2023 16:16:11 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id dm21-20020a05620a1d5500b00742f250ebc0sm4307091qkb.9.2023.03.12.16.16.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 16:16:11 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linux-iio@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.15 v3 2/6] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 12 Mar 2023 19:15:50 -0400
Message-Id: <20230312231554.134858-2-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230312231554.134858-1-william.gray@linaro.org>
References: <20230312231554.134858-1-william.gray@linaro.org>
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

The Counter (CNTR) register is 24 bits wide, but we can have an
effective 25-bit count value by setting bit 24 to the XOR of the Borrow
flag and Carry flag. The flags can be read from the FLAG register, but a
race condition exists: the Borrow flag and Carry flag are instantaneous
and could change by the time the count value is read from the CNTR
register.

Since the race condition could result in an incorrect 25-bit count
value, remove support for 25-bit count values from this driver.

Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 0caa60537..643aae0c9 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -61,10 +61,6 @@ struct quad8 {
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
 #define QUAD8_DIFF_ENCODER_CABLE_STATUS 0x17
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -121,17 +117,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
-	flags = inb(base_offset + 1);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	*val = (unsigned long)(borrow ^ carry) << 24;
+	*val = 0;
 
 	mutex_lock(&priv->lock);
 
@@ -699,8 +687,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
+	return sprintf(buf, "16777215\n");
 }
 
 static ssize_t quad8_count_ceiling_write(struct counter_device *counter,

base-commit: bbf9f29bac04f85bbf45af172dcdc9664d8808cb
-- 
2.39.2

