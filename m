Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 93B62795F4
	for <lists+stable@lfdr.de>; Mon, 29 Jul 2019 21:48:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389728AbfG2TrR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jul 2019 15:47:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:36924 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390301AbfG2TrQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jul 2019 15:47:16 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 154F520C01;
        Mon, 29 Jul 2019 19:47:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564429635;
        bh=U1MrTmgOBlQV6ONvXs/aoEgHVNbQwAm6RBeHlkKYph0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OENqb9+rGPmS/3nHkFH67dJvqUnkQHgC0qVGmzQwLk9qSvoplstHrGU9cXgRZDCfY
         iAcSzhEpck28qx4NrLVO6IfQvw/f2og6UnyjeMZGFmXMW8ULPj3nPhar8VRl4XyE4i
         2CnPTRie2/0+MJt1BDDsw6KG13fXwyQkKOEVS+Dw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>,
        Ira Weiny <ira.weiny@intel.com>,
        John Hubbard <jhubbard@nvidia.com>,
        Ralph Campbell <rcampbell@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Philip Yang <Philip.Yang@amd.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 047/215] mm/hmm: fix use after free with struct hmm in the mmu notifiers
Date:   Mon, 29 Jul 2019 21:20:43 +0200
Message-Id: <20190729190748.653021982@linuxfoundation.org>
X-Mailer: git-send-email 2.22.0
In-Reply-To: <20190729190739.971253303@linuxfoundation.org>
References: <20190729190739.971253303@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 6d7c3cde93c1d9ac0b37f78ec3f2ff052159a242 ]

mmu_notifier_unregister_no_release() is not a fence and the mmu_notifier
system will continue to reference hmm->mn until the srcu grace period
expires.

Resulting in use after free races like this:

         CPU0                                     CPU1
                                               __mmu_notifier_invalidate_range_start()
                                                 srcu_read_lock
                                                 hlist_for_each ()
                                                   // mn == hmm->mn
hmm_mirror_unregister()
  hmm_put()
    hmm_free()
      mmu_notifier_unregister_no_release()
         hlist_del_init_rcu(hmm-mn->list)
			                           mn->ops->invalidate_range_start(mn, range);
					             mm_get_hmm()
      mm->hmm = NULL;
      kfree(hmm)
                                                     mutex_lock(&hmm->lock);

Use SRCU to kfree the hmm memory so that the notifiers can rely on hmm
existing. Get the now-safe hmm struct through container_of and directly
check kref_get_unless_zero to lock it against free.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Reviewed-by: Ira Weiny <ira.weiny@intel.com>
Reviewed-by: John Hubbard <jhubbard@nvidia.com>
Reviewed-by: Ralph Campbell <rcampbell@nvidia.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Tested-by: Philip Yang <Philip.Yang@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hmm.h |  1 +
 mm/hmm.c            | 23 +++++++++++++++++------
 2 files changed, 18 insertions(+), 6 deletions(-)

diff --git a/include/linux/hmm.h b/include/linux/hmm.h
index 044a36d7c3f8..89508dc0795f 100644
--- a/include/linux/hmm.h
+++ b/include/linux/hmm.h
@@ -93,6 +93,7 @@ struct hmm {
 	struct mmu_notifier	mmu_notifier;
 	struct rw_semaphore	mirrors_sem;
 	wait_queue_head_t	wq;
+	struct rcu_head		rcu;
 	long			notifiers;
 	bool			dead;
 };
diff --git a/mm/hmm.c b/mm/hmm.c
index f702a3895d05..4c405dfbd2b3 100644
--- a/mm/hmm.c
+++ b/mm/hmm.c
@@ -104,6 +104,11 @@ static struct hmm *hmm_get_or_create(struct mm_struct *mm)
 	return NULL;
 }
 
+static void hmm_free_rcu(struct rcu_head *rcu)
+{
+	kfree(container_of(rcu, struct hmm, rcu));
+}
+
 static void hmm_free(struct kref *kref)
 {
 	struct hmm *hmm = container_of(kref, struct hmm, kref);
@@ -116,7 +121,7 @@ static void hmm_free(struct kref *kref)
 		mm->hmm = NULL;
 	spin_unlock(&mm->page_table_lock);
 
-	kfree(hmm);
+	mmu_notifier_call_srcu(&hmm->rcu, hmm_free_rcu);
 }
 
 static inline void hmm_put(struct hmm *hmm)
@@ -144,10 +149,14 @@ void hmm_mm_destroy(struct mm_struct *mm)
 
 static void hmm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 {
-	struct hmm *hmm = mm_get_hmm(mm);
+	struct hmm *hmm = container_of(mn, struct hmm, mmu_notifier);
 	struct hmm_mirror *mirror;
 	struct hmm_range *range;
 
+	/* Bail out if hmm is in the process of being freed */
+	if (!kref_get_unless_zero(&hmm->kref))
+		return;
+
 	/* Report this HMM as dying. */
 	hmm->dead = true;
 
@@ -185,13 +194,14 @@ static void hmm_release(struct mmu_notifier *mn, struct mm_struct *mm)
 static int hmm_invalidate_range_start(struct mmu_notifier *mn,
 			const struct mmu_notifier_range *nrange)
 {
-	struct hmm *hmm = mm_get_hmm(nrange->mm);
+	struct hmm *hmm = container_of(mn, struct hmm, mmu_notifier);
 	struct hmm_mirror *mirror;
 	struct hmm_update update;
 	struct hmm_range *range;
 	int ret = 0;
 
-	VM_BUG_ON(!hmm);
+	if (!kref_get_unless_zero(&hmm->kref))
+		return 0;
 
 	update.start = nrange->start;
 	update.end = nrange->end;
@@ -239,9 +249,10 @@ static int hmm_invalidate_range_start(struct mmu_notifier *mn,
 static void hmm_invalidate_range_end(struct mmu_notifier *mn,
 			const struct mmu_notifier_range *nrange)
 {
-	struct hmm *hmm = mm_get_hmm(nrange->mm);
+	struct hmm *hmm = container_of(mn, struct hmm, mmu_notifier);
 
-	VM_BUG_ON(!hmm);
+	if (!kref_get_unless_zero(&hmm->kref))
+		return;
 
 	mutex_lock(&hmm->lock);
 	hmm->notifiers--;
-- 
2.20.1



