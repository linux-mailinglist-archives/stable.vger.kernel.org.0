Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD552CA2B6
	for <lists+stable@lfdr.de>; Tue,  1 Dec 2020 13:31:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728651AbgLAMbL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Dec 2020 07:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55874 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727374AbgLAMbL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 1 Dec 2020 07:31:11 -0500
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB2F7C0613D6
        for <stable@vger.kernel.org>; Tue,  1 Dec 2020 04:30:30 -0800 (PST)
Received: by mail-lj1-x243.google.com with SMTP id s9so2554021ljo.11
        for <stable@vger.kernel.org>; Tue, 01 Dec 2020 04:30:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ramXbjgj53j89UgQhxIKjxJ2+FDANxAA+c6VfvLy/MM=;
        b=GXzM2uIasBy2yUKzrIed6EjYKSguaqtku0tvKNSDySoQjEtIVGNC6LkqPGU80eiHoG
         HWldkNasileS7dxMcgJevn/PzETYHVEVDEha5tctW3FLN3e2RGNDy/7rBlZbGlvu1knt
         xIHx/M844C4Mmi6VUaWRyduwvhv8y+l3jAxnfboJ6DMJeUJLdhdjYOk+DtaF2HzXjNPf
         EM4JtGKFooyNp7RPUYwBIn0FtTn4LIstf2cqpyODo2CEk68D2fvczZ0wrHPVp2D3SFs2
         dbVT/141Gtn5Fp+06RCMIUBjnXkqYFLBtdLH5vFZWH/QqReR5CQPUr+6PMgqkNhsP2/s
         k41A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ramXbjgj53j89UgQhxIKjxJ2+FDANxAA+c6VfvLy/MM=;
        b=swxAoKSNQmVFGAFiypAnKMNz5O/6VNQZfUX45WzmmsjU+BdcPv4CYmiK39+hUYTwV6
         iLkVwZ7wBZS1FJ7Mn6jihUEldoNUNwBQdD0gv18ZJjRFi218dw51PuM9QzEICSWK5qmM
         uGv0ioTFNc1lK7TINrfywhmmT2B+uEEW11XoY+ZI/UxMwcgXf3ar3nLMFAUBZs9sGM1J
         7sH4Nc2eocnYBphifUxrHNYcIhjDo3ocZ5DlpGonDfHKFOvQVi9+RhAvUoAhx4EmdutB
         qFceBg6URhHNM0ShM/ND7fww6u2ZautO0drX4CXOSldljTl6cvEAgOYSJSHgu/pJ43d6
         Rv+Q==
X-Gm-Message-State: AOAM532b3ayt9/qyBpSqfqo2LhrithTUC+GRct/aQJoimEdrHcQWcJ7P
        ZqTRHqVQDZoNhwYm19PTK1Rwig==
X-Google-Smtp-Source: ABdhPJxffjofMUCE9hCOZl04nzYJOPHxcT/AND+7H6EujYSsA+Rhk6txI5PEGcrjVdUUOaaaz6mMkw==
X-Received: by 2002:a2e:b4e1:: with SMTP id s1mr1140952ljm.374.1606825829206;
        Tue, 01 Dec 2020 04:30:29 -0800 (PST)
Received: from localhost.bredbandsbolaget (c-92d7225c.014-348-6c756e10.bbcust.telenor.se. [92.34.215.146])
        by smtp.gmail.com with ESMTPSA id y81sm193148lfc.100.2020.12.01.04.30.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 01 Dec 2020 04:30:28 -0800 (PST)
From:   Linus Walleij <linus.walleij@linaro.org>
To:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org
Cc:     Linus Walleij <linus.walleij@linaro.org>,
        =?UTF-8?q?Andre=20M=C3=BCller?= <andre.muller@web.de>,
        Nick Dyer <nick.dyer@itdev.co.uk>,
        Jiada Wang <jiada_wang@mentor.com>, stable@vger.kernel.org
Subject: [PATCH v3] Input: atmel_mxt_ts - Fix lost interrupts
Date:   Tue,  1 Dec 2020 13:30:26 +0100
Message-Id: <20201201123026.1416743-1-linus.walleij@linaro.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

After commit 74d905d2d38a devices requiring the workaround
for edge triggered interrupts stopped working.

The hardware needs the quirk to be used before even
proceeding to check if the quirk is needed because
mxt_acquire_irq() is called before mxt_check_retrigen()
is called and at this point pending IRQs need to be
checked, and if the workaround is not active, all
interrupts will be lost from this point.

Solve this by switching the calls around.

Cc: Andre Müller <andre.muller@web.de>
Cc: Nick Dyer <nick.dyer@itdev.co.uk>
Cc: Jiada Wang <jiada_wang@mentor.com>
Cc: stable@vger.kernel.org
Reported-by: Andre Müller <andre.muller@web.de>
Tested-by: Andre Müller <andre.muller@web.de>
Suggested-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Fixes: 74d905d2d38a ("Input: atmel_mxt_ts - only read messages in mxt_acquire_irq() when necessary")
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
---
ChangeLog v2->v3:
- Make the simpler fix suggested by Dmitry.
- Collect Andre's Tested-by.
ChangeLog v1->v2:
- Explicitly disable the retrig workaround also if the
  IRQ descriptor says we have a level triggered interrupt.
- Drop the second explicit assigning of "true" to the
  use_retrigen_workaround bool, it is already enabled.
- Augment debug text to say that we leave it enabled
  rather than enable it.
---
 drivers/input/touchscreen/atmel_mxt_ts.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/input/touchscreen/atmel_mxt_ts.c b/drivers/input/touchscreen/atmel_mxt_ts.c
index e34984388791..109655547477 100644
--- a/drivers/input/touchscreen/atmel_mxt_ts.c
+++ b/drivers/input/touchscreen/atmel_mxt_ts.c
@@ -2185,11 +2185,11 @@ static int mxt_initialize(struct mxt_data *data)
 		msleep(MXT_FW_RESET_TIME);
 	}
 
-	error = mxt_acquire_irq(data);
+	error = mxt_check_retrigen(data);
 	if (error)
 		return error;
 
-	error = mxt_check_retrigen(data);
+	error = mxt_acquire_irq(data);
 	if (error)
 		return error;
 
-- 
2.26.2

