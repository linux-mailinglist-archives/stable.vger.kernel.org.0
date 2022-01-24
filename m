Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA7DE4999A6
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:46:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1455912AbiAXVgp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:36:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1453887AbiAXVbI (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 16:31:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 304CCC0AD1AD;
        Mon, 24 Jan 2022 12:20:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9822B811F9;
        Mon, 24 Jan 2022 20:19:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07AF6C340E5;
        Mon, 24 Jan 2022 20:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643055598;
        bh=vHsytlRuhEniNKYDf87eMNzzcRoTpH3g1LK1qlpI8Lw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IkJK1YTAszWW44OV2qJss/MjH3RAadO1t/2rbK1XXw3US1SLbwD9Uvd0RuGWGkB7p
         9U6yPO9g5sbUcjBAPyQWu36ZNl7SVqktHqhhzrF1yY4Krif/qFUJx7upwgECNWAyqb
         SpPXeeEuMJmyUYj4dbx0a1IjWYTCyk6uVJ6Uy6uQ=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 203/846] bpf: Remove config check to enable bpf support for branch records
Date:   Mon, 24 Jan 2022 19:35:20 +0100
Message-Id: <20220124184107.938110220@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184100.867127425@linuxfoundation.org>
References: <20220124184100.867127425@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kajol Jain <kjain@linux.ibm.com>

[ Upstream commit db52f57211b4e45f0ebb274e2c877b211dc18591 ]

Branch data available to BPF programs can be very useful to get stack traces
out of userspace application.

Commit fff7b64355ea ("bpf: Add bpf_read_branch_records() helper") added BPF
support to capture branch records in x86. Enable this feature also for other
architectures as well by removing checks specific to x86.

If an architecture doesn't support branch records, bpf_read_branch_records()
still has appropriate checks and it will return an -EINVAL in that scenario.
Based on UAPI helper doc in include/uapi/linux/bpf.h, unsupported architectures
should return -ENOENT in such case. Hence, update the appropriate check to
return -ENOENT instead.

Selftest 'perf_branches' result on power9 machine which has the branch stacks
support:

 - Before this patch:

  [command]# ./test_progs -t perf_branches
   #88/1 perf_branches/perf_branches_hw:FAIL
   #88/2 perf_branches/perf_branches_no_hw:OK
   #88 perf_branches:FAIL
  Summary: 0/1 PASSED, 0 SKIPPED, 1 FAILED

 - After this patch:

  [command]# ./test_progs -t perf_branches
   #88/1 perf_branches/perf_branches_hw:OK
   #88/2 perf_branches/perf_branches_no_hw:OK
   #88 perf_branches:OK
  Summary: 1/2 PASSED, 0 SKIPPED, 0 FAILED

Selftest 'perf_branches' result on power9 machine which doesn't have branch
stack report:

 - After this patch:

  [command]# ./test_progs -t perf_branches
   #88/1 perf_branches/perf_branches_hw:SKIP
   #88/2 perf_branches/perf_branches_no_hw:OK
   #88 perf_branches:OK
  Summary: 1/1 PASSED, 1 SKIPPED, 0 FAILED

Fixes: fff7b64355eac ("bpf: Add bpf_read_branch_records() helper")
Suggested-by: Peter Zijlstra <peterz@infradead.org>
Signed-off-by: Kajol Jain <kjain@linux.ibm.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20211206073315.77432-1-kjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/bpf_trace.c | 6 +-----
 1 file changed, 1 insertion(+), 5 deletions(-)

diff --git a/kernel/trace/bpf_trace.c b/kernel/trace/bpf_trace.c
index 6c1038526d1fc..5a18b861fcf75 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1322,9 +1322,6 @@ static const struct bpf_func_proto bpf_perf_prog_read_value_proto = {
 BPF_CALL_4(bpf_read_branch_records, struct bpf_perf_event_data_kern *, ctx,
 	   void *, buf, u32, size, u64, flags)
 {
-#ifndef CONFIG_X86
-	return -ENOENT;
-#else
 	static const u32 br_entry_size = sizeof(struct perf_branch_entry);
 	struct perf_branch_stack *br_stack = ctx->data->br_stack;
 	u32 to_copy;
@@ -1333,7 +1330,7 @@ BPF_CALL_4(bpf_read_branch_records, struct bpf_perf_event_data_kern *, ctx,
 		return -EINVAL;
 
 	if (unlikely(!br_stack))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (flags & BPF_F_GET_BRANCH_RECORDS_SIZE)
 		return br_stack->nr * br_entry_size;
@@ -1345,7 +1342,6 @@ BPF_CALL_4(bpf_read_branch_records, struct bpf_perf_event_data_kern *, ctx,
 	memcpy(buf, br_stack->entries, to_copy);
 
 	return to_copy;
-#endif
 }
 
 static const struct bpf_func_proto bpf_read_branch_records_proto = {
-- 
2.34.1



