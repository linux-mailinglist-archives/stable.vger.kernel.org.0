Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 294BB4C80FC
	for <lists+stable@lfdr.de>; Tue,  1 Mar 2022 03:26:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbiCAC1B (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 28 Feb 2022 21:27:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbiCAC1A (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 28 Feb 2022 21:27:00 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36956E61;
        Mon, 28 Feb 2022 18:26:21 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id c1so13182567pgk.11;
        Mon, 28 Feb 2022 18:26:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OtZ5H7gA1nSjwvB7F5W5LwR11EAeV37D2iVoWG7YcAY=;
        b=FZ+gm0fxtX+9o0fF2tU+nI93N6K9TxuDpYBUwENsyMSzxchlUX8/k7xstDT+34K1V6
         ZMvLnV3fCcQWlK56C7L78zjN8CIdXoTt4E6ZIvdEBYahiVmNQmyoEvx99woMGG8AQlcu
         m+q60wjSyV0wlYRmzXiCUYyczSE29lFOjZr5WJnhe/oAfI+9ihJrfC2YPtmXOc4BlQKV
         8Cmf8YxQd1ScqdSb/5vLF2qfJehglQsQUqYx2anzwNmHCJ7bLpR4KZHp5cKkSPngtjMM
         VSCIBBZC1vXu4+NJebqhrj5PTganTuyhcPNafebGsnZuwdh9u6eyQs/QnSUi00Cf3AB4
         8DVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=OtZ5H7gA1nSjwvB7F5W5LwR11EAeV37D2iVoWG7YcAY=;
        b=1DGC90xfunqJxu9dWXcLlzgd6kPPcBndCp3oCDnoh9SCmEj7xXEQFgIC82efhca+/P
         mkTJTWXKo+B5wVk74Kg+pj6+pPYZYcTW9v53+eoqjBRQUL46rT2b16gvtwPCWq53qiXK
         7maKMArLvImtRVGrN3dx/vpD0/2uctlGzXFmhQJKejs5iKZxbCKD7D3dXHsNdCcTdGD4
         CuNEABI+c26rbPAHFSkLT4WONWdyWvzILEYOG6cEp45BpFU9FfknfSFznZTfYucyaF2R
         1wHoVm30wUmHffqB6s9ExLypAcadXlL7sYuDCMYy3P+2xXpF6nNMbJxPAr9pxnRX3M02
         ZWdA==
X-Gm-Message-State: AOAM5319veVh5g3V03/FVPpJv1QtcmNyQY+lOYlsmCgI0p8tV5ZmVMZ2
        bBDgTBJrsb2cjUeo06Th5/EDyNIhEvSF0zZ6
X-Google-Smtp-Source: ABdhPJz4+H7zDIIym143qeqOVXJYAsXj+T2OTzoBFeksx+ZzaXhDx8ZjHa/YI0ezPGO0MgcERj/0Tg==
X-Received: by 2002:a63:7742:0:b0:374:7607:afa with SMTP id s63-20020a637742000000b0037476070afamr19957026pgc.391.1646101580753;
        Mon, 28 Feb 2022 18:26:20 -0800 (PST)
Received: from slim.das-security.cn ([103.84.139.53])
        by smtp.gmail.com with ESMTPSA id 142-20020a621894000000b004dfc714b076sm15417821pfy.11.2022.02.28.18.26.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 28 Feb 2022 18:26:20 -0800 (PST)
From:   Hangyu Hua <hbh25y@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     stable@vger.kernel.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, ben@decadent.org.uk,
        balbi@kernel.org, axboe@kernel.dk, mingo@kernel.org,
        jj251510319013@gmail.com, zsm@chromium.org,
        stern@rowland.harvard.edu, Hangyu Hua <hbh25y@gmail.com>
Subject: [PATCH 4.14 0/2] usb: gadget: use after free in dev_config
Date:   Tue,  1 Mar 2022 10:26:06 +0800
Message-Id: <20220301022608.10950-1-hbh25y@gmail.com>
X-Mailer: git-send-email 2.25.1
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

Author: Hangyu Hua <hbh25y@gmail.com>
commit 89f3594d0de5 ("usb: gadget: don't release an existing dev->buf")

Author: Hangyu Hua <hbh25y@gmail.com>
commit 501e38a5531e ("usb: gadget: clear related members when goto fail")

Add two commits to all stable branches.

There are two bugs:
dev->buf does not need to be released if it already exists before
executing dev_config.
dev->config and dev->hs_config and dev->dev need to be cleaned if
dev_config fails to avoid UAF.

Hangyu Hua (2):
  usb: gadget: don't release an existing dev->buf
  usb: gadget: clear related members when goto fail

 drivers/usb/gadget/legacy/inode.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

-- 
2.25.1

