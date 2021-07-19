Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 978D23CDE00
	for <lists+stable@lfdr.de>; Mon, 19 Jul 2021 17:42:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345163AbhGSPBi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 19 Jul 2021 11:01:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:53792 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344056AbhGSO72 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 19 Jul 2021 10:59:28 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id A74EE611CE;
        Mon, 19 Jul 2021 15:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1626709113;
        bh=TbsAz/5GzeqK7cOx8dmsgOB6evm0KjMHN1LI6yZNuCY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=m6sRcV0hwP9gOOzJli0ceg13Kchgaggdpqdab0O81uNOapnAmS/mvudZ0vdhsbLZ9
         9iL8w4NwOQqQutu+uTJ+T0gvLCSy5ZIVZHDx6O56qrt1vfu/LE0TQNK8MKxPyMINGz
         J0yRQ2SiZovtcK13NWiPV7FVvVT6sCqAiaUIt5Ko=
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
Subject: [PATCH 4.19 224/421] perf llvm: Return -ENOMEM when asprintf() fails
Date:   Mon, 19 Jul 2021 16:50:35 +0200
Message-Id: <20210719144954.099761899@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719144946.310399455@linuxfoundation.org>
References: <20210719144946.310399455@linuxfoundation.org>
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
 tools/perf/util/llvm-utils.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/perf/util/llvm-utils.c
+++ b/tools/perf/util/llvm-utils.c
@@ -500,6 +500,7 @@ int llvm__compile_bpf(const char *path,
 			goto errout;
 		}
 
+		err = -ENOMEM;
 		if (asprintf(&pipe_template, "%s -emit-llvm | %s -march=bpf %s -filetype=obj -o -",
 			      template, llc_path, opts) < 0) {
 			pr_err("ERROR:\tnot enough memory to setup command line\n");
@@ -520,6 +521,7 @@ int llvm__compile_bpf(const char *path,
 
 	pr_debug("llvm compiling command template: %s\n", template);
 
+	err = -ENOMEM;
 	if (asprintf(&command_echo, "echo -n \"%s\"", template) < 0)
 		goto errout;
 


