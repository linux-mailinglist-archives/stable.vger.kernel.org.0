Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF2B04566AD
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 00:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230386AbhKSAAx (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 19:00:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230053AbhKSAAw (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 19:00:52 -0500
Received: from mail-pl1-x629.google.com (mail-pl1-x629.google.com [IPv6:2607:f8b0:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 32C05C061748
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:57:52 -0800 (PST)
Received: by mail-pl1-x629.google.com with SMTP id p18so6667834plf.13
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:57:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3UwJ5dDFRUsiDM86YTsOk4kxwh467C8v6Q3+NzxJ2PE=;
        b=fm/TwLWQrv4BezmLZcfblFavaSNuLLrmAtbYI9bTahTaT49uuS28MyJIiPgqIhnvvQ
         DCuuDObSbDyai2JlILJ7Vw3bMereozM5QgjjVpJtfDkQlutyC56gbS6UzdEECoKpRQxz
         Y1uWzDr2MaYcIPlSzPUFRJdguLyfblgL9rbrlOz3BbC0Hr/xvTuiVzGmrHabNkiJ+pvZ
         NACTJF82gNTmwLc++mWQLxbHMCHVERct0nGQHl/lFfOk65hewFoKT3n++vC7sshcrDem
         7+CS3SEQap/R8ojODn1is4zKrrTWsQ/ccihrrSgZQijsUVHV8sVxFjbq/2+GPZmkpDZc
         yxnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3UwJ5dDFRUsiDM86YTsOk4kxwh467C8v6Q3+NzxJ2PE=;
        b=uL0ia8FMGEnCrg1OzmczkycgI+nTW6omZh718tPhH+8CO7KjAHE8QkL61GZ/+OaVaY
         05B+h6586++gvy9gVAtqfJohzKE7csgbEBw3NX1RMsxIkD2K8riMwJyvqpiKT2WJv4Ce
         p7ATLkFQifMJDqUYugF2+3cJEOtchEOG9I32cOJJekGD1YE8bEZbk3d0kTLGgzOQd0Iz
         /nAZPXRXXLcn06T037gfUb9MVQuP6HxdOuXEgloHnTB0pz548my4dzJYJdElzV5E8z6L
         vzef6PSoRB9Z48yex4dQ1e8SwQiqdVeglu0MapzIBYRHT9Mf95IUgvbnbXsiML6LAtVr
         6/aA==
X-Gm-Message-State: AOAM532RAvIvcx8aPF4uKyk9zLiGJO2TCXjipH9roj9RobjXkLu9px9J
        HKDgVMvIpKqD/blF1YrOqe3VAP3Wv6RVlg==
X-Google-Smtp-Source: ABdhPJyfPDeVb99Oi/x9k+2vq4ATZkEUSOqCvI7P0yUnMVu0oL79eH9N27/jvLhgqcBGJYl9CWVjfQ==
X-Received: by 2002:a17:902:8d85:b0:142:892d:bfa with SMTP id v5-20020a1709028d8500b00142892d0bfamr71797364plo.76.1637279870745;
        Thu, 18 Nov 2021 15:57:50 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id u22sm726999pfk.148.2021.11.18.15.57.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 15:57:50 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     tadeusz.struk@linaro.org, axboe@kernel.dk, hch@lst.de,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+662448179365dddc1880@syzkaller.appspotmail.com,
        xieyongji@bytedance.com
Subject: [PATCH 5.15] block: Add a helper to validate the block size
Date:   Thu, 18 Nov 2021 15:57:38 -0800
Message-Id: <20211118235738.1128085-1-tadeusz.struk@linaro.org>
X-Mailer: git-send-email 2.33.1
In-Reply-To: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
References: <7e6c4c23-f071-f33b-7bd4-da11980d34c6@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Xie Yongji <xieyongji@bytedance.com>

From: Xie Yongji <xieyongji@bytedance.com>

There are some duplicated codes to validate the block
size in block drivers. This limitation actually comes
from block layer, so this patch tries to add a new block
layer helper for that.

Signed-off-by: Xie Yongji <xieyongji@bytedance.com>
Link: https://lore.kernel.org/r/20211026144015.188-2-xieyongji@bytedance.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Tadeusz Struk <tadeusz.struk@linaro.org>
---
 include/linux/blkdev.h | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 683aee365420..5b03795ae33b 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -54,6 +54,14 @@ struct blk_keyslot_manager;
  */
 #define BLKCG_MAX_POLS		6
 
+static inline int blk_validate_block_size(unsigned int bsize)
+{
+	if (bsize < 512 || bsize > PAGE_SIZE || !is_power_of_2(bsize))
+		return -EINVAL;
+
+	return 0;
+}
+
 typedef void (rq_end_io_fn)(struct request *, blk_status_t);
 
 /*
-- 
2.33.1

