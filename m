Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 605996EC314
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 01:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230184AbjDWXU6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 19:20:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229476AbjDWXU5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 19:20:57 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB9C610F0
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:55 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id 3f1490d57ef6-b980ec2a95cso4941865276.2
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682292055; x=1684884055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=7P/6zoNdnIVgVCEt5mDoPuKCp+7Gdkmg7/IH03tl/hc=;
        b=wEk96wY0BNTq4Si5T64xauv4RLRaJkGMx6CMD4mIf694zT68AiY4H/qDevf6Fehfqc
         JQOOaH/f+33/21XGfmN00faEd8Ew41fsJ357jQWHVdQda35ApZF71jWp1gAqCwMVs1F+
         +X8P1x4c3HO3v3jGE7q6d525dYGo+9FxUzp9Hp6ZW7kZ9rjKH0qqSEVhZluxNi+TNvj0
         WQjGb5YNeAn9TbOZUszCeGDDpm4ubTNVfUPTudWLST3e6X+6NdNpLDz0DaJAq93ehLBf
         K6EQIaA+8fFJ++AGF12JVUf0+3blgzzEGroRU9JcExEh5R3A4rOaXoI9kATzMiZkeUGp
         hy2g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682292055; x=1684884055;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7P/6zoNdnIVgVCEt5mDoPuKCp+7Gdkmg7/IH03tl/hc=;
        b=L5wS+m7wPpDL7p/KKRa2stwmT5LtsOTpSmvcP7phHjsbPySdesuD3YBLPO97MsNs0Y
         ZdZLpzqwY5KmUicCTTwKmkdwMVPM2XUvQ4ihA6XYZqKU4PIaauUmmDgMgrmQBDlHB6SQ
         3kuSAGEBFkM4bQ4ZKMiEAeLIdoK8deACioKpe+8Y7bgi86RBdoJ50VOV+rhZPpAnxGhh
         +bM3UOqWJasMCskZQ3lISegMoucCXOxaiZZJBA+ouQ48RUBdaTSvkKfArGXllTjmwPP1
         shi6E6MPvVX/s9nP9XFi5OTmTghoQlMlO0Tv8psUzMprrDym1AAncdx7E2Ehh5jI58I+
         9XgA==
X-Gm-Message-State: AAQBX9fK2YoIYxFxsUdvxdUZkofbRVCDdokEDA1HwT+jzZQajqhDm++0
        44NfNlK8qcHn2t9C8kJHQdYiUw==
X-Google-Smtp-Source: AKy350ZU8SD5UpSm8QXQFKQlKUpoJGlUSQa8uCIAy8admKw4hyfrd8JMtLXsezp3AJ+E4bCYPoR1OQ==
X-Received: by 2002:a25:cac4:0:b0:b8f:2047:181a with SMTP id a187-20020a25cac4000000b00b8f2047181amr8493235ybg.24.1682292055043;
        Sun, 23 Apr 2023 16:20:55 -0700 (PDT)
Received: from fedora.. ([198.136.190.5])
        by smtp.gmail.com with ESMTPSA id z205-20020a0dd7d6000000b0054f856bdc4dsm2607352ywd.38.2023.04.23.16.20.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 16:20:54 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 4.14 v4 1/5] iio: counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 23 Apr 2023 19:20:43 -0400
Message-Id: <20230423232047.12589-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 4aa3b75c74603c3374877d5fd18ad9cc3a9a62ed upstream.

The Counter (CNTR) register is 24 bits wide, but we can have an
effective 25-bit count value by setting bit 24 to the XOR of the Borrow
flag and Carry flag. The flags can be read from the FLAG register, but a
race condition exists: the Borrow flag and Carry flag are instantaneous
and could change by the time the count value is read from the CNTR
register.

Since the race condition could result in an incorrect 25-bit count
value, remove support for 25-bit count values from this driver.

Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
Cc: <stable@vger.kernel.org> # 4.14.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/iio/counter/104-quad-8.c | 10 +---------
 1 file changed, 1 insertion(+), 9 deletions(-)

diff --git a/drivers/iio/counter/104-quad-8.c b/drivers/iio/counter/104-quad-8.c
index 181585ae6e..bdb07694e2 100644
--- a/drivers/iio/counter/104-quad-8.c
+++ b/drivers/iio/counter/104-quad-8.c
@@ -64,9 +64,6 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
 	const int base_offset = priv->base + 2 * chan->channel;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
 	switch (mask) {
@@ -76,12 +73,7 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 			return IIO_VAL_INT;
 		}
 
-		flags = inb(base_offset + 1);
-		borrow = flags & BIT(0);
-		carry = !!(flags & BIT(1));
-
-		/* Borrow XOR Carry effectively doubles count range */
-		*val = (borrow ^ carry) << 24;
+		*val = 0;
 
 		/* Reset Byte Pointer; transfer Counter to Output Latch */
 		outb(0x11, base_offset + 1);

base-commit: df06e352f27a9f368ec6a3b077881c35d933e32c
-- 
2.40.0

