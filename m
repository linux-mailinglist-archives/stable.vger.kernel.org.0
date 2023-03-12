Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C4BB6B6BBF
	for <lists+stable@lfdr.de>; Sun, 12 Mar 2023 22:24:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjCLVYC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 17:24:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229731AbjCLVYB (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 17:24:01 -0400
Received: from mail-qt1-x82f.google.com (mail-qt1-x82f.google.com [IPv6:2607:f8b0:4864:20::82f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6EF72CFF2
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 14:23:59 -0700 (PDT)
Received: by mail-qt1-x82f.google.com with SMTP id l18so11448036qtp.1
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 14:23:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678656239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVLyQ0XiKSvnucCxXN1dJowGWmlgB/Dt3IZETGB50oM=;
        b=NZwlJLjToy+H13MwnYz3wpVEi3eqcyI3Ky/Z95chVi1Etbb7yll674a2Y2UmTnpnmX
         tWd2uorn3U/JuT9zzPi9GmyVOjdMmGBCP0opBRpZGY7fnpIJzGuEX2F/RvENibzPZhix
         T3xaDhFQxPl2+HZSt7MphB9HbflbScriwBEW+c7fgfgV3KgqCKNlYtb3keBmvPRCRl4n
         6xzHBHiHz70dAsqYR307Aee8/G/kQ6m2JPlQ7AQsItuaZabiNL7EONHNOPi/fBmb+Dey
         EBmu2HenQPEd7+/FcfWmlOR5R9ZKizQ394fe6zjr7yjMx5Tu7Np27KHNlF0T+9XQPBsz
         1rMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678656239;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZVLyQ0XiKSvnucCxXN1dJowGWmlgB/Dt3IZETGB50oM=;
        b=ZXuzmx3VS1853WemwlQkwhxQstuSus4xNBv5mmd5+/OiMeDbOsHOR9erEC3a5YH9Ic
         NtS0UvXB9g/2G4RBmjqG3h97DBy8XKqvYoKRyOuwKUTSAyA/Uu+M7yAkKUKsKORaXSmK
         OZk1OtM3xkDa/m4iNX4CnWYq00epK89kXQGf/9NkquaT6+/JE1xk7HYh4/GEvceOxFY3
         VKUn1gAMxp16fTEeoGlN6bmHVHLhawm1h+xs6rhXeTZWJnqtMp7owy7qGdg6TM/Gegmu
         gDQGmRALA1mTvvD9QuofzXDGczqstJwsgrnzWs4/IFKFSDkdLE3s4cuWhbk61gj3V0zm
         /5Pg==
X-Gm-Message-State: AO0yUKUOu7cD/SaNzp+ZqP4o2MbiQgp2aOtsOB6qEpey2d2vNSIxu520
        ZhjGHWkbsVofk4LppYM2X6Bu13m/EwDpRPmGYqw=
X-Google-Smtp-Source: AK7set/3JWlfc/2ZRHjNketi/SeZBKZTydDQmqOhfdBs0PJV6yIC3rVOfTjHRFuIIEip70Ig9+V9vg==
X-Received: by 2002:a05:622a:178b:b0:3bf:daae:7f34 with SMTP id s11-20020a05622a178b00b003bfdaae7f34mr26411301qtk.41.1678656238686;
        Sun, 12 Mar 2023 14:23:58 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id j23-20020ac85517000000b0039cc0fbdb61sm4285274qtq.53.2023.03.12.14.23.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 14:23:58 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linux-iio@vger.kernel.org
Cc:     jic23@kernel.org, linux-kernel@vger.kernel.org,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH v2] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 12 Mar 2023 17:23:47 -0400
Message-Id: <20230312212347.129756-1-william.gray@linaro.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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
value, remove support for 25-bit count values from this driver;
hard-coded maximum count values are replaced by a LS7267_CNTR_MAX define
for consistency and clarity.

Fixes: 28e5d3bb0325 ("iio: 104-quad-8: Add IIO support for the ACCES 104-QUAD-8")
Cc: stable@vger.kernel.org
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
Changes in v2:
 - Correct Fixes tag line in commit description
 - Add Cc tag line for stable@vger.kernel.org

 drivers/counter/104-quad-8.c | 29 +++++++----------------------
 1 file changed, 7 insertions(+), 22 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index deed4afadb29..dba04b5e80b7 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -97,10 +97,6 @@ struct quad8 {
 	struct quad8_reg __iomem *reg;
 };
 
-/* Borrow Toggle flip-flop */
-#define QUAD8_FLAG_BT BIT(0)
-/* Carry Toggle flip-flop */
-#define QUAD8_FLAG_CT BIT(1)
 /* Error flag */
 #define QUAD8_FLAG_E BIT(4)
 /* Up/Down flag */
@@ -133,6 +129,9 @@ struct quad8 {
 #define QUAD8_CMR_QUADRATURE_X2 0x10
 #define QUAD8_CMR_QUADRATURE_X4 0x18
 
+/* Each Counter is 24 bits wide */
+#define LS7267_CNTR_MAX GENMASK(23, 0)
+
 static int quad8_signal_read(struct counter_device *counter,
 			     struct counter_signal *signal,
 			     enum counter_signal_level *level)
@@ -156,19 +155,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8 *const priv = counter_priv(counter);
 	struct channel_reg __iomem *const chan = priv->reg->channel + count->id;
-	unsigned int flags;
-	unsigned int borrow;
-	unsigned int carry;
 	unsigned long irqflags;
 	int i;
 
-	flags = ioread8(&chan->control);
-	borrow = flags & QUAD8_FLAG_BT;
-	carry = !!(flags & QUAD8_FLAG_CT);
-
-	/* Borrow XOR Carry effectively doubles count range */
-	*val = (unsigned long)(borrow ^ carry) << 24;
-
 	spin_lock_irqsave(&priv->lock, irqflags);
 
 	/* Reset Byte Pointer; transfer Counter to Output Latch */
@@ -191,8 +180,7 @@ static int quad8_count_write(struct counter_device *counter,
 	unsigned long irqflags;
 	int i;
 
-	/* Only 24-bit values are supported */
-	if (val > 0xFFFFFF)
+	if (val > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -806,8 +794,7 @@ static int quad8_count_preset_write(struct counter_device *counter,
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned long irqflags;
 
-	/* Only 24-bit values are supported */
-	if (preset > 0xFFFFFF)
+	if (preset > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -834,8 +821,7 @@ static int quad8_count_ceiling_read(struct counter_device *counter,
 		*ceiling = priv->preset[count->id];
 		break;
 	default:
-		/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-		*ceiling = 0x1FFFFFF;
+		*ceiling = LS7267_CNTR_MAX;
 		break;
 	}
 
@@ -850,8 +836,7 @@ static int quad8_count_ceiling_write(struct counter_device *counter,
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned long irqflags;
 
-	/* Only 24-bit values are supported */
-	if (ceiling > 0xFFFFFF)
+	if (ceiling > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
-- 
2.39.2

