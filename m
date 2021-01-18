Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F1312FA293
	for <lists+stable@lfdr.de>; Mon, 18 Jan 2021 15:09:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392640AbhAROId (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 Jan 2021 09:08:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:39744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390567AbhARLpR (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 Jan 2021 06:45:17 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id EBFC52223E;
        Mon, 18 Jan 2021 11:44:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1610970276;
        bh=eRIfF8oWWMgqReAa28aJObfsmKWrb+wSR12SGxCYBmc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Rz7Jyf0ElazIcvdzzErQcubL9XP1ACcYl+t50xm9do4bEeHJUoPcIY7sF4dfx+Rzt
         pC17AT9W/bpkSR0sPKQoRPTnmqwlxMgENnbLCkfuce5Gz420blYycGRl/ii1YX+hDu
         94+MNXDABh8UIqVpY1P0r/aIMH0UZILkWjim4RsM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Kan Liang <kan.liang@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 5.10 112/152] perf intel-pt: Fix CPU too large error
Date:   Mon, 18 Jan 2021 12:34:47 +0100
Message-Id: <20210118113358.098408816@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210118113352.764293297@linuxfoundation.org>
References: <20210118113352.764293297@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

commit 5501e9229a80d95a1ea68609f44c447a75d23ed5 upstream.

In some cases, the number of cpus (nr_cpus_online) is confused with the
maximum cpu number (nr_cpus_avail), which results in the error in the
example below:

Example on system with 8 cpus:

 Before:
   # echo 0 > /sys/devices/system/cpu/cpu2/online
   # ./perf record --kcore -e intel_pt// taskset --cpu-list 7 uname
   Linux
   [ perf record: Woken up 1 times to write data ]
   [ perf record: Captured and wrote 0.147 MB perf.data ]
   # ./perf script --itrace=e
   Requested CPU 7 too large. Consider raising MAX_NR_CPUS
   0x25908 [0x8]: failed to process type: 68 [Invalid argument]

 After:
   # ./perf script --itrace=e
   #

Fixes: 8c7274691f0d ("perf machine: Replace MAX_NR_CPUS with perf_env::nr_cpus_online")
Fixes: 7df4e36a4785 ("perf session: Replace MAX_NR_CPUS with perf_env::nr_cpus_online")
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Tested-by: Kan Liang <kan.liang@linux.intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: stable@vger.kernel.org
Link: http://lore.kernel.org/lkml/20210107174159.24897-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/perf/util/machine.c |    4 ++--
 tools/perf/util/session.c |    2 +-
 2 files changed, 3 insertions(+), 3 deletions(-)

--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -2973,7 +2973,7 @@ int machines__for_each_thread(struct mac
 
 pid_t machine__get_current_tid(struct machine *machine, int cpu)
 {
-	int nr_cpus = min(machine->env->nr_cpus_online, MAX_NR_CPUS);
+	int nr_cpus = min(machine->env->nr_cpus_avail, MAX_NR_CPUS);
 
 	if (cpu < 0 || cpu >= nr_cpus || !machine->current_tid)
 		return -1;
@@ -2985,7 +2985,7 @@ int machine__set_current_tid(struct mach
 			     pid_t tid)
 {
 	struct thread *thread;
-	int nr_cpus = min(machine->env->nr_cpus_online, MAX_NR_CPUS);
+	int nr_cpus = min(machine->env->nr_cpus_avail, MAX_NR_CPUS);
 
 	if (cpu < 0)
 		return -EINVAL;
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -2397,7 +2397,7 @@ int perf_session__cpu_bitmap(struct perf
 {
 	int i, err = -1;
 	struct perf_cpu_map *map;
-	int nr_cpus = min(session->header.env.nr_cpus_online, MAX_NR_CPUS);
+	int nr_cpus = min(session->header.env.nr_cpus_avail, MAX_NR_CPUS);
 
 	for (i = 0; i < PERF_TYPE_MAX; ++i) {
 		struct evsel *evsel;


