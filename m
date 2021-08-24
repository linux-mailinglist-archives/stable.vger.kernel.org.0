Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6C33D3F66BA
	for <lists+stable@lfdr.de>; Tue, 24 Aug 2021 19:26:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240602AbhHXR1D (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 24 Aug 2021 13:27:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:60110 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S241610AbhHXRZD (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 24 Aug 2021 13:25:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D4B3761B3A;
        Tue, 24 Aug 2021 17:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629824641;
        bh=FngWxRSGABYeqvIxTKMML72BSaPPtax2RhsjJFX5i6M=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FDRcXuxrJScac1RuqTdxusmyDBROOUWBCzEjJwjO00Ry9ZfcgCRffKkXQxL6uUrju
         R9W1ozEEH32D1Deh9Mcs2faDy3M6M+EMbR4go9GgBsXnRRK8s3eMp6qkHXx6twJJhi
         RmGNoGmfHSXsKqOee9dHCYem+gfXCM7aFqbUEGov9b1aPeGFhVhLCh31j5J3sUjT8l
         iGTT8x6qmsfAOooU7pGTt7eY+B55WjEqzLB4MkdiTc8RPc/di79qaqs9MJj3vkJG9b
         UPs3j2QdbwHXOWkp3NJ7oXVvaa/Pyj8dcogA45Zqvls95DzWlp9WbaGwPtbgr1hqpQ
         ASX4wp7km3bNQ==
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     "Steven Rostedt (VMware)" <rostedt@goodmis.org>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Tom Zanussi <zanussi@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 72/84] tracing / histogram: Fix NULL pointer dereference on strcmp() on NULL event name
Date:   Tue, 24 Aug 2021 13:02:38 -0400
Message-Id: <20210824170250.710392-73-sashal@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210824170250.710392-1-sashal@kernel.org>
References: <20210824170250.710392-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.19.205-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.19.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.19.205-rc1
X-KernelTest-Deadline: 2021-08-26T17:02+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: "Steven Rostedt (VMware)" <rostedt@goodmis.org>

[ Upstream commit 5acce0bff2a0420ce87d4591daeb867f47d552c2 ]

The following commands:

 # echo 'read_max u64 size;' > synthetic_events
 # echo 'hist:keys=common_pid:count=count:onmax($count).trace(read_max,count)' > events/syscalls/sys_enter_read/trigger

Causes:

 BUG: kernel NULL pointer dereference, address: 0000000000000000
 #PF: supervisor read access in kernel mode
 #PF: error_code(0x0000) - not-present page
 PGD 0 P4D 0
 Oops: 0000 [#1] PREEMPT SMP
 CPU: 4 PID: 1763 Comm: bash Not tainted 5.14.0-rc2-test+ #155
 Hardware name: Hewlett-Packard HP Compaq Pro 6300 SFF/339A, BIOS K01
v03.03 07/14/2016
 RIP: 0010:strcmp+0xc/0x20
 Code: 75 f7 31 c0 0f b6 0c 06 88 0c 02 48 83 c0 01 84 c9 75 f1 4c 89 c0
c3 0f 1f 80 00 00 00 00 31 c0 eb 08 48 83 c0 01 84 d2 74 0f <0f> b6 14 07
3a 14 06 74 ef 19 c0 83 c8 01 c3 31 c0 c3 66 90 48 89
 RSP: 0018:ffffb5fdc0963ca8 EFLAGS: 00010246
 RAX: 0000000000000000 RBX: ffffffffb3a4e040 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: ffff9714c0d0b640 RDI: 0000000000000000
 RBP: 0000000000000000 R08: 00000022986b7cde R09: ffffffffb3a4dff8
 R10: 0000000000000000 R11: 0000000000000000 R12: ffff9714c50603c8
 R13: 0000000000000000 R14: ffff97143fdf9e48 R15: ffff9714c01a2210
 FS:  00007f1fa6785740(0000) GS:ffff9714da400000(0000)
knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000000000000000 CR3: 000000002d863004 CR4: 00000000001706e0
 Call Trace:
  __find_event_file+0x4e/0x80
  action_create+0x6b7/0xeb0
  ? kstrdup+0x44/0x60
  event_hist_trigger_func+0x1a07/0x2130
  trigger_process_regex+0xbd/0x110
  event_trigger_write+0x71/0xd0
  vfs_write+0xe9/0x310
  ksys_write+0x68/0xe0
  do_syscall_64+0x3b/0x90
  entry_SYSCALL_64_after_hwframe+0x44/0xae
 RIP: 0033:0x7f1fa6879e87

The problem was the "trace(read_max,count)" where the "count" should be
"$count" as "onmax()" only handles variables (although it really should be
able to figure out that "count" is a field of sys_enter_read). But there's
a path that does not find the variable and ends up passing a NULL for the
event, which ends up getting passed to "strcmp()".

Add a check for NULL to return and error on the command with:

 # cat error_log
  hist:syscalls:sys_enter_read: error: Couldn't create or find variable
  Command: hist:keys=common_pid:count=count:onmax($count).trace(read_max,count)
                                ^
Link: https://lkml.kernel.org/r/20210808003011.4037f8d0@oasis.local.home

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Fixes: 50450603ec9cb tracing: Add 'onmax' hist trigger action support
Reviewed-by: Tom Zanussi <zanussi@kernel.org>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index bbde8d3d6c8a..44d1340634f6 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -3786,6 +3786,8 @@ onmatch_create_field_var(struct hist_trigger_data *hist_data,
 			event = data->onmatch.match_event;
 		}
 
+		if (!event)
+			goto free;
 		/*
 		 * At this point, we're looking at a field on another
 		 * event.  Because we can't modify a hist trigger on
-- 
2.30.2

