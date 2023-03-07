Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB9CC6AE957
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 18:23:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjCGRXL (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 12:23:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230190AbjCGRWl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 12:22:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 122044ECE8
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 09:18:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7AE496150C
        for <stable@vger.kernel.org>; Tue,  7 Mar 2023 17:18:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4DF65C433A1;
        Tue,  7 Mar 2023 17:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1678209487;
        bh=Yqrs8HTGisDdywa3JPQeocUGX9CBGTZCMFQettr/AWc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GYKbZfoqwpPRGduIBji+pYYHMeXe6xBAacI75dP3Epr1dI7JKqLYjetYGN+4yCiKP
         SiPnHOY3CJGm2Q+WFt+sMjQxnqfZaJtgrSl0k4f3wpALxyArtkEbX6468PYgzDJTte
         Q6V3GsjZiG3KlEnbNNczYiMJTEzCdFeRGyCyKYXg=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        patches@lists.linux.dev, Tonghao Zhang <tong@infragraf.org>,
        Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <martin.lau@linux.dev>,
        Song Liu <song@kernel.org>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Stanislav Fomichev <sdf@google.com>,
        Hao Luo <haoluo@google.com>, Jiri Olsa <jolsa@kernel.org>,
        Martin KaFai Lau <martin.lau@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0236/1001] bpftool: profile online CPUs instead of possible
Date:   Tue,  7 Mar 2023 17:50:08 +0100
Message-Id: <20230307170032.080686152@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tonghao Zhang <tong@infragraf.org>

[ Upstream commit 377c16fa3f3c60d21e4b05314c8be034ce37f2eb ]

The number of online cpu may be not equal to possible cpu.
"bpftool prog profile" can not create pmu event on possible
but on online cpu.

$ dmidecode -s system-product-name
PowerEdge R620
$ cat /sys/devices/system/cpu/possible
0-47
$ cat /sys/devices/system/cpu/online
0-31

Disable cpu dynamically:
$ echo 0 > /sys/devices/system/cpu/cpuX/online

If one cpu is offline, perf_event_open will return ENODEV.
To fix this issue:
* check value returned and skip offline cpu.
* close pmu_fd immediately on error path, avoid fd leaking.

Fixes: 47c09d6a9f67 ("bpftool: Introduce "prog profile" command")
Signed-off-by: Tonghao Zhang <tong@infragraf.org>
Cc: Quentin Monnet <quentin@isovalent.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Martin KaFai Lau <martin.lau@linux.dev>
Cc: Song Liu <song@kernel.org>
Cc: Yonghong Song <yhs@fb.com>
Cc: John Fastabend <john.fastabend@gmail.com>
Cc: KP Singh <kpsingh@kernel.org>
Cc: Stanislav Fomichev <sdf@google.com>
Cc: Hao Luo <haoluo@google.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20230202131701.29519-1-tong@infragraf.org
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/bpf/bpftool/prog.c | 38 ++++++++++++++++++++++++++++++--------
 1 file changed, 30 insertions(+), 8 deletions(-)

diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
index cfc9fdc1e8634..e87738dbffc10 100644
--- a/tools/bpf/bpftool/prog.c
+++ b/tools/bpf/bpftool/prog.c
@@ -2233,10 +2233,38 @@ static void profile_close_perf_events(struct profiler_bpf *obj)
 	profile_perf_event_cnt = 0;
 }
 
+static int profile_open_perf_event(int mid, int cpu, int map_fd)
+{
+	int pmu_fd;
+
+	pmu_fd = syscall(__NR_perf_event_open, &metrics[mid].attr,
+			 -1 /*pid*/, cpu, -1 /*group_fd*/, 0);
+	if (pmu_fd < 0) {
+		if (errno == ENODEV) {
+			p_info("cpu %d may be offline, skip %s profiling.",
+				cpu, metrics[mid].name);
+			profile_perf_event_cnt++;
+			return 0;
+		}
+		return -1;
+	}
+
+	if (bpf_map_update_elem(map_fd,
+				&profile_perf_event_cnt,
+				&pmu_fd, BPF_ANY) ||
+	    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
+		close(pmu_fd);
+		return -1;
+	}
+
+	profile_perf_events[profile_perf_event_cnt++] = pmu_fd;
+	return 0;
+}
+
 static int profile_open_perf_events(struct profiler_bpf *obj)
 {
 	unsigned int cpu, m;
-	int map_fd, pmu_fd;
+	int map_fd;
 
 	profile_perf_events = calloc(
 		sizeof(int), obj->rodata->num_cpu * obj->rodata->num_metric);
@@ -2255,17 +2283,11 @@ static int profile_open_perf_events(struct profiler_bpf *obj)
 		if (!metrics[m].selected)
 			continue;
 		for (cpu = 0; cpu < obj->rodata->num_cpu; cpu++) {
-			pmu_fd = syscall(__NR_perf_event_open, &metrics[m].attr,
-					 -1/*pid*/, cpu, -1/*group_fd*/, 0);
-			if (pmu_fd < 0 ||
-			    bpf_map_update_elem(map_fd, &profile_perf_event_cnt,
-						&pmu_fd, BPF_ANY) ||
-			    ioctl(pmu_fd, PERF_EVENT_IOC_ENABLE, 0)) {
+			if (profile_open_perf_event(m, cpu, map_fd)) {
 				p_err("failed to create event %s on cpu %d",
 				      metrics[m].name, cpu);
 				return -1;
 			}
-			profile_perf_events[profile_perf_event_cnt++] = pmu_fd;
 		}
 	}
 	return 0;
-- 
2.39.2



