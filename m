Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 149AB6B6C6E
	for <lists+stable@lfdr.de>; Mon, 13 Mar 2023 00:16:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229731AbjCLXQP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 12 Mar 2023 19:16:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229493AbjCLXQN (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 12 Mar 2023 19:16:13 -0400
Received: from mail-qt1-x82c.google.com (mail-qt1-x82c.google.com [IPv6:2607:f8b0:4864:20::82c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E787826C01
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:10 -0700 (PDT)
Received: by mail-qt1-x82c.google.com with SMTP id cf14so11533236qtb.10
        for <stable@vger.kernel.org>; Sun, 12 Mar 2023 16:16:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1678662970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=/NAfHzXco6zldfvoqj7JCDbqEcSO07sI8PwkAWaYsfA=;
        b=OokZaiJCpnD5oAhQfkNIC+T59gteaQHE4PiwicIbHexn3wwhyM86RRbxYPVgBHfRGJ
         EdmimsprMfFCJeICkrv+imkOwOLEns2PkkmD9TsnQmf3+u4IVCbzjB8dEtWWxnBqkb74
         CZRkHXUrmBloa81NMIBz/+/WrV0UguRmVuJ0QACwLmD7+Ox4eB/ZZwkZgHaEB8a6sWa2
         +Mdzi4IeZkQF2ftysRuM3NXdf9JM8VVThMtQlQNVMwEtUIMFMhAWUDft+SSWMuEpB4HH
         HpugeJmUe+ooS0cL0AhrZ0dWa71NOoiS+oe/7ncJjCBOJ3pbyXWJ2tTp+5CgSld0ntKb
         bWVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678662970;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/NAfHzXco6zldfvoqj7JCDbqEcSO07sI8PwkAWaYsfA=;
        b=n9Qr1mBIbmZXwOWMyVWUu0RsyvXPaNthVG2BEpGu1C66wLftqABrFvd40ocLFm9cqH
         XeY8YX/sKjwrPedQIWtJuomYSF6TsO3eoNaPBL7laUJFayiEQeaddScgM6uaK/PWYaYw
         StDR+HyoE9rO4Sn+lFA9h7UOhDCcocoX8tTIP7qVpaNGrhkmV+PTpqBUIPMnRZXoNGPX
         lXQ/cbcn8W/ZREbXiWPk6c0u0hE/UgY05dQjojmGzS5Ij84rfL+USf6bcXe/BcMhLvMK
         zMKfNV/RhUHwOEEMb3/ONmrcUaK8wJW+Oec+IfjuVENZhQelf4QV17WEu+NJS258IvbE
         Pxuw==
X-Gm-Message-State: AO0yUKWU5D+Q9IeB5iWyMjRwwNuMAEFDOJv93Q4xJmafrijVfpmDL6dR
        vqmN+7JwRylPspSBmSGIkHUyag==
X-Google-Smtp-Source: AK7set9XzbO64RfWj4xomyRP7VJdmUocrohQOEmQzHErg/vfVJb+t90oVFfpuPrF+Y0unlFKFc5KTQ==
X-Received: by 2002:ac8:5996:0:b0:3bf:d11a:c82f with SMTP id e22-20020ac85996000000b003bfd11ac82fmr59823074qte.58.1678662970046;
        Sun, 12 Mar 2023 16:16:10 -0700 (PDT)
Received: from fedora.attlocal.net (69-109-179-158.lightspeed.dybhfl.sbcglobal.net. [69.109.179.158])
        by smtp.gmail.com with ESMTPSA id dm21-20020a05620a1d5500b00742f250ebc0sm4307091qkb.9.2023.03.12.16.16.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 12 Mar 2023 16:16:09 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     linux-iio@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org, jic23@kernel.org, lars@metafoo.de,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 6.1,6.2,6.3 v3 1/6] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 12 Mar 2023 19:15:49 -0400
Message-Id: <20230312231554.134858-1-william.gray@linaro.org>
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
Cc: <stable@vger.kernel.org> # 6.1.x
Cc: <stable@vger.kernel.org> # 6.2.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
Changes in v3:
 - Initialize *val in quad8_count_read()

 drivers/counter/104-quad-8.c | 29 ++++++++---------------------
 1 file changed, 8 insertions(+), 21 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index deed4afadb29..d59e4f34a680 100644
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
@@ -156,18 +155,10 @@ static int quad8_count_read(struct counter_device *counter,
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
+	*val = 0;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
 
@@ -191,8 +182,7 @@ static int quad8_count_write(struct counter_device *counter,
 	unsigned long irqflags;
 	int i;
 
-	/* Only 24-bit values are supported */
-	if (val > 0xFFFFFF)
+	if (val > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -806,8 +796,7 @@ static int quad8_count_preset_write(struct counter_device *counter,
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned long irqflags;
 
-	/* Only 24-bit values are supported */
-	if (preset > 0xFFFFFF)
+	if (preset > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);
@@ -834,8 +823,7 @@ static int quad8_count_ceiling_read(struct counter_device *counter,
 		*ceiling = priv->preset[count->id];
 		break;
 	default:
-		/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-		*ceiling = 0x1FFFFFF;
+		*ceiling = LS7267_CNTR_MAX;
 		break;
 	}
 
@@ -850,8 +838,7 @@ static int quad8_count_ceiling_write(struct counter_device *counter,
 	struct quad8 *const priv = counter_priv(counter);
 	unsigned long irqflags;
 
-	/* Only 24-bit values are supported */
-	if (ceiling > 0xFFFFFF)
+	if (ceiling > LS7267_CNTR_MAX)
 		return -ERANGE;
 
 	spin_lock_irqsave(&priv->lock, irqflags);

base-commit: fe15c26ee26efa11741a7b632e9f23b01aca4cc6
-- 
2.39.2

