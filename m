Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C285DD207
	for <lists+stable@lfdr.de>; Sat, 19 Oct 2019 00:08:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387403AbfJRWHw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 18 Oct 2019 18:07:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:40272 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733298AbfJRWHw (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 18 Oct 2019 18:07:52 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9817C22459;
        Fri, 18 Oct 2019 22:07:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571436471;
        bh=7khnZJWJ7vIgs08vHDk9ylnVLrS98r5d9JQHYR0MKeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VGnJ0p955I0ey2rCZckX4/cpW/h4j/ZjdB7WhC226BvX2wCJopREwWKIXVfKtLsQd
         27u3EYMkBbT9Gl5cOlFqRSZ3YTlhUJA7dPqYJbTipW9IUcAhIxUJJnNIWgCvOKd5zX
         1V3a9/R4wQ5Pal5bYsfzSBOMUYiQ+GLv8uj2A/go=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Petr Mladek <pmladek@suse.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 100/100] tracing: Initialize iter->seq after zeroing in tracing_read_pipe()
Date:   Fri, 18 Oct 2019 18:05:25 -0400
Message-Id: <20191018220525.9042-100-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191018220525.9042-1-sashal@kernel.org>
References: <20191018220525.9042-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Petr Mladek <pmladek@suse.com>

[ Upstream commit d303de1fcf344ff7c15ed64c3f48a991c9958775 ]

A customer reported the following softlockup:

[899688.160002] NMI watchdog: BUG: soft lockup - CPU#0 stuck for 22s! [test.sh:16464]
[899688.160002] CPU: 0 PID: 16464 Comm: test.sh Not tainted 4.12.14-6.23-azure #1 SLE12-SP4
[899688.160002] RIP: 0010:up_write+0x1a/0x30
[899688.160002] Kernel panic - not syncing: softlockup: hung tasks
[899688.160002] RIP: 0010:up_write+0x1a/0x30
[899688.160002] RSP: 0018:ffffa86784d4fde8 EFLAGS: 00000257 ORIG_RAX: ffffffffffffff12
[899688.160002] RAX: ffffffff970fea00 RBX: 0000000000000001 RCX: 0000000000000000
[899688.160002] RDX: ffffffff00000001 RSI: 0000000000000080 RDI: ffffffff970fea00
[899688.160002] RBP: ffffffffffffffff R08: ffffffffffffffff R09: 0000000000000000
[899688.160002] R10: 0000000000000000 R11: 0000000000000000 R12: ffff8b59014720d8
[899688.160002] R13: ffff8b59014720c0 R14: ffff8b5901471090 R15: ffff8b5901470000
[899688.160002]  tracing_read_pipe+0x336/0x3c0
[899688.160002]  __vfs_read+0x26/0x140
[899688.160002]  vfs_read+0x87/0x130
[899688.160002]  SyS_read+0x42/0x90
[899688.160002]  do_syscall_64+0x74/0x160

It caught the process in the middle of trace_access_unlock(). There is
no loop. So, it must be looping in the caller tracing_read_pipe()
via the "waitagain" label.

Crashdump analyze uncovered that iter->seq was completely zeroed
at this point, including iter->seq.seq.size. It means that
print_trace_line() was never able to print anything and
there was no forward progress.

The culprit seems to be in the code:

	/* reset all but tr, trace, and overruns */
	memset(&iter->seq, 0,
	       sizeof(struct trace_iterator) -
	       offsetof(struct trace_iterator, seq));

It was added by the commit 53d0aa773053ab182877 ("ftrace:
add logic to record overruns"). It was v2.6.27-rc1.
It was the time when iter->seq looked like:

     struct trace_seq {
	unsigned char		buffer[PAGE_SIZE];
	unsigned int		len;
     };

There was no "size" variable and zeroing was perfectly fine.

The solution is to reinitialize the structure after or without
zeroing.

Link: http://lkml.kernel.org/r/20191011142134.11997-1-pmladek@suse.com

Signed-off-by: Petr Mladek <pmladek@suse.com>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/trace/trace.c b/kernel/trace/trace.c
index 3b0de19b9ed75..706155ca344b0 100644
--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -5753,6 +5753,7 @@ tracing_read_pipe(struct file *filp, char __user *ubuf,
 	       sizeof(struct trace_iterator) -
 	       offsetof(struct trace_iterator, seq));
 	cpumask_clear(iter->started);
+	trace_seq_init(&iter->seq);
 	iter->pos = -1;
 
 	trace_event_read_lock();
-- 
2.20.1

