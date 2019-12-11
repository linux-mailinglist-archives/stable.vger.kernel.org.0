Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0011B23A
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:35:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387532AbfLKP2C (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:28:02 -0500
Received: from mail.kernel.org ([198.145.29.99]:33966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387522AbfLKP2B (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:28:01 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 191E824654;
        Wed, 11 Dec 2019 15:28:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576078080;
        bh=NE/R/5Kiv8n0dRAYWexZi/K1QnUmHbuXTiVQhKJGVuE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xqmIwtj0oKE3lpdVfiZttEV//JmYqGTEIQC0eSN4pndWGCLI+78qBDIYGOlsdZi95
         bEX0uji27fGYlAS6ooMHiTmGovuvbDSPIMkwBp7G1AiVb3FqTN595F7j6sKiJneK8w
         N9z7s20CG358fVbEetUFWy2FCRNel3gSatJmZo4o=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 4.19 71/79] perf script: Fix brstackinsn for AUXTRACE
Date:   Wed, 11 Dec 2019 10:26:35 -0500
Message-Id: <20191211152643.23056-71-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211152643.23056-1-sashal@kernel.org>
References: <20191211152643.23056-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 0cd032d3b5fcebf5454315400ab310746a81ca53 ]

brstackinsn must be allowed to be set by the user when AUX area data has
been captured because, in that case, the branch stack might be
synthesized on the fly. This fixes the following error:

Before:

  $ perf record -e '{intel_pt//,cpu/mem_inst_retired.all_loads,aux-sample-size=8192/pp}:u' grep -rqs jhgjhg /boot
  [ perf record: Woken up 19 times to write data ]
  [ perf record: Captured and wrote 2.274 MB perf.data ]
  $ perf script -F +brstackinsn --xed --itrace=i1usl100 | head
  Display of branch stack assembler requested, but non all-branch filter set
  Hint: run 'perf record -b ...'

After:

  $ perf record -e '{intel_pt//,cpu/mem_inst_retired.all_loads,aux-sample-size=8192/pp}:u' grep -rqs jhgjhg /boot
  [ perf record: Woken up 19 times to write data ]
  [ perf record: Captured and wrote 2.274 MB perf.data ]
  $ perf script -F +brstackinsn --xed --itrace=i1usl100 | head
            grep 13759 [002]  8091.310257:       1862                                        instructions:uH:      5641d58069eb bmexec+0x86b (/bin/grep)
        bmexec+2485:
        00005641d5806b35                        jnz 0x5641d5806bd0              # MISPRED
        00005641d5806bd0                        movzxb  (%r13,%rdx,1), %eax
        00005641d5806bd6                        add %rdi, %rax
        00005641d5806bd9                        movzxb  -0x1(%rax), %edx
        00005641d5806bdd                        cmp %rax, %r14
        00005641d5806be0                        jnb 0x5641d58069c0              # MISPRED
        mismatch of LBR data and executable
        00005641d58069c0                        movzxb  (%r13,%rdx,1), %edi

Fixes: 48d02a1d5c13 ("perf script: Add 'brstackinsn' for branch stacks")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20191127095322.15417-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index a4c78499c838b..1200973c77cb2 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -428,7 +428,7 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		       "selected. Hence, no address to lookup the source line number.\n");
 		return -EINVAL;
 	}
-	if (PRINT_FIELD(BRSTACKINSN) &&
+	if (PRINT_FIELD(BRSTACKINSN) && !allow_user_set &&
 	    !(perf_evlist__combined_branch_type(session->evlist) &
 	      PERF_SAMPLE_BRANCH_ANY)) {
 		pr_err("Display of branch stack assembler requested, but non all-branch filter set\n"
-- 
2.20.1

