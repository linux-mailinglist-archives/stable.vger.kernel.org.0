Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3918F3B85B1
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 17:02:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235772AbhF3PFJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 11:05:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235552AbhF3PFI (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 11:05:08 -0400
Received: from mail-wm1-x349.google.com (mail-wm1-x349.google.com [IPv6:2a00:1450:4864:20::349])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09D5C061766
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 08:02:39 -0700 (PDT)
Received: by mail-wm1-x349.google.com with SMTP id a129-20020a1ce3870000b02901f050bc61d2so857491wmh.8
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 08:02:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lvrIaQ6ThTaENrGFdNSy44zlHv6vzHwWs8O331HJaOs=;
        b=UedDNaHadRhM1ur9CcmhNsbBrMJzHEB1U+0r2AOapItU7e7vsnxt3c9g0LnyNpCox3
         oY1ub/Vq0GNFDP4URYTbHrG8G5qqLvTSMvekpZ4F39GE+u/bot8Kanw4LCwn+j36aEhj
         i47cryF1FdWFZi8blrc9xRb9zSV5lPP5aTPFNlpA3Y2di1UfAV6KrCZKzGTJqnsnSEQU
         sgUjRWtus0jBIR8XPgwE9r6tldW5PgFmHRGZm3jmRejMWv/x/2NmjRQGf/uWQZsvRxvE
         ymtFZELBVHFsnM8UZ/4gj3dTCBECQeH/udKlGBdrzTQKS3VQ5J61/+i+aKSV6UlzGt7g
         5ARQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lvrIaQ6ThTaENrGFdNSy44zlHv6vzHwWs8O331HJaOs=;
        b=BLtzMpDfdyNSMu258zvk2zdFeo3LNA9vKC3OqH9FyTWolzzW/dwTDPN8HmGyzbpTE1
         sBJI7HrWQ8klrpYMt8AVANdQM6rWKveMBS3gufCUllLrZmoDndJEyuy7Vsjp/gEnWbIJ
         0dvdn5dyzpEoxexB1CbIAT7oMogqbsHViZszhYAsUMBKymedn00abjOKaTjy0sXARVa8
         ap+986VNrU2VVgiGA7IcS0ixxo2chSfsmpiR56Fi+5C9taB2MW2VduCwpC3aSctgGId2
         yEbtYQqHRfg263PupsMTWGwnaYUFqc7iWHK0I8RPHmUIjpxipkL7MQwNsw+eLWijHBrz
         smJw==
X-Gm-Message-State: AOAM533dM+jPQuv+H8qWbzkCoEFxEMPeJRuNJchzey2XkMBq1N20byWD
        lYU/Qw0nIGdRz2cU2Ay5ahTfeAUU6CI=
X-Google-Smtp-Source: ABdhPJw3Yb4pAIycwjH7H7zCVelcp5Z4pYuZ2OS90TFwioUrU+wqzGQYm+MMsUvB66LM+CC6SclAOogXvy4=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:15:13:a3fc:e8:8089:1013])
 (user=glider job=sendgmr) by 2002:a05:600c:1552:: with SMTP id
 f18mr39350083wmg.184.1625065358251; Wed, 30 Jun 2021 08:02:38 -0700 (PDT)
Date:   Wed, 30 Jun 2021 17:02:33 +0200
Message-Id: <20210630150234.1109496-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v4 1/2] kfence: move the size check to the beginning of __kfence_alloc()
From:   Alexander Potapenko <glider@google.com>
To:     akpm@linux-foundation.org
Cc:     dvyukov@google.com, elver@google.com, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, stable@vger.kernel.org,
        gregkh@linuxfoundation.org, jrdr.linux@gmail.com,
        Alexander Potapenko <glider@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Check the allocation size before toggling kfence_allocation_gate.
This way allocations that can't be served by KFENCE will not result in
waiting for another CONFIG_KFENCE_SAMPLE_INTERVAL without allocating
anything.

Suggested-by: Marco Elver <elver@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: Marco Elver <elver@google.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: stable@vger.kernel.org # 5.12+
Signed-off-by: Alexander Potapenko <glider@google.com>
Reviewed-by: Marco Elver <elver@google.com>
---
 mm/kfence/core.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/mm/kfence/core.c b/mm/kfence/core.c
index 4d21ac44d5d35..33bb20d91bf6a 100644
--- a/mm/kfence/core.c
+++ b/mm/kfence/core.c
@@ -733,6 +733,13 @@ void kfence_shutdown_cache(struct kmem_cache *s)
 
 void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 {
+	/*
+	 * Perform size check before switching kfence_allocation_gate, so that
+	 * we don't disable KFENCE without making an allocation.
+	 */
+	if (size > PAGE_SIZE)
+		return NULL;
+
 	/*
 	 * allocation_gate only needs to become non-zero, so it doesn't make
 	 * sense to continue writing to it and pay the associated contention
@@ -757,9 +764,6 @@ void *__kfence_alloc(struct kmem_cache *s, size_t size, gfp_t flags)
 	if (!READ_ONCE(kfence_enabled))
 		return NULL;
 
-	if (size > PAGE_SIZE)
-		return NULL;
-
 	return kfence_guarded_alloc(s, size, flags);
 }
 
-- 
2.32.0.93.g670b81a890-goog

