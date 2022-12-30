Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCDFD659A15
	for <lists+stable@lfdr.de>; Fri, 30 Dec 2022 16:41:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229761AbiL3Plm (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 30 Dec 2022 10:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235415AbiL3Pku (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 30 Dec 2022 10:40:50 -0500
Received: from mail-vs1-xe32.google.com (mail-vs1-xe32.google.com [IPv6:2607:f8b0:4864:20::e32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17F326422
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 07:40:49 -0800 (PST)
Received: by mail-vs1-xe32.google.com with SMTP id x65so8087451vsb.13
        for <stable@vger.kernel.org>; Fri, 30 Dec 2022 07:40:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=joelfernandes.org; s=google;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=aIMd1LWhkroXdGwdivEGj9erxBWvA/SmDnMPje3G3Co=;
        b=lgwF6CnkrLtrwV+zjhVSGdlBl468LnfuMr3N/KU/LvEZ8x4RNxsIDvsF9H/QGGwHcL
         DRDiR6esJ6clvzw2JOSaB4TxEJV9cchdk+y8980YRb7CkRCGGlA3pZNyroRlUVnxOCGT
         V3mlwldc+LCyEUXw2bHFib3o3O9PZNDWI/5Gk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=aIMd1LWhkroXdGwdivEGj9erxBWvA/SmDnMPje3G3Co=;
        b=ZBsG/KG6QpO/KE4CQv1qED3XAhmPlLQpPFYIpKfQWQ/WMKHP0HWSgp/+q7w+VD3ppE
         9f8wTXD4Hp/Nwt/XiC6yET0h2Vchi06+PP8zFrtJlTy24p12/brL6vDvc5Oa0O5AO5yh
         m4dXXySzA02tC+QzSfozMt0yQWc7bGvEv/2DpdpfgId2S1UHDmCpzvDJJc1mrUkbRGFS
         /BElDgzsbFeyUS3voUq3ijYB8iIpyP/uY7nW+gOmk5xkuW+MNDqqyDyqBuF52Xz7mckg
         eo3Vn3jg+ma+UsRsYSnN3PkEI4pj9Fywv0bLAKGm3iSqYDt4HVAxnzxAkkM81xgjPGon
         zV4A==
X-Gm-Message-State: AFqh2krKqoZ0JTMIL31rPkgfq3ibxJAIBgCjWOZOLoxkumGf8lQ821eV
        ZL9ETM2UawPkS3WGboMmxA80COVLLKpR5pdSOiA=
X-Google-Smtp-Source: AMrXdXsYNydnUCPoQhwV+uLUBo2IK8+osQMCJ8zPGzqsmkRzEJrQnmDEOEha7/5uiZK0vJtOCZ98Xw==
X-Received: by 2002:a05:6102:41a7:b0:3ca:3e2b:b56f with SMTP id cd39-20020a05610241a700b003ca3e2bb56fmr8685691vsb.4.1672414847476;
        Fri, 30 Dec 2022 07:40:47 -0800 (PST)
Received: from joelboxx.c.googlers.com.com (228.221.150.34.bc.googleusercontent.com. [34.150.221.228])
        by smtp.gmail.com with ESMTPSA id t29-20020a37ea1d000000b006fc40dafaa2sm15182168qkj.8.2022.12.30.07.40.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Dec 2022 07:40:46 -0800 (PST)
From:   "Joel Fernandes (Google)" <joel@joelfernandes.org>
To:     stable@vger.kernel.org
Cc:     "Paul E. McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>, rcu@vger.kernel.org
Subject: [PATCH v5.15] rcu-tasks: Simplify trc_read_check_handler() atomic operations
Date:   Fri, 30 Dec 2022 15:40:09 +0000
Message-Id: <20221230154009.2628728-1-joel@joelfernandes.org>
X-Mailer: git-send-email 2.39.0.314.g84b9a713c41-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Paul E. McKenney" <paulmck@kernel.org>

commit 96017bf9039763a2e02dcc6adaa18592cd73a39d upstream.

Currently, trc_wait_for_one_reader() atomically increments
the trc_n_readers_need_end counter before sending the IPI
invoking trc_read_check_handler().  All failure paths out of
trc_read_check_handler() and also from the smp_call_function_single()
within trc_wait_for_one_reader() must carefully atomically decrement
this counter.  This is more complex than it needs to be.

This commit therefore simplifies things and saves a few lines of
code by dispensing with the atomic decrements in favor of having
trc_read_check_handler() do the atomic increment only in the success case.
In theory, this represents no change in functionality.

Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Cc: <stable@vger.kernel.org> # 5.15.x
Signed-off-by: Joel Fernandes (Google) <joel@joelfernandes.org>
---
I confirmed the patch fixes the following splat which happens twice on TRACE02 rcutorture test:

[  765.941351] WARNING: CPU: 0 PID: 80 at kernel/rcu/tasks.h:895 trc_read_check_handler+0x61/0xe0
[  765.949880] Modules linked in:
[  765.953006] CPU: 0 PID: 80 Comm: rcu_torture_rea Not tainted 5.15.86-rc1+ #25
[  765.959982] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.15.0-1 04/01/2014
[  765.967964] RIP: 0010:trc_read_check_handler+0x61/0xe0
[  765.973050] Code: 01 00 89 c0 48 03 2c c5 80 f8 a5 ae c6 45 00 00 [..]
[  765.991768] RSP: 0000:ffffa64ac0003fb0 EFLAGS: 00010047
[  765.997042] RAX: ffffffffad4f8610 RBX: ffffa26b41bd3000 RCX: ffffa26b5f4ac8c0
[  766.004418] RDX: 0000000000000000 RSI: ffffffffae978121 RDI: ffffa26b41bd3000
[  766.011502] RBP: ffffa26b41bd6000 R08: ffffa26b41bd3000 R09: 0000000000000000
[  766.018778] R10: 0000000000000000 R11: ffffa64ac0003ff8 R12: 0000000000000000
[  766.025943] R13: ffffa26b5f4ac8c0 R14: 0000000000000000 R15: 0000000000000000
[  766.034383] FS:  0000000000000000(0000) GS:ffffa26b5f400000(0000) knlGS:0000000000000000
[  766.042925] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  766.048775] CR2: 0000000000000000 CR3: 0000000001924000 CR4: 00000000000006f0
[  766.055991] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[  766.063135] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
[  766.070711] Call Trace:
[  766.073515]  <IRQ>
[  766.075807]  flush_smp_call_function_queue+0xec/0x1a0
[  766.081087]  __sysvec_call_function_single+0x3e/0x1d0
[  766.086466]  sysvec_call_function_single+0x89/0xc0
[  766.091431]  </IRQ>
[  766.093713]  <TASK>
[  766.095930]  asm_sysvec_call_function_single+0x16/0x20

 kernel/rcu/tasks.h | 20 +++-----------------
 1 file changed, 3 insertions(+), 17 deletions(-)

diff --git a/kernel/rcu/tasks.h b/kernel/rcu/tasks.h
index ae8396032b5d..4bd07cc3c0ea 100644
--- a/kernel/rcu/tasks.h
+++ b/kernel/rcu/tasks.h
@@ -892,32 +892,24 @@ static void trc_read_check_handler(void *t_in)
 
 	// If the task is no longer running on this CPU, leave.
 	if (unlikely(texp != t)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
 		goto reset_ipi; // Already on holdout list, so will check later.
 	}
 
 	// If the task is not in a read-side critical section, and
 	// if this is the last reader, awaken the grace-period kthread.
 	if (likely(!READ_ONCE(t->trc_reader_nesting))) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
-		// Mark as checked after decrement to avoid false
-		// positives on the above WARN_ON_ONCE().
 		WRITE_ONCE(t->trc_reader_checked, true);
 		goto reset_ipi;
 	}
 	// If we are racing with an rcu_read_unlock_trace(), try again later.
-	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0)) {
-		if (WARN_ON_ONCE(atomic_dec_and_test(&trc_n_readers_need_end)))
-			wake_up(&trc_wait);
+	if (unlikely(READ_ONCE(t->trc_reader_nesting) < 0))
 		goto reset_ipi;
-	}
 	WRITE_ONCE(t->trc_reader_checked, true);
 
 	// Get here if the task is in a read-side critical section.  Set
 	// its state so that it will awaken the grace-period kthread upon
 	// exit from that critical section.
