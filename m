Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F5606ED1E0
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 18:01:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231855AbjDXQBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Apr 2023 12:01:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231770AbjDXQBP (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Apr 2023 12:01:15 -0400
Received: from mail-ej1-x62c.google.com (mail-ej1-x62c.google.com [IPv6:2a00:1450:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 971326A59
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 09:01:13 -0700 (PDT)
Received: by mail-ej1-x62c.google.com with SMTP id a640c23a62f3a-94f6c285d22so841647466b.2
        for <stable@vger.kernel.org>; Mon, 24 Apr 2023 09:01:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682352072; x=1684944072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ItXk9sOTul8nHcQoQ5OMTNAOIPvFkgfn2LiOsp6dVh0=;
        b=A98E6RSSxhUqhBadttwvToEIPQtUZ0mPjxzjyU/Mim0Lf27+ucjlh9vx5EJpiAKR9o
         s+VdC3LYCGvdDbRpjZqaAaJRDEzr6ZqeulhvVhZ+ked7yhukf0hOni56WkJ2NQTaWBoi
         wQPgSyFBDgbWNtUId7uZ1HKtmQGE2jusMyJvgpeHu2Tz+MJT8aPBtLWcArcxM5nD+HAJ
         6Ct5Mlz2q8bbcCl8cNYDXzcBOxgHl7nFNuR/WcHJMiRBuHiArPbpfe4HpruRSOriA3s/
         xigazvQbMa0by/5CgQwhdGjhT3zeq3J5PK87PMEZwEU//gqYN1lp+5KqNhEL4cFFRkaV
         j37A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682352072; x=1684944072;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ItXk9sOTul8nHcQoQ5OMTNAOIPvFkgfn2LiOsp6dVh0=;
        b=i9zJWSWWm/jqC7KeWpXfwfIQL/dwIqkJP9EpM4pK+16y9Po+kxWFoqj35BJB6NMRoA
         swuDEjZLXXTrgFneB46Memdtxy9rgvP0HgikkhZSDrXaPhzg+1i6qXlHW3Xhj0IGAo0U
         PVbVcOFX6tA6UvQ8EFjW9WDzxPJPeqtTZPuIogQ88h3BhBSEoRqlNj+dSrGasEAGRD08
         K9OT60sHGBezNJv91YsYFolzFuGfSU+XKjCtze483My6qaRUevPEFFoTlBiDp094R7iL
         Bg/ncX/TEP7Yq/Q7ghJK6VmlrQfuOnh0/iX0D77dQeaMpEQr5AHWMrCXL49CumPdyUWT
         4Eew==
X-Gm-Message-State: AAQBX9eeqnxlAE3igSlhT2ZWm4SUV3ZXKwiqZ2jbxbe06f8n9a8ca7jM
        evJmRzTvj+OGPRB2rgf/44w2fg==
X-Google-Smtp-Source: AKy350a+fhIV7M5cXo7+HmyMP6SNbnABDOalrjajHuvMxEIjPJCMkgiw02UjrpIcuXQxRcLwA+5IRQ==
X-Received: by 2002:a17:907:6d24:b0:94a:9f9a:b3c4 with SMTP id sa36-20020a1709076d2400b0094a9f9ab3c4mr11161282ejc.49.1682352071911;
        Mon, 24 Apr 2023 09:01:11 -0700 (PDT)
Received: from fedora.. ([195.167.132.10])
        by smtp.gmail.com with ESMTPSA id g10-20020a170906594a00b008cecb8f374asm5665879ejr.0.2023.04.24.09.01.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 24 Apr 2023 09:01:11 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.4 v5 1/2] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Mon, 24 Apr 2023 12:01:04 -0400
Message-Id: <20230424160106.4415-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.40.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable
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
Cc: <stable@vger.kernel.org> # 5.4.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 30 ++++--------------------------
 1 file changed, 4 insertions(+), 26 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index f261a57af1c..919d6f1ced8 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -57,10 +57,6 @@ struct quad8_iio {
 
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
 
 		mutex_lock(&priv->lock);
 
@@ -639,19 +627,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8_iio *const priv = counter->priv;
 	const int base_offset = priv->base + 2 * count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
-	unsigned long position;
+	unsigned long position = 0;
 	int i;
 
-	flags = inb(base_offset + 1);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	position = (unsigned long)(borrow ^ carry) << 24;
-
 	mutex_lock(&priv->lock);
 
 	/* Reset Byte Pointer; transfer Counter to Output Latch */
@@ -1204,8 +1182,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
+	return sprintf(buf, "16777215\n");
 }
 
 static ssize_t quad8_count_ceiling_write(struct counter_device *counter,

base-commit: 58f42ed1cd31238745bddd943c4f5849dc83a2ac
-- 
2.40.0

