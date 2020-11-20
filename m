Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 451A02BA885
	for <lists+stable@lfdr.de>; Fri, 20 Nov 2020 12:09:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727773AbgKTLIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 20 Nov 2020 06:08:44 -0500
Received: from mail.kernel.org ([198.145.29.99]:55444 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728534AbgKTLHd (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 20 Nov 2020 06:07:33 -0500
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1E686206E3;
        Fri, 20 Nov 2020 11:07:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1605870452;
        bh=KJ3O/wOGutgyxWpSd5ofPcjTYg/p/bintXddORhACEY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=pAX4WHpr9NcvBNzKveIwwtP8Re2zqxBSdYWpw9ocxWCEziJr4S0/kKDyncMHVwLhV
         GhP8w+q/6qTCEgRPI9ulC0xExUtP7ws6b3TcpDJ33khEVGSLNNAswjNjLTF7Bg5Tga
         w56qOIiHtNx+8mMj3KRxdeaJ2XVYm0X4r2Tk6rJE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Qian Cai <cai@redhat.com>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Michael Ellerman <mpe@ellerman.id.au>
Subject: [PATCH 5.9 11/14] powerpc/smp: Call rcu_cpu_starting() earlier
Date:   Fri, 20 Nov 2020 12:03:49 +0100
Message-Id: <20201120104541.719427713@linuxfoundation.org>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201120104541.168007611@linuxfoundation.org>
References: <20201120104541.168007611@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Qian Cai <cai@redhat.com>

commit 99f070b62322a4b8c1252952735806d09eb44b68 upstream.

The call to rcu_cpu_starting() in start_secondary() is not early
enough in the CPU-hotplug onlining process, which results in lockdep
splats as follows (with CONFIG_PROVE_RCU_LIST=y):

  WARNING: suspicious RCU usage
  -----------------------------
  kernel/locking/lockdep.c:3497 RCU-list traversed in non-reader section!!

  other info that might help us debug this:

  RCU used illegally from offline CPU!
  rcu_scheduler_active = 1, debug_locks = 1
  no locks held by swapper/1/0.

  Call Trace:
  dump_stack+0xec/0x144 (unreliable)
  lockdep_rcu_suspicious+0x128/0x14c
  __lock_acquire+0x1060/0x1c60
  lock_acquire+0x140/0x5f0
  _raw_spin_lock_irqsave+0x64/0xb0
  clockevents_register_device+0x74/0x270
  register_decrementer_clockevent+0x94/0x110
  start_secondary+0x134/0x800
  start_secondary_prolog+0x10/0x14

This is avoided by adding a call to rcu_cpu_starting() near the
beginning of the start_secondary() function. Note that the
raw_smp_processor_id() is required in order to avoid calling into
lockdep before RCU has declared the CPU to be watched for readers.

It's safe to call rcu_cpu_starting() in the arch code as well as later
in generic code, as explained by Paul:

  It uses a per-CPU variable so that RCU pays attention only to the
  first call to rcu_cpu_starting() if there is more than one of them.
  This is even intentional, due to there being a generic
  arch-independent call to rcu_cpu_starting() in
  notify_cpu_starting().

  So multiple calls to rcu_cpu_starting() are fine by design.

Fixes: 4d004099a668 ("lockdep: Fix lockdep recursion")
Signed-off-by: Qian Cai <cai@redhat.com>
Acked-by: Paul E. McKenney <paulmck@kernel.org>
[mpe: Add Fixes tag, reword slightly & expand change log]
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://lore.kernel.org/r/20201028182334.13466-1-cai@redhat.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/smp.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/powerpc/kernel/smp.c
+++ b/arch/powerpc/kernel/smp.c
@@ -1251,7 +1251,7 @@ static bool shared_caches;
 /* Activate a secondary processor. */
 void start_secondary(void *unused)
 {
-	unsigned int cpu = smp_processor_id();
+	unsigned int cpu = raw_smp_processor_id();
 	struct cpumask *(*sibling_mask)(int) = cpu_sibling_mask;
 
 	mmgrab(&init_mm);