+	atomic_inc(&trc_n_readers_need_end); // One more to wait on.
 	WARN_ON_ONCE(READ_ONCE(t->trc_reader_special.b.need_qs));
 	WRITE_ONCE(t->trc_reader_special.b.need_qs, true);
 
@@ -1017,21 +1009,15 @@ static void trc_wait_for_one_reader(struct task_struct *t,
 		if (per_cpu(trc_ipi_to_cpu, cpu) || t->trc_ipi_to_cpu >= 0)
 			return;
 
-		atomic_inc(&trc_n_readers_need_end);
 		per_cpu(trc_ipi_to_cpu, cpu) = true;
 		t->trc_ipi_to_cpu = cpu;
 		rcu_tasks_trace.n_ipis++;
-		if (smp_call_function_single(cpu,
-					     trc_read_check_handler, t, 0)) {
+		if (smp_call_function_single(cpu, trc_read_check_handler, t, 0)) {
 			// Just in case there is some other reason for
 			// failure than the target CPU being offline.
 			rcu_tasks_trace.n_ipis_fails++;
 			per_cpu(trc_ipi_to_cpu, cpu) = false;
 			t->trc_ipi_to_cpu = cpu;
-			if (atomic_dec_and_test(&trc_n_readers_need_end)) {
-				WARN_ON_ONCE(1);
-				wake_up(&trc_wait);
-			}
 		}
 	}
 }
-- 
2.39.0.314.g84b9a713c41-goog

