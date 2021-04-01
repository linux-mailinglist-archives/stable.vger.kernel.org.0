Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70C66351F8D
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:21:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbhDATVV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:21:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234287AbhDATVM (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:21:12 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A16CC048F31
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:17:56 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id l13so3606202qtu.6
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:17:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=EPPZk3kaJmCkCuLSmDGChUbNjldn8zDlCy03b3PwOQY=;
        b=Sw3ihxK4bHf0Qh8AFiyTVIWGEOipcxVOp6rn+s5hDqIUo0cxKJRzuojdeIGP5He/Gw
         LoLmjPOTGaSquZ+lRKHRbtWHje87Yf3SBxBdxeWvHNJbjxUf8PAJfsP5cgxJzwHnqviV
         MwVsReqjMjwKcYoTftk0u/HxV/jVLUfYU5z2RnnVpeWJQSnww2MH9+KzScoKdF/pbB4O
         7OGjMlISEy8QQwWA2r2+qjc8o8/jbzjE3N6xvKQZLlfs3zSk3+e1iaS5oODjHUF9lhWw
         FlFGgk+pTNiX2VXqit05IKys2IvnhJ3cFfixyjjiUTm1lMWEF0wKuuTFwo4e/klARQxM
         9TTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=EPPZk3kaJmCkCuLSmDGChUbNjldn8zDlCy03b3PwOQY=;
        b=bxnRm8juJ6qcm1YBVfbVRApEpQYBqkXdpQ41vNHV64Qbr85I/FgKIowUfKkPp3Uvek
         5IJgNWr/tIN92GyfU1szT6swTEvSkQsqMs8mLWveabYmsE8qs4SukbWnhhGRgdebck3R
         jxswH9p1VaeO7Ltjjh6PjbIsOnJNvJoafXmHlNYPN/Uq+tdX7+g+TlS/FDCalm5IwKj0
         IivEV/yLckG1nclygGkn9t415ls6cBw5YF9dka1RfWvoq18Ojt00K/GrQBGth3qICdS5
         9vv6iiUnsJmZ0SF94iV7wteKE8PyvITYENXo1KqIc6tSMzYc+511u+ByW9kSc1p27hbV
         Hv/g==
X-Gm-Message-State: AOAM531l6xJAb3kUH1T3AtIuP1DEvboqxeRChD7JnfmA4RdUPEFiKMpS
        ePWNq2nVBP6oSnvPXitB5/F2UnJsWcTD7n10urVAC6T51tm3WNcxVWIJGAmylUTw5IXP+yF/fT/
        QvdapZEY6sHR0nCU4rWeCOZ7yDrmUQaELqtOLBVkBpBl83qrP4tQM/DD7ymuN/A==
X-Google-Smtp-Source: ABdhPJwOK8+v3IEC4Rr66Qc+yElipZ/pNCwtCC/TEjMZUv12p1QLgJWmZUAkzgRnWJqR407P20su7HNvSUA=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:899:1066:21fc:b3c5])
 (user=surenb job=sendgmr) by 2002:a05:6214:12ec:: with SMTP id
 w12mr9122530qvv.54.1617301075354; Thu, 01 Apr 2021 11:17:55 -0700 (PDT)
Date:   Thu,  1 Apr 2021 11:17:40 -0700
In-Reply-To: <20210401181741.168763-1-surenb@google.com>
Message-Id: <20210401181741.168763-5-surenb@google.com>
Mime-Version: 1.0
References: <20210401181741.168763-1-surenb@google.com>
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 4/5] userfaultfd: wp: add helper for writeprotect check
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Andrea Arcangeli <aarcange@redhat.com>,
        Peter Xu <peterx@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jerome Glisse <jglisse@redhat.com>,
        Mike Rapoport <rppt@linux.vnet.ibm.com>,
        Rik van Riel <riel@redhat.com>,
        "Kirill A . Shutemov" <kirill@shutemov.name>,
        Mel Gorman <mgorman@suse.de>, Hugh Dickins <hughd@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Bobby Powers <bobbypowers@gmail.com>,
        Brian Geffon <bgeffon@google.com>,
        David Hildenbrand <david@redhat.com>,
        Denis Plotnikov <dplotnikov@virtuozzo.com>,
        "Dr . David Alan Gilbert" <dgilbert@redhat.com>,
        Martin Cracauer <cracauer@cons.org>,
        Marty McFadden <mcfadden8@llnl.gov>,
        Maya Gokhale <gokhale2@llnl.gov>,
        Mike Kravetz <mike.kravetz@oracle.com>,
        Pavel Emelyanov <xemul@openvz.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Shaohua Li <shli@fb.com>

Patch series "userfaultfd: write protection support", v6.

Overview
========

The uffd-wp work was initialized by Shaohua Li [1], and later continued by
Andrea [2].  This series is based upon Andrea's latest userfaultfd tree,
and it is a continuous works from both Shaohua and Andrea.  Many of the
follow up ideas come from Andrea too.

