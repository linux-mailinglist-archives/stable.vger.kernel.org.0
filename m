Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F93A3C5054
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:45:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347054AbhGLHcC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 03:32:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1345512AbhGLH3z (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 03:29:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 00CA0611AF;
        Mon, 12 Jul 2021 07:26:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626074815;
        bh=hHMXRUxcWcAG6C9Q/dJOF0deEznyyuh+SrM9U2OncYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=A9/YjWxayruJMwd0cotj/NBMrqGdcIfAKBkMAsj5nO51dK5Z3q+GbKlfD+1TNPzOo
         9Ag2KSzcpz5zPbHAhdu0kqyhs8/BCSKQe0DtyPeG3sjCtaQ89rZzmvaYfm1h4+LkV1
         XyRKQ57unmVSFEYpVETsSg7HCom7lmkGCBrRUP+I=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Hulk Robot <hulkci@huawei.com>,
        Zhihao Cheng <chengzhihao1@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Ingo Molnar <mingo@redhat.com>, Jiri Olsa <jolsa@redhat.com>,
        Nathan Chancellor <nathan@kernel.org>,
        Nick Desaulniers <ndesaulniers@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Yu Kuai <yukuai3@huawei.com>,
        clang-built-linux@googlegroups.com,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.12 678/700] perf llvm: Return -ENOMEM when asprintf() fails
Date:   Mon, 12 Jul 2021 08:12:41 +0200
Message-Id: <20210712061048.018913193@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060924.797321836@linuxfoundation.org>
References: <20210712060924.797321836@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

[ Upstream commit c435c166dcf526ac827bc964d82cc0d5e7a1fd0b ]

Zhihao sent a patch but it made llvm__compile_bpf() return what
asprintf() returns on error, which is just -1, but since this function
returns -errno, fix it by returning -ENOMEM for this case instead.

Fixes: cb76371441d098 ("perf llvm: Allow passing options to llc ...")
Fixes: 5eab5a7ee032ac ("perf llvm: Display eBPF compiling command ...")
Reported-by: Hulk Robot <hulkci@huawei.com>
Reported-by: Zhihao Cheng <chengzhihao1@huawei.com>
Cc: Alexei Starovoitov <ast@kernel.org>
Cc: Andrii Nakryiko <andrii@kernel.org>
Cc: Daniel Borkmann <daniel@iogearbox.net>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Yu Kuai <yukuai3@huawei.com>
Cc: clang-built-linux@googlegroups.com
Link: http://lore.kernel.org/lkml/20210609115945.2193194-1-chengzhihao1@huawei.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/llvm-utils.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/tools/perf/util/llvm-utils.c b/tools/perf/util/llvm-utils.c
index dbdffb6673fe..0bf6b4d4c90a 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -504,6 +504,7 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 			goto errout;
 		}
 
+		err = -ENOMEM;
 		if (asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
 			      template, llc_path, opts) < 0) {
 			pr_err("ERROR:\tnot enough memory to setup command line\n");
@@ -524,6 +525,7 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
 	pr_debug("llvm compiling command template: %s\n", template);
 
+	err = -ENOMEM;
 	if (asprintf(&command_echo, "echo -n \"%s\"", template) < 0)
 		goto errout;
 
-- 
2.30.2



