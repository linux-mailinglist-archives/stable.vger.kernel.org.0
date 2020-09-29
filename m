Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99F0E27C848
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730702AbgI2MA1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:00:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:36568 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730575AbgI2Lkx (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:40:53 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5BC142065C;
        Tue, 29 Sep 2020 11:40:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601379635;
        bh=vrHzzj0NJ4cs62aCcsnRTYbtKwEJBxuDPemCWbUZoIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=iSDDuKwi141jINaFg8maaqlUU4aO8WzDBuT8Cn0qoBd7pAJhoQ5T8Pij+QekXOUQ9
         rfEqNlx0f5CdXsNZeRygbIxXooJV5YmGdiowtExYVBACVNVoNz885T+vRGFvSa9nFy
         baHr6Ic5juQHfsv7nfBgGDjp9vRg9/uyo9FJLtxg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 221/388] mm/swapfile: fix data races in try_to_unuse()
Date:   Tue, 29 Sep 2020 12:59:12 +0200
Message-Id: <20200929110021.176039912@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929110010.467764689@linuxfoundation.org>
References: <20200929110010.467764689@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit 218209487c3da2f6d861b236c11226b6eca7b7b7 ]

si->inuse_pages could be accessed concurrently as noticed by KCSAN,

 write to 0xffff98b00ebd04dc of 4 bytes by task 82262 on cpu 92:
  swap_range_free+0xbe/0x230
  swap_range_free at mm/swapfile.c:719
  swapcache_free_entries+0x1be/0x250
  free_swap_slot+0x1c8/0x220
  __swap_entry_free.constprop.19+0xa3/0xb0
  free_swap_and_cache+0x53/0xa0
  unmap_page_range+0x7e0/0x1ce0
  unmap_single_vma+0xcd/0x170
  unmap_vmas+0x18b/0x220
  exit_mmap+0xee/0x220
  mmput+0xe7/0x240
  do_exit+0x598/0xfd0
  do_group_exit+0x8b/0x180
  get_signal+0x293/0x13d0
  do_signal+0x37/0x5d0
  prepare_exit_to_usermode+0x1b7/0x2c0
  ret_from_intr+0x32/0x42

 read to 0xffff98b00ebd04dc of 4 bytes by task 82499 on cpu 46:
  try_to_unuse+0x86b/0xc80
  try_to_unuse at mm/swapfile.c:2185
  __x64_sys_swapoff+0x372/0xd40
  do_syscall_64+0x91/0xb05
  entry_SYSCALL_64_after_hwframe+0x49/0xbe

The plain reads in try_to_unuse() are outside si->lock critical section
which result in data races that could be dangerous to be used in a loop.
Fix them by adding READ_ONCE().

Signed-off-by: Qian Cai <cai@lca.pw>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Andrew Morton <akpm@linux-foundation.org>
Cc: Marco Elver <elver@google.com>
Cc: Hugh Dickins <hughd@google.com>
Link: http://lkml.kernel.org/r/1582578903-29294-1-git-send-email-cai@lca.pw
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/swapfile.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/mm/swapfile.c b/mm/swapfile.c
index 646fd0a8e3202..2f59495782dd4 100644
--- a/mm/swapfile.c
+++ b/mm/swapfile.c
@@ -2132,7 +2132,7 @@ int try_to_unuse(unsigned int type, bool frontswap,
 	swp_entry_t entry;
 	unsigned int i;
 
-	if (!si->inuse_pages)
+	if (!READ_ONCE(si->inuse_pages))
 		return 0;
 
 	if (!frontswap)
@@ -2148,7 +2148,7 @@ retry:
 
 	spin_lock(&mmlist_lock);
 	p = &init_mm.mmlist;
-	while (si->inuse_pages &&
+	while (READ_ONCE(si->inuse_pages) &&
 	       !signal_pending(current) &&
 	       (p = p->next) != &init_mm.mmlist) {
 
@@ -2177,7 +2177,7 @@ retry:
 	mmput(prev_mm);
 
 	i = 0;
-	while (si->inuse_pages &&
+	while (READ_ONCE(si->inuse_pages) &&
 	       !signal_pending(current) &&
 	       (i = find_next_to_unuse(si, i, frontswap)) != 0) {
 
@@ -2219,7 +2219,7 @@ retry:
 	 * been preempted after get_swap_page(), temporarily hiding that swap.
 	 * It's easy and robust (though cpu-intensive) just to keep retrying.
 	 */
-	if (si->inuse_pages) {
+	if (READ_ONCE(si->inuse_pages)) {
 		if (!signal_pending(current))
 			goto retry;
 		retval = -EINTR;
-- 
2.25.1



