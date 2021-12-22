Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5345747D7F6
	for <lists+stable@lfdr.de>; Wed, 22 Dec 2021 20:48:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345308AbhLVTsk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Dec 2021 14:48:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230447AbhLVTsk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 22 Dec 2021 14:48:40 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A114BC061574
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 11:48:39 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id d9so7111336wrb.0
        for <stable@vger.kernel.org>; Wed, 22 Dec 2021 11:48:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=colorfullife-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s0Np47Sa5pl9gnz8YRlCOL68fxuhegQ0UELp+V7hih0=;
        b=ShpxXURYszaRMGGR7Amw9aByeA2z9pmwguw8vJMrwma0p7JrEpZAR//BeulUjTnj4B
         D3Gv45fD6hNXeM3/mRdYiiBubdKW7j+wgRlIWLPf8R7hqqaUhWdTgxePlh4HoTJ32G2V
         ezxsX+SpUXz95b65NKPd3pqEt2CuZ2oBGk30meGymGMRMGxngkY7I9E/uvR+1jMxQtkD
         u+OS/gIG7X3qxv9zdGVx/hOSUR+/EB8nN01ntjA3CDwTZI/SQ0MgKd6zXX7XQ9MFzNGr
         G2U6eUr1iavHJofLSRrJ5ZmkNCcggBSQCKFQDZUhdNgQraXr0UtZ/TvbyTkEROBnYCYp
         ncmQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=s0Np47Sa5pl9gnz8YRlCOL68fxuhegQ0UELp+V7hih0=;
        b=taZNdt7Kh4ndfIaFn/xixeR+fad+EfcyCUiFKoDGOnrtu8laO7RM3YnrPe66u5Xzyn
         5ZFoWJkIprHFw6HWjS3J7mXxla/nb18N6ipsA9+pz359Aw+nnhgpducDa5qqo/ZubOt2
         uy5TGrwgOBFI8pJyKcIXp1xOSaq4WjcBXIx5DVORxH++dpeHov4zGPqV+z2CiDE+YE1m
         VLr+HIjpbJt5+id3x8vFk6WzCdX3XC3GzpYB2Av3wUp+3sqYcgwMpTfHYKyajr7HeI4Y
         SVRDAMtru7+Tk31K4vv8675krMPFkSLSQ4xtxDrki8rx4gcUaACGvxgwRDcEBshuxaJe
         MIGQ==
X-Gm-Message-State: AOAM532iOSMEgwY6WmOvjkFeqcPtAO+mKVY4pK7A1qAjuoAI/JL4X72l
        MT60HWFYQZ7nvj+gzmWhupLzLw==
X-Google-Smtp-Source: ABdhPJwrNjuRSRbCuEDIvyvjT5LMfUxmfDcjFXxqtdFWy3mco/AY4P0vZNGjc6maPs4bae7pSiZfeg==
X-Received: by 2002:a5d:4dca:: with SMTP id f10mr3113197wru.595.1640202518184;
        Wed, 22 Dec 2021 11:48:38 -0800 (PST)
Received: from localhost.localdomain (p200300d9970878003dae64a47964a371.dip0.t-ipconnect.de. [2003:d9:9708:7800:3dae:64a4:7964:a371])
        by smtp.googlemail.com with ESMTPSA id c7sm3273596wri.21.2021.12.22.11.48.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Dec 2021 11:48:37 -0800 (PST)
From:   Manfred Spraul <manfred@colorfullife.com>
To:     LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Cc:     Vasily Averin <vvs@virtuozzo.com>, cgel.zte@gmail.com,
        shakeelb@google.com, rdunlap@infradead.org, dbueso@suse.de,
        unixbhaskar@gmail.com, chi.minghao@zte.com.cn, arnd@arndb.de,
        Zeal Robot <zealci@zte.com.cn>, linux-mm@kvack.org,
        1vier1@web.de, Manfred Spraul <manfred@colorfullife.com>,
        stable@vger.kernel.org
Subject: [PATCH] mm/util.c: Make kvfree() safe for calling while holding spinlocks
Date:   Wed, 22 Dec 2021 20:48:28 +0100
Message-Id: <20211222194828.15320-1-manfred@colorfullife.com>
X-Mailer: git-send-email 2.33.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

One codepath in find_alloc_undo() calls kvfree() while holding a spinlock.
Since vfree() can sleep this is a bug.

Previously, the code path used kfree(), and kfree() is safe to be called
while holding a spinlock.

Minghao proposed to fix this by updating find_alloc_undo().

Alternate proposal to fix this: Instead of changing find_alloc_undo(),
change kvfree() so that the same rules as for kfree() apply:
Having different rules for kfree() and kvfree() just asks for bugs.

Disadvantage: Releasing vmalloc'ed memory will be delayed a bit.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Reported-by: Minghao Chi <chi.minghao@zte.com.cn>
Link: https://lore.kernel.org/all/20211222081026.484058-1-chi.minghao@zte.com.cn/
Fixes: fc37a3b8b438 ("[PATCH] ipc sem: use kvmalloc for sem_undo allocation")
Cc: stable@vger.kernel.org
Signed-off-by: Manfred Spraul <manfred@colorfullife.com>
---
 mm/util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/mm/util.c b/mm/util.c
index 741ba32a43ac..7f9181998835 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -610,12 +610,12 @@ EXPORT_SYMBOL(kvmalloc_node);
  * It is slightly more efficient to use kfree() or vfree() if you are certain
  * that you know which one to use.
  *
- * Context: Either preemptible task context or not-NMI interrupt.
+ * Context: Any context except NMI interrupt.
  */
 void kvfree(const void *addr)
 {
 	if (is_vmalloc_addr(addr))
-		vfree(addr);
+		vfree_atomic(addr);
 	else
 		kfree(addr);
 }
-- 
2.33.1

