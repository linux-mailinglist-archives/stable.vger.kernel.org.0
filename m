Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 494C8337F4D
	for <lists+stable@lfdr.de>; Thu, 11 Mar 2021 21:56:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229938AbhCKUzh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 11 Mar 2021 15:55:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:56950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229900AbhCKUzc (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 11 Mar 2021 15:55:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1456864F88;
        Thu, 11 Mar 2021 20:55:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1615496132;
        bh=dnjQBY3USZHTKFKxLEavowBMTkiUnSiRMefxt1MVWp4=;
        h=Date:From:To:Subject:From;
        b=f+Y2WF0qFsESBPdbMqTNjKW+gSKc6v9dZRG5fSPNA3JyyirQlA2KmcKgFTir/dCAt
         LYyzWQxipS//dibnYRu/Hdwxzqh93U0KJ0S16xBTqF7d0LRePjB0MiMgcIq9Z6NYA9
         41lAYgYgUo+yrFqnaaphWzo9l2Gu09MXesYblO+s=
Date:   Thu, 11 Mar 2021 12:55:30 -0800
From:   akpm@linux-foundation.org
To:     aarcange@redhat.com, bgardon@google.com, dimitri.sivanich@hpe.com,
        hannes@cmpxchg.org, jgg@ziepe.ca, jglisse@redhat.com,
        mhocko@suse.com, mm-commits@vger.kernel.org, rientjes@google.com,
        seanjc@google.com, stable@vger.kernel.org
Subject:  +
 mm-mmu_notifiers-esnure-range_end-is-paired-with-range_start.patch added to
 -mm tree
Message-ID: <20210311205530.-OFwWXE16%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/mmu_notifiers: ensure range_end() is paired with range_sta=
rt()
has been added to the -mm tree.  Its filename is
     mm-mmu_notifiers-esnure-range_end-is-paired-with-range_start.patch

This patch should soon appear at
    https://ozlabs.org/~akpm/mmots/broken-out/mm-mmu_notifiers-esnure-range=
_end-is-paired-with-range_start.patch
and later at
    https://ozlabs.org/~akpm/mmotm/broken-out/mm-mmu_notifiers-esnure-range=
_end-is-paired-with-range_start.patch

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
Subject: mm/mmu_notifiers: ensure range_end() is paired with range_start()

If one or more notifiers fails .invalidate_range_start(), invoke
.invalidate_range_end() for "all" notifiers.  If there are multiple
notifiers, those that did not fail are expecting _start() and _end() to be
paired, e.g.  KVM's mmu_notifier_count would become imbalanced.  Disallow
notifiers that can fail _start() from implementing _end() so that it's
unnecessary to either track which notifiers rejected _start(), or had
already succeeded prior to a failed _start().

Note, the existing behavior of calling _start() on all notifiers even
after a previous notifier failed _start() was an unintented "feature".=20
Make it canon now that the behavior is depended on for correctness.

As of today, the bug is likely benign:

  1. The only caller of the non-blocking notifier is OOM kill.
  2. The only notifiers that can fail _start() are the i915 and Nouveau
     drivers.
  3. The only notifiers that utilize _end() are the SGI UV GRU driver
     and KVM.
  4. The GRU driver will never coincide with the i195/Nouveau drivers.
  5. An imbalanced kvm->mmu_notifier_count only causes soft lockup in the
     _guest_, and the guest is already doomed due to being an OOM victim.

Fix the bug now to play nice with future usage, e.g.  KVM has a potential
use case for blocking memslot updates in KVM while an invalidation is
in-progress, and failure to unblock would result in said updates being
blocked indefinitely and hanging.

Found by inspection.  Verified by adding a second notifier in KVM that
periodically returns -EAGAIN on non-blockable ranges, triggering OOM, and
observing that KVM exits with an elevated notifier count.

Link: https://lkml.kernel.org/r/20210311180057.1582638-1-seanjc@google.com
Fixes: 93065ac753e4 ("mm, oom: distinguish blockable mode for mmu notifiers=
")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Cc: David Rientjes <rientjes@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "J=C3=A9r=C3=B4me Glisse" <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 include/linux/mmu_notifier.h |   10 +++++-----
 mm/mmu_notifier.c            |   23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 5 deletions(-)

--- a/include/linux/mmu_notifier.h~mm-mmu_notifiers-esnure-range_end-is-pai=
red-with-range_start
+++ a/include/linux/mmu_notifier.h
@@ -169,11 +169,11 @@ struct mmu_notifier_ops {
 	 * the last refcount is dropped.
 	 *
 	 * If blockable argument is set to false then the callback cannot
-	 * sleep and has to return with -EAGAIN. 0 should be returned
-	 * otherwise. Please note that if invalidate_range_start approves
-	 * a non-blocking behavior then the same applies to
-	 * invalidate_range_end.
-	 *
+	 * sleep and has to return with -EAGAIN if sleeping would be required.
+	 * 0 should be returned otherwise. Please note that notifiers that can
+	 * fail invalidate_range_start are not allowed to implement
+	 * invalidate_range_end, as there is no mechanism for informing the
+	 * notifier that its start failed.
 	 */
 	int (*invalidate_range_start)(struct mmu_notifier *subscription,
 				      const struct mmu_notifier_range *range);
--- a/mm/mmu_notifier.c~mm-mmu_notifiers-esnure-range_end-is-paired-with-ra=
nge_start
+++ a/mm/mmu_notifier.c
@@ -501,10 +501,33 @@ static int mn_hlist_invalidate_range_sta
 						"");
 				WARN_ON(mmu_notifier_range_blockable(range) ||
 					_ret !=3D -EAGAIN);
+				/*
+				 * We call all the notifiers on any EAGAIN,
+				 * there is no way for a notifier to know if
+				 * its start method failed, thus a start that
+				 * does EAGAIN can't also do end.
+				 */
+				WARN_ON(ops->invalidate_range_end);
 				ret =3D _ret;
 			}
 		}
 	}
+
+	if (ret) {
+		/*
+		 * Must be non-blocking to get here.  If there are multiple
+		 * notifiers and one or more failed start, any that succeeded
+		 * start are expecting their end to be called.  Do so now.
+		 */
+		hlist_for_each_entry_rcu(subscription, &subscriptions->list,
+					 hlist, srcu_read_lock_held(&srcu)) {
+			if (!subscription->ops->invalidate_range_end)
+				continue;
+
+			subscription->ops->invalidate_range_end(subscription,
+								range);
+		}
+	}
 	srcu_read_unlock(&srcu, id);
=20
 	return ret;
_

Patches currently in -mm which might be from seanjc@google.com are

mm-mmu_notifiers-esnure-range_end-is-paired-with-range_start.patch

