Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CFE1B30054B
	for <lists+stable@lfdr.de>; Fri, 22 Jan 2021 15:25:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728673AbhAVOZA (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 22 Jan 2021 09:25:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:40762 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728645AbhAVOYQ (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 22 Jan 2021 09:24:16 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C7CB23B99;
        Fri, 22 Jan 2021 14:18:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1611325104;
        bh=RFMlqyLw1tlq0GlayLVyZgIN40+Brn9eAw78yxoKv/8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qQScNU9XAI/9R8xaGY+OwtTxY9Jl/9+HMNY6wsmqb93QX/5efpCFEthD0DhGuO9Ve
         DO28FzpnvntNHExvxHBc+cTn0yDg0Q59ItzWuCBbtX/4rXSqSfnvR4pJIZ99+0Hue/
         8RoGQrcyHp7+ksCcmH1ACYRuWimcoJZTrdMCw3lw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrei Matei <andreimatei1@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Florian Lehner <dev@der-flo.net>, Yonghong Song <yhs@fb.com>,
        Lorenz Bauer <lmb@cloudflare.com>
Subject: [PATCH 5.10 02/43] bpf: Fix selftest compilation on clang 11
Date:   Fri, 22 Jan 2021 15:12:18 +0100
Message-Id: <20210122135735.742795244@linuxfoundation.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210122135735.652681690@linuxfoundation.org>
References: <20210122135735.652681690@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrei Matei <andreimatei1@gmail.com>

commit fb3558127cb62ba2dea9e3d0efa1bb1d7e5eee2a upstream.

Before this patch, profiler.inc.h wouldn't compile with clang-11 (before
the __builtin_preserve_enum_value LLVM builtin was introduced in
https://reviews.llvm.org/D83242).

Another test that uses this builtin (test_core_enumval) is conditionally
skipped if the compiler is too old. In that spirit, this patch inhibits
part of populate_cgroup_info(), which needs this CO-RE builtin. The
selftests build again on clang-11.

The affected test (the profiler test) doesn't pass on clang-11 because
it's missing https://reviews.llvm.org/D85570, but at least the test suite
as a whole compiles. The test's expected failure is already called out in
the README.

Signed-off-by: Andrei Matei <andreimatei1@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Florian Lehner <dev@der-flo.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20201125035255.17970-1-andreimatei1@gmail.com
Cc: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 tools/testing/selftests/bpf/progs/profiler.inc.h |    2 ++
 1 file changed, 2 insertions(+)

--- a/tools/testing/selftests/bpf/progs/profiler.inc.h
+++ b/tools/testing/selftests/bpf/progs/profiler.inc.h
@@ -256,6 +256,7 @@ static INLINE void* populate_cgroup_info
 		BPF_CORE_READ(task, nsproxy, cgroup_ns, root_cset, dfl_cgrp, kn);
 	struct kernfs_node* proc_kernfs = BPF_CORE_READ(task, cgroups, dfl_cgrp, kn);
 
+#if __has_builtin(__builtin_preserve_enum_value)
 	if (ENABLE_CGROUP_V1_RESOLVER && CONFIG_CGROUP_PIDS) {
 		int cgrp_id = bpf_core_enum_value(enum cgroup_subsys_id___local,
 						  pids_cgrp_id___local);
@@ -275,6 +276,7 @@ static INLINE void* populate_cgroup_info
 			}
 		}
 	}
+#endif
 
 	cgroup_data->cgroup_root_inode = get_inode_from_kernfs(root_kernfs);
 	cgroup_data->cgroup_proc_inode = get_inode_from_kernfs(proc_kernfs);


