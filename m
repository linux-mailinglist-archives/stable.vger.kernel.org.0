Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 34EB84C80FF
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 03:26:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230330AbiCAC1H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 21:27:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33990 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230197AbiCAC1F (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 21:27:05 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E409DF3E;
        Mon, 28 Feb 2022 18:26:25 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id b8so12827025pjb.4;
        Mon, 28 Feb 2022 18:26:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=zsGUyzPwyU2D48eLQi5oVaEc8GeAsTJmPIqyMWCKDVc=;
        b=PBxoH++E61U8SoMAfdf8/lkKMP2fB3X7XjKhEiQJwTXYEiWzxFauDPV6rB2idA6+E6
         ZbQNd0++9tHFXa55fAWuDA3wymOjt9Ib3UXZGDdzkFM+UIsHBveZHlHspRiACA8owpQm
         /m3M5qZOWRHrpAlDF3uFM8yyxqZhxFe2DyXw2ym+tB5/hTloKomS/fyu/zxE5/llwRr3
         cujV9zrDiubh+GgccgRVqxHn3LLkFh9P0zQ2sVh/Ty2UFRLQHQx+rQ+068dxKaHC3Lt9
         k7mDmcyElbqoG4Sobd0U+u776NAdhAhwHW3zevKxK/I+Yc7VV/xV860E0Xw+PJDM3Gz5
         lsiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=zsGUyzPwyU2D48eLQi5oVaEc8GeAsTJmPIqyMWCKDVc=;
        b=LFSqma8Po9zmgqxBLb0ozTURDo4Lcb7ydyyJE0tACU/hxeN7XZNEWEyV4eT/qon7bD
         RajKu53O1mVAH0wOdPMDkVSa6u+Rgacr8Qr8B5Ru2FiG/YN0NFo4KaGOs8yL5XZhQueY
         iPmuhD9/Bfs9IKji0EGxqJa4zaHLU6vetNawU7vLf/hetX+0UG4gQnEP/JTsuRPdviUc
         vUOYtF49zpkfzB+EFHumbkgsntO5TbKkB9byF8xezJ9N4BRFhX2NY3PEnfxdHZylh84c
         CbVnIvLGQl7Zc+ZYRC+WKL1SJyuz3iNNEm36rb275bovowAO7qH9+/GxR/xhRQtPp01t
         6Ujw==
X-Gm-Message-State: AOAM533a1zellqKVTZ50J/7FjVKAFSho3BYOeFuTRTm+9MP15IeVezLm
        xN16mxFuqnr2Q+BUg5Sxb/k=
X-Google-Smtp-Source: ABdhPJzK9da69Q5Nc3yJLe9jqoEypr+doI5u3C17/fA7kZSfn3RwQaXxpS0P5tQj/d9793VQWNzPNQ==
X-Received: by 2002:a17:902:a404:b0:14b:1100:aebc with SMTP id p4-20020a170902a40400b0014b1100aebcmr22765667plq.133.1646101585158;
        Mon, 28 Feb 2022 18:26:25 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id 142-20020a621894000000b004dfc714b076sm15417821pfy.11.2022.02.28.18.26.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 18:26:24 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        balbi@kernel.org, axboe@kernel.dk, mingo@kernel.org,
        jj251510319013@gmail.com, zsm@chromium.org,
        stern@rowland.harvard.edu, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 4.14 1/2] usb: gadget: don't release an existing dev->buf
Date:   Tue,  1 Mar 2022 10:26:07 +0800
Message-Id: <20220301022608.10950-2-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20220301022608.10950-1-hbh25y@gmail.com>
References: <20220301022608.10950-1-hbh25y@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

dev->buf does not need to be released if it already exists before
executing dev_config.

Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
Link: https://lore.kernel.org/r/20211231172138.7993-2-hbh25y@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org #4.4+
---
 drivers/usb/gadget/legacy/inode.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legacy/inode.c
index 3b58f4fc0a80..eaad03c0252f 100644
--- a/drivers/usb/gadget/legacy/inode.c
+++ b/drivers/usb/gadget/legacy/inode.c
@@ -1826,8 +1826,9 @@ dev_config (struct file *fd, const char __user *buf, size_t len, loff_t *ptr)
 	spin_lock_irq (&dev->lock);
 	value = -EINVAL;
 	if (dev->buf) {
+		spin_unlock_irq(&dev->lock);
 		kfree(kbuf);
-		goto fail;
+		return value;
 	}
 	dev->buf = kbuf;
 
-- 
2.25.1

