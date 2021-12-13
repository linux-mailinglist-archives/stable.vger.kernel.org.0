Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0334C472948
	for <lists+stable@lfdr.de>; Mon, 13 Dec 2021 11:20:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237799AbhLMKTZ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Dec 2021 05:19:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243286AbhLMKMq (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Dec 2021 05:12:46 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B95EC001629;
        Mon, 13 Dec 2021 01:54:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC537CE0B59;
        Mon, 13 Dec 2021 09:54:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F3CCC34601;
        Mon, 13 Dec 2021 09:54:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639389258;
        bh=rsTeZMk7O/u8nSH8mgVqInhb4PGf6dAuTmB3GF4JZNc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=v6M0oFa3oYVDn3VvUYsl6TYkwqHrUk2MDT9aZDfYQwZImC/Tow+XJF5maXCAo6Tvp
         00qAeJ0ioE2jyypqxABuXm/tqBcfzqND1qKTzA1lrk4fL1sTihValqmI02pLDZIZEo
         p3vZdiOLutGeQKS49S8sP89zYbRNbkvshOSKCmlk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Daniel Borkmann <daniel@iogearbox.net>
Subject: [PATCH 5.15 038/171] bpf: Make sure bpf_disable_instrumentation() is safe vs preemption.
Date:   Mon, 13 Dec 2021 10:29:13 +0100
Message-Id: <20211213092946.341901910@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211213092945.091487407@linuxfoundation.org>
References: <20211213092945.091487407@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

commit 79364031c5b4365ca28ac0fa00acfab5bf465be1 upstream.

The initial implementation of migrate_disable() for mainline was a
wrapper around preempt_disable(). RT kernels substituted this with a
real migrate disable implementation.

Later on mainline gained true migrate disable support, but neither
documentation nor affected code were updated.

Remove stale comments claiming that migrate_disable() is PREEMPT_RT only.

Don't use __this_cpu_inc() in the !PREEMPT_RT path because preemption is
not disabled and the RMW operation can be preempted.

Fixes: 74d862b682f51 ("sched: Make migrate_disable/enable() independent of RT")
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211127163200.10466-3-bigeasy@linutronix.de
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h    |   16 ++--------------
 include/linux/filter.h |    3 ---
 2 files changed, 2 insertions(+), 17 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1321,28 +1321,16 @@ extern struct mutex bpf_stats_enabled_mu
  * kprobes, tracepoints) to prevent deadlocks on map operations as any of
  * these events can happen inside a region which holds a map bucket lock
  * and can deadlock on it.
- *
- * Use the preemption safe inc/dec variants on RT because migrate disable
- * is preemptible on RT and preemption in the middle of the RMW operation
- * might lead to inconsistent state. Use the raw variants for non RT
- * kernels as migrate_disable() maps to preempt_disable() so the slightly
- * more expensive save operation can be avoided.
  */
 static inline void bpf_disable_instrumentation(void)
 {
 	migrate_disable();
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		this_cpu_inc(bpf_prog_active);
-	else
-		__this_cpu_inc(bpf_prog_active);
+	this_cpu_inc(bpf_prog_active);
 }
 
 static inline void bpf_enable_instrumentation(void)
 {
-	if (IS_ENABLED(CONFIG_PREEMPT_RT))
-		this_cpu_dec(bpf_prog_active);
-	else
-		__this_cpu_dec(bpf_prog_active);
+	this_cpu_dec(bpf_prog_active);
 	migrate_enable();
 }
 
--- a/include/linux/filter.h
+++ b/include/linux/filter.h
@@ -639,9 +639,6 @@ static __always_inline u32 bpf_prog_run(
  * This uses migrate_disable/enable() explicitly to document that the
  * invocation of a BPF program does not require reentrancy protection
  * against a BPF program which is invoked from a preempting task.
- *
- * For non RT enabled kernels migrate_disable/enable() maps to
- * preempt_disable/enable(), i.e. it disables also preemption.
  */
 static inline u32 bpf_prog_run_pin_on_cpu(const struct bpf_prog *prog,
 					  const void *ctx)


