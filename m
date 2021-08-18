Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9B133F0427
	for <lists+stable@lfdr.de>; Wed, 18 Aug 2021 15:03:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236365AbhHRNDn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 18 Aug 2021 09:03:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236646AbhHRNDm (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 18 Aug 2021 09:03:42 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58371C061764
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 06:03:07 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id z1-20020adfdf810000b0290154f7f8c412so558260wrl.21
        for <stable@vger.kernel.org>; Wed, 18 Aug 2021 06:03:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=RrG3CyO9Gjt37gk9O8igCLRvqsHUd/YOk6xR8PM41xQ=;
        b=mUuxo16hVJ+iZgyLxC/SaVrM1114EX1QQ8bF2KypKKGX1JQEyAfvoujkSpT0sGjXTh
         MmG7VHJVTVnSrFHhgY0E8Xr0I7tz+ZAMbyqFV312p3CuLzmNv/iH1Rjv/ge2Oe426hqh
         pup5K/Ou0j9iqKQLgX+OxbxI8iAoZyYbSleEejVKg5aDm+a0zwEyEkD6QzV7IEUCMxs8
         jaydHwdr9D2u1R3P9aAmXFZ/SavvdP9B7wfMP3mRTX1DjzGLo5XGcaZD6GGDueu7ehZe
         nqpdtyOxPLHHmPgYQUVC1EMuERPjPRKxHlidRCzvKDJKXzywaY5qkAhb2zSu0pifJh3g
         1C8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=RrG3CyO9Gjt37gk9O8igCLRvqsHUd/YOk6xR8PM41xQ=;
        b=pTyKrJem7ojPn5blzOhm/wiXnsRTcOqWB2dFbSmx8iRioNQx+N1prHatsEYCFtj1uK
         RVwTfg6UaJ4k9quF591A2DM1RVCLJgpYR5dV04EVIwAJ6tqklovfEZj05jkRch5TOgvh
         jdGLkoT9R4rWi3Z/qTHr3BK1fYWIeXCLvoSngmyMgerK+w+we/DAmjZb+PLwWm86qQIj
         8Xf9kHe1PCCc4kt4wLyLwbRAzaiZvUKEuHriooFyM/ahzH2u8GMeES+B/y692CbIlvyt
         kk0SBStnVC6e3vXMSMsQvkfuZt9LEDJ0/TTqrIN+QUtA82H0MwSBaVHQomIy3JGF/jIr
         QUgw==
X-Gm-Message-State: AOAM532dNIXLakS173qU1YJa3fcek0Eq31sBaA/2RLXkFQKH+hwXXOj/
        JhXHl01x+G5WqrDrPAcnF9Y0CeCXuw==
X-Google-Smtp-Source: ABdhPJzbSbjgQk5lmEa3hM+PK3vcJ+Jbea7iM+3mGTQTNzNWuNnofg3TzKJCoftHPaHYa4/ctrMFY6/l4Q==
X-Received: from elver.muc.corp.google.com ([2a00:79e0:15:13:52dc:2f6d:34df:96a5])
 (user=elver job=sendgmr) by 2002:a05:600c:35d3:: with SMTP id
 r19mr574288wmq.1.1629291785265; Wed, 18 Aug 2021 06:03:05 -0700 (PDT)
Date:   Wed, 18 Aug 2021 15:03:00 +0200
Message-Id: <20210818130300.2482437-1-elver@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.rc1.237.g0d66db33f3-goog
Subject: [PATCH] kfence: fix is_kfence_address() for addresses below KFENCE_POOL_SIZE
From:   Marco Elver <elver@google.com>
To:     elver@google.com, akpm@linux-foundation.org
Cc:     glider@google.com, dvyukov@google.com,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        kasan-dev@googlegroups.com,
        Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>,
        stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Originally the addr != NULL check was meant to take care of the case
where __kfence_pool == NULL (KFENCE is disabled). However, this does not
work for addresses where addr > 0 && addr < KFENCE_POOL_SIZE.

This can be the case on NULL-deref where addr > 0 && addr < PAGE_SIZE or
any other faulting access with addr < KFENCE_POOL_SIZE. While the kernel
would likely crash, the stack traces and report might be confusing due
to double faults upon KFENCE's attempt to unprotect such an address.

Fix it by just checking that __kfence_pool != NULL instead.

Fixes: 0ce20dd84089 ("mm: add Kernel Electric-Fence infrastructure")
Reported-by: Kuan-Ying Lee <Kuan-Ying.Lee@mediatek.com>
Signed-off-by: Marco Elver <elver@google.com>
Cc: <stable@vger.kernel.org>    [5.12+]
---
 include/linux/kfence.h | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/linux/kfence.h b/include/linux/kfence.h
index a70d1ea03532..3fe6dd8a18c1 100644
--- a/include/linux/kfence.h
+++ b/include/linux/kfence.h
@@ -51,10 +51,11 @@ extern atomic_t kfence_allocation_gate;
 static __always_inline bool is_kfence_address(const void *addr)
 {
 	/*
-	 * The non-NULL check is required in case the __kfence_pool pointer was
-	 * never initialized; keep it in the slow-path after the range-check.
+	 * The __kfence_pool != NULL check is required to deal with the case
+	 * where __kfence_pool == NULL && addr < KFENCE_POOL_SIZE. Keep it in
+	 * the slow-path after the range-check!
 	 */
-	return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && addr);
+	return unlikely((unsigned long)((char *)addr - __kfence_pool) < KFENCE_POOL_SIZE && __kfence_pool);
 }
 
 /**
-- 
2.33.0.rc1.237.g0d66db33f3-goog

