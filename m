Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5173017323D
	for <lists+stable@lfdr.de>; Fri, 28 Feb 2020 08:57:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726738AbgB1H5t (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 28 Feb 2020 02:57:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:49102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbgB1H5t (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 28 Feb 2020 02:57:49 -0500
Received: from localhost.localdomain (NE2965lan1.rev.em-net.ne.jp [210.141.244.193])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DF0C42467B;
        Fri, 28 Feb 2020 07:57:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582876668;
        bh=447A/1eVEf79zNA/V+pehDVUNQ6KKCGcSrLGSGA9AoU=;
        h=From:To:Cc:Subject:Date:From;
        b=RHtiadStP1W/S2hSUdKQj7XDq8rPJB682X4hV10pvYXtL9ykALtdjIWUE67xUbHWJ
         MczoDw0POlqK2SDp7oQ9vJqEnFLuOfsDH/szjaSIjWgOwrKkzbdppsIm6ngOTJWRul
         lJf/O15F8ZDHfdcjUGoBwDXTKQnyKd5OB0YCSC2c=
From:   Masami Hiramatsu <mhiramat@kernel.org>
To:     Arnaldo Carvalho de Melo <acme@kernel.org>
Cc:     Masami Hiramatsu <mhiramat@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        He Zhe <zhe.he@windriver.com>, stable@vger.kernel.org
Subject: [PATCH v2] perf probe: Fix to delete multiple probe event
Date:   Fri, 28 Feb 2020 16:57:42 +0900
Message-Id: <158287666197.16697.7514373548551863562.stgit@devnote2>
X-Mailer: git-send-email 2.20.1
User-Agent: StGit/0.17.1-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Fix to delete multiple probe event with filter correctly.

When we put an event with multiple probes, perf-probe fails
to delete with filters. This comes from a failure to list
up the event name because of overwrapping its name.

To fix this issue, skip to list up the event which has
same name.

Without this patch:
  # perf probe -l \*
    probe_perf:map__map_ip (on perf_sample__fprintf_brstackoff:21@
    probe_perf:map__map_ip (on perf_sample__fprintf_brstackoff:25@
    probe_perf:map__map_ip (on append_inlines:12@util/machine.c in
    probe_perf:map__map_ip (on unwind_entry:19@util/machine.c in /
    probe_perf:map__map_ip (on map__map_ip@util/map.h in /home/mhi
    probe_perf:map__map_ip (on map__map_ip@util/map.h in /home/mhi
  # perf probe -d \*
  "*" does not hit any event.
    Error: Failed to delete events. Reason: No such file or directory (Code: -2)

With this:
  # perf probe -d \*
  Removed event: probe_perf:map__map_ip

Fixes: 72363540c009 ("perf probe: Support multiprobe event")
Reported-by: Arnaldo Carvalho de Melo <acme@kernel.org>
Reported-by: He Zhe <zhe.he@windriver.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
---
 v2:
  - Forward port on the latest perf/urgent tree.
  - Add Fixes and Reporters.
---
 tools/perf/util/probe-file.c |    3 +++
 1 file changed, 3 insertions(+)

diff --git a/tools/perf/util/probe-file.c b/tools/perf/util/probe-file.c
index 0f5fda11675f..8c852948513e 100644
--- a/tools/perf/util/probe-file.c
+++ b/tools/perf/util/probe-file.c
@@ -206,6 +206,9 @@ static struct strlist *__probe_file__get_namelist(int fd, bool include_group)
 		} else
 			ret = strlist__add(sl, tev.event);
 		clear_probe_trace_event(&tev);
+		/* Skip if there is same name multi-probe event in the list */
+		if (ret == -EEXIST)
+			ret = 0;
 		if (ret < 0)
 			break;
 	}

