Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6D8D60FC1B
	for <lists+stable@lfdr.de>; Thu, 27 Oct 2022 17:37:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236174AbiJ0PhF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Oct 2022 11:37:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236169AbiJ0PhE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 Oct 2022 11:37:04 -0400
Received: from mail-yw1-x1149.google.com (mail-yw1-x1149.google.com [IPv6:2607:f8b0:4864:20::1149])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CB68C469
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 08:37:02 -0700 (PDT)
Received: by mail-yw1-x1149.google.com with SMTP id 00721157ae682-36ba0287319so16472437b3.3
        for <stable@vger.kernel.org>; Thu, 27 Oct 2022 08:37:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PYXrnN5iza6YPpzurOADerzZKqz3PzMIcN5CECnV9i0=;
        b=rQJZzRT6Dmnq4nMudY6UXRryJ8w245Cvfjt1RaI5F93xnjvZhUIGNEzCsOvZmyF5gf
         aCddEqOqid4yibzIBVJ4/Bj4/EgFytH+lqusMZHSIQg0TdpKejimXuo1SlDN994H0XIC
         7IhtKGFc0ZgVgdi/cuJLSeEoQsUp+LxcFl6edDcY8cvw0MMUvYqxeuOvLLGx+5Mvgsrz
         Sxjsok1lESxL36fSO3OJwaEJcPHuJvisg1RhFg4V+RiGk/4B3NyIGUlkzY3PvZQ0kq4S
         3HVGvdjDz418GkP3rs3XAd7cAtpVVFjQeJ9mU8ibxTbBMvW1to5/bxUXYjJVjSRjFTjk
         TSKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:message-id:mime-version:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=PYXrnN5iza6YPpzurOADerzZKqz3PzMIcN5CECnV9i0=;
        b=7i5bqucyxYbZSEppOKSitZHnaOQiKzuoG/asc7d2Z1+Ya7XISP4LR869BvL71pV+YX
         oEhTdK484LPCw5U3KQnaGU/DJXOVUs7gw0nWV425XGklkmksrkOFE4NZJRMTHpCHPn0B
         L9QjgKJoyPiIcV9hvNOEyTYQaCuQKqU5kLrFuSm+pO5otAsct0Ycquakfmb5j/FptDz9
         gtFTIa6ZfFTuocKdbZUTEy5Rz+zC/HUBadvs/2FZ3MY0pEDpi9TuNJ4g2wE253Mobb1z
         tHNr4HtyBIeRRoxheJh8WHqBoMZ2sGiCLi1aZfKjP7RuKqqeaTJwuP7RkHo78diMxGde
         NVyQ==
X-Gm-Message-State: ACrzQf3yqxJli6y0I6NOqQ+kuwF28HRypf+z7pnTjOoD32g+WmhctZST
        wEy9m4envEJwg9+V3BFE2YuIFdXC//neqW9Ei9gYFmZ4xUrjVBWe/MRkBVPzBZnA7SUcDoZPgsl
        aAnGedgSaRG3tazRL0DfWkXFkq0GWKHJ4DeQDImLPW5RylqvoNH8rQ+1R/Hw7k7IAA4rf5sAI3I
        Y=
X-Google-Smtp-Source: AMsMyM779ufkJM0Noob8odSoewRcY84+cD7Nb4H/zA5mwPdoYb67Q6MN3IFaGWcDmlLDAM1w4e1w43noMnAtklxolw==
X-Received: from roguebantha-cloud.c.googlers.com ([fda3:e722:ac3:cc00:2b:7d90:c0a8:1eee])
 (user=sethjenkins job=sendgmr) by 2002:a25:32ca:0:b0:6ca:40e2:90c8 with SMTP
 id y193-20020a2532ca000000b006ca40e290c8mr35115116yby.55.1666885021683; Thu,
 27 Oct 2022 08:37:01 -0700 (PDT)
Date:   Thu, 27 Oct 2022 11:36:52 -0400
Mime-Version: 1.0
X-Mailer: git-send-email 2.38.0.135.g90850a2211-goog
Message-ID: <20221027153652.899495-1-sethjenkins@google.com>
Subject: [PATCH stable 4.19-5.19] mm: /proc/pid/smaps_rollup: fix no vma's null-deref
From:   Seth Jenkins <sethjenkins@google.com>
To:     stable@vger.kernel.org
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Seth Jenkins <sethjenkins@google.com>,
        Alexey Dobriyan <adobriyan@gmail.com>
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

Commit 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value
seq_file") introduced a null-deref if there are no vma's in the task in
show_smaps_rollup.

Fixes: 258f669e7e88 ("mm: /proc/pid/smaps_rollup: convert to single value seq_file")
Signed-off-by: Seth Jenkins <sethjenkins@google.com>
Reviewed-by: Alexey Dobriyan <adobriyan@gmail.com>
Tested-by: Alexey Dobriyan <adobriyan@gmail.com>
---
c4c84f06285e on upstream resolves this issue as part of the switch to using
maple trees for VMA lookups, but a fix must still be applied to stable trees
4.19-5.19.

 fs/proc/task_mmu.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/proc/task_mmu.c b/fs/proc/task_mmu.c
index 4e0023643f8b..1e7bbc0873a4 100644
--- a/fs/proc/task_mmu.c
+++ b/fs/proc/task_mmu.c
@@ -969,7 +969,7 @@ static int show_smaps_rollup(struct seq_file *m, void *v)
 		vma = vma->vm_next;
 	}
 
-	show_vma_header_prefix(m, priv->mm->mmap->vm_start,
+	show_vma_header_prefix(m, priv->mm->mmap ? priv->mm->mmap->vm_start : 0,
 			       last_vma_end, 0, 0, 0, 0);
 	seq_pad(m, ' ');
 	seq_puts(m, "[rollup]\n");
-- 
2.38.0.rc1.362.ged0d419d3c-goog

