Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E565E7F150
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 11:38:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390781AbfHBJfV (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 05:35:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:35796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2403845AbfHBJfU (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 2 Aug 2019 05:35:20 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF67721773;
        Fri,  2 Aug 2019 09:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564738520;
        bh=uHZHfjJtUWc+mrMGGjekpwtVMwWSmtYBS8YZx8R0QgM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=RQq2LQcLn6zhYfq3TP1g5V3BNI+FkmLJ86IXuqq/WAJvjkuOfaL8ZW+0ZhtZX2pCT
         i3ujYVCglwJYqlKofJLdHCCVTvFVCw0Fl2HLBv7yzLvJMkUc1bCEAEN0wnweRipLW1
         so+MsQ2FQSYBU7t50U9pI6rnEJlLred9WAtJyK0w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Jean-Philippe Brucker <jean-philippe.brucker@arm.com>,
        =?UTF-8?q?J=C3=A9r=C3=B4me=20Glisse?= <jglisse@redhat.com>,
        Michal Hocko <mhocko@suse.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 136/158] mm/mmu_notifier: use hlist_add_head_rcu()
Date:   Fri,  2 Aug 2019 11:29:17 +0200
Message-Id: <20190802092230.781546358@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190802092203.671944552@linuxfoundation.org>
References: <20190802092203.671944552@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 543bdb2d825fe2400d6e951f1786d92139a16931 ]

Make mmu_notifier_register() safer by issuing a memory barrier before
registering a new notifier.  This fixes a theoretical bug on weakly
ordered CPUs.  For example, take this simplified use of notifiers by a
driver:

	my_struct->mn.ops = &my_ops; /* (1) */
	mmu_notifier_register(&my_struct->mn, mm)
		...
		hlist_add_head(&mn->hlist, &mm->mmu_notifiers); /* (2) */
		...

Once mmu_notifier_register() releases the mm locks, another thread can
invalidate a range:

	mmu_notifier_invalidate_range()
		...
		hlist_for_each_entry_rcu(mn, &mm->mmu_notifiers, hlist) {
			if (mn->ops->invalidate_range)

The read side relies on the data dependency between mn and ops to ensure
that the pointer is properly initialized.  But the write side doesn't have
any dependency between (1) and (2), so they could be reordered and the
readers could dereference an invalid mn->ops.  mmu_notifier_register()
does take all the mm locks before adding to the hlist, but those have
acquire semantics which isn't sufficient.

By calling hlist_add_head_rcu() instead of hlist_add_head() we update the
hlist using a store-release, ensuring that readers see prior
initialization of my_struct.  This situation is better illustated by
litmus test MP+onceassign+derefonce.

Link: http://lkml.kernel.org/r/20190502133532.24981-1-jean-philippe.brucker@arm.com
Fixes: cddb8a5c14aa ("mmu-notifiers: core")
Signed-off-by: Jean-Philippe Brucker <jean-philippe.brucker@arm.com>
Cc: Jérôme Glisse <jglisse@redhat.com>
Cc: Michal Hocko <mhocko@suse.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/mmu_notifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/mmu_notifier.c b/mm/mmu_notifier.c
index 5fbdd367bbed..ad90b8f85223 100644
--- a/mm/mmu_notifier.c
+++ b/mm/mmu_notifier.c
@@ -286,7 +286,7 @@ static int do_mmu_notifier_register(struct mmu_notifier *mn,
 	 * thanks to mm_take_all_locks().
 	 */
 	spin_lock(&mm->mmu_notifier_mm->lock);
-	hlist_add_head(&mn->hlist, &mm->mmu_notifier_mm->list);
+	hlist_add_head_rcu(&mn->hlist, &mm->mmu_notifier_mm->list);
 	spin_unlock(&mm->mmu_notifier_mm->lock);
 
 	mm_drop_all_locks(mm);
-- 
2.20.1



