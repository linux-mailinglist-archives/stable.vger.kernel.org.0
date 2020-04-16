Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BD9AB1ACC2E
	for <lists+stable@lfdr.de>; Thu, 16 Apr 2020 17:57:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2442836AbgDPP4c (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 16 Apr 2020 11:56:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:38156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2895902AbgDPN2y (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 16 Apr 2020 09:28:54 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D134E217D8;
        Thu, 16 Apr 2020 13:28:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587043732;
        bh=vAJ3XMJ+64UTF8UdA1rtf/aMMyHBYqKrlx4E7E88V40=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BBjHPIXd+B04IL+Pw30qfeF2r3ZVLbcBHP5jSifqqI1npNnuyoMH2hxKsP1iy9A//
         zpetkjDUvnKulc3oWBLVgt9wYVFOpLfdGR0E39r5yLW8dtmu/sX672Lz2XtNRCn3ko
         X1oUxwhvv35ue4BQyY4yXkNICES6CwrbVgziiRBs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Boqun Feng <boqun.feng@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 036/146] locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps()
Date:   Thu, 16 Apr 2020 15:22:57 +0200
Message-Id: <20200416131247.435680058@linuxfoundation.org>
X-Mailer: git-send-email 2.26.1
In-Reply-To: <20200416131242.353444678@linuxfoundation.org>
References: <20200416131242.353444678@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Boqun Feng <boqun.feng@gmail.com>

[ Upstream commit 25016bd7f4caf5fc983bbab7403d08e64cba3004 ]

Qian Cai reported a bug when PROVE_RCU_LIST=y, and read on /proc/lockdep
triggered a warning:

  [ ] DEBUG_LOCKS_WARN_ON(current->hardirqs_enabled)
  ...
  [ ] Call Trace:
  [ ]  lock_is_held_type+0x5d/0x150
  [ ]  ? rcu_lockdep_current_cpu_online+0x64/0x80
  [ ]  rcu_read_lock_any_held+0xac/0x100
  [ ]  ? rcu_read_lock_held+0xc0/0xc0
  [ ]  ? __slab_free+0x421/0x540
  [ ]  ? kasan_kmalloc+0x9/0x10
  [ ]  ? __kmalloc_node+0x1d7/0x320
  [ ]  ? kvmalloc_node+0x6f/0x80
  [ ]  __bfs+0x28a/0x3c0
  [ ]  ? class_equal+0x30/0x30
  [ ]  lockdep_count_forward_deps+0x11a/0x1a0

The warning got triggered because lockdep_count_forward_deps() call
__bfs() without current->lockdep_recursion being set, as a result
a lockdep internal function (__bfs()) is checked by lockdep, which is
unexpected, and the inconsistency between the irq-off state and the
state traced by lockdep caused the warning.

Apart from this warning, lockdep internal functions like __bfs() should
always be protected by current->lockdep_recursion to avoid potential
deadlocks and data inconsistency, therefore add the
current->lockdep_recursion on-and-off section to protect __bfs() in both
lockdep_count_forward_deps() and lockdep_count_backward_deps()

Reported-by: Qian Cai <cai@lca.pw>
Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20200312151258.128036-1-boqun.feng@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 1e272f6a01e73..8a1758b094b70 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1260,9 +1260,11 @@ unsigned long lockdep_count_forward_deps(struct lock_class *class)
 	this.class = class;
 
 	raw_local_irq_save(flags);
+	current->lockdep_recursion = 1;
 	arch_spin_lock(&lockdep_lock);
 	ret = __lockdep_count_forward_deps(&this);
 	arch_spin_unlock(&lockdep_lock);
+	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 
 	return ret;
@@ -1287,9 +1289,11 @@ unsigned long lockdep_count_backward_deps(struct lock_class *class)
 	this.class = class;
 
 	raw_local_irq_save(flags);
+	current->lockdep_recursion = 1;
 	arch_spin_lock(&lockdep_lock);
 	ret = __lockdep_count_backward_deps(&this);
 	arch_spin_unlock(&lockdep_lock);
+	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 
 	return ret;
-- 
2.20.1



