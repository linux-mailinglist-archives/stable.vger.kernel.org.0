Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9D656DDFFA
	for <lists+stable@lfdr.de>; Tue, 11 Apr 2023 17:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230259AbjDKPwg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 11 Apr 2023 11:52:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbjDKPwf (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 11 Apr 2023 11:52:35 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E973B4EC3
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:33 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id f188so40446242ybb.3
        for <stable@vger.kernel.org>; Tue, 11 Apr 2023 08:52:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1681228353; x=1683820353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R2fQ8lpuhAnY5CWWZIXFfg7wKiEfX2djoV2eUnsPPVc=;
        b=QeRpnyUOHzGwuIeP0MNJJWJHdCioAjOAx1apI5BRCq0IYAMc/njk8B75syYr9AqXE2
         tejgjgi07wNgTlMzVt7hopwjrFADlgs/D92apR5rb+ejmRJ1nEJbnEZMC4oLtN44t4DM
         /ZUauG7kYMGyCJXUv0YDarqKe929Ac22GVOww4nsqChyhez7viGB6+dBIDD5fe7F3Li1
         56IEUCdZw0+Fuws9CIpj52fOiWM6wGDf7RSk00d8j5XtxHmb+NcXuTmq2FBUtp68BGO2
         LFMnOce6hRQsYFA+/EhCW/NTi8KUgCXbqsgC4dzdfX3DUnbV/GBcjOe5RXfUea1y+7Zo
         Kq8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1681228353; x=1683820353;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=R2fQ8lpuhAnY5CWWZIXFfg7wKiEfX2djoV2eUnsPPVc=;
        b=Z6T3qSPOVlm36EWKaOYcsomh6VYdkuan6grdkBvK4KqScu1CrqvXKMxkC4gA1IA75C
         qNsKpQj0T5T4tuTtIvW16VaZygViBNZeXWgkdXw2a6rkkIEY+OKLK/Sq56J1lPjR6RSN
         /uTOpVrjhGxWZPt+XmW+ZzDtFZqHfLZhkXTFi7ZzciHsNOAFlQeqVV9rInWraum2IPjD
         UejUdTZ5IEe5otwCZovoJRJuQqZ1h70nfNkhFRUFJSkFYKC/5pGkvJutfJGw0qzZThbA
         eEbUDfOomdKTl4d7CO2hE+NX3ADKI/suC2lcUr1wnEKjErCYsKMXVA9gJOTML5ANzFKh
         9z6w==
X-Gm-Message-State: AAQBX9dv8MqDDHVANJuHKxeRYoTicnRPDsLSHCd0/14Ngk5cs2UteDEc
        lkgWrL5Z60ygsWd7GfU5HyZ13Q==
X-Google-Smtp-Source: AKy350YaiHBMwi9YMqi/fZ+eHfktwCe2cCyF5zaXDxiQxeUqS2HU922wdMU3rxmLbgmRzBoeF8wuaA==
X-Received: by 2002:a25:688a:0:b0:b8f:227a:b080 with SMTP id d132-20020a25688a000000b00b8f227ab080mr2237727ybc.18.1681228353118;
        Tue, 11 Apr 2023 08:52:33 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id i13-20020a056902068d00b00b7767ca749fsm3683390ybt.60.2023.04.11.08.52.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 11 Apr 2023 08:52:32 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [RESEND PATCH 4.19 v3 2/5] iio: counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Tue, 11 Apr 2023 11:52:17 -0400
Message-Id: <20230411155220.9754-2-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230411155220.9754-1-william.gray@linaro.org>
References: <20230411155220.9754-1-william.gray@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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
Cc: <stable@vger.kernel.org> # 4.19.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/iio/counter/104-quad-8.c | 14 +-------------
 1 file changed, 1 insertion(+), 13 deletions(-)

diff --git a/drivers/iio/counter/104-quad-8.c b/drivers/iio/counter/104-quad-8.c
index 92be8d0f77..92e68cada8 100644
--- a/drivers/iio/counter/104-quad-8.c
+++ b/drivers/iio/counter/104-quad-8.c
@@ -61,10 +61,6 @@ struct quad8_iio {
 
 #define QUAD8_REG_CHAN_OP 0x11
 #define QUAD8_REG_INDEX_INPUT_LEVELS 0x16
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -97,9 +93,6 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 {
 	struct quad8_iio *const priv = iio_priv(indio_dev);
 	const int base_offset = priv->base + 2 * chan->channel;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	int i;
 
 	switch (mask) {
@@ -110,12 +103,7 @@ static int quad8_read_raw(struct iio_dev *indio_dev,
 			return IIO_VAL_INT;
 		}
 
-		flags = inb(base_offset + 1);
-		borrow = flags & QUAD8_FLAG_BT;
-		carry = !!(flags & QUAD8_FLAG_CT);
-
-		/* Borrow XOR Carry effectively doubles count range */
-		*val = (borrow ^ carry) << 24;
+		*val = 0;
 
 		/* Reset Byte Pointer; transfer Counter to Output Latch */
 		outb(QUAD8_CTR_RLD | QUAD8_RLD_RESET_BP | QUAD8_RLD_CNTR_OUT,

base-commit: 5c0966408dee90137adf2e96f949e50a2ba7e401
-- 
2.39.2

