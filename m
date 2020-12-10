Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CA242D6521
	for <lists+stable@lfdr.de>; Thu, 10 Dec 2020 19:34:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390806AbgLJSeD (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Dec 2020 13:34:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:41826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390749AbgLJOdg (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Dec 2020 09:33:36 -0500
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Authentication-Results: mail.kernel.org; dkim=permerror (bad message/signature format)
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <qcai@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.19 23/39] mm/swapfile: do not sleep with a spin lock held
Date:   Thu, 10 Dec 2020 15:27:02 +0100
Message-Id: <20201210142603.414894255@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201210142602.272595094@linuxfoundation.org>
References: <20201210142602.272595094@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <qcai@redhat.com>

commit b11a76b37a5aa7b07c3e3eeeaae20b25475bddd3 upstream.

We can't call kvfree() with a spin lock held, so defer it.  Fixes a
might_sleep() runtime warning.

Fixes: 873d7bcfd066 ("mm/swapfile.c: use kvzalloc for swap_info_struct allocation")
Signed-off-by: Qian Cai <qcai@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: <stable@vger.kernel.org>
Link: https://lkml.kernel.org/r/20201202151549.10350-1-qcai@redhat.com
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/swapfile.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2825,6 +2825,7 @@ late_initcall(max_swapfiles_check);
 static struct swap_info_struct *alloc_swap_info(void)
 {
 	struct swap_info_struct *p;
+	struct swap_info_struct *defer = NULL;
 	unsigned int type;
 	int i;
 	int size = sizeof(*p) + nr_node_ids * sizeof(struct plist_node);
@@ -2854,7 +2855,7 @@ static struct swap_info_struct *alloc_sw
 		smp_wmb();
 		WRITE_ONCE(nr_swapfiles, nr_swapfiles + 1);
 	} else {
-		kvfree(p);
+		defer = p;
 		p = swap_info[type];
 		/*
 		 * Do not memset this entry: a racing procfs swap_next()
@@ -2867,6 +2868,7 @@ static struct swap_info_struct *alloc_sw
 		plist_node_init(&p->avail_lists[i], 0);
 	p->flags = SWP_USED;
 	spin_unlock(&swap_lock);
+	kvfree(defer);
 	spin_lock_init(&p->lock);
 	spin_lock_init(&p->cont_lock);
 


