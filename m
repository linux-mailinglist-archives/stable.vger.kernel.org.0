Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B05B62D1F44
	for <lists+stable@lfdr.de>; Tue,  8 Dec 2020 01:47:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728735AbgLHArR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 7 Dec 2020 19:47:17 -0500
Received: from mail.kernel.org ([198.145.29.99]:60094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbgLHArR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 7 Dec 2020 19:47:17 -0500
Date:   Mon, 07 Dec 2020 16:46:20 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607388380;
        bh=XTIIMbjDAHAjOCEGfRSnHksXkqMeACSP7SLpUsO6+JE=;
        h=From:To:Subject:From;
        b=HK49m5HAonvikyHtqDvs6tYaBtfa1PLiG3MIJDA3pLY11vuA5TKhTmooHE6YZA8z9
         Hl4C5KsEKrgZHSGFz28gPk7yEzoQFbdw9Z6etaQtD89sZ1GHFJsk/pJxpr5w+r7Jf/
         5aKRCy5Dh1mpY3RonK23qOYLGWkZvmg8w4Ztu3N8=
From:   akpm@linux-foundation.org
To:     akpm@linux-foundation.org, hughd@google.com,
        mm-commits@vger.kernel.org, qcai@redhat.com, stable@vger.kernel.org
Subject:  [merged]
 mm-swapfile-do-not-sleep-with-a-spin-lock-held.patch removed from -mm tree
Message-ID: <20201208004620.V9_Q79gId%akpm@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


The patch titled
     Subject: mm/swapfile: do not sleep with a spin lock held
has been removed from the -mm tree.  Its filename was
     mm-swapfile-do-not-sleep-with-a-spin-lock-held.patch

This patch was dropped because it was merged into mainline or a subsystem tree

------------------------------------------------------
From: Qian Cai <qcai@redhat.com>
Subject: mm/swapfile: do not sleep with a spin lock held

We can't call kvfree() with a spin lock held, so defer it.  Fixes a
might_sleep() runtime warning.

Link: https://lkml.kernel.org/r/20201202151549.10350-1-qcai@redhat.com
Fixes: 873d7bcfd066 ("mm/swapfile.c: use kvzalloc for swap_info_struct allocation")
Signed-off-by: Qian Cai <qcai@redhat.com>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c~mm-swapfile-do-not-sleep-with-a-spin-lock-held
+++ a/mm/swapfile.c
@@ -2867,6 +2867,7 @@ late_initcall(max_swapfiles_check);
 static struct swap_info_struct *alloc_swap_info(void)
 {
 	struct swap_info_struct *p;
+	struct swap_info_struct *defer = NULL;
 	unsigned int type;
 	int i;
 
@@ -2895,7 +2896,7 @@ static struct swap_info_struct *alloc_sw
 		smp_wmb();
 		WRITE_ONCE(nr_swapfiles, nr_swapfiles + 1);
 	} else {
-		kvfree(p);
+		defer = p;
 		p = swap_info[type];
 		/*
 		 * Do not memset this entry: a racing procfs swap_next()
@@ -2908,6 +2909,7 @@ static struct swap_info_struct *alloc_sw
 		plist_node_init(&p->avail_lists[i], 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
+	kvfree(defer);
 	spin_lock_init(&p->lock);
 	spin_lock_init(&p->cont_lock);
 
_

Patches currently in -mm which might be from qcai@redhat.com are


