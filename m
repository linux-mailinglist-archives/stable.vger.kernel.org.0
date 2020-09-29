Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB1E127C3F6
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 13:10:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729146AbgI2LKM (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 07:10:12 -0400
Received: from mail.kernel.org ([198.145.29.99]:50890 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729132AbgI2LKL (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:10:11 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B8A1921941;
        Tue, 29 Sep 2020 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601377811;
        bh=1RB9PptwezVIEq4RXFnWE/U6qsX71aoTnZ18odfUcek=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=o0kz+iLfqRwLTbpfEscbQ8MKxsL4Xym1Pw2WpZJv6j+jMFHU8YAV/QUPZHkW85lng
         stDYEcFdTtlWM73rddBg354AMeYxzEtMNiEPf/SXXih8pJgN8KpDGH71yk4BxRi2ug
         qdzt9I34HcaTJXDKp3HS/rtYIU+lCaTV+GM3uR2w=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 053/121] bpf: Remove recursion prevention from rcu free callback
Date:   Tue, 29 Sep 2020 12:59:57 +0200
Message-Id: <20200929105932.816498205@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105930.172747117@linuxfoundation.org>
References: <20200929105930.172747117@linuxfoundation.org>
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
index 8648d7d297081..1253261fdb3ba 100644
--- a/kernel/bpf/hashtab.c
+++ b/kernel/bpf/hashtab.c
@@ -427,15 +427,7 @@ static void htab_elem_free_rcu(struct rcu_head *head)
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
 
 static void free_htab_elem(struct bpf_htab *htab, struct htab_elem *l)
-- 
2.25.1



