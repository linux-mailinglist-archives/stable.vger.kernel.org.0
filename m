Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EF3F41D83EC
	for <lists+stable@lfdr.de>; Mon, 18 May 2020 20:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729436AbgERSIi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 18 May 2020 14:08:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56668 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387433AbgERSHk (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 18 May 2020 14:07:40 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4F2BB20715;
        Mon, 18 May 2020 18:07:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589825259;
        bh=5RVUNeeq1bOhBax5PxSgXQk4pY6uDomCG0Yjuq6vgiA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BgaNQk0UGcUYtLBqrbVvvlF9L7VFZiGe5hJxlxp/igFwItS6GEiJAO+kz9f0sM+CI
         woHEFo6axsx1wxpkKKsPf9AMJjkvBI4v2wxZybAxz7m58+OV8uIUdaJPdlpsJE4+8R
         1Jatnp0xLxWX8/Y8Y26wHFH1O9GLl1WlxpCOmuik=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Yonghong Song <yhs@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>
Subject: [PATCH 5.6 192/194] selftests/bpf: Enforce returning 0 for fentry/fexit programs
Date:   Mon, 18 May 2020 19:38:02 +0200
Message-Id: <20200518173547.378254492@linuxfoundation.org>
X-Mailer: git-send-email 2.26.2
In-Reply-To: <20200518173531.455604187@linuxfoundation.org>
References: <20200518173531.455604187@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Yonghong Song <yhs@fb.com>

commit 6d74f64b922b8394dccc52576659cb0dc0a1da7b upstream.

There are a few fentry/fexit programs returning non-0.
The tests with these programs will break with the previous
patch which enfoced return-0 rules. Fix them properly.

Fixes: ac065870d928 ("selftests/bpf: Add BPF_PROG, BPF_KPROBE, and BPF_KRETPROBE macros")
Signed-off-by: Yonghong Song <yhs@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Andrii Nakryiko <andriin@fb.com>
Link: https://lore.kernel.org/bpf/20200514053207.1298479-1-yhs@fb.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/progs/test_overhead.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/tools/testing/selftests/bpf/progs/test_overhead.c
+++ b/tools/testing/selftests/bpf/progs/test_overhead.c
@@ -33,13 +33,13 @@ int prog3(struct bpf_raw_tracepoint_args
 SEC("fentry/__set_task_comm")
 int BPF_PROG(prog4, struct task_struct *tsk, const char *buf, bool exec)
 {
-	return !tsk;
+	return 0;
 }
 
 SEC("fexit/__set_task_comm")
 int BPF_PROG(prog5, struct task_struct *tsk, const char *buf, bool exec)
 {
-	return !tsk;
+	return 0;
 }
 
 char _license[] SEC("license") = "GPL";


