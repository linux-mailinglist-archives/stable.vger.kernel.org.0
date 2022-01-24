Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD84249A26F
	for <lists+stable@lfdr.de>; Tue, 25 Jan 2022 03:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2365764AbiAXXvk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 18:51:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1837945AbiAXWpj (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 17:45:39 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AD141C0550DA;
        Mon, 24 Jan 2022 13:06:08 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 45CC261440;
        Mon, 24 Jan 2022 21:06:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25B13C340E5;
        Mon, 24 Jan 2022 21:06:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643058367;
        bh=ztqfitNffqsFqfEWPzKX7KUjxMzkshc6Xzsm9WfQhxk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m5v6nL8lYuo0767OwOxLLWlgeTmDDdtTZdzw0NUCq0XvaNAVwqRAYuvrD70gOQVmg
         GLmLrCdF/RzI05kFirWnF2Ewyuw+aq2ZdWLUNnczSG14r8mAjP1mxUPFv4QCNs0D3T
         FEB08uS9B59YAl0AplH4pAV24xObOimQDOgUnwJo=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Peter Zijlstra <peterz@infradead.org>,
        Kajol Jain <kjain@linux.ibm.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.16 0234/1039] bpf: Remove config check to enable bpf support for branch records
Date:   Mon, 24 Jan 2022 19:33:43 +0100
Message-Id: <20220124184133.182515019@linuxfoundation.org>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20220124184125.121143506@linuxfoundation.org>
References: <20220124184125.121143506@linuxfoundation.org>
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
index ae9755037b7ee..e36d184615fb7 100644
--- a/kernel/trace/bpf_trace.c
+++ b/kernel/trace/bpf_trace.c
@@ -1400,9 +1400,6 @@ static const struct bpf_func_proto bpf_perf_prog_read_value_proto = {
 BPF_CALL_4(bpf_read_branch_records, struct bpf_perf_event_data_kern *, ctx,
 	   void *, buf, u32, size, u64, flags)
 {
-#ifndef CONFIG_X86
-	return -ENOENT;
-#else
 	static const u32 br_entry_size = sizeof(struct perf_branch_entry);
 	struct perf_branch_stack *br_stack = ctx->data->br_stack;
 	u32 to_copy;
@@ -1411,7 +1408,7 @@ BPF_CALL_4(bpf_read_branch_records, struct bpf_perf_event_data_kern *, ctx,
 		return -EINVAL;
 
 	if (unlikely(!br_stack))
-		return -EINVAL;
+		return -ENOENT;
 
 	if (flags & BPF_F_GET_BRANCH_RECORDS_SIZE)
 		return br_stack->nr * br_entry_size;
@@ -1423,7 +1420,6 @@ BPF_CALL_4(bpf_read_branch_records, struct bpf_perf_event_data_kern *, ctx,
 	memcpy(buf, br_stack->entries, to_copy);
 
 	return to_copy;
-#endif
 }
 
 static const struct bpf_func_proto bpf_read_branch_records_proto = {
-- 
2.34.1



