Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 52A7911B630
	for <lists+stable@lfdr.de>; Wed, 11 Dec 2019 16:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731670AbfLKP72 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Dec 2019 10:59:28 -0500
Received: from mail.kernel.org ([198.145.29.99]:38596 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731566AbfLKPOD (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Dec 2019 10:14:03 -0500
Received: from sasha-vm.mshome.net (c-73-47-72-35.hsd1.nh.comcast.net [73.47.72.35])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 021B32467E;
        Wed, 11 Dec 2019 15:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1576077242;
        bh=DuiprRsIOBez5iBZiFbIaAK/2cU1tXqeLTv5CQvxk00=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CCcrWfYh0hgiGtWgppwtYPb8aWjmFgd7ltRm5ZHgg9jpBAOTkgbrn9kPuCX4i3XA0
         tIb+lqb6KRCNv805LPYD2KXyLM2FxYXkWK0gdnj1oGIGyDI0ny12axxIUADiOqAMP3
         bMJBYiE3eh2tS+9lmd6tpoEepEe8ccgDHUuGb7MA=
From:   Sasha Levin <sashal@kernel.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@redhat.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.4 120/134] perf script: Fix invalid LBR/binary mismatch error
Date:   Wed, 11 Dec 2019 10:11:36 -0500
Message-Id: <20191211151150.19073-120-sashal@kernel.org>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20191211151150.19073-1-sashal@kernel.org>
References: <20191211151150.19073-1-sashal@kernel.org>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

[ Upstream commit 5172672da02e483d9b3c4d814c3482d0c8ffb1a6 ]

The 'len' returned by grab_bb() includes an extra MAXINSN bytes to allow
for the last instruction, so the the final 'offs' will not be 'len'.
Fix the error condition logic accordingly.

Before:

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

After:

  $ perf script -F +brstackinsn --xed --itrace=i1usl100 | head
            grep 13759 [002]  8091.310257:       1862                                        instructions:uH:      5641d58069eb bmexec+0x86b (/bin/grep)
        bmexec+2485:
        00005641d5806b35                        jnz 0x5641d5806bd0              # MISPRED
        00005641d5806bd0                        movzxb  (%r13,%rdx,1), %eax
        00005641d5806bd6                        add %rdi, %rax
        00005641d5806bd9                        movzxb  -0x1(%rax), %edx
        00005641d5806bdd                        cmp %rax, %r14
        00005641d5806be0                        jnb 0x5641d58069c0              # MISPRED
        00005641d58069c0                        movzxb  (%r13,%rdx,1), %edi
        00005641d58069c6                        add %rax, %rdi

Fixes: e98df280bc2a ("perf script brstackinsn: Fix recovery from LBR/binary mismatch")
Reported-by: Andi Kleen <ak@linux.intel.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Link: http://lore.kernel.org/lkml/20191127095631.15663-1-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/builtin-script.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 67be8d31afab6..6dba8b728d232 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -1084,7 +1084,7 @@ static int perf_sample__fprintf_brstackinsn(struct perf_sample *sample,
 				insn++;
 			}
 		}
-		if (off != (unsigned)len)
+		if (off != end - start)
 			printed += fprintf(fp, "\tmismatch of LBR data and executable\n");
 	}
 
-- 
2.20.1

