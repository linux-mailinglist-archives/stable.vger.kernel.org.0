Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D21AD1FBB6C
	for <lists+stable@lfdr.de>; Tue, 16 Jun 2020 18:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729543AbgFPPhH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 16 Jun 2020 11:37:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:48282 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730195AbgFPPhF (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 16 Jun 2020 11:37:05 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EDC3F20C56;
        Tue, 16 Jun 2020 15:37:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592321824;
        bh=wO96Syrd3Y+CQYFKAlkerJFStFL475pUlPCVcms5cC0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Xg3Fp0utWisbhEbwRV3AK/OTm2q31Ov/tHOuR6ybMW3oovLM2c0FC6+L/DnKEmTzw
         yQp8Nq/NVAkvQegdR3IEqWCYOLWr8JCufQTMgitrSWbGv5usUtWJ0WX20cRTIBgEfZ
         qOT9K9cLvDpxHBCWNin23UCtyf1gjjcNmpw7M5ZE=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yuxuan Shui <yshuiv7@gmail.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 029/134] perf probe: Accept the instance number of kretprobe event
Date:   Tue, 16 Jun 2020 17:33:33 +0200
Message-Id: <20200616153102.169724260@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200616153100.633279950@linuxfoundation.org>
References: <20200616153100.633279950@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Masami Hiramatsu <mhiramat@kernel.org>

[ Upstream commit c6aab66a728b6518772c74bd9dff66e1a1c652fd ]

Since the commit 6a13a0d7b4d1 ("ftrace/kprobe: Show the maxactive number
on kprobe_events") introduced to show the instance number of kretprobe
events, the length of the 1st format of the kprobe event will not 1, but
it can be longer.  This caused a parser error in perf-probe.

Skip the length check the 1st format of the kprobe event to accept this
instance number.

Without this fix:

  # perf probe -a vfs_read%return
  Added new event:
    probe:vfs_read__return (on vfs_read%return)

  You can now use it in all perf tools, such as:

  	perf record -e probe:vfs_read__return -aR sleep 1

  # perf probe -l
  Semantic error :Failed to parse event name: r16:probe/vfs_read__return
    Error: Failed to show event list.

And with this fixes:

  # perf probe -a vfs_read%return
  ...
  # perf probe -l
    probe:vfs_read__return (on vfs_read%return)

Fixes: 6a13a0d7b4d1 ("ftrace/kprobe: Show the maxactive number on kprobe_events")
Reported-by: Yuxuan Shui <yshuiv7@gmail.com>
Signed-off-by: Masami Hiramatsu <mhiramat@kernel.org>
Tested-by: Yuxuan Shui <yshuiv7@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: stable@vger.kernel.org
Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=207587
Link: http://lore.kernel.org/lkml/158877535215.26469.1113127926699134067.stgit@devnote2
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/probe-event.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/util/probe-event.c b/tools/perf/util/probe-event.c
index 91cab5f669d2..92b07be0b48b 100644
--- a/tools/perf/util/probe-event.c
+++ b/tools/perf/util/probe-event.c
@@ -1757,8 +1757,7 @@ int parse_probe_trace_command(const char *cmd, struct probe_trace_event *tev)
 	fmt1_str = strtok_r(argv0_str, ":", &fmt);
 	fmt2_str = strtok_r(NULL, "/", &fmt);
 	fmt3_str = strtok_r(NULL, " \t", &fmt);
-	if (fmt1_str == NULL || strlen(fmt1_str) != 1 || fmt2_str == NULL
-	    || fmt3_str == NULL) {
+	if (fmt1_str == NULL || fmt2_str == NULL || fmt3_str == NULL) {
 		semantic_error("Failed to parse event name: %s\n", argv[0]);
 		ret = -EINVAL;
 		goto out;
-- 
2.25.1



