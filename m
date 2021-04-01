Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB0C9351F86
	for <lists+stable@lfdr.de>; Thu,  1 Apr 2021 21:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234793AbhDATVQ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 1 Apr 2021 15:21:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234174AbhDATVJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 1 Apr 2021 15:21:09 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E3B11C05BD11
        for <stable@vger.kernel.org>; Thu,  1 Apr 2021 11:17:48 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id a16so3621750qtw.1
        for <stable@vger.kernel.org>; Thu, 01 Apr 2021 11:17:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=LPFWmJy1CR1Tecu95yi/uuh4QosZ2hRzRB/6uLDr3pg=;
        b=U/hIVzen7h5iBYCTINhsdvlCIxT9bQoEkiUuVj6wyA3f3yFx7A9gdg0qKC8Z+EfrFV
         O5YF45bNSQgokePzuLdTj89hb7rRyPSXG/OXOtZbf23vNx4W9KLI3368F0b9XRoXvM9A
         2iISQ9Ss1tzF0OOqnCYY6G3Jgbj4fQZlmW7HHx2lmCViU4QkSJmxeivTAstXqOUK2+Wj
         mBoTrjGW218GT90ckbb1GaRsqs0WrKUiCch7pg78HAUqiV2CF5USWTfwz0YjYLhJXu+I
         odTxDIWm3pgKH/RnZW0gXxqfJzvJiktdKyuUQa3sc1MGzuKp9My+LPOvtJVfX7RcwT6R
         kNGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=LPFWmJy1CR1Tecu95yi/uuh4QosZ2hRzRB/6uLDr3pg=;
        b=PkbiIVtybFnSmmw49a+U85wGDHog5uE/I703qRFDCWS6SKkS/eKeAHbmWDZ+vCNgSt
         Pl0KclbpyIjCvZwB22BJxBMBSk/z4QJ2fpI6NTGe11RTVlETfR9PDzF4IoApq22f/MYU
         uX/FgoVe9qEfOzB5U/fylFU2bQX0YNPO7ybV8yX4YgpvlAh8kVhLg6CqTIyQUJvFHMgI
         nWdG6/5WvAtYm82TB1dwDPca90/5f5rf6thn5VmNwGfJUVqeeNsWm31XNdEfkxUQi1eU
         z1viyJHz4Cm5xht6S+PF0XtHSZ8HNRn5jJn1uwy2Zsmy6YNFGWeoJsHm5fGQC+8asBCe
         56nw==
X-Gm-Message-State: AOAM530BYs9zCcdcixWAam8ZmbNI0qjH2RvUGiE6UZK4fM7teFpFZDXG
        tvGUNaQOEmMx/jSvf7YyP2kZx8YoIy3XTTeWJdd6xwBkuHmuSGYjaQcKNEmfRYlPXEIAuTav928
        C4e4iSFGSPhY083CBHNebGuo8oTSrzoflYCw2qbvlGHbn4cAGET0V14cX9Dlmrg==
X-Google-Smtp-Source: ABdhPJw3F1KX4e2DJnP33lAQeo4/gq99iK78UX7Xwlo3sqgnSKgk2nmVQXajUO34F3V/0QA2K1uBVmt5inQ=
X-Received: from surenb1.mtv.corp.google.com ([2620:15c:211:200:899:1066:21fc:b3c5])
 (user=surenb job=sendgmr) by 2002:a0c:cb0c:: with SMTP id o12mr9357867qvk.54.1617301067902;
 Thu, 01 Apr 2021 11:17:47 -0700 (PDT)
Date:   Thu,  1 Apr 2021 11:17:36 -0700
Message-Id: <20210401181741.168763-1-surenb@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.31.0.291.g576ba9dcdaf-goog
Subject: [PATCH 0/5] 4.14 backports of fixes for "CoW after fork() issue"
From:   Suren Baghdasaryan <surenb@google.com>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, jannh@google.com, ktkhai@virtuozzo.com,
        torvalds@linux-foundation.org, shli@fb.com, namit@vmware.com,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, Suren Baghdasaryan <surenb@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

We received a report that the copy-on-write issue repored by Jann Horn in
https://bugs.chromium.org/p/project-zero/issues/detail?id=2045 is still
reproducible on 4.14 and 4.19 kernels (the first issue with the reproducer
coded in vmsplice.c). I confirmed this and also that the issue was not
reproducible with 5.10 kernel. I tracked the fix to the following patch
introduced in 5.9 which changes the do_wp_page() logic:

09854ba94c6a 'mm: do_wp_page() simplification'

I backported this patch (#2 in the series) along with 2 prerequisite patches
(#1 and #4) that keep the backports clean and two followup fixes to the main
patch (#3 and #5). I had to skip the following fix:

feb889fb40fa 'mm: don't put pinned pages into the swap cache'

because it uses page_maybe_dma_pinned() which does not exists in earlier
kernels. Because pin_user_pages() does not exist there as well, I *think*
we can safely skip this fix on older kernels, but I would appreciate if
someone could confirm that claim.

The patchset cleanly applies over: stable linux-4.14.y, tag: v4.14.228

Note: 4.14 and 4.19 backports are very similar, so while I backported
only to these two versions I think backports for other versions can be
done easily.

Kirill Tkhai (1):
  mm: reuse only-pte-mapped KSM page in do_wp_page()

Linus Torvalds (2):
  mm: do_wp_page() simplification
  mm: fix misplaced unlock_page in do_wp_page()

Nadav Amit (1):
  mm/userfaultfd: fix memory corruption due to writeprotect

Shaohua Li (1):
  userfaultfd: wp: add helper for writeprotect check

 include/linux/ksm.h           |  7 ++++
 include/linux/userfaultfd_k.h | 10 ++++++
 mm/ksm.c                      | 30 ++++++++++++++++--
 mm/memory.c                   | 60 ++++++++++++++++-------------------
 4 files changed, 73 insertions(+), 34 deletions(-)

-- 
2.31.0.291.g576ba9dcdaf-goog

