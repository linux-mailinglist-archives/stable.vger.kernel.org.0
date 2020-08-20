Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 83ED124BA25
	for <lists+stable@lfdr.de>; Thu, 20 Aug 2020 14:03:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729273AbgHTMAn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 20 Aug 2020 08:00:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47980 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730272AbgHTKAO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 20 Aug 2020 06:00:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67ACC2067C;
        Thu, 20 Aug 2020 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597917614;
        bh=829OW9TDD1C+O9hfHOA1MBt+kZABuG0zo7L/+wYSKm4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=NL/JGoRD1QN3JfkRLULTlr/MyrFbAXVJgL/8pClndA85DkvZ//Nq7vT20/cpWPgJ2
         iG9uBo3TakcKlLp3dy8c2Cwq0cAOwlR7VmKB9bryW95Cx0S6rp1pXbEX599rsmFq4A
         oiEFMn7jxe8ZLtznxNlS0nj7yf7wi1En+t1dy+Kg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, "Paul E. McKenney" <paulmck@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 093/212] fs/btrfs: Add cond_resched() for try_release_extent_mapping() stalls
Date:   Thu, 20 Aug 2020 11:21:06 +0200
Message-Id: <20200820091607.045861123@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200820091602.251285210@linuxfoundation.org>
References: <20200820091602.251285210@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Paul E. McKenney <paulmck@kernel.org>

[ Upstream commit 9f47eb5461aaeb6cb8696f9d11503ae90e4d5cb0 ]

Very large I/Os can cause the following RCU CPU stall warning:

RIP: 0010:rb_prev+0x8/0x50
Code: 49 89 c0 49 89 d1 48 89 c2 48 89 f8 e9 e5 fd ff ff 4c 89 48 10 c3 4c =
89 06 c3 4c 89 40 10 c3 0f 1f 00 48 8b 0f 48 39 cf 74 38 <48> 8b 47 10 48 85 c0 74 22 48 8b 50 08 48 85 d2 74 0c 48 89 d0 48
RSP: 0018:ffffc9002212bab0 EFLAGS: 00000287 ORIG_RAX: ffffffffffffff13
RAX: ffff888821f93630 RBX: ffff888821f93630 RCX: ffff888821f937e0
RDX: 0000000000000000 RSI: 0000000000102000 RDI: ffff888821f93630
RBP: 0000000000103000 R08: 000000000006c000 R09: 0000000000000238
R10: 0000000000102fff R11: ffffc9002212bac8 R12: 0000000000000001
R13: ffffffffffffffff R14: 0000000000102000 R15: ffff888821f937e0
 __lookup_extent_mapping+0xa0/0x110
 try_release_extent_mapping+0xdc/0x220
 btrfs_releasepage+0x45/0x70
 shrink_page_list+0xa39/0xb30
 shrink_inactive_list+0x18f/0x3b0
 shrink_lruvec+0x38e/0x6b0
 shrink_node+0x14d/0x690
 do_try_to_free_pages+0xc6/0x3e0
 try_to_free_mem_cgroup_pages+0xe6/0x1e0
 reclaim_high.constprop.73+0x87/0xc0
 mem_cgroup_handle_over_high+0x66/0x150
 exit_to_usermode_loop+0x82/0xd0
 do_syscall_64+0xd4/0x100
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

On a PREEMPT=n kernel, the try_release_extent_mapping() function's
"while" loop might run for a very long time on a large I/O.  This commit
therefore adds a cond_resched() to this loop, providing RCU any needed
quiescent states.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/btrfs/extent_io.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/fs/btrfs/extent_io.c b/fs/btrfs/extent_io.c
index 8c0ff985c1919..fa22bb29eee6f 100644
--- a/fs/btrfs/extent_io.c
+++ b/fs/btrfs/extent_io.c
@@ -4340,6 +4340,8 @@ int try_release_extent_mapping(struct extent_map_tree *map,
 
 			/* once for us */
 			free_extent_map(em);
+
+			cond_resched(); /* Allow large-extent preemption. */
 		}
 	}
 	return try_release_extent_state(map, tree, page, mask);
-- 
2.25.1



