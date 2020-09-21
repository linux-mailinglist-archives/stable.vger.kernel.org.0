Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31C80272F12
	for <lists+stable@lfdr.de>; Mon, 21 Sep 2020 18:55:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729745AbgIUQqt (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Sep 2020 12:46:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727231AbgIUQqs (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 21 Sep 2020 12:46:48 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 456192388B;
        Mon, 21 Sep 2020 16:46:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600706808;
        bh=JPG2gxzH8/PmMe7MPg6i78jrQ21xF4EspNNevikwD7w=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CtNTOnDoC1sohP+qx+UQ9fNuLVJAWWW/DyfM0hSt5Ex7m3/6pyKeKBomtZzCExeRA
         CmQcB+cjXnY3bLbMpFfIAWvlgdRWw7/n8Gm5HoFGWA2PZq3zBvjXgpDGO3xbIW4gZ5
         PIn6SkAQcSkO7Kg/nhRFzfNtNaNPRa/HjrjKVoJA=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Shakeel Butt <shakeelb@google.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Michal Hocko <mhocko@suse.com>,
        Mike Kravetz <mike.kravetz@oracle.com>, Qian Cai <cai@lca.pw>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 5.8 103/118] ksm: reinstate memcg charge on copied pages
Date:   Mon, 21 Sep 2020 18:28:35 +0200
Message-Id: <20200921162041.161799840@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200921162036.324813383@linuxfoundation.org>
References: <20200921162036.324813383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 62fdb1632bcbed30c40f6bd2b58297617e442658 upstream.

Patch series "mm: fixes to past from future testing".

Here's a set of independent fixes against 5.9-rc2: prompted by
testing Alex Shi's "warning on !memcg" and lru_lock series, but
I think fit for 5.9 - though maybe only the first for stable.

This patch (of 5):

In 5.8 some instances of memcg charging in do_swap_page() and unuse_pte()
were removed, on the understanding that swap cache is now already charged
at those points; but a case was missed, when ksm_might_need_to_copy() has
decided it must allocate a substitute page: such pages were never charged.
Fix it inside ksm_might_need_to_copy().

This was discovered by Alex Shi's prospective commit "mm/memcg: warning on
!memcg after readahead page charged".

But there is a another surprise: this also fixes some rarer uncharged
PageAnon cases, when KSM is configured in, but has never been activated.
ksm_might_need_to_copy()'s anon_vma->root and linear_page_index() check
sometimes catches a case which would need to have been copied if KSM were
turned on.  Or that's my optimistic interpretation (of my own old code),
but it leaves some doubt as to whether everything is working as intended
there - might it hint at rare anon ptes which rmap cannot find?  A
question not easily answered: put in the fix for missed memcg charges.

Cc; Matthew Wilcox <willy@infradead.org>

Fixes: 4c6355b25e8b ("mm: memcontrol: charge swapin pages on instantiation")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Shakeel Butt <shakeelb@google.com>
Acked-by: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Qian Cai <cai@lca.pw>
Cc: <stable@vger.kernel.org>	[5.8]
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301343270.5954@eggly.anvils
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2008301358020.5954@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/ksm.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2585,6 +2585,10 @@ struct page *ksm_might_need_to_copy(stru
 		return page;		/* let do_swap_page report the error */
 
 	new_page = alloc_page_vma(GFP_HIGHUSER_MOVABLE, vma, address);
+	if (new_page && mem_cgroup_charge(new_page, vma->vm_mm, GFP_KERNEL)) {
+		put_page(new_page);
+		new_page = NULL;
+	}
 	if (new_page) {
 		copy_user_highpage(new_page, page, address, vma);
 


