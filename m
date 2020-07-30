Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C33232E0E
	for <lists+stable@lfdr.de>; Thu, 30 Jul 2020 10:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729703AbgG3IJn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 30 Jul 2020 04:09:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:48198 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729271AbgG3IJi (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 30 Jul 2020 04:09:38 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3F59A2074B;
        Thu, 30 Jul 2020 08:09:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596096577;
        bh=tHuG06lH8svj5l1Txy9XjlGDzB6W2pXKLJki2MBeZBs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W2qVJnrjE9/PUIN7kX2pGTE66/h7MWDdAM2H2PcfSDgBp/zo0ako/seybT/bG/qyk
         cbt7dEgZobor8NvO3b/5HVxmmw87ZxMui711rNNPgK9qPEANT9WDX4wPQ0oR5XcYFd
         zNZIpQGrD2XJKDjHugh70V0VR9jBOT2xJdOO0RKo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hugh Dickins <hughd@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Shakeel Butt <shakeelb@google.com>,
        Michal Hocko <mhocko@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 4.9 41/61] mm/memcg: fix refcount error while moving and swapping
Date:   Thu, 30 Jul 2020 10:04:59 +0200
Message-Id: <20200730074422.823349331@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200730074420.811058810@linuxfoundation.org>
References: <20200730074420.811058810@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Hugh Dickins <hughd@google.com>

commit 8d22a9351035ef2ff12ef163a1091b8b8cf1e49c upstream.

It was hard to keep a test running, moving tasks between memcgs with
move_charge_at_immigrate, while swapping: mem_cgroup_id_get_many()'s
refcount is discovered to be 0 (supposedly impossible), so it is then
forced to REFCOUNT_SATURATED, and after thousands of warnings in quick
succession, the test is at last put out of misery by being OOM killed.

This is because of the way moved_swap accounting was saved up until the
task move gets completed in __mem_cgroup_clear_mc(), deferred from when
mem_cgroup_move_swap_account() actually exchanged old and new ids.
Concurrent activity can free up swap quicker than the task is scanned,
bringing id refcount down 0 (which should only be possible when
offlining).

Just skip that optimization: do that part of the accounting immediately.

Fixes: 615d66c37c75 ("mm: memcontrol: fix memcg id ref counter on swap charge move")
Signed-off-by: Hugh Dickins <hughd@google.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reviewed-by: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Alex Shi <alex.shi@linux.alibaba.com>
Cc: Shakeel Butt <shakeelb@google.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/alpine.LSU.2.11.2007071431050.4726@eggly.anvils
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 mm/memcontrol.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4794,7 +4794,6 @@ static void __mem_cgroup_clear_mc(void)
 		if (!mem_cgroup_is_root(mc.to))
 			page_counter_uncharge(&mc.to->memory, mc.moved_swap);
 
-		mem_cgroup_id_get_many(mc.to, mc.moved_swap);
 		css_put_many(&mc.to->css, mc.moved_swap);
 
 		mc.moved_swap = 0;
@@ -4972,7 +4971,8 @@ put:			/* get_mctgt_type() gets the page
 			ent = target.ent;
 			if (!mem_cgroup_move_swap_account(ent, mc.from, mc.to)) {
 				mc.precharge--;
-				/* we fixup refcnts and charges later. */
+				mem_cgroup_id_get_many(mc.to, 1);
+				/* we fixup other refcnts and charges later. */
 				mc.moved_swap++;
 			}
 			break;


