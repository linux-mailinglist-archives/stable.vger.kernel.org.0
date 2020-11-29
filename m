Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 203762C7B61
	for <lists+stable@lfdr.de>; Sun, 29 Nov 2020 22:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726293AbgK2VZH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Nov 2020 16:25:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725950AbgK2VZH (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 29 Nov 2020 16:25:07 -0500
Received: from mail-lf1-x143.google.com (mail-lf1-x143.google.com [IPv6:2a00:1450:4864:20::143])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DDFBC0613CF
        for <stable@vger.kernel.org>; Sun, 29 Nov 2020 13:24:21 -0800 (PST)
Received: by mail-lf1-x143.google.com with SMTP id z21so16875905lfe.12
        for <stable@vger.kernel.org>; Sun, 29 Nov 2020 13:24:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Biku2J8BsPoMFtUmmujXmzyLzFVT5Xoun9zHadRzJbM=;
        b=hOHQ1TZu8nseHNCD+nD1x4B6XCYfKa30cEkxmCBA5wJGA5Sfxi1OiuvFm5Zmg0ScT1
         3fMSKUllzJtT9M78YcKRJcS6EeGxDQjizufmq7u4CsCwC2OGooS0DmTfwH/5miioegYz
         0GD8LOeNyYT4XQcQER9Wg/iTX+kK4DAEMMmdhSrLfJaHW17Qbp8ysj6SVkeincIKvwFv
         l5dzRUbjLriSIH5wLJ4uM4RmaZ265LkA9eohgoHp7n9YcgpLaf+6+biGeH1ggN16UlM7
         kAdij97trvDWpsLj7xX/zx7aMJxoQKWVeFW8oeZU3fnHNPItFLIHylPSS8+oq95JAqoh
         vOPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=Biku2J8BsPoMFtUmmujXmzyLzFVT5Xoun9zHadRzJbM=;
        b=B+miytsXxhInP2lNC5O83BqnHVa2RDS9F7PbiVqPnKCj3bRblQQ0F0d2uAeOvo1wsi
         sWFCDJNK2Ve/5pGmQ/vnoQgtUNDoJGWclrQvIGRd+Jk7a9jrQAQw9E1BfmfuGLNsstp3
         liFZosAW2xlf2IyhdoQG9Qks0VQLUSEAT+tvkJnpUDC9qm3Ml5QgJr9q7iRkc75/KaKs
         25B0XhHpFYidG+R9zbbcRSOLEM+N2uPXDtPCNuCJYH++54KOKjjlfhX28lOdVNH56ejW
         VDYsJI9o4O+Xm+L23ZTQb926A+DvVeBX4HBXDPTPObdsaQyBqOR4TpAsjOKa+uFI0hJC
         2GDg==
X-Gm-Message-State: AOAM530ia6T0rB1fAKe8iTS0GNOP4LYW+lAOSv64Ssfuwy+v1VTtXAkj
        32YmW6c2/F0ZtsI7xhEiW1eBIg==
X-Google-Smtp-Source: ABdhPJycz35NJ0RSwoiD9TfC/V4tORz+4FANT05txRcr2AIJkOOWQiWd0CZx9UQXrLYDk7qUAxHXQQ==
X-Received: by 2002:a19:40d5:: with SMTP id n204mr7941318lfa.29.1606685059817;
        Sun, 29 Nov 2020 13:24:19 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id o6sm960685ljc.25.2020.11.29.13.24.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 29 Nov 2020 13:24:19 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Andre=20M=C3=BCller?= <andre.muller@web.de>,
        Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>, stable@vger.kernel.org
Subject: [PATCH v2] Input: atmel_mxt_ts - Fix lost interrupts
Date:   Sun, 29 Nov 2020 22:24:15 +0100
Message-Id: <20201129212415.1167540-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 74d905d2d38a devices requiring the workaround
for edge triggered interrupts stopped working.

This is because the "data" state container defaults to
*not* using the workaround, but the workaround gets used
*before* the check of whether it is needed or not. This
semantic is not obvious from just looking on the patch,
but related to the program flow.

The hardware needs the quirk to be used before even
proceeding to check if the quirk is needed.

This patch makes the quirk be used until we determine
it is *not* needed. It is determined as not needed when
we either have a level-triggered interrupt or the
firmware claims that it has enabled retrigging.

Cc: Andre Müller <andre.muller@web.de>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Jiada Wang <jiada_wang@mentor.com>
Cc: stable@vger.kernel.org
Reported-by: Andre Müller <andre.muller@web.de>
Fixes: 74d905d2d38a ("Input: atmel_mxt_ts - only read messages in mxt_acquire_irq() when necessary")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v1->v2:
- Explicitly disable the retrig workaround also if the
  IRQ descriptor says we have a level triggered interrupt.
- Drop the second explicit assigning of "true" to the
  use_retrigen_workaround bool, it is already enabled.
- Augment debug text to say that we leave it enabled
  rather than enable it.
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e34984388791..c822db8dbd02 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -1297,14 +1297,18 @@ static int mxt_check_retrigen(struct mxt_data *data)
 	int val;
 	struct irq_data *irqd;
 
-	data->use_retrigen_workaround = false;
-
 	irqd = irq_get_irq_data(data->irq);
 	if (!irqd)
 		return -EINVAL;
 
-	if (irqd_is_level_type(irqd))
+	if (irqd_is_level_type(irqd)) {
+		/*
+		 * We don't need the workaround if we have level trigged
+		 * interrupts. This will just work fine.
+		 */
+		data->use_retrigen_workaround = false;
 		return 0;
+	}
 
 	if (data->T18_address) {
 		error = __mxt_read_reg(client,
@@ -1313,12 +1317,13 @@ static int mxt_check_retrigen(struct mxt_data *data)
 		if (error)
 			return error;
 
-		if (val & MXT_COMMS_RETRIGEN)
+		if (val & MXT_COMMS_RETRIGEN) {
+			data->use_retrigen_workaround = false;
 			return 0;
+		}
 	}
 
-	dev_warn(&client->dev, "Enabling RETRIGEN workaround\n");
-	data->use_retrigen_workaround = true;
+	dev_warn(&client->dev, "Leaving RETRIGEN workaround enabled\n");
 	return 0;
 }
 
@@ -3117,6 +3122,7 @@ static int mxt_probe(struct i2c_client *client, const struct i2c_device_id *id)
 	data = devm_kzalloc(&client->dev, sizeof(struct mxt_data), GFP_KERNEL);
 	if (!data)
 		return -ENOMEM;
+	data->use_retrigen_workaround = true;
 
 	snprintf(data->phys, sizeof(data->phys), "i2c-%u-%04x/input0",
 		 client->adapter->nr, client->addr);
-- 
2.26.2

