Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80A29414014
	for <lists+stable@lfdr.de>; Wed, 22 Sep 2021 05:33:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbhIVDfI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 21 Sep 2021 23:35:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46602 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbhIVDfI (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 21 Sep 2021 23:35:08 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29E24C061574;
        Tue, 21 Sep 2021 20:33:39 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id il14-20020a17090b164e00b0019c7a7c362dso3058183pjb.0;
        Tue, 21 Sep 2021 20:33:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQTATNYUh692iWKEczEMwnFaT7RAPjE0jlz0RulYirw=;
        b=a/IqhzdDO75haJO7x6YBCLKX61gvnWPnUA4hZU4h7adRLEL2brjyV+XQDAyvyK7RO/
         3pa+OLSKzIJRMUOoGOq3a2I/0xNYnMqq6vNheE363QmeOYlI9jzH22QbyOt7CIB7hd+b
         gF021OZ3oW+xUwQSkWki7+Woq9O3lYkVgJ54VZgyaWumhJ5rAQbC3R8HwWpIuXsAgi3w
         M75ic2MX9kRYp8XQWjvgTPXDnm520xhiKE4JULBJYivvhgGcpUITEDoXpx6GYuuzWXMY
         F3XshnhEQA5VuxYuRkllF7THaRCkA5gKjeLujlpumJ0n8hhKun71FGadjlIA2hVwNfJG
         BxYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=eQTATNYUh692iWKEczEMwnFaT7RAPjE0jlz0RulYirw=;
        b=wPw4VYz5i1ejFTVTgMrwx8/2MtBB75WBDzYHAMPT3SNP4utQ6+FNMhD8f98OiLBRL0
         QXwzX2iUOLcEkQyZNd0LkHEwrYDXAvrF+yTQfKvU4TZeUPBIzzNh1K/wwxHsVs0zRhYb
         s3JypBlRYwrjnLe8647rv4DwgTmL+4F1EXkGsfJRx/QoFEVthoyqBodAG1kEiPJSuF0x
         0rSbcchi6J3EDgiOTJy/93UMFn2KaMIvzoi8lcMG575cHpt5k3SuTrA4lS3Kcebtjok+
         tKBnJRJqWaqiBTwwUSomq4EnQ8+wKXe4UV1kTbfqL1P4EzyHun0vbARATBTaiGvq079+
         ZQ/w==
X-Gm-Message-State: AOAM5335RBkpq+FbWIt1elAA4R/UPdHkT0fM0SaDLOvEalQG3pTKISRI
        Qqda7l0GUroXp9AqRb/EGNs=
X-Google-Smtp-Source: ABdhPJz2KrQag+OKt4QC063tE+Ulganv9Gy25Vr8NKz3BeobUb+mp52m7woVoBnaRctAJza3g5U/pA==
X-Received: by 2002:a17:90a:353:: with SMTP id 19mr8936162pjf.83.1632281618361;
        Tue, 21 Sep 2021 20:33:38 -0700 (PDT)
Received: from sc2-haas01-esx0118.eng.vmware.com ([66.170.99.1])
        by smtp.gmail.com with ESMTPSA id o15sm537269pfg.14.2021.09.21.20.33.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Sep 2021 20:33:37 -0700 (PDT)
From:   Nadav Amit <nadav.amit@gmail.com>
X-Google-Original-From: Nadav Amit
To:     Andrew Morton <akpm@linux-foundation.org>
Cc:     linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, Nadav Amit <namit@vmware.com>,
        Peter Xu <peterx@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>, stable@vger.kernel.org
Subject: [PATCH] userfaultfd: fix a race between writeprotect and exit_mmap()
Date:   Tue, 21 Sep 2021 13:02:47 -0700
Message-Id: <20210921200247.25749-1-namit@vmware.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Nadav Amit <namit@vmware.com>

A race is possible when a process exits, its VMAs are removed
by exit_mmap() and at the same time userfaultfd_writeprotect() is
called.

The race was detected by KASAN on a development kernel, but it appears
to be possible on vanilla kernels as well.

Use mmget_not_zero() to prevent the race as done in other userfaultfd
operations.

Cc: Peter Xu <peterx@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: stable@vger.kernel.org
Fixes: 63b2d4174c4ad ("userfaultfd: wp: add the writeprotect API to userfaultfd ioctl")
Signed-off-by: Nadav Amit <namit@vmware.com>
---
 fs/userfaultfd.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/fs/userfaultfd.c b/fs/userfaultfd.c
index 003f0d31743e..22bf14ab2d16 100644
--- a/fs/userfaultfd.c
+++ b/fs/userfaultfd.c
@@ -1827,9 +1827,15 @@ static int userfaultfd_writeprotect(struct userfaultfd_ctx *ctx,
 	if (mode_wp && mode_dontwake)
 		return -EINVAL;
 
-	ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
-				  uffdio_wp.range.len, mode_wp,
-				  &ctx->mmap_changing);
+	if (mmget_not_zero(ctx->mm)) {
+		ret = mwriteprotect_range(ctx->mm, uffdio_wp.range.start,
+					  uffdio_wp.range.len, mode_wp,
+					  &ctx->mmap_changing);
+		mmput(ctx->mm);
+	} else {
+		return -ESRCH;
+	}
+
 	if (ret)
 		return ret;
 
-- 
2.25.1

