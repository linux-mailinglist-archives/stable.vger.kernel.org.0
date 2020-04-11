Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31A4B1A51AB
	for <lists+stable@lfdr.de>; Sat, 11 Apr 2020 14:27:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727983AbgDKMOj (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 11 Apr 2020 08:14:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:48148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727980AbgDKMOj (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 11 Apr 2020 08:14:39 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A2AD220644;
        Sat, 11 Apr 2020 12:14:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586607279;
        bh=3p1hq6BIBuc0+vFYbTPfMRq7iCHk0swCK/hCdXftwMM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=G9cGlSiBdKVAtlHXf0OSPqNXC4GZnUN/CVdZcjiG3qZjqubgD5Yyc0zO957tTODhc
         VTPSmM53h9opVYml3BLZq7RPV/+z5aIdJg+XQA4hsRMcqfBGkVGpimtL/VuDoHHs+p
         cEzE97yyQlzJuTUcLH3/UCTQjRQOlWIOB2pxoVdY=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 4.19 01/54] ipv4: fix a RCU-list lock in fib_triestat_seq_show
Date:   Sat, 11 Apr 2020 14:08:43 +0200
Message-Id: <20200411115508.424171453@linuxfoundation.org>
X-Mailer: git-send-email 2.26.0
In-Reply-To: <20200411115508.284500414@linuxfoundation.org>
References: <20200411115508.284500414@linuxfoundation.org>
User-Agent: quilt/0.66
X-stable: review
X-Patchwork-Hint: ignore
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@lca.pw>

[ Upstream commit fbe4e0c1b298b4665ee6915266c9d6c5b934ef4a ]

fib_triestat_seq_show() calls hlist_for_each_entry_rcu(tb, head,
tb_hlist) without rcu_read_lock() will trigger a warning,

 net/ipv4/fib_trie.c:2579 RCU-list traversed in non-reader section!!

 other info that might help us debug this:

 rcu_scheduler_active = 2, debug_locks = 1
 1 lock held by proc01/115277:
  #0: c0000014507acf00 (&p->lock){+.+.}-{3:3}, at: seq_read+0x58/0x670

 Call Trace:
  dump_stack+0xf4/0x164 (unreliable)
  lockdep_rcu_suspicious+0x140/0x164
  fib_triestat_seq_show+0x750/0x880
  seq_read+0x1a0/0x670
  proc_reg_read+0x10c/0x1b0
  __vfs_read+0x3c/0x70
  vfs_read+0xac/0x170
  ksys_read+0x7c/0x140
  system_call+0x5c/0x68

Fix it by adding a pair of rcu_read_lock/unlock() and use
cond_resched_rcu() to avoid the situation where walking of a large
number of items  may prevent scheduling for a long time.

Signed-off-by: Qian Cai <cai@lca.pw>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/fib_trie.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/net/ipv4/fib_trie.c
+++ b/net/ipv4/fib_trie.c
@@ -2337,6 +2337,7 @@ static int fib_triestat_seq_show(struct
 		   " %zd bytes, size of tnode: %zd bytes.\n",
 		   LEAF_SIZE, TNODE_SIZE(0));
 
+	rcu_read_lock();
 	for (h = 0; h < FIB_TABLE_HASHSZ; h++) {
 		struct hlist_head *head = &net->ipv4.fib_table_hash[h];
 		struct fib_table *tb;
@@ -2356,7 +2357,9 @@ static int fib_triestat_seq_show(struct
 			trie_show_usage(seq, t->stats);
 #endif
 		}
+		cond_resched_rcu();
 	}
+	rcu_read_unlock();
 
 	return 0;
 }


