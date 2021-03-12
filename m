Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DBD19339533
	for <lists+stable@lfdr.de>; Fri, 12 Mar 2021 18:40:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbhCLRkF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 12 Mar 2021 12:40:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232602AbhCLRkB (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 12 Mar 2021 12:40:01 -0500
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8EFBC061574;
        Fri, 12 Mar 2021 09:40:01 -0800 (PST)
Received: by mail-pl1-x62f.google.com with SMTP id c16so12275549ply.0;
        Fri, 12 Mar 2021 09:40:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Um41cau/4cI5zZ0IFqq13GRE02mbM3czC6F6elPaPlY=;
        b=jMixJe4t1LMYNSBJap26jButQmWlKnEZrOAPlkS0RrI7DelOA0vKb7j29BQMM5SVm2
         Xh6aCuObFfIL/4OfMm+iiSV77LLp4zP6ESMqpB/jdoERxPsJ3Nql+QiUj93tyhZ4tUj0
         DepqiabV0uYOPqw0b8+kk24TliM7NFr9NMv0Lpz/V/y3NlHcGHG/T6CcwOHTDBY8fDqg
         VvBJVWz289so/cWa0O00do1k8x9I5qISz7dUZc7FHV9r0FpRLJU37ldg3fTmWeTZ9AoL
         uAQJ0d+86tc7SrgZnpfdQrmDx+BTMmJhzFSmruJsXHlLONFRMh1llRNd+wwXgLXuwfSY
         y2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :in-reply-to:references:mime-version:content-transfer-encoding;
        bh=Um41cau/4cI5zZ0IFqq13GRE02mbM3czC6F6elPaPlY=;
        b=NGnjwGtCukGMzbAbgmpiNqtZCV4f1tG40qb4Kjr+g4FZyYXi7jFaOi0Y+WJ4l9Uedy
         l2SXdh4hZA8bEJFFi9Huctjr8kOgrC2j1DaihU2Gbtd8iKPj19TSqiqv6yCqu/2j/Mlb
         qo5xk8Wwvao12b6jTVQpXNlIQTkpGTbbJsmRvcdFTsvHTkZGXbLDzlSl6D1gyDV8nBmV
         BFG+sMcq7roTPjJmz46nnCEWcg5tgIvrVxMMJ9RIQCK8aHUQtIgj769cbrny7eIjPbA6
         wEjQulxVDr1zv0xRzZn5W+cWQ32wviUzFGvZvbPuNvLQnYuxZ6crF9uYLA8HkxRXstJp
         +inw==
X-Gm-Message-State: AOAM530eckfaY3Mw4gjJFYelIHQIVhiZpyeVu9njPWn0Huy09+xgc0Od
        h/Fr+XXFoB+XhO4NiijruYGNSHSzdIc=
X-Google-Smtp-Source: ABdhPJxu/Lu0+tqy5r7stynf3bxCZN+S2Pd635BU8/UGHeIyyy+vw2zQwKM8Hn4nI4yCeCHDiRDvEw==
X-Received: by 2002:a17:90a:8a8b:: with SMTP id x11mr15208004pjn.151.1615570801371;
        Fri, 12 Mar 2021 09:40:01 -0800 (PST)
Received: from bbox-1.mtv.corp.google.com ([2620:15c:211:201:8d76:9272:43a9:a6d0])
        by smtp.gmail.com with ESMTPSA id g21sm2694958pjl.28.2021.03.12.09.39.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 12 Mar 2021 09:40:00 -0800 (PST)
Sender: Minchan Kim <minchan.kim@gmail.com>
From:   Minchan Kim <minchan@kernel.org>
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     joaodias@google.com, LKML <linux-kernel@vger.kernel.org>,
        Amos Bianchi <amosbianchi@google.com>,
        Colin Ian King <colin.king@canonical.com>,
        Minchan Kim <minchan@kernel.org>,
        Sergey Senozhatsky <sergey.senozhatsky@gmail.com>,
        stable@vger.kernel.org
Subject: [PATCH 2/2] zram: fix broken page writeback
Date:   Fri, 12 Mar 2021 09:39:49 -0800
Message-Id: <20210312173949.2197662-2-minchan@kernel.org>
X-Mailer: git-send-email 2.31.0.rc2.261.g7f71774620-goog
In-Reply-To: <20210312173949.2197662-1-minchan@kernel.org>
References: <20210312173949.2197662-1-minchan@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit 0d8359620d9b ("zram: support page writeback") introduced
two problems. It overwrites writeback_store's return value as
kstrtol's return value, which makes return value zero so user
could see zero as return value of write syscall even though it
wrote data successfully.

It also breaks index value in the loop in that it doesn't
increase the index any longer. It means it can write only
first starting block index so user couldn't write all idle
pages in the zram so lose memory saving chance.

This patch fixes those issues.

Cc: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>
Cc: stable@vger.kernel.org
Reported-by: Amos Bianchi <amosbianchi@google.com>
Fixes: 0d8359620d9b("zram: support page writeback")
Signed-off-by: Minchan Kim <minchan@kernel.org>
---
 drivers/block/zram/zram_drv.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/block/zram/zram_drv.c b/drivers/block/zram/zram_drv.c
index 63bbefdffc81..cf8deecc39ef 100644
--- a/drivers/block/zram/zram_drv.c
+++ b/drivers/block/zram/zram_drv.c
@@ -638,8 +638,8 @@ static ssize_t writeback_store(struct device *dev,
 		if (strncmp(buf, PAGE_WB_SIG, sizeof(PAGE_WB_SIG) - 1))
 			return -EINVAL;
 
-		ret = kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index);
-		if (ret || index >= nr_pages)
+		if (kstrtol(buf + sizeof(PAGE_WB_SIG) - 1, 10, &index) ||
+				index >= nr_pages)
 			return -EINVAL;
 
 		nr_pages = 1;
@@ -663,7 +663,7 @@ static ssize_t writeback_store(struct device *dev,
 		goto release_init_lock;
 	}
 
-	while (nr_pages--) {
+	for (; nr_pages != 0; index++, nr_pages--) {
 		struct bio_vec bvec;
 
 		bvec.bv_page = page;
-- 
2.31.0.rc2.261.g7f71774620-goog

