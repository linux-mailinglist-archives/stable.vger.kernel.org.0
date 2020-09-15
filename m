Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 34D3226B570
	for <lists+stable@lfdr.de>; Wed, 16 Sep 2020 01:44:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727104AbgIOXnr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 15 Sep 2020 19:43:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:47656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726161AbgIOOd4 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 15 Sep 2020 10:33:56 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E303023C17;
        Tue, 15 Sep 2020 14:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600179918;
        bh=RrlsD9NdrbML6SLa8BP9HqWhrWQm7OexGuvYAJIiDYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y5VHKmoOHW1LvhxMrPsxDBJyyCmIHNpq4nVqsC4Mqt1uwGl3hnMHQaXscyQIWP9VV
         mfg7Hn7wE3zh1p+htSCdhMNNcuEi197rr/oau23bL451Qnzz9gh9cVPNG+Ck0aEIVq
         MvAshTY1BVz9I9T626DYLlgSbv9TFL7++LYz9dSo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f4b9f49e38e25eb4ef52@syzkaller.appspotmail.com,
        Daniel Jordan <daniel.m.jordan@oracle.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        linux-crypto@vger.kernel.org, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.8 037/177] padata: fix possible padata_works_lock deadlock
Date:   Tue, 15 Sep 2020 16:11:48 +0200
Message-Id: <20200915140655.417897354@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200915140653.610388773@linuxfoundation.org>
References: <20200915140653.610388773@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Daniel Jordan <daniel.m.jordan@oracle.com>

[ Upstream commit 1b0df11fde0f14a269a181b3b7f5122415bc5ed7 ]

syzbot reports,

  WARNING: inconsistent lock state
  5.9.0-rc2-syzkaller #0 Not tainted
  --------------------------------
  inconsistent {IN-SOFTIRQ-W} -> {SOFTIRQ-ON-W} usage.
  syz-executor.0/26715 takes:
  (padata_works_lock){+.?.}-{2:2}, at: padata_do_parallel kernel/padata.c:220
  {IN-SOFTIRQ-W} state was registered at:
    spin_lock include/linux/spinlock.h:354 [inline]
    padata_do_parallel kernel/padata.c:220
    ...
    __do_softirq kernel/softirq.c:298
    ...
    sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1091
    asm_sysvec_apic_timer_interrupt arch/x86/include/asm/idtentry.h:581

   Possible unsafe locking scenario:

         CPU0
         ----
    lock(padata_works_lock);
    <Interrupt>
      lock(padata_works_lock);

padata_do_parallel() takes padata_works_lock with softirqs enabled, so a
deadlock is possible if, on the same CPU, the lock is acquired in
process context and then softirq handling done in an interrupt leads to
the same path.

Fix by leaving softirqs disabled while do_parallel holds
padata_works_lock.

Reported-by: syzbot+f4b9f49e38e25eb4ef52@syzkaller.appspotmail.com
Fixes: 4611ce2246889 ("padata: allocate work structures for parallel jobs from a pool")
Signed-off-by: Daniel Jordan <daniel.m.jordan@oracle.com>
Cc: Herbert Xu <herbert@gondor.apana.org.au>
Cc: Steffen Klassert <steffen.klassert@secunet.com>
Cc: linux-crypto@vger.kernel.org
Cc: linux-kernel@vger.kernel.org
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/padata.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/padata.c b/kernel/padata.c
index 4373f7adaa40a..3bc90fec0904c 100644
--- a/kernel/padata.c
+++ b/kernel/padata.c
@@ -215,12 +215,13 @@ int padata_do_parallel(struct padata_shell *ps,
 	padata->pd = pd;
 	padata->cb_cpu = *cb_cpu;
 
-	rcu_read_unlock_bh();
-
 	spin_lock(&padata_works_lock);
 	padata->seq_nr = ++pd->seq_nr;
 	pw = padata_work_alloc();
 	spin_unlock(&padata_works_lock);
+
+	rcu_read_unlock_bh();
+
 	if (pw) {
 		padata_work_init(pw, padata_parallel_worker, padata, 0);
 		queue_work(pinst->parallel_wq, &pw->pw_work);
-- 
2.25.1



