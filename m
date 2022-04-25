Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1F6650E977
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 21:27:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236732AbiDYTau (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 15:30:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiDYTau (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 15:30:50 -0400
Received: from mail-yw1-x114a.google.com (mail-yw1-x114a.google.com [IPv6:2607:f8b0:4864:20::114a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9AE53C8BCC
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:27:44 -0700 (PDT)
Received: by mail-yw1-x114a.google.com with SMTP id 00721157ae682-2f7ddeb73c1so35169387b3.5
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=a/9N3Y9cDKd6QNX3QzIWpLrmjV0Ybp/QO5qtJbsALzg=;
        b=e/xt2N5vy1AYBV9C7fnefmGMLKqP4KTCpNIyazSBH2/SMa3z0u0iKZj+sBspOv5Hck
         0pz4OMGHkohoUNH2OS3wS0eObz9IemBiAPjJx/c/KFoVmTGrc/d4VkcBGTLV/f6ZC7wZ
         NUD+vZ3IqBhhsG8R3BpnJF6Z9qU76QFUVZD4Asnby5ySHgT5edkCyk8y7ED8jxTsXRNQ
         9/z905ACLR8w3g9nk1tjsN2MmEDWv22+tUlDwYjPPvPKFG1WhcaFcS4KAJJ/OgxxJtHM
         Qzjrqvwa9SGwFA2cyqw0DZciXvtXHttqliTm8BZMItfmNg4RC2MXLKcf/1ZhelTg0S92
         BBPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=a/9N3Y9cDKd6QNX3QzIWpLrmjV0Ybp/QO5qtJbsALzg=;
        b=TNhymf5hOMRYnXX1UlEPPMXVuJvVmnQsW0iKHYwEKHJ7r9ARgEOvCBuAwY+V+xYWNg
         6v23UOpQQGWob1SBw7RjtOaVURcRSJcP1asHLd5CtOftkM3HsCezFWNBnbMDvGtUIkSS
         seBKNLNswhM0ZA9cHHcHmol0e8AE9nbPbzW0NkdnJdm2Z7+AwASJH9G0+NrDClB9gRi6
         xyQWdbnMKT3HHyHCxQ07NUdsUyISP/IJq85aDy2FsT/lyCfnnOx5lqTcVbC/LG8Hz5tV
         ebGXK9qQkZhhgB1fOcy0/8tOPw1waG9BEnt/7wnGj9vQgiHxK6PSGL8fUB5W/fTC38Q1
         y+hg==
X-Gm-Message-State: AOAM531W8e+dvNCazgkf6xpp5fF1Gh4DcH+IBSgw5ghRxG3NOTXLwA1O
        2B0DCRGDN7JS1N31XGYIKUqe0GfoqnMgFSvsqsYi33r1s0e4IXtdPfhq0CMwe/NRkC+d5yuIIU5
        I0wniK9AizuWeSi90UBdcKDdKOeSldtT6oP3SE7pLG5TxMpAgWrckap5c7Auh7w==
X-Google-Smtp-Source: ABdhPJyl+AbBgN8xwDewp1+9uU5DmwVacVt1CsluREKWvOXmrPBSs9Wz5XGnK1l2a5oe1CH7HI9OCRaCKYI=
X-Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2cd:202:fbbd:1726:b5e8:e81b])
 (user=khazhy job=sendgmr) by 2002:a81:9b45:0:b0:2f7:ca2b:b5f with SMTP id
 s66-20020a819b45000000b002f7ca2b0b5fmr11684205ywg.337.1650914863825; Mon, 25
 Apr 2022 12:27:43 -0700 (PDT)
Date:   Mon, 25 Apr 2022 12:27:39 -0700
In-Reply-To: <20220419191239.588421-1-khazhy@google.com>
Message-Id: <20220425192740.171756-1-khazhy@google.com>
Mime-Version: 1.0
References: <20220419191239.588421-1-khazhy@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v5.10] block/compat_ioctl: fix range check in BLKGETSIZE
From:   Khazhismel Kumykov <khazhy@google.com>
To:     stable@vger.kernel.org
Cc:     Khazhismel Kumykov <khazhy@google.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Chaitanya Kulkarni <kch@nvidia.com>,
        Jens Axboe <axboe@kernel.dk>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit ccf16413e520164eb718cf8b22a30438da80ff23 ]

kernel ulong and compat_ulong_t may not be same width. Use type directly
to eliminate mismatches.

This would result in truncation rather than EFBIG for 32bit mode for
large disks.

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Khazhismel Kumykov <khazhy@google.com>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Link: https://lore.kernel.org/r/20220414224056.2875681-1-khazhy@google.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
---
 block/ioctl.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/block/ioctl.c b/block/ioctl.c
index ed240e170e14..e7eed7dadb5c 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -679,7 +679,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			       (bdev->bd_bdi->ra_pages * PAGE_SIZE) / 512);
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
-		if ((size >> 9) > ~0UL)
+		if ((size >> 9) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(argp, size >> 9);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