Besides the old MISSING register mode of userfaultfd, the new uffd-wp
support provides another alternative register mode called
UFFDIO_REGISTER_MODE_WP that can be used to listen to not only missing
page faults but also write protection page faults, or even they can be
registered together.  At the same time, the new feature also provides a
new userfaultfd ioctl called UFFDIO_WRITEPROTECT which allows the
userspace to write protect a range or memory or fixup write permission of
faulted pages.

Please refer to the document patch "userfaultfd: wp:
UFFDIO_REGISTER_MODE_WP documentation update" for more information on the
new interface and what it can do.

The major workflow of an uffd-wp program should be:

  1. Register a memory region with WP mode using UFFDIO_REGISTER_MODE_WP

  2. Write protect part of the whole registered region using
     UFFDIO_WRITEPROTECT, passing in UFFDIO_WRITEPROTECT_MODE_WP to
     show that we want to write protect the range.

  3. Start a working thread that modifies the protected pages,
     meanwhile listening to UFFD messages.

  4. When a write is detected upon the protected range, page fault
     happens, a UFFD message will be generated and reported to the
     page fault handling thread

  5. The page fault handler thread resolves the page fault using the
     new UFFDIO_WRITEPROTECT ioctl, but this time passing in
     !UFFDIO_WRITEPROTECT_MODE_WP instead showing that we want to
     recover the write permission.  Before this operation, the fault
     handler thread can do anything it wants, e.g., dumps the page to
     a persistent storage.

  6. The worker thread will continue running with the correctly
     applied write permission from step 5.

Currently there are already two projects that are based on this new
userfaultfd feature.

QEMU Live Snapshot: The project provides a way to allow the QEMU
                    hypervisor to take snapshot of VMs without
                    stopping the VM [3].

LLNL umap library:  The project provides a mmap-like interface and
                    "allow to have an application specific buffer of
                    pages cached from a large file, i.e. out-of-core
                    execution using memory map" [4][5].

Before posting the patchset, this series was smoke tested against QEMU
live snapshot and the LLNL umap library (by doing parallel quicksort using
128 sorting threads + 80 uffd servicing threads).  My sincere thanks to
Marty Mcfadden and Denis Plotnikov for the help along the way.

TODO
====

- hugetlbfs/shmem support
- performance
- more architectures
- cooperate with mprotect()-allowed processes (???)
- ...

References
==========

[1] https://lwn.net/Articles/666187/
[2] https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/log/?h=userfault
[3] https://github.com/denis-plotnikov/qemu/commits/background-snapshot-kvm
[4] https://github.com/LLNL/umap
[5] https://llnl-umap.readthedocs.io/en/develop/
[6] https://git.kernel.org/pub/scm/linux/kernel/git/andrea/aa.git/commit/?h=userfault&id=b245ecf6cf59156966f3da6e6b674f6695a5ffa5
[7] https://lkml.org/lkml/2018/11/21/370
[8] https://lkml.org/lkml/2018/12/30/64

This patch (of 19):

Add helper for writeprotect check. Will use it later.

Signed-off-by: Shaohua Li <shli@fb.com>
Signed-off-by: Andrea Arcangeli <aarcange@redhat.com>
Signed-off-by: Peter Xu <peterx@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Jerome Glisse <jglisse@redhat.com>
Reviewed-by: Mike Rapoport <rppt@linux.vnet.ibm.com>
Cc: Rik van Riel <riel@redhat.com>
Cc: Kirill A. Shutemov <kirill@shutemov.name>
Cc: Mel Gorman <mgorman@suse.de>
Cc: Hugh Dickins <hughd@google.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Bobby Powers <bobbypowers@gmail.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Denis Plotnikov <dplotnikov@virtuozzo.com>
Cc: "Dr . David Alan Gilbert" <dgilbert@redhat.com>
Cc: Martin Cracauer <cracauer@cons.org>
Cc: Marty McFadden <mcfadden8@llnl.gov>
Cc: Maya Gokhale <gokhale2@llnl.gov>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Pavel Emelyanov <xemul@openvz.org>
Link: http://lkml.kernel.org/r/20200220163112.11409-2-peterx@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
---
 include/linux/userfaultfd_k.h | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/include/linux/userfaultfd_k.h b/include/linux/userfaultfd_k.h
index f2f3b68ba910..07878cd475f2 100644
--- a/include/linux/userfaultfd_k.h
+++ b/include/linux/userfaultfd_k.h
@@ -48,6 +48,11 @@ static inline bool userfaultfd_missing(struct vm_area_struct *vma)
 	return vma->vm_flags & VM_UFFD_MISSING;
 }
 
+static inline bool userfaultfd_wp(struct vm_area_struct *vma)
+{
+	return vma->vm_flags & VM_UFFD_WP;
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return vma->vm_flags & (VM_UFFD_MISSING | VM_UFFD_WP);
@@ -91,6 +96,11 @@ static inline bool userfaultfd_missing(struct vm_area_struct *vma)
 	return false;
 }
 
+static inline bool userfaultfd_wp(struct vm_area_struct *vma)
+{
+	return false;
+}
+
 static inline bool userfaultfd_armed(struct vm_area_struct *vma)
 {
 	return false;
-- 
2.31.0.291.g576ba9dcdaf-goog

