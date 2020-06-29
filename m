Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0781420E2F8
	for <lists+stable@lfdr.de>; Tue, 30 Jun 2020 00:02:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730373AbgF2VK1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Jun 2020 17:10:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:45424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729899AbgF2TAS (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Jun 2020 15:00:18 -0400
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 24598254FA;
        Mon, 29 Jun 2020 15:54:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593446057;
        bh=AviOQAwt76TQyzxVk0GuHDNspXCn0OKJCjcTl6g8b68=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jbLGvdMQVWQmf2FxZYT8A04xbHTPVxLmeUnDRWb9zP6Ri6PGK8TMbibOxv1PO+Ln2
         2GCvEhdYdjoOBwBazZI8rNSBxgiffizbp/0+VimNL/Zqi66KBzoRtTnA4d6HSx45nA
         H2GL5g2PZuprdwh45YqivxJWtdjBt6fAanmqZ1Ok=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Gaurav Singh <gaurav1086@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Alexander Shishkin <alexander.shishkin@linux.intel.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@kernel.org>,
        Kan Liang <kan.liang@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 057/135] perf report: Fix NULL pointer dereference in hists__fprintf_nr_sample_events()
Date:   Mon, 29 Jun 2020 11:51:51 -0400
Message-Id: <20200629155309.2495516-58-sashal@kernel.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200629155309.2495516-1-sashal@kernel.org>
References: <20200629155309.2495516-1-sashal@kernel.org>
MIME-Version: 1.0
X-KernelTest-Patch: http://kernel.org/pub/linux/kernel/v4.x/stable-review/patch-4.4.229-rc1.gz
X-KernelTest-Tree: git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git
X-KernelTest-Branch: linux-4.4.y
X-KernelTest-Patches: git://git.kernel.org/pub/scm/linux/kernel/git/stable/stable-queue.git
X-KernelTest-Version: 4.4.229-rc1
X-KernelTest-Deadline: 2020-07-01T15:53+00:00
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Gaurav Singh <gaurav1086@gmail.com>

[ Upstream commit 11b6e5482e178055ec1f2444b55f2518713809d1 ]

The 'evname' variable can be NULL, as it is checked a few lines back,
check it before using.

Fixes: 9e207ddfa207 ("perf report: Show call graph from reference events")
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Alexander Shishkin <alexander.shishkin@linux.intel.com>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@kernel.org>
Cc: Kan Liang <kan.liang@intel.com>
Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lore.kernel.org/lkml/
Signed-off-by: Gaurav Singh <gaurav1086@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-report.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/tools/perf/builtin-report.c b/tools/perf/builtin-report.c
index f256fac1e7225..74dd196acdac3 100644
--- a/tools/perf/builtin-report.c
+++ b/tools/perf/builtin-report.c
@@ -334,8 +334,7 @@ static size_t hists__fprintf_nr_sample_events(struct hists *hists, struct report
 	if (evname != NULL)
 		ret += fprintf(fp, " of event '%s'", evname);
 
-	if (symbol_conf.show_ref_callgraph &&
-	    strstr(evname, "call-graph=no")) {
+	if (symbol_conf.show_ref_callgraph && evname && strstr(evname, "call-graph=no")) {
 		ret += fprintf(fp, ", show reference callgraph");
 	}
 
-- 
2.25.1

