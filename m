Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBFFF620A60
	for <lists+stable@lfdr.de>; Tue,  8 Nov 2022 08:38:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233671AbiKHHim (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 8 Nov 2022 02:38:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233699AbiKHHiN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 8 Nov 2022 02:38:13 -0500
Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 725F1429B9
        for <stable@vger.kernel.org>; Mon,  7 Nov 2022 23:37:52 -0800 (PST)
Received: by mail-pl1-f180.google.com with SMTP id p21so13427800plr.7
        for <stable@vger.kernel.org>; Mon, 07 Nov 2022 23:37:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QFgQ8c9VVCwCQa1695IsqvZFsH7CMTMS7tq3bW5Bovo=;
        b=mCjcukznV/Q+Q+cPSWc7vqZQVivnx/widCcHDGTIDNHezsC9A9282TJ7Yu6ylu8Tss
         0k737MdY1wSy3oOktS633BeUDAwey0FMPbZY+34Incku3GRFOFECzCIqV3orp/D426Ua
         5OSZrxAPsJKTI6CKweQNeO03UPZJreP8CcP/AvUCLi7oGZOBJk97CbvEX39QkFazQ3LT
         9fu0MoXBlcHdSoarBDWAXcIRUndMbQD0K3lrGLNHBilMv1ueb5gehFXfLx7Zw0xxDa77
         MfqIOXQKhUpogrlvLRmGVWiq63XAStlMV710nEwuoLMa2h2VepYWmTdh6TaL+NvTmgbM
         LOdg==
X-Gm-Message-State: ACrzQf132Z0vNExnGEWCDNmh/gOHDY8tf5fL0eGeaAZDIhgwHs3i9kPa
        ALsOObDP7NffMYKwUyzCS0oxOe/Cm5zlKg==
X-Google-Smtp-Source: AMsMyM63aSQSj5shzxvbvF9OR2pEmLTZ0vnB/0Ni4f8eqTGQt3f0vvEYeGxdaSDDtthCFo3melxNBg==
X-Received: by 2002:a17:90a:8504:b0:212:c1f4:ddf1 with SMTP id l4-20020a17090a850400b00212c1f4ddf1mr56939260pjn.224.1667893072011;
        Mon, 07 Nov 2022 23:37:52 -0800 (PST)
Received: from localhost.localdomain ([116.128.244.169])
        by smtp.gmail.com with ESMTPSA id k21-20020a628415000000b0056bb06ce1cfsm5872043pfd.97.2022.11.07.23.37.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 07 Nov 2022 23:37:51 -0800 (PST)
From:   xiongxin <xiongxin@kylinos.cn>
To:     xiongxin@kylinos.cn
Cc:     stable@vger.kernel.org
Subject: [PATCH v2 1/2] PM: hibernate: fix spelling mistake for annotation
Date:   Tue,  8 Nov 2022 15:37:40 +0800
Message-Id: <20221108073741.3837659-2-xiongxin@kylinos.cn>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20221108073741.3837659-1-xiongxin@kylinos.cn>
References: <20221108073741.3837659-1-xiongxin@kylinos.cn>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The actual calculation formula in the code below is:

max_size = (count - (size + PAGES_FOR_IO)) / 2
	    - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE);

But function comments are written differently, the comment is wrong?

By the way, what exactly do the "/ 2" and "2 *" mean?

Cc: stable@vger.kernel.org
Signed-off-by: xiongxin <xiongxin@kylinos.cn>
---
 kernel/power/snapshot.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/power/snapshot.c b/kernel/power/snapshot.c
index 2a406753af90..c20ca5fb9adc 100644
--- a/kernel/power/snapshot.c
+++ b/kernel/power/snapshot.c
@@ -1723,8 +1723,8 @@ static unsigned long minimum_image_size(unsigned long saveable)
  * /sys/power/reserved_size, respectively).  To make this happen, we compute the
  * total number of available page frames and allocate at least
  *
- * ([page frames total] + PAGES_FOR_IO + [metadata pages]) / 2
- *  + 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
+ * ([page frames total] - PAGES_FOR_IO - [metadata pages]) / 2
+ *  - 2 * DIV_ROUND_UP(reserved_size, PAGE_SIZE)
  *
  * of them, which corresponds to the maximum size of a hibernation image.
  *
-- 
2.25.1

