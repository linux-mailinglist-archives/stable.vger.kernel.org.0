Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B47582D0128
	for <lists+stable@lfdr.de>; Sun,  6 Dec 2020 07:15:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725866AbgLFGPh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 6 Dec 2020 01:15:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:58684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725379AbgLFGPh (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 6 Dec 2020 01:15:37 -0500
Date:   Sat, 05 Dec 2020 22:14:55 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
        s=korg; t=1607235296;
        bh=yQHF9wy/rEDp1jEnZIQgWe+affdUfYqCvb72tCH1FP0=;
        h=From:To:Subject:In-Reply-To:From;
        b=XThZZkI8OIP4QZjWIZNoEBx2nuAn7+HlDDpPEgArXBEZHdkYqhaqDfHTpq5sDjhbp
         JRsgXNKSTTiNASvB7U4QnrkUm/Zfy+OYpK5OAdSmzdKC+B6VdTh5JOT7/ik2i3TWXJ
         /TWylwhzx5X69m6/nW5FQ1jaB1GrveFKFCJsL0SE=
From:   Andrew Morton <akpm@linux-foundation.org>
To:     akpm@linux-foundation.org, hughd@google.com, linux-mm@kvack.org,
        mm-commits@vger.kernel.org, qcai@redhat.com,
        stable@vger.kernel.org, torvalds@linux-foundation.org
Subject:  [patch 06/12] mm/swapfile: do not sleep with a spin lock
 held
Message-ID: <20201206061455.fGLHX_jlo%akpm@linux-foundation.org>
In-Reply-To: <20201205221412.67f14b9b3a5ef531c76dd452@linux-foundation.org>
User-Agent: s-nail v14.8.16
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

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
