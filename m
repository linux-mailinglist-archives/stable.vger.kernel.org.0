Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 893DF336855
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 01:07:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229643AbhCKAG3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 10 Mar 2021 19:06:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:45672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229593AbhCKAGR (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 10 Mar 2021 19:06:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D36CE64E33;
        Thu, 11 Mar 2021 00:06:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615421177;
        bh=eBw6Er0rU51Hw+o8upNvkWLSj/B7ASVGL2a9wlNGeIE=;
        h=Date:From:To:Subject:From;
        b=vNkU0N+sUHsBzQG4Yh63Oh+jpN8RkQM7gr+cyW4fSrAGRQmuQQ0NgQW+u9nqfRk5X
         twI167aezceeTX5Diulwfa/wFzi4FCtIDPSFYLZ5Q49a50xQmXibURH8mfz5f8KnVG
         2tOSGeDeYMO1AyuuSutXoqy5amvPHx2sSOMu6jzw=
Date:   Wed, 10 Mar 2021 16:06:16 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bgardon@google.com, dimitri.sivanich@hpe.com,
        hannes@cmpxchg.org, jgg@ziepe.ca, jglisse@redhat.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        seanjc@google.com, stable@vger.kernel.org
Subject:  +
 mm-oom_kill-ensure-mmu-notifier-range_end-is-paired-with-range_start.patch
 added to -mm tree
Message-ID: <20210311000616.GIEHU6C1Q%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/oom_kill: ensure MMU notifier range_end() is paired with r=
ange_start()
has been added to the -mm tree.  Its filename is
     mm-oom_kill-ensure-mmu-notifier-range_end-is-paired-with-range_start.p=
atch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-oom_kill-ensure-mmu-notifi=
er-range_end-is-paired-with-range_start.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-oom_kill-ensure-mmu-notifi=
er-range_end-is-paired-with-range_start.patch

Before you just go and hit "reply", please:
   a) Consider who else should be cc'ed
   b) Prefer to cc a suitable mailing list as well
   c) Ideally: find the original patch on the mailing list and do a
      reply-to-all to that, adding suitable additional cc's

*** Remember to use Documentation/process/submit-checklist.rst when testing=
 your code ***

The -mm tree is included into linux-next and is updated
there every 3-4 working days

------------------------------------------------------
=46rom: Sean Christopherson <seanjc@google.com>
Subject: mm/oom_kill: ensure MMU notifier range_end() is paired with range_=
start()

Invoke the MMU notifier's .invalidate_range_end() callbacks even if one of
the .invalidate_range_start() callbacks failed.  If there are multiple
notifiers, the notifier that did not fail may have performed actions in
its ...start() that it expects to unwind via ...end().  Per the
mmu_notifier_ops documentation, ...start() and ...end() must be paired.

The only in-kernel usage that is fatally broken is the SGI UV GRU driver,
which effectively blocks and sleeps fault handlers during ...start(), and
unblocks/wakes the handlers during ...end().  But, the only users that can
fail ...start() are the i915 and Nouveau drivers, which are unlikely to
collide with the SGI driver.

KVM is the only other user of ...end(), and while KVM also blocks fault
handlers in ...start(), the fault handlers do not sleep and originate in
killable ioctl() calls.  So while it's possible for the i915 and Nouveau
drivers to collide with KVM, the bug is benign for KVM since the process
is dying and KVM's guest is about to be terminated.

So, as of today, the bug is likely benign.  But, that may not always be
true, e.g.  there is a potential use case for blocking memslot updates in
KVM while an invalidation is in-progress, and failure to unblock would
result in said updates being blocked indefinitely and hanging.

Found by inspection.  Verified by adding a second notifier in KVM that
periodically returns -EAGAIN on non-blockable ranges, triggering OOM, and
observing that KVM exits with an elevated notifier count.

Link: https://lkml.kernel.org/r/20210310213117.1444147-1-seanjc@google.com
Fixes: 93065ac753e4 ("mm, oom: distinguish blockable mode for mmu notifiers=
")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Ben Gardon <bgardon@google.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/oom_kill.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/mm/oom_kill.c~mm-oom_kill-ensure-mmu-notifier-range_end-is-paired-wit=
h-range_start
+++ a/mm/oom_kill.c
@@ -546,12 +546,10 @@ bool __oom_reap_task_mm(struct mm_struct
 						vma, mm, vma->vm_start,
 						vma->vm_end);
 			tlb_gather_mmu(&tlb, mm);
-			if (mmu_notifier_invalidate_range_start_nonblock(&range)) {
-				tlb_finish_mmu(&tlb);
+			if (!mmu_notifier_invalidate_range_start_nonblock(&range))
+				unmap_page_range(&tlb, vma, range.start, range.end, NULL);
+			else
 				ret =3D false;
-				continue;
-			}
-			unmap_page_range(&tlb, vma, range.start, range.end, NULL);
 			mmu_notifier_invalidate_range_end(&range);
 			tlb_finish_mmu(&tlb);
 		}
_

Patches currently in -mm which might be from seanjc@google.com are

mm-oom_kill-ensure-mmu-notifier-range_end-is-paired-with-range_start.patch

