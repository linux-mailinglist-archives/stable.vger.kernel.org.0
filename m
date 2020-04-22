Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17D131B3BCD
	for <lists+stable@lfdr.de>; Wed, 22 Apr 2020 11:59:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbgDVJ7L (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 22 Apr 2020 05:59:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:45434 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726023AbgDVJ7K (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 22 Apr 2020 05:59:10 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 754B12076C;
        Wed, 22 Apr 2020 09:59:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1587549549;
        bh=PZA3Vw1JHUk8Sy3E3cFgr+3sTMuxx5oWNx1mnU7ajYE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XWV+1123JBaB+TMXsq0hu9zNN4frCxQeX4togqxLFyDx0jfT88owdrLnQKGiSdDYC
         NeeqFGXitTvTAR65iO/vhZjgL0FtHQRl3Q/JmWP8Z6KMKN0si3CVHw+/O+iHyK99zP
         yYF8KDBLRroU6yhuzjac2g8JsVxKzx+rcqHYlNL4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@lca.pw>,
        Boqun Feng <boqun.feng@gmail.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 010/100] locking/lockdep: Avoid recursion in lockdep_count_{for,back}ward_deps()
Date:   Wed, 22 Apr 2020 11:55:40 +0200
Message-Id: <20200422095024.837041098@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200422095022.476101261@linuxfoundation.org>
References: <20200422095022.476101261@linuxfoundation.org>
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
index a419696709a1a..0a00720d3cccb 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -1265,9 +1265,11 @@ unsigned long lockdep_count_forward_deps(struct lock_class *class)
 	this.class = class;
 
 	raw_local_irq_save(flags);
+	current->lockdep_recursion = 1;
 	arch_spin_lock(&lockdep_lock);
 	ret = __lockdep_count_forward_deps(&this);
 	arch_spin_unlock(&lockdep_lock);
+	current->lockdep_recursion = 0;
 	raw_local_irq_restore(flags);
 
 	return ret;
@@ -1292,9 +1294,11 @@ unsigned long lockdep_count_backward_deps(struct lock_class *class)
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



