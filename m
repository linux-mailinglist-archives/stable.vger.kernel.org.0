Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64BC4351F98
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:22:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234981AbhDATWw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:22:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234596AbhDATWq (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:22:46 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EDE2C049FCD
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:21:35 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id o70so4294797qke.16
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:21:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8Xx3EMbt3lWftC565J98KDcCTdVlINzv28vYEZ4TIC0=;
        b=CyTw/nT5gMtmomOnKvEQJWZQC7zx7O8RFWGWRxX1tBWJoRo/mtzO45PCK/X6LfVZBz
         TZj6ALX+DBVMAVBlnTM+hlWEgoJM0Ebb5G+cDixyLdkNAnMyJWoDadrg2W1TXJ8th1OW
         K8GsDUjTdnEv+/LqBvFA5sS0KivmMPAw/x6BAd4tcpCohJgaIGS0n2YVooRvSsnYW2e2
         BpR1BcAhpDqAkqf63CK8ZPeIwwFfr3YbefIcirUMQ2NOSxK6x7ktzhGRAp+bvEk48aF1
         sfgIgYMBx4denxOtxjkHtyapTJ3khXVxmZ7xCSYyW1wtcgznxcTYvNjW/Ntjctq20j0k
         a77A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8Xx3EMbt3lWftC565J98KDcCTdVlINzv28vYEZ4TIC0=;
        b=C1QLxNvZVW8njJKlZaN5LZ9Ou64/Ozf+jxUT0WW7pdLh1RQjvfBeRtOvVKJ/BYBrne
         b6x5txp+coaOum8Jr05/tIpeTtToPCd8CC8v7z929QA3iGULaLjSq2fxTvGZpjXO7T1V
         tkw2KY0xBMtuLOeeq2Kwwxs0RQowJUovXKSBWJtdJIXuMCDpSHmhkwnpALOfn4TyBRDR
         GlUoauoojBL5HO5QTFE/NEEWLXesL3xiLKBKNlESjzyplgIpbcze0iCybg4bLhGAc4Gx
         XbB0Q4ImJH1f1VHh3dwDBSEvwqSwqDswt7kHvDqxXbesxVCX7U9Ixq78lI2iU1AoJMzt
         mgXQ==
X-Gm-Message-State: AOAM532cY5QEjtqU/tIJG1f1X7Nhi7fBThcndlHMFaCH8pbVWhkp8aQR
        5/rG1pwgIjAOa/Jat9KUKPY/NMKe4B5i219difGoMhP0Il2GbhmmnXI97OnTR8QYWGYv/Tgzbpy
        S7l1osfzrjlXDozP5Ol/JMtgnuwP4mTVPEVqQQM9TtZbLXOES/8PTW7690qVQ2Q==
X-Google-Smtp-Source: ABdhPJzYZtXxecIdNmcFtDCEDkAl7Gs49jiklL4srXB9l0qyspWnXlQ8pnumnoU7LzSqaXDiu3/eTNejh00=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:899:1066:21fc:b3c5])
 (user=surenb job=sendgmr) by 2002:a05:6214:1c0c:: with SMTP id
 u12mr9334832qvc.24.1617301294229; Thu, 01 Apr 2021 11:21:34 -0700 (PDT)
Date:   Thu,  1 Apr 2021 11:21:23 -0700
In-Reply-To: <20210401182125.171484-1-surenb@google.com>
Message-Id: <20210401182125.171484-4-surenb@google.com>
Mime-Version: 1.0
References: <20210401182125.171484-1-surenb@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 3/5] mm: fix misplaced unlock_page in do_wp_page()
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, surenb@google.com,
        Qian Cai <cai@redhat.com>,
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
index d95a4573a273..656d90a75cf8 100644
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -2863,8 +2863,8 @@ static vm_fault_t do_wp_page(struct vm_fault *vmf)
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

