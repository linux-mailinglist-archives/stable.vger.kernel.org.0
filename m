Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76A63E5ADA
	for <lists+stable@lfdr.de>; Sat, 26 Oct 2019 15:18:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727846AbfJZNSb (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sat, 26 Oct 2019 09:18:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:40238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727838AbfJZNSa (ORCPT <rfc822;stable@vger.kernel.org>);
        Sat, 26 Oct 2019 09:18:30 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id AF29A214DA;
        Sat, 26 Oct 2019 13:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572095909;
        bh=TJk2tjIKr4Qqm72MXMCqDsEKOT5bNxsmulkSYmv9kmo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=E48f+eA3ADFoU60RTj9uwvKdzIVjFzDyul9QidPAxcyP5Oa4H2e8NqAF6sXuwYFaf
         o0cFxQdTND14/njSmFQRg0uJKFXlLMGscnc5Uc824ot2e98TtfzCcBW/2u0jGu6uM0
         fEKgD9jDntFRTsvgIa97UjM6+8hJaejCL0HIXM5s=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Marco Elver <elver@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 83/99] stop_machine: Avoid potential race behaviour
Date:   Sat, 26 Oct 2019 09:15:44 -0400
Message-Id: <20191026131600.2507-83-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191026131600.2507-1-sashal@kernel.org>
References: <20191026131600.2507-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Mark Rutland <mark.rutland@arm.com>

[ Upstream commit b1fc5833357524d5d342737913dbe32ff3557bc5 ]

Both multi_cpu_stop() and set_state() access multi_stop_data::state
racily using plain accesses. These are subject to compiler
transformations which could break the intended behaviour of the code,
and this situation is detected by KCSAN on both arm64 and x86 (splats
below).

Improve matters by using READ_ONCE() and WRITE_ONCE() to ensure that the
compiler cannot elide, replay, or tear loads and stores.

In multi_cpu_stop() the two loads of multi_stop_data::state are expected to
be a consistent value, so snapshot the value into a temporary variable to
ensure this.

The state transitions are serialized by atomic manipulation of
multi_stop_data::num_threads, and other fields in multi_stop_data are not
modified while subject to concurrent reads.

KCSAN splat on arm64:

| BUG: KCSAN: data-race in multi_cpu_stop+0xa8/0x198 and set_state+0x80/0xb0
|
| write to 0xffff00001003bd00 of 4 bytes by task 24 on cpu 3:
|  set_state+0x80/0xb0
|  multi_cpu_stop+0x16c/0x198
|  cpu_stopper_thread+0x170/0x298
|  smpboot_thread_fn+0x40c/0x560
|  kthread+0x1a8/0x1b0
|  ret_from_fork+0x10/0x18
|
| read to 0xffff00001003bd00 of 4 bytes by task 14 on cpu 1:
|  multi_cpu_stop+0xa8/0x198
|  cpu_stopper_thread+0x170/0x298
|  smpboot_thread_fn+0x40c/0x560
|  kthread+0x1a8/0x1b0
|  ret_from_fork+0x10/0x18
|
| Reported by Kernel Concurrency Sanitizer on:
| CPU: 1 PID: 14 Comm: migration/1 Not tainted 5.3.0-00007-g67ab35a199f4-dirty #3
| Hardware name: linux,dummy-virt (DT)

KCSAN splat on x86:

| write to 0xffffb0bac0013e18 of 4 bytes by task 19 on cpu 2:
|  set_state kernel/stop_machine.c:170 [inline]
|  ack_state kernel/stop_machine.c:177 [inline]
|  multi_cpu_stop+0x1a4/0x220 kernel/stop_machine.c:227
|  cpu_stopper_thread+0x19e/0x280 kernel/stop_machine.c:516
|  smpboot_thread_fn+0x1a8/0x300 kernel/smpboot.c:165
|  kthread+0x1b5/0x200 kernel/kthread.c:255
|  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:352
|
| read to 0xffffb0bac0013e18 of 4 bytes by task 44 on cpu 7:
|  multi_cpu_stop+0xb4/0x220 kernel/stop_machine.c:213
|  cpu_stopper_thread+0x19e/0x280 kernel/stop_machine.c:516
|  smpboot_thread_fn+0x1a8/0x300 kernel/smpboot.c:165
|  kthread+0x1b5/0x200 kernel/kthread.c:255
|  ret_from_fork+0x35/0x40 arch/x86/entry/entry_64.S:352
|
| Reported by Kernel Concurrency Sanitizer on:
| CPU: 7 PID: 44 Comm: migration/7 Not tainted 5.3.0+ #1
| Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.12.0-1 04/01/2014

Signed-off-by: Mark Rutland <mark.rutland@arm.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Acked-by: Marco Elver <elver@google.com>
Link: https://lkml.kernel.org/r/20191007104536.27276-1-mark.rutland@arm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/stop_machine.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/kernel/stop_machine.c b/kernel/stop_machine.c
index b4f83f7bdf86c..a84d98dec504a 100644
--- a/kernel/stop_machine.c
+++ b/kernel/stop_machine.c
@@ -7,6 +7,7 @@
  * Copyright (C) 2010		SUSE Linux Products GmbH
  * Copyright (C) 2010		Tejun Heo <tj@kernel.org>
  */
+#include <linux/compiler.h>
 #include <linux/completion.h>
 #include <linux/cpu.h>
 #include <linux/init.h>
@@ -167,7 +168,7 @@ static void set_state(struct multi_stop_data *msdata,
 	/* Reset ack counter. */
 	atomic_set(&msdata->thread_ack, msdata->num_threads);
 	smp_wmb();
-	msdata->state = newstate;
+	WRITE_ONCE(msdata->state, newstate);
 }
 
 /* Last one to ack a state moves to the next state. */
@@ -186,7 +187,7 @@ void __weak stop_machine_yield(const struct cpumask *cpumask)
 static int multi_cpu_stop(void *data)
 {
 	struct multi_stop_data *msdata = data;
-	enum multi_stop_state curstate = MULTI_STOP_NONE;
+	enum multi_stop_state newstate, curstate = MULTI_STOP_NONE;
 	int cpu = smp_processor_id(), err = 0;
 	const struct cpumask *cpumask;
 	unsigned long flags;
@@ -210,8 +211,9 @@ static int multi_cpu_stop(void *data)
 	do {
 		/* Chill out and ensure we re-read multi_stop_state. */
 		stop_machine_yield(cpumask);
-		if (msdata->state != curstate) {
-			curstate = msdata->state;
+		newstate = READ_ONCE(msdata->state);
+		if (newstate != curstate) {
+			curstate = newstate;
 			switch (curstate) {
 			case MULTI_STOP_DISABLE_IRQ:
 				local_irq_disable();
-- 
2.20.1

