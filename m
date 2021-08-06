Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 759C33E258E
	for <lists+stable@lfdr.de>; Fri,  6 Aug 2021 10:21:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244289AbhHFIUw (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 6 Aug 2021 04:20:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:50976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S243999AbhHFITv (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 6 Aug 2021 04:19:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 626DD611F0;
        Fri,  6 Aug 2021 08:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628237974;
        bh=4r1dCxAxu4ZWEMqsIZGQNr3rovCELk59h1Qr4gCXHvY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=R7B/WlWhllqMABUOnX/SSKiEOVcYk/G93O+syEhzeU6ERnpXUxvX8FMhsl9ArwuW/
         o2n6ahC8gnnOf0xruzAt7YBvmyRAWJSXPTXazymzQxFVa0Iq4EzeAhr9ZvsrRlj8mr
         i9ZwWUjgXJDwEPLRLsc5lbhS61djpIAkIeOrSLb4=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Yonghong Song <yhs@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Ovidiu Panait <ovidiu.panait@windriver.com>
Subject: [PATCH 5.10 25/30] selftests/bpf: Add a test for ptr_to_map_value on stack for helper access
Date:   Fri,  6 Aug 2021 10:17:03 +0200
Message-Id: <20210806081113.981351079@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806081113.126861800@linuxfoundation.org>
References: <20210806081113.126861800@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

commit b4b638c36b7e7acd847b9c4b9c80f268e45ea30c upstream

Change bpf_iter_task.c such that pointer to map_value may appear
on the stack for bpf_seq_printf() to access. Without previous
verifier patch, the bpf_iter test will fail.

Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20201210013350.943985-1-yhs@fb.com
Signed-off-by: Ovidiu Panait <ovidiu.panait@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/bpf_iter_task.c |    3 ++-
 tools/testing/selftests/bpf/verifier/unpriv.c     |    5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

--- a/tools/testing/selftests/bpf/progs/bpf_iter_task.c
+++ b/tools/testing/selftests/bpf/progs/bpf_iter_task.c
@@ -11,9 +11,10 @@ int dump_task(struct bpf_iter__task *ctx
 {
 	struct seq_file *seq = ctx->meta->seq;
 	struct task_struct *task = ctx->task;
+	static char info[] = "    === END ===";
 
 	if (task == (void *)0) {
-		BPF_SEQ_PRINTF(seq, "    === END ===\n");
+		BPF_SEQ_PRINTF(seq, "%s\n", info);
 		return 0;
 	}
 
--- a/tools/testing/selftests/bpf/verifier/unpriv.c
+++ b/tools/testing/selftests/bpf/verifier/unpriv.c
@@ -108,8 +108,9 @@
 	BPF_EXIT_INSN(),
 	},
 	.fixup_map_hash_8b = { 3 },
-	.errstr = "invalid indirect read from stack off -8+0 size 8",
-	.result = REJECT,
+	.errstr_unpriv = "invalid indirect read from stack off -8+0 size 8",
+	.result_unpriv = REJECT,
+	.result = ACCEPT,
 },
 {
 	"unpriv: mangle pointer on stack 1",


