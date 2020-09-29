Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14ADF27CBD7
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:31:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732974AbgI2Max (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:30:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:41564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729207AbgI2L3g (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:29:36 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 060A823A6A;
        Tue, 29 Sep 2020 11:24:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378644;
        bh=eJUpK7/qw6BnJLNqvb7DTW1JHZGMyCW4pYM7azEwQjY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vWuCmd+yafMoYX7snCgNQafa5R3/DruuIYS/F8Y2g5s6lMnd3fbnmljM6kHDB8BKA
         vrR6vylaC4HHfoyQKXs56e2gsfAMx0/WawI/8ppFy5PYrDh6MhQKxPWjei5E8U+RMy
         gKGu3SJYkDKb9hkD6TopUChdJk5pIn1sjMNtiZFM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 088/245] bpf: Remove recursion prevention from rcu free callback
Date:   Tue, 29 Sep 2020 12:58:59 +0200
Message-Id: <20200929105951.269780776@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105946.978650816@linuxfoundation.org>
References: <20200929105946.978650816@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Thomas Gleixner <tglx@linutronix.de>

[ Upstream commit 8a37963c7ac9ecb7f86f8ebda020e3f8d6d7b8a0 ]

If an element is freed via RCU then recursion into BPF instrumentation
functions is not a concern. The element is already detached from the map
and the RCU callback does not hold any locks on which a kprobe, perf event
or tracepoint attached BPF program could deadlock.

Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://lore.kernel.org/bpf/20200224145643.259118710@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/hashtab.c | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/kernel/bpf/hashtab.c b/kernel/bpf/hashtab.c
index 1b28fb006763a..3f3ed33bd2fdc 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -667,15 +667,7 @@ static void htab_elem_free_rcu(struct rcu_head *head)
 	struct htab_elem *l = container_of(head, struct htab_elem, rcu);
 	struct bpf_htab *htab = l->htab;
 
-	/* must increment bpf_prog_active to avoid kprobe+bpf triggering while
-	 * we're calling kfree, otherwise deadlock is possible if kprobes
-	 * are placed somewhere inside of slub
-	 */
-	preempt_disable();
-	__this_cpu_inc(bpf_prog_active);
 	htab_elem_free(htab, l);
-	__this_cpu_dec(bpf_prog_active);
-	preempt_enable();
 }
 
 static void htab_put_fd_value(struct bpf_htab *htab, struct htab_elem *l)
-- 
2.25.1



