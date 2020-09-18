Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2FA3A26F294
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 05:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727691AbgIRC7s (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:59:48 -0400
Received: from mail.kernel.org ([198.145.29.99]:54476 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727647AbgIRCFt (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:05:49 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B9FC22388E;
        Fri, 18 Sep 2020 02:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394748;
        bh=vrHzzj0NJ4cs62aCcsnRTYbtKwEJBxuDPemCWbUZoIw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v1C6OeIqjeJ1Fa+8R4+GvcsiR7aBsVsAuUUqj9pPpXNY+z9wjYH9dMONnbAAh+yrL
         FREMVPwUCAPpKvDB/psTLPptbCVEDTx+hLIIxj/w1M4pfHAm+uIs9uRXrnkCqQGvxc
         9YT7C9B42CtrQjmkcEz5qIUL7EZKXCJNB5FeBGBA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Qian Cai <cai@lca.pw>, Andrew Morton <akpm@linux-foundation.org>,
        Marco Elver <elver@google.com>,
        Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Sasha Levin <sashal@kernel.org>, linux-mm@kvack.org
Subject: [PATCH AUTOSEL 5.4 227/330] mm/swapfile: fix data races in try_to_unuse()
Date:   Thu, 17 Sep 2020 21:59:27 -0400
Message-Id: <20200918020110.2063155-227-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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

