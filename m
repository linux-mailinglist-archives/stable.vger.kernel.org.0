Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C2A6C573885
	for <lists+stable@lfdr.de>; Wed, 13 Jul 2022 16:13:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbiGMONn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 Jul 2022 10:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbiGMONk (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 Jul 2022 10:13:40 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87BBF9FC5
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 07:13:39 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id d1so191929qko.13
        for <stable@vger.kernel.org>; Wed, 13 Jul 2022 07:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXRv0gtyHIIjpH4XHcFmhsbTOk+Z7GVu51i8mbaOjmU=;
        b=z/dz1t+89fSoikCSPNvj2ywJY/buZPTmgbQ1N+m8xrst4vrTWeYz4qZOXZMWMUXGb4
         2s6tWDBAak5/bqzgqVbkW5h53Wca2C2848w1FJHdwNtTmlAdk62sh8QDv8AuTH19uj4N
         +weYBRwlOoYcCBslvWDtmMwznCTobZ5kYaW8/DDGczQeduZHx5t68m7FaMtbVpj7uhwQ
         BT896bYA08lOh8Zh3e26csS/91xHcnAdEwyfhIm756VVCXGnv5+1XRxGgEguZ0RZBW2i
         B1ibpyGlwR7xq9aqUWgGI8leuKYnW38GYsVZ1eR9U7pMjMiXPnTLUTCDgWNeGlE5p9BM
         Hu+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=zXRv0gtyHIIjpH4XHcFmhsbTOk+Z7GVu51i8mbaOjmU=;
        b=cPxTuI+4l7fz7o7rEL5NHKOZSmnnTsbY3Ib3RF2Tili31Hn2I3ps4GdcoAUahwbVZ6
         N1/OFlIH54lBLTwFprsP5yfraQnr7b6PDNefPqa8TYFy0eAsi2Cg6MOgVGSIJJ1oWX96
         eBSs439RHgDc1v82tNytUGS+pd206FilYb9R37Il036qY9AqDQ0ceWb76kNc4xFIcCCu
         3m/BI5QcmXBcofXyffei2qfnJ7kcdDKAKqPxSfhmlX/DTFLbfYESU9csg2Ed2FWWdsQK
         P7AqHHBK9jDo18+EQ1Sj+CYPwjKfrE2P8We8UIZiwiH4+y7mWvbdDzFV7FSdNmztxc1A
         LmrQ==
X-Gm-Message-State: AJIora8ZgVPBF6J39X8SraZ1devkER9BWCmcd5kexH74XH8MCwV9GK0w
        E7izJfs8Jggrvj67swFxQ0mKan0jIOdS2A==
X-Google-Smtp-Source: AGRyM1s+u+leCBPwtg87lHA5q/oV4ruD4KylxxEIcztUxa3a/kH9KlYVUyLT8vIubJB8aH7WGVlNSQ==
X-Received: by 2002:ae9:e64a:0:b0:6b5:90cf:822 with SMTP id x10-20020ae9e64a000000b006b590cf0822mr2500695qkl.541.1657721618420;
        Wed, 13 Jul 2022 07:13:38 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id l20-20020a05622a175400b00304fa21762csm6778274qtk.53.2022.07.13.07.13.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jul 2022 07:13:37 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     akpm@linux-foundation.org, linux-mm@kvack.org
Cc:     "Kirill A . Shutemov" <kirill.shutemov@linux.intel.com>,
        Matthew Wilcox <willy@infradead.org>, stable@vger.kernel.org,
        Rik van Riel <riel@surriel.com>, Chris Mason <clm@fb.com>
Subject: [PATCH v2] mm: fix page leak with multiple threads mapping the same page
Date:   Wed, 13 Jul 2022 10:13:37 -0400
Message-Id: <e90c8f0dbae836632b669c2afc434006a00d4a67.1657721478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.26.3
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We have an application with a lot of threads that use a shared mmap
backed by tmpfs mounted with -o huge=within_size.  This application
started leaking loads of huge pages when we upgraded to a recent kernel.

Using the page ref tracepoints and a BPF program written by Tejun Heo we
were able to determine that these pages would have multiple refcounts
from the page fault path, but when it came to unmap time we wouldn't
drop the number of refs we had added from the faults.

I wrote a reproducer that mmap'ed a file backed by tmpfs with -o
huge=always, and then spawned 20 threads all looping faulting random
offsets in this map, while using madvise(MADV_DONTNEED) randomly for
huge page aligned ranges.  This very quickly reproduced the problem.

The problem here is that we check for the case that we have multiple
threads faulting in a range that was previously unmapped.  One thread
maps the PMD, the other thread loses the race and then returns 0.
However at this point we already have the page, and we are no longer
putting this page into the processes address space, and so we leak the
page.  We actually did the correct thing prior to f9ce0be71d1f, however
it looks like Kirill copied what we do in the anonymous page case.  In
the anonymous page case we don't yet have a page, so we don't have to
drop a reference on anything.  Previously we did the correct thing for
file based faults by returning VM_FAULT_NOPAGE so we correctly drop the
reference on the page we faulted in.

Fix this by returning VM_FAULT_NOPAGE in the pmd_devmap_trans_unstable()
case, this makes us drop the ref on the page properly, and now my
reproducer no longer leaks the huge pages.

Fixes: f9ce0be71d1f ("mm: Cleanup faultaround and finish_fault() codepaths")
Cc: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: stable@vger.kernel.org
Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Rik van Riel <riel@surriel.com>
Signed-off-by: Chris Mason <clm@fb.com>
---
v1->v2:
- Added Kirill's Acked-by.
- Added cc:stable
- Added a comment about why we need to return NOPAGE.

 mm/memory.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/mm/memory.c b/mm/memory.c
index 7a089145cad4..207b29b09286 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -4369,9 +4369,12 @@ vm_fault_t finish_fault(struct vm_fault *vmf)
 			return VM_FAULT_OOM;
 	}
 
-	/* See comment in handle_pte_fault() */
+	/*
+	 * See comment in handle_pte_fault() for how this scenario happens, we
+	 * need to return NOPAGE so that we drop this page.
+	 */
 	if (pmd_devmap_trans_unstable(vmf->pmd))
-		return 0;
+		return VM_FAULT_NOPAGE;
 
 	vmf->pte = pte_offset_map_lock(vma->vm_mm, vmf->pmd,
 				      vmf->address, &vmf->ptl);
-- 
2.36.1

