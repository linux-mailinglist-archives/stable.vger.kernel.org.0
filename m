Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1775951D2CD
	for <lists+stable@lfdr.de>; Fri,  6 May 2022 10:06:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389792AbiEFIKZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 May 2022 04:10:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239540AbiEFIKX (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 6 May 2022 04:10:23 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D433445514;
        Fri,  6 May 2022 01:06:41 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id cx11-20020a17090afd8b00b001d9fe5965b3so10181398pjb.3;
        Fri, 06 May 2022 01:06:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id;
        bh=GIOdOXa5ZfB2uJVmQgtKIxqW4ntVqgfvN4zvijAfGks=;
        b=kGUYQbBLRaqUISAsbY0V1LU9b5rYzU5I7SHYjf+y58iMDfVDZWLHDpQetNYI3NV7Wo
         lBLDwcmTnnyedxRlgjB7/xN3pgITFXN+y/k/Y4cZ2QAWgPKsMsxzVuBGQzThcdMYvfU1
         1PpygFd9jq6zN/FphPU7bVtedgtpIrt98g5obSpWLPntFct+taZjH3sqO3q81x/ir6UI
         gaLV4oIaakhlbFmn8Vq8KTlHY1MMBd8OWNY/94HmYl8wkOImaNK1ZV5eVgK365KjbAGY
         tZJel8eqiapMDji9xBTTcWcuWzu7PmcLon+oGUESxUy9N1QmiW+f82N5SZ57873VkRfW
         6TlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=GIOdOXa5ZfB2uJVmQgtKIxqW4ntVqgfvN4zvijAfGks=;
        b=eT9Q2mt8xOAnGhWQuvI+V2Vf6vgty6YMa4nYeddf7GhZ/aPNO5VFNk9ZaAWc4M1v6r
         hpTjSSqPemEjKsIFfBW+dA7ZLKo8slgtyedn2UOa6vQUB7acZVfuxKknUzneCko2JB88
         8LoaeoHW9P4ro3/6e2/y3FcOpesSD67o+nEBVgkdR3Ov6ZO1QxJkw1CaeiqNCd58DlB5
         iA5z7mBzD+3FQzO0B3piq+/keyhkokuXzhLzW9fWDzbGfiBR4gu7tI7MHMFYyXJp0Twj
         th9IIIkTz8UenSxm07lIQOsx9dq9yVdFLjv5mDCvCa9Mn4tDkWxoxJCgMe+NqBoxfNa9
         2elw==
X-Gm-Message-State: AOAM532TblaK3hLrAtEZs3c4L1+LYasXkbvQxKH5uoA1vjyI+29dvJnr
        ESKy4lcr1a/CSxIwOwECkWAYUhEr/ABPltpGq/E=
X-Google-Smtp-Source: ABdhPJwQoGMIxKM9HPOGJlGXafi++kl5wzVAl94nSX0DpLZzoLMpQKUbe9fLNcDe+oqfyOaL0GVcug==
X-Received: by 2002:a17:902:70c1:b0:154:667f:e361 with SMTP id l1-20020a17090270c100b00154667fe361mr2410029plt.148.1651824401004;
        Fri, 06 May 2022 01:06:41 -0700 (PDT)
Received: from localhost.localdomain ([183.14.31.73])
        by smtp.gmail.com with ESMTPSA id r9-20020a056a00216900b0050dc7628195sm2712436pff.111.2022.05.06.01.06.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 May 2022 01:06:40 -0700 (PDT)
From:   Puyou Lu <puyou.lu@gmail.com>
Cc:     stable@vger.kernel.org, Puyou Lu <puyou.lu@gmail.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Bartosz Golaszewski <brgl@bgdev.pl>,
        Marc Zyngier <maz@misterjones.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-gpio@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] gpio: pca953x: fix irq_stat not updated when irq is disabled (irq_mask not set)
Date:   Fri,  6 May 2022 16:06:30 +0800
Message-Id: <20220506080630.4151-1-puyou.lu@gmail.com>
X-Mailer: git-send-email 2.17.1
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

When one port's input state get inverted (eg. from low to hight) after
pca953x_irq_setup but before setting irq_mask (by some other driver such as
"gpio-keys"), the next inversion of this port (eg. from hight to low) will not
be triggered any more (because irq_stat is not updated at the first time). Issue
should be fixed after this commit.

Fixes: 89ea8bbe9c3e ("gpio: pca953x.c: add interrupt handling capability")
Signed-off-by: Puyou Lu <puyou.lu@gmail.com>

---

Change since v1:
add fixes tag and commit message https://lore.kernel.org/lkml/20220501092201.16411-1-puyou.lu@gmail.com/

---
 drivers/gpio/gpio-pca953x.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/gpio/gpio-pca953x.c b/drivers/gpio/gpio-pca953x.c
index d2fe76f3f34f..8726921a1129 100644
--- a/drivers/gpio/gpio-pca953x.c
+++ b/drivers/gpio/gpio-pca953x.c
@@ -762,11 +762,11 @@ static bool pca953x_irq_pending(struct pca953x_chip *chip, unsigned long *pendin
 	bitmap_xor(cur_stat, new_stat, old_stat, gc->ngpio);
 	bitmap_and(trigger, cur_stat, chip->irq_mask, gc->ngpio);
 
+	bitmap_copy(chip->irq_stat, new_stat, gc->ngpio);
+
 	if (bitmap_empty(trigger, gc->ngpio))
 		return false;
 
-	bitmap_copy(chip->irq_stat, new_stat, gc->ngpio);
-
 	bitmap_and(cur_stat, chip->irq_trig_fall, old_stat, gc->ngpio);
 	bitmap_and(old_stat, chip->irq_trig_raise, new_stat, gc->ngpio);
 	bitmap_or(new_stat, old_stat, cur_stat, gc->ngpio);
-- 
2.17.1

