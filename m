Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69106E67D9
	for <lists+stable@lfdr.de>; Sun, 27 Oct 2019 22:25:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732632AbfJ0VY7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 27 Oct 2019 17:24:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:46666 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732607AbfJ0VY6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 27 Oct 2019 17:24:58 -0400
Received: from localhost (100.50.158.77.rev.sfr.net [77.158.50.100])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 488F021850;
        Sun, 27 Oct 2019 21:24:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572211497;
        bh=VjuvPT47fQEVdtE0EJLHgkIrVxCYhOshqwCqj7yCM9I=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gfjx65duw0gpVfXk25IoyV516C5qgn4fmjWcriISI8fx8WLpEpIAFOk2+BC4o++3u
         4X7FQI+Ta6346h3sg/gWub2X+awM/Ip5Vc87xKrAN4eyS8Sh59enVwEHR3vn83oYsf
         zpmRGDY4OMeNaHLTN0+qOLniGo5zQDtHvCZRhc4s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Song Liu <songliubraving@fb.com>,
        Prateek Sood <prsood@codeaurora.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>
Subject: [PATCH 5.3 171/197] tracing: Fix race in perf_trace_buf initialization
Date:   Sun, 27 Oct 2019 22:01:29 +0100
Message-Id: <20191027203403.951943623@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191027203351.684916567@linuxfoundation.org>
References: <20191027203351.684916567@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Prateek Sood <prsood@codeaurora.org>

commit 6b1340cc00edeadd52ebd8a45171f38c8de2a387 upstream.

A race condition exists while initialiazing perf_trace_buf from
perf_trace_init() and perf_kprobe_init().

      CPU0                                        CPU1
perf_trace_init()
  mutex_lock(&event_mutex)
    perf_trace_event_init()
      perf_trace_event_reg()
        total_ref_count == 0
	buf = alloc_percpu()
        perf_trace_buf[i] = buf
        tp_event->class->reg() //fails       perf_kprobe_init()
	goto fail                              perf_trace_event_init()
                                                 perf_trace_event_reg()
        fail:
	  total_ref_count == 0

                                                   total_ref_count == 0
                                                   buf = alloc_percpu()
                                                   perf_trace_buf[i] = buf
                                                   tp_event->class->reg()
                                                   total_ref_count++

          free_percpu(perf_trace_buf[i])
          perf_trace_buf[i] = NULL

Any subsequent call to perf_trace_event_reg() will observe total_ref_count > 0,
causing the perf_trace_buf to be always NULL. This can result in perf_trace_buf
getting accessed from perf_trace_buf_alloc() without being initialized. Acquiring
event_mutex in perf_kprobe_init() before calling perf_trace_event_init() should
fix this race.

The race caused the following bug:

 Unable to handle kernel paging request at virtual address 0000003106f2003c
 Mem abort info:
   ESR = 0x96000045
   Exception class = DABT (current EL), IL = 32 bits
   SET = 0, FnV = 0
   EA = 0, S1PTW = 0
 Data abort info:
   ISV = 0, ISS = 0x00000045
   CM = 0, WnR = 1
 user pgtable: 4k pages, 39-bit VAs, pgdp = ffffffc034b9b000
 [0000003106f2003c] pgd=0000000000000000, pud=0000000000000000
 Internal error: Oops: 96000045 [#1] PREEMPT SMP
 Process syz-executor (pid: 18393, stack limit = 0xffffffc093190000)
 pstate: 80400005 (Nzcv daif +PAN -UAO)
 pc : __memset+0x20/0x1ac
 lr : memset+0x3c/0x50
 sp : ffffffc09319fc50

  __memset+0x20/0x1ac
  perf_trace_buf_alloc+0x140/0x1a0
  perf_trace_sys_enter+0x158/0x310
  syscall_trace_enter+0x348/0x7c0
  el0_svc_common+0x11c/0x368
  el0_svc_handler+0x12c/0x198
  el0_svc+0x8/0xc

Ramdumps showed the following:
  total_ref_count = 3
  perf_trace_buf = (
      0x0 -> NULL,
      0x0 -> NULL,
      0x0 -> NULL,
      0x0 -> NULL)

Link: http://lkml.kernel.org/r/1571120245-4186-1-git-send-email-prsood@codeaurora.org

Cc: stable@vger.kernel.org
Fixes: e12f03d7031a9 ("perf/core: Implement the 'perf_kprobe' PMU")
Acked-by: Song Liu <songliubraving@fb.com>
Signed-off-by: Prateek Sood <prsood@codeaurora.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 kernel/trace/trace_event_perf.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -272,9 +272,11 @@ int perf_kprobe_init(struct perf_event *
 		goto out;
 	}
 
+	mutex_lock(&event_mutex);
 	ret = perf_trace_event_init(tp_event, p_event);
 	if (ret)
 		destroy_local_trace_kprobe(tp_event);
+	mutex_unlock(&event_mutex);
 out:
 	kfree(func);
 	return ret;
@@ -282,8 +284,10 @@ out:
 
 void perf_kprobe_destroy(struct perf_event *p_event)
 {
+	mutex_lock(&event_mutex);
 	perf_trace_event_close(p_event);
 	perf_trace_event_unreg(p_event);
+	mutex_unlock(&event_mutex);
 
 	destroy_local_trace_kprobe(p_event->tp_event);
 }


