Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE844566B9
	for <lists+stable@lfdr.de>; Fri, 19 Nov 2021 00:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233524AbhKSABO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 18 Nov 2021 19:01:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233429AbhKSABL (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 18 Nov 2021 19:01:11 -0500
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84D4AC061574
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:58:09 -0800 (PST)
Received: by mail-pf1-x431.google.com with SMTP id r130so7699919pfc.1
        for <stable@vger.kernel.org>; Thu, 18 Nov 2021 15:58:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=4rpZGCTbKBiGjmtzGhgW6CK6EMd3LEVNf1dfX6HFghQ=;
        b=QQWOck8j0+FFQqp9DDAcFXvAZCuqBxhYe+Hhm027LcAg6kMBTZEixpAPgXZMvDEPQu
         VmFjdp9Wej0Kci9DSSCFYgvPWoFlYAHUVZbSL9YQ0gQjnagB1MatFVdhyTyJmXBzb3Mw
         6pzgG2RCndEkAM55X5RaI+GdXiQtGZ0w4b/D0qR83mbDkHTrtBPV0IxG9uW+06j6d4yY
         kO0K7VjB7goGrJTDCIibwuUsvRYcezZp81iBEJxmx2kXkEdDpP6Z+5EogR+xMSnaE9gN
         B0IgECgrq1HYwrc4QjItYu2llOLwHuplt+jvJ2n7qiXa262OIMisRpYUtW0tBQz89xsx
         gw2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=4rpZGCTbKBiGjmtzGhgW6CK6EMd3LEVNf1dfX6HFghQ=;
        b=01IDH1IUcgIz+B+tcHvQrmKBPwMUM/FKxTNxRJljU0Mziqi6z+8fSonoJnovM7tluc
         lNTqagQQfNHqDvMNi4BrhKQpbZBW7LmWYikHj4efJVfwnhDfvxPZdgjq6rN5RAGx01oK
         CHvLcZb5GS6ahjSbd3rVbtRSMDk5nF0RIwFWHe9qK0sCKNctq8TQO4ZOKlC4McwUEB1E
         BfvWuZpy38Prc1APWn7tMWsrBDXNJ8ozG7+RTpyOAC507ZIyVfh6QQchEiYXJO0EJdLa
         6zmGaxSubIxjRdgtBgP81lzTwNCSbYfVw3jzfVDd+usarU+pxOCPMae4VbziwFQ4Et48
         AZ1g==
X-Gm-Message-State: AOAM531ReCkF7KVg29laZJ9Zin4STdukNXzBdhWnQRaXNtnDUVtVgD49
        QnbZFrVpHudhunpEHweV+NEP3KRvPxXrQQ==
X-Google-Smtp-Source: ABdhPJwofaoOdmDDhaskHtIZryki0A+tmXZox9rRYiee7+l8BcJCyR75Rmu+i2bmarhQoeAyG5x94A==
X-Received: by 2002:a63:844a:: with SMTP id k71mr4169755pgd.101.1637279888906;
        Thu, 18 Nov 2021 15:58:08 -0800 (PST)
Received: from localhost.localdomain ([50.39.160.154])
        by smtp.gmail.com with ESMTPSA id ip6sm9786395pjb.42.2021.11.18.15.58.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Nov 2021 15:58:08 -0800 (PST)
From:   Tadeusz Struk <tadeusz.struk@linaro.org>
To:     stable@vger.kernel.org
Cc:     tadeusz.struk@linaro.org, axboe@kernel.dk, hch@lst.de,
        linux-block@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzbot+662448179365dddc1880@syzkaller.appspotmail.com,
        xieyongji@bytedance.com
Subject: [PATCH 5.14] block: Add a helper to validate the block size
Date:   Thu, 18 Nov 2021 15:57:56 -0800
Message-Id: <20211118235756.1128122-1-tadeusz.struk@linaro.org>
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
index e7979fe7e4fa..84019910446a 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -59,6 +59,14 @@ struct blk_keyslot_manager;
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

