Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 012202692D3
	for <lists+stable@lfdr.de>; Mon, 14 Sep 2020 19:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726361AbgINRQn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 14 Sep 2020 13:16:43 -0400
Received: from Galois.linutronix.de ([193.142.43.55]:34800 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726269AbgINRQZ (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 14 Sep 2020 13:16:25 -0400
Date:   Mon, 14 Sep 2020 17:16:12 -0000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1600103773;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fLSnEgwh8ujg7fMrevLvBVnoQboiRoJVpphwkpSLwRA=;
        b=gnt3Uw/PnJ1o6+nxEJqPT51LubGOhzH+U8/jVgv8Be6UEymN3eiBy5+3uuZ4TcD/NzFV6g
        WLgDdSXLlhC/vVA0vtAujPWUCEW0rezNBF6eQcHtHUD48JL02qZHFdtGeLT8YLShYQcO1n
        IN6MpntSGcMSg4Sh8b96hnBV6rF5Uxvpw+haxTuumgXAEt8RotcOFRAhhIBW9+GfIpWtzM
        0mZ9q9+51hmmfzi+PrMNNRnQ2hS9HYbrmB+NkC7E3aXTeZyTCT4nYFRjhC69625jRmleGe
        zUwnwWFh/yRnoLIYU8FfWQ/vG6VXKh1ZkHPvvHKruS2CgWI78kGNgtD9OjwGww==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1600103773;
        h=from:from:sender:sender:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fLSnEgwh8ujg7fMrevLvBVnoQboiRoJVpphwkpSLwRA=;
        b=0376xdLIFdOkV3n23pHqNypL+On0ZO9B0iO+VVBXNSP0ilEt9ycCFYSv+X9/SQzaysQ9yR
        fNvw/d//VTtsefCQ==
From:   "tip-bot2 for Masami Hiramatsu" <tip-bot2@linutronix.de>
Reply-to: linux-kernel@vger.kernel.org
To:     linux-tip-commits@vger.kernel.org
Subject: [tip: perf/kprobes] kprobes: Fix to check probe enabled before
 disarm_kprobe_ftrace()
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org,
        x86 <x86@kernel.org>, LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <159888672694.1411785.5987998076694782591.stgit@devnote2>
References: <159888672694.1411785.5987998076694782591.stgit@devnote2>
MIME-Version: 1.0
Message-ID: <160010377221.15536.8797457304463305492.tip-bot2@tip-bot2>
Robot-ID: <tip-bot2.linutronix.de>
Robot-Unsubscribe: Contact <mailto:tglx@linutronix.de> to get blacklisted from these emails
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

The following commit has been merged into the perf/kprobes branch of tip:

Commit-ID:     bcb53209be5cb32d485507452edda19b78f31d84
Gitweb:        https://git.kernel.org/tip/bcb53209be5cb32d485507452edda19b78f31d84
Author:        Masami Hiramatsu <mhiramat@kernel.org>
AuthorDate:    Tue, 01 Sep 2020 00:12:07 +09:00
Committer:     Ingo Molnar <mingo@kernel.org>
CommitterDate: Mon, 14 Sep 2020 11:20:03 +02:00

kprobes: Fix to check probe enabled before disarm_kprobe_ftrace()

Commit:

  0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")

fixed one bug but the underlying bugs are not completely fixed yet.

If we run a kprobe_module.tc of ftracetest, a warning triggers:

  # ./ftracetest test.d/kprobe/kprobe_module.tc
  === Ftrace unit tests ===
  [1] Kprobe dynamic event - probing module
  ...
   ------------[ cut here ]------------
   Failed to disarm kprobe-ftrace at trace_printk_irq_work+0x0/0x7e [trace_printk] (-2)
   WARNING: CPU: 7 PID: 200 at kernel/kprobes.c:1091 __disarm_kprobe_ftrace.isra.0+0x7e/0xa0

This is because the kill_kprobe() calls disarm_kprobe_ftrace() even
if the given probe is not enabled. In that case, ftrace_set_filter_ip()
fails because the given probe point is not registered to ftrace.

Fix to check the given (going) probe is enabled before invoking
disarm_kprobe_ftrace().

Fixes: 0cb2f1372baa ("kprobes: Fix NULL pointer dereference at kprobe_ftrace_handler")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/159888672694.1411785.5987998076694782591.stgit@devnote2
---
 kernel/kprobes.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/kernel/kprobes.c b/kernel/kprobes.c
index 732a701..3b61ae8 100644
--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -2235,9 +2235,10 @@ static void kill_kprobe(struct kprobe *p)
 
 	/*
 	 * The module is going away. We should disarm the kprobe which
-	 * is using ftrace.
+	 * is using ftrace, because ftrace framework is still available at
+	 * MODULE_STATE_GOING notification.
 	 */
-	if (kprobe_ftrace(p))
+	if (kprobe_ftrace(p) && !kprobe_disabled(p) && !kprobes_all_disarmed)
 		disarm_kprobe_ftrace(p);
 }
 
