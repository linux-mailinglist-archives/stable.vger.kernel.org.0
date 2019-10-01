Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1D00CC3DCD
	for <lists+stable@lfdr.de>; Tue,  1 Oct 2019 19:03:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728635AbfJAQj5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 1 Oct 2019 12:39:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:51040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728595AbfJAQjz (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 1 Oct 2019 12:39:55 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2E17921920;
        Tue,  1 Oct 2019 16:39:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569947995;
        bh=NuHhHXw4QZBdglT0kxOOBHpNOn1XLOOMc9cyecLOYBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KFlQ0fe81+Fa8eDae6cTPtZ3TXN5IjIKlTipmtZAqLD+ceBYENQDxSciZyd5oGIOX
         5/Pb1J/P/aUugBkn7YY4bW9BFN82ZHf1le/1UJnt5sgoqGcV/Y9SreEB2CZdklgqfY
         7wFGsz9wZ/WdY3iDf1E6R07C7V5xht0A8GMeueIc=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.3 21/71] perf probe: Fix to clear tev->nargs in clear_probe_trace_event()
Date:   Tue,  1 Oct 2019 12:38:31 -0400
Message-Id: <20191001163922.14735-21-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191001163922.14735-1-sashal@kernel.org>
References: <20191001163922.14735-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit 9e6124d9d635957b56717f85219a88701617253f ]

Since add_probe_trace_event() can reuse tf->tevs[i] after calling
clear_probe_trace_event(), this can make perf-probe crash if the 1st
attempt of probe event finding fails to find an event argument, and the
2nd attempt fails to find probe point.

E.g.
  $ perf probe -D "task_pid_nr tsk"
  Failed to find 'tsk' in this function.
  Failed to get entry address of warn_bad_vsyscall
  Segmentation fault (core dumped)

Committer testing:

After the patch:

  $ perf probe -D "task_pid_nr tsk"
  Failed to find 'tsk' in this function.
  Failed to get entry address of warn_bad_vsyscall
  Failed to get entry address of signal_fault
  Failed to get entry address of show_signal
  Failed to get entry address of umip_printk
  Failed to get entry address of __bad_area_nosemaphore
  <SNIP>
  Failed to get entry address of sock_set_timeout
  Failed to get entry address of tcp_recvmsg
  Probe point 'task_pid_nr' not found.
    Error: Failed to add events.
  $

Fixes: 092b1f0b5f9f ("perf probe: Clear probe_trace_event when add_probe_trace_event() fails")
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Wang Nan <wangnan0@huawei.com>
Link: http://lore.kernel.org/lkml/156856587999.25775.5145779959474477595.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-event.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 8394d48f8b32e..3355c445abedf 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -2329,6 +2329,7 @@ void clear_probe_trace_event(struct probe_trace_event *tev)
 		}
 	}
 	zfree(&tev->args);
+	tev->nargs = 0;
 }
 
 struct kprobe_blacklist_node {
-- 
2.20.1

