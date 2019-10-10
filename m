Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E77EBD258A
	for <lists+stable@lfdr.de>; Thu, 10 Oct 2019 11:02:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387801AbfJJImP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 10 Oct 2019 04:42:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:46780 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388505AbfJJImO (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 10 Oct 2019 04:42:14 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5564921A4C;
        Thu, 10 Oct 2019 08:42:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1570696933;
        bh=NuHhHXw4QZBdglT0kxOOBHpNOn1XLOOMc9cyecLOYBc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VXmdMV5T0Blg5SknT5F4OCZkGgelj1rw0yKIcvs1uExynIJmYuh2bHAElvy9sLAjq
         PG0whQ2LKffoa9Ri4IaeEdKNNbHlQwA9ZISjGTDMOi495Fj0r33h8dXVy7OUCH6tRj
         qCPB+DyJ1EKt91gBFVnt/8fd5ddPYAQZwjeZ3ZTk=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Masami Hiramatsu <mhiramat@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Wang Nan <wangnan0@huawei.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.3 106/148] perf probe: Fix to clear tev->nargs in clear_probe_trace_event()
Date:   Thu, 10 Oct 2019 10:36:07 +0200
Message-Id: <20191010083617.608325655@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20191010083609.660878383@linuxfoundation.org>
References: <20191010083609.660878383@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
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



