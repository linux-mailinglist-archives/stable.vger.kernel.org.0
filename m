Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C8E6475EA3
	for <lists+stable@lfdr.de>; Wed, 15 Dec 2021 18:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245421AbhLORXk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 15 Dec 2021 12:23:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245442AbhLORXM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 15 Dec 2021 12:23:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99936C061792;
        Wed, 15 Dec 2021 09:23:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 63652B82029;
        Wed, 15 Dec 2021 17:23:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D36C36AE0;
        Wed, 15 Dec 2021 17:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1639588987;
        bh=izRc/pK+0c9RjeJQKOGwnEypR9yzix4/b84JvcZddvI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oHxOunxVOfpa6+abuPbV+ag7nv9VTR6JPH0hU85SKjYVIwsCyO7yaTml4jY20AX2c
         euvXOToMw1FL8NfN+ol0BaXTSTYrQPRoS/SyQW3X6u6BSlX0Qd1jfzcVT317MMXymK
         /jD8GPi+381EwKA+Gj7Rc1oKloiRb9qsMC0flsNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Song Liu <songliubraving@fb.com>, Jiri Olsa <jolsa@kernel.org>,
        Namhyung Kim <namhyung@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 10/42] perf bpf_skel: Do not use typedef to avoid error on old clang
Date:   Wed, 15 Dec 2021 18:20:51 +0100
Message-Id: <20211215172026.995295881@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20211215172026.641863587@linuxfoundation.org>
References: <20211215172026.641863587@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Song Liu <songliubraving@fb.com>

[ Upstream commit 5a897531e00243cebbcc4dbe4ab06cd559ccf53f ]

When building bpf_skel with clang-10, typedef causes confusions like:

  libbpf: map 'prev_readings': unexpected def kind var.

Fix this by removing the typedef.

Fixes: 7fac83aaf2eecc9e ("perf stat: Introduce 'bperf' to share hardware PMCs with BPF")
Reported-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Song Liu <songliubraving@fb.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Link: http://lore.kernel.org/lkml/BEF5C312-4331-4A60-AEC0-AD7617CB2BC4@fb.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/bpf_skel/bperf.h              | 14 --------------
 tools/perf/util/bpf_skel/bperf_follower.bpf.c | 16 +++++++++++++---
 tools/perf/util/bpf_skel/bperf_leader.bpf.c   | 16 +++++++++++++---
 3 files changed, 26 insertions(+), 20 deletions(-)
 delete mode 100644 tools/perf/util/bpf_skel/bperf.h

diff --git a/tools/perf/util/bpf_skel/bperf.h b/tools/perf/util/bpf_skel/bperf.h
deleted file mode 100644
index 186a5551ddb9d..0000000000000
--- a/tools/perf/util/bpf_skel/bperf.h
+++ /dev/null
@@ -1,14 +0,0 @@
-// SPDX-License-Identifier: (GPL-2.0-only OR BSD-2-Clause)
-// Copyright (c) 2021 Facebook
-
-#ifndef __BPERF_STAT_H
-#define __BPERF_STAT_H
-
-typedef struct {
-	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
-	__uint(key_size, sizeof(__u32));
-	__uint(value_size, sizeof(struct bpf_perf_event_value));
-	__uint(max_entries, 1);
-} reading_map;
-
-#endif /* __BPERF_STAT_H */
diff --git a/tools/perf/util/bpf_skel/bperf_follower.bpf.c b/tools/perf/util/bpf_skel/bperf_follower.bpf.c
index b8fa3cb2da230..6d2ea67b161ac 100644
--- a/tools/perf/util/bpf_skel/bperf_follower.bpf.c
+++ b/tools/perf/util/bpf_skel/bperf_follower.bpf.c
@@ -4,11 +4,21 @@
 #include <linux/perf_event.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
-#include "bperf.h"
 #include "bperf_u.h"
 
-reading_map diff_readings SEC(".maps");
-reading_map accum_readings SEC(".maps");
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+	__uint(max_entries, 1);
+} diff_readings SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+	__uint(max_entries, 1);
+} accum_readings SEC(".maps");
 
 struct {
 	__uint(type, BPF_MAP_TYPE_HASH);
diff --git a/tools/perf/util/bpf_skel/bperf_leader.bpf.c b/tools/perf/util/bpf_skel/bperf_leader.bpf.c
index 4f70d1459e86c..d82e1633a2e0a 100644
--- a/tools/perf/util/bpf_skel/bperf_leader.bpf.c
+++ b/tools/perf/util/bpf_skel/bperf_leader.bpf.c
@@ -4,7 +4,6 @@
 #include <linux/perf_event.h>
 #include <bpf/bpf_helpers.h>
 #include <bpf/bpf_tracing.h>
-#include "bperf.h"
 
 struct {
 	__uint(type, BPF_MAP_TYPE_PERF_EVENT_ARRAY);
@@ -13,8 +12,19 @@ struct {
 	__uint(map_flags, BPF_F_PRESERVE_ELEMS);
 } events SEC(".maps");
 
-reading_map prev_readings SEC(".maps");
-reading_map diff_readings SEC(".maps");
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+	__uint(max_entries, 1);
+} prev_readings SEC(".maps");
+
+struct {
+	__uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
+	__uint(key_size, sizeof(__u32));
+	__uint(value_size, sizeof(struct bpf_perf_event_value));
+	__uint(max_entries, 1);
+} diff_readings SEC(".maps");
 
 SEC("raw_tp/sched_switch")
 int BPF_PROG(on_switch)
-- 
2.33.0



