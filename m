Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B5F153B8499
	for <lists+stable@lfdr.de>; Wed, 30 Jun 2021 16:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235978AbhF3OEi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 30 Jun 2021 10:04:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236441AbhF3OEc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 30 Jun 2021 10:04:32 -0400
Received: from mail-wr1-x449.google.com (mail-wr1-x449.google.com [IPv6:2a00:1450:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7338C09B095
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 06:53:22 -0700 (PDT)
Received: by mail-wr1-x449.google.com with SMTP id u16-20020a5d51500000b029011a6a17cf62so982751wrt.13
        for <stable@vger.kernel.org>; Wed, 30 Jun 2021 06:53:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=dtH0IQ32mjHBoYzYQxUVAIZ8CYFo4XITSUGYSoSmvuA=;
        b=n8OrDYvB4lu0VQjvPLvwRPRKVdXxpGavb6OmQT8FlcNgMfasGdem5Xe1GYKcQwQLjF
         eqsZ/j6Bbhjo4RwvKBjlIA3938u9XJL5kaLuPE+AemK9oldlEH9n/O7jYcK/nQm3nGC/
         Nodeu3rbuP4Y585s02N0WHsbJ2x4Ya5xzJ+LCr23nVTYRDU3lUUHASCch1pHLLVWRqzx
         qK2MpDY+sFqPLYhBmtHXEGpiDV69xYuYF+iyRSt6NjSv0Iz7u/pnaDM80+VLCjkUWrmC
         MpK9GM8HVUwec7+08q8yLbjtgq8yh5ljCYRIegMIXTR9+YZw73NAB/ZVV8kyVtmNYwC6
         MRIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=dtH0IQ32mjHBoYzYQxUVAIZ8CYFo4XITSUGYSoSmvuA=;
        b=A35VcCIc+AfCL4b+0JrPKqEKgT3vTyKRgwCJVn+u0Sd/p67i93Ei/2DpMyb62saMeg
         CPbJe7ubCFr9A5TcsOm4mJtBj58cSi+qf++TsxRm5wqpg+iZoyFIp+ATMBov2uL/GmpP
         mzcXDZ8iJqffXIjL4XddieW4qBpQIRb9vxuXBtoU4kkFIPjXtKZEFndaWnBts3Nc4aXX
         G1wpdWCezE/OgaDdVu7p0/Sd24F3z9+GS5WTj+9/7p578gRarpHmWAPKqZSPz8w5SibN
         QUrSPWiH54SvV1H42tQN1Lb+F3xO3AI9Cf9RKhYJh3ulQvxiDvhp7gf/w6siLFNdD05C
         Wyyg==
X-Gm-Message-State: AOAM530wuwKKzvNXYdcEkwZMai41BGYMb39kLWHC/FIVk0fNZ6sgVuOR
        O+3DTypEBNWzWV/58gJs7eV7w18W92o=
X-Google-Smtp-Source: ABdhPJxEOOWrV1qY5ZQLKAMR0q+wxV55Lm0/JLt5nQqznaRHf1ul1AN8gIWXEvsyC132NIT7onyLV9XuHP4=
X-Received: from glider.muc.corp.google.com ([2a00:79e0:15:13:a3fc:e8:8089:1013])
 (user=glider job=sendgmr) by 2002:a1c:638a:: with SMTP id x132mr4681717wmb.90.1625061200569;
 Wed, 30 Jun 2021 06:53:20 -0700 (PDT)
Date:   Wed, 30 Jun 2021 15:53:12 +0200
Message-Id: <20210630135313.1072577-1-glider@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.93.g670b81a890-goog
Subject: [PATCH v3 1/2] kfence: move the size check to the beginning of __kfence_alloc()
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

