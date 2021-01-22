Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 94728300141
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 12:16:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727207AbhAVLMG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 06:12:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727805AbhAVLG5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 22 Jan 2021 06:06:57 -0500
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7AB0EC0613D6
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 03:06:16 -0800 (PST)
Received: by mail-pf1-x432.google.com with SMTP id u67so3469612pfb.3
        for <stable@vger.kernel.org>; Fri, 22 Jan 2021 03:06:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=8xmowMygRP96q6ZfQepL38bbSA5RtX+xDKaDnp6OZZo=;
        b=xRAWJg9uWyvrqCaVbaGDdjfC4XRsikv5lqCfNDaWh8BruWcMsnByoGA5IerSTm4iLs
         IfocfLfTFc1n302KZOhl75FOqrKzBRaL3p8dhxhuMc6rzBc3hVp6/sysJJDRo/yQAL0a
         G9ok1GyFpyD3+RmFx6m1O4t+yCM2Foy3AHMkg7eQmFACmTQD3hgi2/PtUJZPV9lXX/O1
         npcolHS9Hz6jth/kq/FBvjUahiuiIMWuM8T6WA9sRlekgcPftdYBDwaGdlz2zI5/GgfL
         fhcnkCXn2jq71kYxLQNDNBBPTUVHzm1CuZUPl71eEoBunw7ejl9M0RfgFScOhTzszAFY
         BPYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=8xmowMygRP96q6ZfQepL38bbSA5RtX+xDKaDnp6OZZo=;
        b=Dm4G10C90kpS8TdZ7lmXZi6bxlYc4VL6uUWvKrO1jmfpN7lVKbUtLO1x5E/HKqiRch
         twjOtyDwuk/JUP/k9deIuXovRsNMTsPQvpVgI1bBV0JofW64cXc7pbkhhNREd/qlW6oF
         Lnvbwh+59hjBSORsoUnPpTyzWwi7FpYQ6OA+zd9SMWqdNEFl9pPkrN4DRB20OtCj9+0Q
         fWZm5HSQa38sBJEGId4kspINCpmUU11NDipqr13ko3dIDSiDT0dKskxiblpYkMD/jKqo
         +VBo/wjLXejLdygRe+lQoxAsoywdjMROTfJJC1SIsdhtGO5/pFy9oieEMBUD8wZQZRFF
         N9xQ==
X-Gm-Message-State: AOAM533upmvQjHHZE0FGd6zU8PhzfKoitPKIuhnu9k/InrLebngB4Qjb
        XaibPxG60WFu9LUDuu/3R7hDiQ==
X-Google-Smtp-Source: ABdhPJw9OXYA0Ves4zH7Zwge3APRupjHpxKEZURTnQT2SSrlD8+pcogSCSV9X4HvSz9Fw7OVlfcWLg==
X-Received: by 2002:a65:4549:: with SMTP id x9mr4253916pgr.6.1611313575903;
        Fri, 22 Jan 2021 03:06:15 -0800 (PST)
Received: from localhost.localdomain ([122.173.53.31])
        by smtp.gmail.com with ESMTPSA id j3sm8854562pjs.50.2021.01.22.03.06.12
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Jan 2021 03:06:15 -0800 (PST)
From:   Sumit Garg <sumit.garg@linaro.org>
To:     kgdb-bugreport@lists.sourceforge.net
Cc:     jason.wessel@windriver.com, daniel.thompson@linaro.org,
        dianders@chromium.org, linux-kernel@vger.kernel.org,
        Sumit Garg <sumit.garg@linaro.org>, stable@vger.kernel.org
Subject: [PATCH v3] kdb: Make memory allocations more robust
Date:   Fri, 22 Jan 2021 16:35:56 +0530
Message-Id: <1611313556-4004-1-git-send-email-sumit.garg@linaro.org>
X-Mailer: git-send-email 2.7.4
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Currently kdb uses in_interrupt() to determine whether its library
code has been called from the kgdb trap handler or from a saner calling
context such as driver init. This approach is broken because
in_interrupt() alone isn't able to determine kgdb trap handler entry from
normal task context. This can happen during normal use of basic features
such as breakpoints and can also be trivially reproduced using:
echo g > /proc/sysrq-trigger

We can improve this by adding check for in_dbg_master() instead which
explicitly determines if we are running in debugger context.

Cc: stable@vger.kernel.org
Signed-off-by: Sumit Garg <sumit.garg@linaro.org>
---

Changes in v3:
- Refined commit description and Cc: stable@vger.kernel.org.

Changes in v2:
- Get rid of redundant in_atomic() check.

 kernel/debug/kdb/kdb_private.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/debug/kdb/kdb_private.h b/kernel/debug/kdb/kdb_private.h
index 7a4a181..344eb0d 100644
--- a/kernel/debug/kdb/kdb_private.h
+++ b/kernel/debug/kdb/kdb_private.h
@@ -231,7 +231,7 @@ extern struct task_struct *kdb_curr_task(int);
 
 #define kdb_task_has_cpu(p) (task_curr(p))
 
-#define GFP_KDB (in_interrupt() ? GFP_ATOMIC : GFP_KERNEL)
+#define GFP_KDB (in_dbg_master() ? GFP_ATOMIC : GFP_KERNEL)
 
 extern void *debug_kmalloc(size_t size, gfp_t flags);
 extern void debug_kfree(void *);
-- 
2.7.4

