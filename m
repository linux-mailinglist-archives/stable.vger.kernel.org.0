Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C42D734C947
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:32:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232473AbhC2I3M (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:29:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:41084 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233662AbhC2IZy (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:25:54 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A2D25619AD;
        Mon, 29 Mar 2021 08:25:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006307;
        bh=KaYd8dVXMt9M6AZMf3IdFWvp7nB0CJPh5ckzuu6pDN4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=doL8Pshs/udgVD69/bl4xwS+o3/YnT4H1k9MgCBKKG/QvTDECyRCX9oQeFZMLErJA
         qRk+e1/zQJSwYv36RSRI11eqKOwD6NDJnDTaSTWRs76rwPurnHEHlHHBmuF0nyxVd8
         czKTtj6DLxUbUfGJLkc5t+ZLvKtJ3KdbZH2h6p+0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Sean Christopherson <seanjc@google.com>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Jason Gunthorpe <jgg@nvidia.com>,
        David Rientjes <rientjes@google.com>,
        Ben Gardon <bgardon@google.com>,
        Michal Hocko <mhocko@suse.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Dimitri Sivanich <dimitri.sivanich@hpe.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 194/221] mm/mmu_notifiers: ensure range_end() is paired with range_start()
Date:   Mon, 29 Mar 2021 09:58:45 +0200
Message-Id: <20210329075635.600543100@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075629.172032742@linuxfoundation.org>
References: <20210329075629.172032742@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sean Christopherson <seanjc@google.com>

[ Upstream commit c2655835fd8cabdfe7dab737253de3ffb88da126 ]

If one or more notifiers fails .invalidate_range_start(), invoke
.invalidate_range_end() for "all" notifiers.  If there are multiple
notifiers, those that did not fail are expecting _start() and _end() to
be paired, e.g.  KVM's mmu_notifier_count would become imbalanced.
Disallow notifiers that can fail _start() from implementing _end() so
that it's unnecessary to either track which notifiers rejected _start(),
or had already succeeded prior to a failed _start().

Note, the existing behavior of calling _start() on all notifiers even
after a previous notifier failed _start() was an unintented "feature".
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

Fix the bug now to play nice with future usage, e.g.  KVM has a
potential use case for blocking memslot updates in KVM while an
invalidation is in-progress, and failure to unblock would result in said
updates being blocked indefinitely and hanging.

Found by inspection.  Verified by adding a second notifier in KVM that
periodically returns -EAGAIN on non-blockable ranges, triggering OOM,
and observing that KVM exits with an elevated notifier count.

Link: https://lkml.kernel.org/r/20210311180057.1582638-1-seanjc@google.com
Fixes: 93065ac753e4 ("mm, oom: distinguish blockable mode for mmu notifiers")
Signed-off-by: Sean Christopherson <seanjc@google.com>
Suggested-by: Jason Gunthorpe <jgg@ziepe.ca>
Reviewed-by: Jason Gunthorpe <jgg@nvidia.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: "Jérôme Glisse" <jglisse@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Dimitri Sivanich <dimitri.sivanich@hpe.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/mmu_notifier.h | 10 +++++-----
 mm/mmu_notifier.c            | 23 +++++++++++++++++++++++
 2 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/include/linux/mmu_notifier.h b/include/linux/mmu_notifier.h
index b8200782dede..1a6a9eb6d3fa 100644
--- a/include/linux/mmu_notifier.h
+++ b/include/linux/mmu_notifier.h
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
diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 5654dd19addc..07f42a7a6065 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -501,10 +501,33 @@ static int mn_hlist_invalidate_range_start(
 						"");
 				WARN_ON(mmu_notifier_range_blockable(range) ||
 					_ret != -EAGAIN);
+				/*
+				 * We call all the notifiers on any EAGAIN,
+				 * there is no way for a notifier to know if
+				 * its start method failed, thus a start that
+				 * does EAGAIN can't also do end.
+				 */
+				WARN_ON(ops->invalidate_range_end);
 				ret = _ret;
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
 
 	return ret;
-- 
2.30.1



