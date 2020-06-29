Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39FC320E804
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:12:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726288AbgF2SfX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 14:35:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:56892 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726175AbgF2SfW (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 14:35:22 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 16422247C9;
        Mon, 29 Jun 2020 15:22:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593444135;
        bh=+BScHcEoWoNxBeKrIFUTdorvUOhsOsh1PWnSVcUlz+c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=C7ZZEU5o/tSeT1CJRSnZB4t4L2xwXudOXzi6nGDqaHhfiGax9+j92QEpq9pg9pXib
         /FesMi5G1tSLGrCgPs4GY+LSFWbt+ZJD1LLOVN7jSe+pS0sKIh8ZpLpJFH4/M0I+MI
         Nulj7Z+FEOpX0NpN3kipMPcrcJUFKbtIa31S5bDM=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>,
        linux-kernel@i4.cs.fau.de,
        Maximilian Werner <maximilian.werner96@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 5.7 241/265] tracing/boottime: Fix kprobe multiple events
Date:   Mon, 29 Jun 2020 11:17:54 -0400
Message-Id: <20200629151818.2493727-242-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629151818.2493727-1-sashal@kernel.org>
References: <20200629151818.2493727-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.7.7-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-5.7.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 5.7.7-rc1
X-KernelTest-Deadline: 2020-07-01T15:14+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>

commit 20dc3847cc2fc886ee4eb9112e6e2fad9419b0c7 upstream.

Fix boottime kprobe events to report and abort after each failure when
adding probes.

As an example, when we try to set multiprobe kprobe events in
bootconfig like this:

ftrace.event.kprobes.vfsevents {
        probes = "vfs_read $arg1 $arg2,,
                 !error! not reported;?", // leads to error
                 "vfs_write $arg1 $arg2"
}

This will not work as expected. After
commit da0f1f4167e3af69e ("tracing/boottime: Fix kprobe event API usage"),
the function trace_boot_add_kprobe_event will not produce any error
message when adding a probe fails at kprobe_event_gen_cmd_start.
Furthermore, we continue to add probes when kprobe_event_gen_cmd_end fails
(and kprobe_event_gen_cmd_start did not fail). In this case the function
even returns successfully when the last call to kprobe_event_gen_cmd_end
is successful.

The behaviour of reporting and aborting after failures is not
consistent.

The function trace_boot_add_kprobe_event now reports each failure and
stops adding probes immediately.

Link: https://lkml.kernel.org/r/20200618163301.25854-1-sascha.ortmann@stud.uni-hannover.de

Cc: stable@vger.kernel.org
Cc: linux-kernel@i4.cs.fau.de
Co-developed-by: Maximilian Werner <maximilian.werner96@gmail.com>
Fixes: da0f1f4167e3 ("tracing/boottime: Fix kprobe event API usage")
Acked-by: Masami Hiramatsu <mhiramat@kernel.org>
Signed-off-by: Maximilian Werner <maximilian.werner96@gmail.com>
Signed-off-by: Sascha Ortmann <sascha.ortmann@stud.uni-hannover.de>
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_boot.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_boot.c b/kernel/trace/trace_boot.c
index 9de29bb45a27f..fdc5abc00bf84 100644
--- a/kernel/trace/trace_boot.c
+++ b/kernel/trace/trace_boot.c
@@ -101,12 +101,16 @@ trace_boot_add_kprobe_event(struct xbc_node *node, const char *event)
 		kprobe_event_cmd_init(&cmd, buf, MAX_BUF_LEN);
 
 		ret = kprobe_event_gen_cmd_start(&cmd, event, val);
-		if (ret)
+		if (ret) {
+			pr_err("Failed to generate probe: %s\n", buf);
 			break;
+		}
 
 		ret = kprobe_event_gen_cmd_end(&cmd);
-		if (ret)
+		if (ret) {
 			pr_err("Failed to add probe: %s\n", buf);
+			break;
+		}
 	}
 
 	return ret;
-- 
2.25.1

