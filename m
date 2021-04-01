Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25040351F8C
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234914AbhDATVU (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbhDATVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:21:12 -0400
Received: from mail-qk1-x749.google.com (mail-qk1-x749.google.com [IPv6:2607:f8b0:4864:20::749])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63D54C048F2F
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:17:54 -0700 (PDT)
Received: by mail-qk1-x749.google.com with SMTP id v136so4303662qkb.9
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:17:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xxiAXSo3VjIRKYILlCaYgYwnfwMxsag7xg8F7C8V4gk=;
        b=WHCnyfgYE72BsxoC3+we8HzNs4Cc2W1zdmE2FBIe8p+ZzPpPzsPi4TtDXqwNyNCWiP
         +Gg6WechHI5zDExRJ9YvYIIXygcLqALrlFi3u3gY01HPKlZgpBcGUJUK1CmSam6/Gtpb
         z1zC77H9PxKT39XC6llEq3qNKJTrdeTO/C1UAuUipIPijkof5was8wfysttuQOB6Ul9K
         p5zoGxqTEtpRm/rRTG8FoFoUO60ZHTf9Ho6P8g4rHxBaF9VnMrRhVQ0REouKLdZYLUO7
         9MQ5wPt6Sejmp+5AnwsHVoj0KjgBeostzPsWDXVe2OmFvRkatC4LvBzmvvzybLQTKqvP
         yE5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xxiAXSo3VjIRKYILlCaYgYwnfwMxsag7xg8F7C8V4gk=;
        b=KkUlURlEZ4O9q1HlsT+/9/FuvAblfAKRaiTv6la9t3tKU0W1TPzT5rC/binLCwqAXa
         JGALJS4GTk9WYajbK9bo/uCeEVfyF8euduK0XLFfC7Ibz2TU1PBUfFANAYy+YbaOGZm9
         aXqg+/nWIP8H580RNRqPWo3ZG7wVU5VmYOIT5W6YVTPtK+SXNhnO6kuQayJXYoELJrhC
         tXeZc4bHHxQD/qp+Jq/x4J1rMP8HORncafO8HnrWmw8vl4omGlFKttgiHn+aWvJVxFKe
         LEgjP0ikhV/8TPdK90HPuKDQB2sir8lqzAP+99j70WsquPzG4TXnpqlHhbDv/VvywYGH
         wmiQ==
X-Gm-Message-State: AOAM531Z1jxOmBquca5UZA3/G9LxMStZ9PkG9zSz9SeOdoJNqE6kkjiW
        BnJmsfWJA8kXhyo+ZCheglPVoXPFNKFpE4b5l2GjLIgBZQLJCBErsNtA7G8GjXEAdzCKrnkV9Ra
        DcMbPecfJ7X6Nm5+7YmpBsXztXN6Q3TayeiqLGc3t8J9Jbv2a5xX3kY80SAgqsA==
X-Google-Smtp-Source: ABdhPJzWpshHJYnTRPhKzhXMsIiS2RDdrBVS8l2L80P/crekRlC8oE3WyRSgXrn5+ygoLXbaAAC9XSW3rIs=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:899:1066:21fc:b3c5])
 (user=surenb job=sendgmr) by 2002:a05:6214:9c9:: with SMTP id
 dp9mr9503117qvb.34.1617301073524; Thu, 01 Apr 2021 11:17:53 -0700 (PDT)
Date:   Thu,  1 Apr 2021 11:17:39 -0700
In-Reply-To: <20210401181741.168763-1-surenb@google.com>
Message-Id: <20210401181741.168763-4-surenb@google.com>
Mime-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 3/5] mm: fix misplaced unlock_page in do_wp_page()
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Qian Cai <cai@redhat.com>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Linus Torvalds <torvalds@linux-foundation.org>

Commit 09854ba94c6a ("mm: do_wp_page() simplification") reorganized all
the code around the page re-use vs copy, but in the process also moved
the final unlock_page() around to after the wp_page_reuse() call.

That normally doesn't matter - but it means that the unlock_page() is
now done after releasing the page table lock.  Again, not a big deal,
you'd think.

But it turns out that it's very wrong indeed, because once we've
released the page table lock, we've basically lost our only reference to
the page - the page tables - and it could now be free'd at any time.  We
do hold the mmap_sem, so no actual unmap() can happen, but madvise can
come in and a MADV_DONTNEED will zap the page range - and free the page.

So now the page may be free'd just as we're unlocking it, which in turn
will usually trigger a "Bad page state" error in the freeing path.  To
make matters more confusing, by the time the debug code prints out the
page state, the unlock has typically completed and everything looks fine
again.

This all doesn't happen in any normal situations, but it does trigger
with the dirtyc0w_child LTP test.  And it seems to trigger much more
easily (but not expclusively) on s390 than elsewhere, probably because
s390 doesn't do the "batch pages up for freeing after the TLB flush"
that gives the unlock_page() more time to complete and makes the race
harder to hit.

Fixes: 09854ba94c6a ("mm: do_wp_page() simplification")
Link: https://lore.kernel.org/lkml/a46e9bbef2ed4e17778f5615e818526ef848d791.camel@redhat.com/
Link: https://lore.kernel.org/linux-mm/c41149a8-211e-390b-af1d-d5eee690fecb@linux.alibaba.com/
Reported-by: Qian Cai <cai@redhat.com>
Reported-by: Alex Shi <alex.shi@linux.alibaba.com>
Bisected-and-analyzed-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Tested-by: Gerald Schaefer <gerald.schaefer@linux.ibm.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 mm/memory.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memory.c b/mm/memory.c
index e84648d81d6d..14470ceaf3f2 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2848,8 +2848,8 @@ static int do_wp_page(struct vm_fault *vmf)
 		 * page count reference, and the page is locked,
 		 * it's dark out, and we're wearing sunglasses. Hit it.
 		 */
-		wp_page_reuse(vmf);
 		unlock_page(page);
+		wp_page_reuse(vmf);
 		return VM_FAULT_WRITE;
 	} else if (unlikely((vma->vm_flags & (VM_WRITE|VM_SHARED)) ==
 					(VM_WRITE|VM_SHARED))) {
-- 
2.31.0.291.g576ba9dcdaf-goog

