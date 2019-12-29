Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EA04212C7DB
	for <lists+stable@lfdr.de>; Sun, 29 Dec 2019 19:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731289AbfL2Rrg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 29 Dec 2019 12:47:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:58238 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731283AbfL2Rre (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 29 Dec 2019 12:47:34 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 03CBD206A4;
        Sun, 29 Dec 2019 17:47:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1577641653;
        bh=qeuZG+/n31WVc1mNt/xqAu0lc909xKlVxXhFOtAYtL4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=h21Zdm+ngeqfhYZzB4WZV97fIVHLEz18D7DYmUmRh5Pv0KO/oBT0IavVz1LOfjRSh
         oOK+xGy3pwc1ZEvley++e8+tHJyoAKDIBrSQWl+p7eqnI4o4Cw1yHhmb84hFzhsRFL
         2p6e3ZBxHga02cUr8sJb7jB0EqTyxhGxue5Ikgjk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 156/434] bpf/stackmap: Fix deadlock with rq_lock in bpf_get_stack()
Date:   Sun, 29 Dec 2019 18:23:29 +0100
Message-Id: <20191229172712.125304914@linuxfoundation.org>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20191229172702.393141737@linuxfoundation.org>
References: <20191229172702.393141737@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit eac9153f2b584c702cea02c1f1a57d85aa9aea42 ]

bpf stackmap with build-id lookup (BPF_F_STACK_BUILD_ID) can trigger A-A
deadlock on rq_lock():

rcu: INFO: rcu_sched detected stalls on CPUs/tasks:
[...]
Call Trace:
 try_to_wake_up+0x1ad/0x590
 wake_up_q+0x54/0x80
 rwsem_wake+0x8a/0xb0
 bpf_get_stack+0x13c/0x150
 bpf_prog_fbdaf42eded9fe46_on_event+0x5e3/0x1000
 bpf_overflow_handler+0x60/0x100
 __perf_event_overflow+0x4f/0xf0
 perf_swevent_overflow+0x99/0xc0
 ___perf_sw_event+0xe7/0x120
 __schedule+0x47d/0x620
 schedule+0x29/0x90
 futex_wait_queue_me+0xb9/0x110
 futex_wait+0x139/0x230
 do_futex+0x2ac/0xa50
 __x64_sys_futex+0x13c/0x180
 do_syscall_64+0x42/0x100
 entry_SYSCALL_64_after_hwframe+0x44/0xa9

This can be reproduced by:
1. Start a multi-thread program that does parallel mmap() and malloc();
2. taskset the program to 2 CPUs;
3. Attach bpf program to trace_sched_switch and gather stackmap with
   build-id, e.g. with trace.py from bcc tools:
   trace.py -U -p <pid> -s <some-bin,some-lib> t:sched:sched_switch

A sample reproducer is attached at the end.

This could also trigger deadlock with other locks that are nested with
rq_lock.

Fix this by checking whether irqs are disabled. Since rq_lock and all
other nested locks are irq safe, it is safe to do up_read() when irqs are
not disable. If the irqs are disabled, postpone up_read() in irq_work.

Fixes: 615755a77b24 ("bpf: extend stackmap to save binary_build_id+offset instead of address")
Signed-off-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20191014171223.357174-1-songliubraving@fb.com

Reproducer:
============================ 8< ============================

char *filename;

void *worker(void *p)
{
        void *ptr;
        int fd;
        char *pptr;

        fd = open(filename, O_RDONLY);
        if (fd < 0)
                return NULL;
        while (1) {
                struct timespec ts = {0, 1000 + rand() % 2000};

                ptr = mmap(NULL, 4096 * 64, PROT_READ, MAP_PRIVATE, fd, 0);
                usleep(1);
                if (ptr == MAP_FAILED) {
                        printf("failed to mmap\n");
                        break;
                }
                munmap(ptr, 4096 * 64);
                usleep(1);
                pptr = malloc(1);
                usleep(1);
                pptr[0] = 1;
                usleep(1);
                free(pptr);
                usleep(1);
                nanosleep(&ts, NULL);
        }
        close(fd);
        return NULL;
}

int main(int argc, char *argv[])
{
        void *ptr;
        int i;
        pthread_t threads[THREAD_COUNT];

        if (argc < 2)
                return 0;

        filename = argv[1];

        for (i = 0; i < THREAD_COUNT; i++) {
                if (pthread_create(threads + i, NULL, worker, NULL)) {
                        fprintf(stderr, "Error creating thread\n");
                        return 0;
                }
        }

        for (i = 0; i < THREAD_COUNT; i++)
                pthread_join(threads[i], NULL);
        return 0;
}
============================ 8< ============================

Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index 052580c33d26..173e983619d7 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -287,7 +287,7 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 	bool irq_work_busy = false;
 	struct stack_map_irq_work *work = NULL;
 
-	if (in_nmi()) {
+	if (irqs_disabled()) {
 		work = this_cpu_ptr(&up_read_work);
 		if (work->irq_work.flags & IRQ_WORK_BUSY)
 			/* cannot queue more up_read, fallback */
@@ -295,8 +295,9 @@ static void stack_map_get_build_id_offset(struct bpf_stack_build_id *id_offs,
 	}
 
 	/*
-	 * We cannot do up_read() in nmi context. To do build_id lookup
-	 * in nmi context, we need to run up_read() in irq_work. We use
+	 * We cannot do up_read() when the irq is disabled, because of
+	 * risk to deadlock with rq_lock. To do build_id lookup when the
+	 * irqs are disabled, we need to run up_read() in irq_work. We use
 	 * a percpu variable to do the irq_work. If the irq_work is
 	 * already used by another lookup, we fall back to report ips.
 	 *
-- 
2.20.1



