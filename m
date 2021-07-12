Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 80F4E3C4734
	for <lists+stable@lfdr.de>; Mon, 12 Jul 2021 12:26:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236027AbhGLGbq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 12 Jul 2021 02:31:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:53342 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237407AbhGLGbC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 12 Jul 2021 02:31:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2BDF660234;
        Mon, 12 Jul 2021 06:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626071291;
        bh=sZQ6ZnIjlP80FIRyhMSmcadDe89iggu2b0xo7MLak/Q=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gk7XjbfWPPN97BNVIs5d5uMEFvDJMVftxTaMIFIqhiRsuD73NCZJPfT+yKgckizBf
         vFra4MQNAB6IcYQOd9ydmAKh13iO/nP7J0xCbbLv1lOt2NwZ9406PTwbXr+Noe9yj8
         jz3RyPrjw0MucilCP4j0dHySMtRymhnCLVVSAxtQ=
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
Subject: [PATCH 5.4 343/348] perf llvm: Return -ENOMEM when asprintf() fails
Date:   Mon, 12 Jul 2021 08:12:07 +0200
Message-Id: <20210712060749.608981013@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210712060659.886176320@linuxfoundation.org>
References: <20210712060659.886176320@linuxfoundation.org>
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
index 8b14e4a7f1dc..e7c7e3232fc5 100644
--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -502,6 +502,7 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 			goto errout;
 		}
 
+		err = -ENOMEM;
 		if (asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
 			      template, llc_path, opts) < 0) {
 			pr_err("ERROR:\tnot enough memory to setup command line\n");
@@ -522,6 +523,7 @@ int llvm__compile_bpf(const char *path, void **p_obj_buf,
 
 	pr_debug("llvm compiling command template: %s\n", template);
 
+	err = -ENOMEM;
 	if (asprintf(&command_echo, "echo -n \"%s\"", template) < 0)
 		goto errout;
 
-- 
2.30.2



