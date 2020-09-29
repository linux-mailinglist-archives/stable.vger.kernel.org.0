Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2B33A27CC71
	for <lists+stable@lfdr.de>; Tue, 29 Sep 2020 14:37:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728671AbgI2Mg2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 29 Sep 2020 08:36:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:37022 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729063AbgI2LU6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 29 Sep 2020 07:20:58 -0400
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 30C5F221EF;
        Tue, 29 Sep 2020 11:18:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601378291;
        bh=+hiScWzlYdU5Vu6lWpmYKEZSFBIA+xOYgmz1poSBJBo=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HW1PQP8OhzduxNpPUBBKpUXz7TwYfe5rKcHKOVJMu/WR5pJS+NSfZaV6bXnSHyltg
         XXfXmXvG5tTzjJeVmww5Iuzk5MZ8Aqe7iuAZlSLWlpKSgm0GYGIkk48zZN8EnzdGFS
         riRLOElVQf7uc+MF9tCwdNuhsLTKgdbFkDe6ghNc=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        "Steven Rostedt (VMware)" <rostedt@goodmis.org>, x86@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 129/166] perf kcore_copy: Fix module map when there are no modules loaded
Date:   Tue, 29 Sep 2020 13:00:41 +0200
Message-Id: <20200929105941.639664403@linuxfoundation.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20200929105935.184737111@linuxfoundation.org>
References: <20200929105935.184737111@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 61f82e3fb697a8e85f22fdec786528af73dc36d1 ]

In the absence of any modules, no "modules" map is created, but there
are other executable pages to map, due to eBPF JIT, kprobe or ftrace.
Map them by recognizing that the first "module" symbol is not
necessarily from a module, and adjust the map accordingly.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Leo Yan <leo.yan@linaro.org>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Poirier <mathieu.poirier@linaro.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Steven Rostedt (VMware) <rostedt@goodmis.org>
Cc: x86@kernel.org
Link: http://lore.kernel.org/lkml/20200512121922.8997-10-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/symbol-elf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/tools/perf/util/symbol-elf.c b/tools/perf/util/symbol-elf.c
index 3d39332b3a06a..a0a4afa7e6781 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1420,6 +1420,7 @@ struct kcore_copy_info {
 	u64 first_symbol;
 	u64 last_symbol;
 	u64 first_module;
+	u64 first_module_symbol;
 	u64 last_module_symbol;
 	struct phdr_data kernel_map;
 	struct phdr_data modules_map;
@@ -1434,6 +1435,8 @@ static int kcore_copy__process_kallsyms(void *arg, const char *name, char type,
 		return 0;
 
 	if (strchr(name, '[')) {
+		if (!kci->first_module_symbol || start < kci->first_module_symbol)
+			kci->first_module_symbol = start;
 		if (start > kci->last_module_symbol)
 			kci->last_module_symbol = start;
 		return 0;
@@ -1558,6 +1561,10 @@ static int kcore_copy__calc_maps(struct kcore_copy_info *kci, const char *dir,
 		kci->etext += page_size;
 	}
 
+	if (kci->first_module_symbol &&
+	    (!kci->first_module || kci->first_module_symbol < kci->first_module))
+		kci->first_module = kci->first_module_symbol;
+
 	kci->first_module = round_down(kci->first_module, page_size);
 
 	if (kci->last_module_symbol) {
-- 
2.25.1



