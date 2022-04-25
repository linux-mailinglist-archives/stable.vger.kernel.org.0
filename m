Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA33A50E978
	for <lists+stable@lfdr.de>; Mon, 25 Apr 2022 21:27:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244452AbiDYTaw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 25 Apr 2022 15:30:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230214AbiDYTaw (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 25 Apr 2022 15:30:52 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E02810771F
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:27:47 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a17-20020a258051000000b00648703d0c56so2825007ybn.22
        for <stable@vger.kernel.org>; Mon, 25 Apr 2022 12:27:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=PodgmYzgZq42kh2uQlZntrqzAr16BDXeqiF59lBx694=;
        b=lCqu9tNh9HkB9iPwGvTpjtlsubOhvrzblStAonbuqO6lFMQLIvRmYQXm/fD727PN4o
         lqAvteiSOOJiXP2YNGIANQ1EcHYqTSsNEHAA+PslsAhtToAPvdUs66BvokAl0dbStX8i
         lSCkh9gkByTZPOaRDCUzsONb4KFCBKzJwprHYnvUfDwkiLqkH/ZlkYjxzNihXQjxyPiv
         ZRHy4bSlDyb8uLH8T0rZnBq4/0Kls28FE455R8OUgEvN631RAK3SN6QRT0IkBe4i1Qgq
         igxQQwazID3xDnVdNWfKNBdw0pg9fXiTBK+hyfIOFHCV4PjNhKz7vFO1LD4kHnVzOxVl
         v3sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=PodgmYzgZq42kh2uQlZntrqzAr16BDXeqiF59lBx694=;
        b=KFmmHQDcXjq0evZcq0yDaoBKmtLygpapHbEjUHKaTP28xUPSAXnBS+15xBnZUH52qW
         TXp2IGAu0GfMgNVr42kUK2LzaBNWWEqyKafuM1372L/92u3+otQ5Ta+2LDPfEWaRsOLs
         W3nlh70PlUR7c0ko/ikdB74d1D3rowdwpaS4+6yfBE/wsWOaEa52cep2xBcPVUKqTLRe
         K8JzUU2NpMa4tqS3LlgG3f4VdgvepXSovx0LptT6PocFWTBzhpb3vNad8FqAD6oopQG6
         RGz0RmaOVoipKghJ9qppHlINqtRijZHQXHqgS22Dr1Yr79oeW19Ou1xO7k5fuxK4Hkwf
         NcpA==
X-Gm-Message-State: AOAM533SfE/gsJDyiicMCTRcJptoXGrKyDbvKpxUftR6/W3wXOJrzcGT
        31c4DSKUV9YWHMydmH9Rsef+8Q256rgwLnUPMYqPE7lwlkCO73IqgfM0k7IxrVtqLtg8icWU5wL
        qvl0Pef/kMchu8dBvoy2yDxdxN79QMfd+S5V2meVTJcRvdN7dKW1Napuxj35kgA==
X-Google-Smtp-Source: ABdhPJyK4tt9EdSK/BNHeH4Q+jnWgNokawLCZajdf8UGUXUUnAMMgAaAaB1Pca6gKtJXunK7jDk5vEcpAJo=
X-Received: from khazhy-linux.svl.corp.google.com ([2620:15c:2cd:202:fbbd:1726:b5e8:e81b])
 (user=khazhy job=sendgmr) by 2002:a81:ff06:0:b0:2e6:d7bc:c812 with SMTP id
 k6-20020a81ff06000000b002e6d7bcc812mr18031765ywn.122.1650914866687; Mon, 25
 Apr 2022 12:27:46 -0700 (PDT)
Date:   Mon, 25 Apr 2022 12:27:40 -0700
In-Reply-To: <20220425192740.171756-1-khazhy@google.com>
Message-Id: <20220425192740.171756-2-khazhy@google.com>
Mime-Version: 1.0
References: <20220419191239.588421-1-khazhy@google.com> <20220425192740.171756-1-khazhy@google.com>
X-Mailer: git-send-email 2.36.0.rc2.479.g8af0fa9b8e-goog
Subject: [PATCH v5.15] block/compat_ioctl: fix range check in BLKGETSIZE
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
index a31be7fa31a5..cd506a902963 100644
--- a/block/ioctl.c
+++ b/block/ioctl.c
@@ -645,7 +645,7 @@ long compat_blkdev_ioctl(struct file *file, unsigned cmd, unsigned long arg)
 			(bdev->bd_disk->bdi->ra_pages * PAGE_SIZE) / 512);
 	case BLKGETSIZE:
 		size = i_size_read(bdev->bd_inode);
-		if ((size >> 9) > ~0UL)
+		if ((size >> 9) > ~(compat_ulong_t)0)
 			return -EFBIG;
 		return compat_put_ulong(argp, size >> 9);
 
-- 
2.36.0.rc2.479.g8af0fa9b8e-goog

