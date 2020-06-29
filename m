Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE12C20D0FE
	for <lists+stable@lfdr.de>; Mon, 29 Jun 2020 20:41:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727085AbgF2Sha (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:37:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:56910 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726787AbgF2Sfu (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:50 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EF715247BF;
        Mon, 29 Jun 2020 15:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444128;
        bh=MTjlcBR2OT9Vy7WzWDXrko29JUse4iEHGIPkf4sLke4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=x7ChO+Ijz3J0EYFzyhebws5qgBexDJBFiXyiyNpp2vYgQYu2ssxTNepyt7Qdi8Rm8
         hcYksgSJ5jFcLMY/r2MEDkq5kJfpLSh5dpqTs7/Fgm0ahmrDroFobcTlIdWFz9R28D
         2DwrghE0FjtkZY3XnAyDZWjcDJUYV8nWx1gf/Ly8=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>,
        Michal Hocko <mhocko@suse.com>,
        Chris Down <chris@chrisdown.name>,
        Roman Gushchin <guro@fb.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 235/265] mm: memcontrol: handle div0 crash race condition in memory.low
Date:   Mon, 29 Jun 2020 11:17:48 -0400
Message-Id: <20200629151818.2493727-236-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Johannes Weiner <hannes@cmpxchg.org>

commit cd324edce598ebddde44162a2aa01321c1261b9e upstream.

Tejun reports seeing rare div0 crashes in memory.low stress testing:

  RIP: 0010:mem_cgroup_calculate_protection+0xed/0x150
  Code: 0f 46 d1 4c 39 d8 72 57 f6 05 16 d6 42 01 40 74 1f 4c 39 d8 76 1a 4c 39 d1 76 15 4c 29 d1 4c 29 d8 4d 29 d9 31 d2 48 0f af c1 <49> f7 f1 49 01 c2 4c 89 96 38 01 00 00 5d c3 48 0f af c7 31 d2 49
  RSP: 0018:ffffa14e01d6fcd0 EFLAGS: 00010246
  RAX: 000000000243e384 RBX: 0000000000000000 RCX: 0000000000008f4b
  RDX: 0000000000000000 RSI: ffff8b89bee84000 RDI: 0000000000000000
  RBP: ffffa14e01d6fcd0 R08: ffff8b89ca7d40f8 R09: 0000000000000000
  R10: 0000000000000000 R11: 00000000006422f7 R12: 0000000000000000
  R13: ffff8b89d9617000 R14: ffff8b89bee84000 R15: ffffa14e01d6fdb8
  FS:  0000000000000000(0000) GS:ffff8b8a1f1c0000(0000) knlGS:0000000000000000
  CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
  CR2: 00007f93b1fc175b CR3: 000000016100a000 CR4: 0000000000340ea0
  Call Trace:
    shrink_node+0x1e5/0x6c0
    balance_pgdat+0x32d/0x5f0
    kswapd+0x1d7/0x3d0
    kthread+0x11c/0x160
    ret_from_fork+0x1f/0x30

This happens when parent_usage == siblings_protected.

We check that usage is bigger than protected, which should imply
parent_usage being bigger than siblings_protected.  However, we don't
read (or even update) these values atomically, and they can be out of
sync as the memory state changes under us.  A bit of fluctuation around
the target protection isn't a big deal, but we need to handle the div0
case.

Check the parent state explicitly to make sure we have a reasonable
positive value for the divisor.

Link: http://lkml.kernel.org/r/20200615140658.601684-1-hannes@cmpxchg.org
Fixes: 8a931f801340 ("mm: memcontrol: recursive memory.low protection")
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
Reported-by: Tejun Heo <tj@kernel.org>
Acked-by: Michal Hocko <mhocko@suse.com>
Acked-by: Chris Down <chris@chrisdown.name>
Cc: Roman Gushchin <guro@fb.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/memcontrol.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index a3b97f1039665..1b05e25d8aef2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6349,11 +6349,16 @@ static unsigned long effective_protection(unsigned long usage,
 	 * We're using unprotected memory for the weight so that if
 	 * some cgroups DO claim explicit protection, we don't protect
 	 * the same bytes twice.
+	 *
+	 * Check both usage and parent_usage against the respective
+	 * protected values. One should imply the other, but they
+	 * aren't read atomically - make sure the division is sane.
 	 */
 	if (!(cgrp_dfl_root.flags & CGRP_ROOT_MEMORY_RECURSIVE_PROT))
 		return ep;
-
-	if (parent_effective > siblings_protected && usage > protected) {
+	if (parent_effective > siblings_protected &&
+	    parent_usage > siblings_protected &&
+	    usage > protected) {
 		unsigned long unclaimed;
 
 		unclaimed = parent_effective - siblings_protected;
-- 
2.25.1

