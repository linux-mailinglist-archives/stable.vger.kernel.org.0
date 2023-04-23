Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F3F26EC31C
	for <lists+stable@lfdr.de>; Mon, 24 Apr 2023 01:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230253AbjDWXVC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 23 Apr 2023 19:21:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230231AbjDWXVA (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 23 Apr 2023 19:21:00 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3366010F9
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:59 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-552a6357d02so44178477b3.3
        for <stable@vger.kernel.org>; Sun, 23 Apr 2023 16:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1682292058; x=1684884058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cthSXcBD9iVVm3blHORVesLHvMRZmvd8/QCQdXoEC9w=;
        b=GWjo56mOVxMl3/ic3j4OMgChqlqhOWUjboVme/sgNAmexMKgwhq5r3VnqgqBwOG4q2
         kxfQtGAfprBou0GxqWhlhL3m6SFg0pdlqdp+yQ7dj7JLoW6ewPrpYepLO2g9/MsDmOJz
         cVBTVaH8tPsn1xSPdZxgSgARwrwUd7GmJ83/gXesp1mMUv4EEjm+F+cH41TAkrOBmdY+
         m/WXjupw6/uCBbQ/EMlT7V33mUMOpAybNRdZeOZUySmMgsi1Sh//waXvkReGkiJMB2HW
         dnPBZ4Uebcm8Xn89cIrrb18cBkhKcLrVwqLOAtCWZCs6YZf3seZeC3Cr7V9ncqcwVt7T
         PjFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682292058; x=1684884058;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cthSXcBD9iVVm3blHORVesLHvMRZmvd8/QCQdXoEC9w=;
        b=F5208bsVdY0rNzVDtgAXr9DIsZo9XSjQgygnxCgZG4zLsDTGXlfcBjKcsGfDyhZoWV
         j1uM9PYjIoB+Ia5v9cvcY5RBF62fzzfN5IcwbUU5bpukcDxr9zAVKHKYGl8kDsgyi4gt
         /rzqWqm7rbMCm1KpWuxMTC6h8x0dPBB/wcYpHyMXic4ahjM8+4x4uW1O+8ibY9evzdpX
         s/9NgoRts474ngQ2voU/gFRNgiDX0JfdX0n2OosKVFhdMbtUiNUg92B3fg/GMAfJogd8
         d5iHnYG3LSG3YSmFstBKJzBLWG/5DoxQ6feaWt0KuXy4NS3uyD4NbzboezBUNO+kelbo
         H/WA==
X-Gm-Message-State: AAQBX9f+bdzERRpeUkp3h/KG4+PvALB7TnNV0xq0kMqV1JapvpwGaGdP
        dalE/yY/y00bkO5oA6wl7+V7yA==
X-Google-Smtp-Source: AKy350Z967+MY7g96A5l7axv+F6eC9z/8DRdK5wXWyezSDx8VydBB1G/9jvkKKVaRPE6QkO4MRmmRg==
X-Received: by 2002:a81:838b:0:b0:54f:df51:7422 with SMTP id t133-20020a81838b000000b0054fdf517422mr6176587ywf.34.1682292058026;
        Sun, 23 Apr 2023 16:20:58 -0700 (PDT)
Received: from fedora.. ([198.136.190.5])
        by smtp.gmail.com with ESMTPSA id z205-20020a0dd7d6000000b0054f856bdc4dsm2607352ywd.38.2023.04.23.16.20.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 23 Apr 2023 16:20:57 -0700 (PDT)
From:   William Breathitt Gray <william.gray@linaro.org>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonathan Cameron <jic23@kernel.org>,
        William Breathitt Gray <william.gray@linaro.org>,
        stable@vger.kernel.org
Subject: [PATCH 5.10 v4 4/5] counter: 104-quad-8: Fix race condition between FLAG and CNTR reads
Date:   Sun, 23 Apr 2023 19:20:46 -0400
Message-Id: <20230423232047.12589-4-william.gray@linaro.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230423232047.12589-1-william.gray@linaro.org>
References: <20230423232047.12589-1-william.gray@linaro.org>
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
Cc: <stable@vger.kernel.org> # 5.10.x
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
---
 drivers/counter/104-quad-8.c | 18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

diff --git a/drivers/counter/104-quad-8.c b/drivers/counter/104-quad-8.c
index 21bb2bb767..1b4fdee9d9 100644
--- a/drivers/counter/104-quad-8.c
+++ b/drivers/counter/104-quad-8.c
@@ -62,10 +62,6 @@ struct quad8_iio {
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
@@ -643,17 +639,9 @@ static int quad8_count_read(struct counter_device *counter,
 {
 	struct quad8_iio *const priv = counter->priv;
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
 
@@ -1198,8 +1186,8 @@ static ssize_t quad8_count_ceiling_read(struct counter_device *counter,
 
 	mutex_unlock(&priv->lock);
 
-	/* By default 0x1FFFFFF (25 bits unsigned) is maximum count */
-	return sprintf(buf, "33554431\n");
+	/* By default 0xFFFFFF (24 bits unsigned) is maximum count */
+	return sprintf(buf, "16777215\n");
 }
 
 static ssize_t quad8_count_ceiling_write(struct counter_device *counter,

base-commit: 791a854ae5a5f5988f1291ae91168a149bd5ba57
-- 
2.40.0

