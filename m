Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0DBE393A71
	for <lists+stable@lfdr.de>; Fri, 28 May 2021 02:47:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234617AbhE1Asd (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 May 2021 20:48:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbhE1Asd (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 27 May 2021 20:48:33 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3173AC061760
        for <stable@vger.kernel.org>; Thu, 27 May 2021 17:46:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id j7-20020a258b870000b029052360b1e3e2so2428123ybl.8
        for <stable@vger.kernel.org>; Thu, 27 May 2021 17:46:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:cc;
        bh=PlH95++B36nHBbK4Jduk7vzZIY/Sp5eibx3QUHpkfY4=;
        b=d8JjgOYRm5B+az3o5xuyhJh4s4yOm3NSMPpy9CvUAUdDygC5AmVSotAECzCOWOmOCK
         MtEFJvT/fk65zwVtYPJ1TEzGWEeN9Ca6yQDjrucYfC5pfTScNpzBQm9l187O49k7+yo8
         ncN6n70im6MOOYNAsIho6nIgWGXR0TLfKrJGaggtrh5V7bEZuHwcLrYT207BjNul4F51
         VXa+rKxgOFpC4IlNQDcb5aNKTXzQUQpVaEbDaKWn6f2OGeYOMAmdDgqKqetmyUKN3UOd
         Y+Ky2OCUKLTsa6/W9PbdMpIq6ERJtuNnbcztazqZkEYzAa4/DoW2pq3FSK62fzEusbFu
         h8uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:cc;
        bh=PlH95++B36nHBbK4Jduk7vzZIY/Sp5eibx3QUHpkfY4=;
        b=F7ssIsWZFTHjYsnA265QaGq9tgLcAXjwKhcR2Z2LzQ4MZv3b2GKBuvm9VDqH/Av+RM
         cQ0mWZObErdt5w40J1nTF6kRXhIe1+qgIJq8piIWP1wKzR4YL9gG/40jMaXle9xNZ8pz
         LMBustHPXoK5muuLqDCJTXLqjcU35ToUDeEAhO+kNXbtgsASVN4fZCX5MNaGomMqpQPC
         tSwMl8Z2mOnq8gFzBqjJTHjYE3qCQPWoQiWsjdGcpVRX0i23ftMxs70oIDlS1irvDlK8
         L8R8c0B1dNQjqsnIokmE60FR7n4UGf11qUZIPCqVPW+5BHqPxfqmZV0euYjl9MjhXHEb
         IvIQ==
X-Gm-Message-State: AOAM532okR3zuFPybtEgvDZFacrlco1KQZrOkmSMIiRTwnhp9nt+mII6
        r2NT0ZMqMECIzm2UtV+kmhWBhix+uUGtBKHgZA==
X-Google-Smtp-Source: ABdhPJypQIi7OLeQOMkKC8MqPd+cdGydq1CCA7pc+vFNILHmJek6bUDtkR6qrp28z/EouWBP2MGghJ0c3azUecOTpw==
X-Received: from almasrymina.svl.corp.google.com ([2620:15c:2cd:202:b35:38bd:7e0f:3b1d])
 (user=almasrymina job=sendgmr) by 2002:a25:7a41:: with SMTP id
 v62mr8586302ybc.225.1622162816966; Thu, 27 May 2021 17:46:56 -0700 (PDT)
Date:   Thu, 27 May 2021 17:46:49 -0700
Message-Id: <20210528004649.85298-1-almasrymina@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v4] mm, hugetlb: Fix simple resv_huge_pages underflow on UFFDIO_COPY
From:   Mina Almasry <almasrymina@google.com>
Cc:     Mina Almasry <almasrymina@google.com>,
        Axel Rasmussen <axelrasmussen@google.com>,
        Peter Xu <peterx@redhat.com>, linux-mm@kvack.org,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
To:     unlisted-recipients:; (no To-header on input)
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The userfaultfd hugetlb tests detect a resv_huge_pages underflow. This
happens when hugetlb_mcopy_atomic_pte() is called with !is_continue on
an index for which we already have a page in the cache. When this
happens, we allocate a second page, double consuming the reservation,
and then fail to insert the page into the cache and return -EEXIST.

To fix this, we first if there exists a page in the cache which already
consumed the reservation, and return -EEXIST immediately if so.

There is still a rare condition where we fail to copy the page contents
AND race with a call for hugetlb_no_page() for this index and again we
will underflow resv_huge_pages. That is fixed in a more complicated
patch not targeted for -stable.

Test:
Hacked the code locally such that resv_huge_pages underflows produce
a warning, then:

./tools/testing/selftests/vm/userfaultfd hugetlb_shared 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success
./tools/testing/selftests/vm/userfaultfd hugetlb 10
	2 /tmp/kokonut_test/huge/userfaultfd_test && echo test success

Both tests succeed and produce no warnings. After the
test runs number of free/resv hugepages is correct.

Signed-off-by: Mina Almasry <almasrymina@google.com>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: linux-mm@kvack.org
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-mm@kvack.org
Cc: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org

---
 mm/hugetlb.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/mm/hugetlb.c b/mm/hugetlb.c
index ead5d12e0604..76e2a6efc165 100644
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -4925,10 +4925,20 @@ int hugetlb_mcopy_atomic_pte(struct mm_struct *dst_mm,
 		if (!page)
 			goto out;
 	} else if (!*pagep) {
-		ret = -ENOMEM;
+		/* If a page already exists, then it's UFFDIO_COPY for
+		 * a non-missing case. Return -EEXIST.
+		 */
+		if (vm_shared &&
+		    hugetlbfs_pagecache_present(h, dst_vma, dst_addr)) {
+			ret = -EEXIST;
+			goto out;
+		}
+
 		page = alloc_huge_page(dst_vma, dst_addr, 0);
-		if (IS_ERR(page))
+		if (IS_ERR(page)) {
+			ret = -ENOMEM;
 			goto out;
+		}

 		ret = copy_huge_page_from_user(page,
 						(const void __user *) src_addr,
--
2.32.0.rc0.204.g9fa02ecfa5-goog
