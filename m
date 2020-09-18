Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCE5726F1EB
	for <lists+stable@lfdr.de>; Fri, 18 Sep 2020 04:54:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726662AbgIRCyv (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Sep 2020 22:54:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57572 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727237AbgIRCHU (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 17 Sep 2020 22:07:20 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BD621238E3;
        Fri, 18 Sep 2020 02:07:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600394839;
        bh=GM7f6/Yo+DhTZY+DXNizPAXkh5SdHzaJ/cPyt9D+hfI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rHPRI3YX77ldMOqBSPWx+gx8x04eg+Fq7AdIc0QbfxrXf6ghE8KLPxWkoUi5oCHM8
         d7VW0YkFeg7+hvJhE7JJ6TAGagwEOlYn/DnQGPOrImKt0zAeDLkZU23bVs3c7gp2XA
         PtEnW79vBvxcrtb+zMQvP2lkmdI2dNIhOrOQC+ok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Borislav Petkov <bp@alien8.de>,
        "H . Peter Anvin" <hpa@zytor.com>, Jiri Olsa <jolsa@redhat.com>,
        Leo Yan <leo.yan@linaro.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Steven Rostedt <rostedt@goodmis.org>, x86@kernel.org,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 297/330] perf kcore_copy: Fix module map when there are no modules loaded
Date:   Thu, 17 Sep 2020 22:00:37 -0400
Message-Id: <20200918020110.2063155-297-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200918020110.2063155-1-sashal@kernel.org>
References: <20200918020110.2063155-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
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
index 66f4be1df573e..2ec0a32da5793 100644
--- a/tools/perf/util/symbol-elf.c
+++ b/tools/perf/util/symbol-elf.c
@@ -1449,6 +1449,7 @@ struct kcore_copy_info {
 	u64 first_symbol;
 	u64 last_symbol;
 	u64 first_module;
+	u64 first_module_symbol;
 	u64 last_module_symbol;
 	size_t phnum;
 	struct list_head phdrs;
@@ -1525,6 +1526,8 @@ static int kcore_copy__process_kallsyms(void *arg, const char *name, char type,
 		return 0;
 
 	if (strchr(name, '[')) {
+		if (!kci->first_module_symbol || start < kci->first_module_symbol)
+			kci->first_module_symbol = start;
 		if (start > kci->last_module_symbol)
 			kci->last_module_symbol = start;
 		return 0;
@@ -1722,6 +1725,10 @@ static int kcore_copy__calc_maps(struct kcore_copy_info *kci, const char *dir,
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

