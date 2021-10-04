Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A216E420FED
	for <lists+stable@lfdr.de>; Mon,  4 Oct 2021 15:37:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237825AbhJDNjP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 4 Oct 2021 09:39:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:51966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238153AbhJDNhI (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 4 Oct 2021 09:37:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D3CB6124B;
        Mon,  4 Oct 2021 13:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633353405;
        bh=KMlCW3ihomlYIXeJo//98hTRu56y/+zQROHmuNdSJxs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tGao5fDQOLiNRM2qS1FbavaTBSS4P6myoWir72up5/k4Qcwsjb4Ftf7iDC9iNbFcn
         2MqOvfFIZsNLTzaUeqaYHh2YpMt3gaHI5I2gwnHUCGqMGEcQJKRU85x3ifqnwMDgeK
         v4luCo4+8OGFd2acvymW5gqiX5C+s9JQgl8eA2ag=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.14 115/172] libbpf: Fix segfault in static linker for objects without BTF
Date:   Mon,  4 Oct 2021 14:52:45 +0200
Message-Id: <20211004125048.693992509@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211004125044.945314266@linuxfoundation.org>
References: <20211004125044.945314266@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit bcfd367c2839f2126c048fe59700ec1b538e2b06 ]

When a BPF object is compiled without BTF info (without -g),
trying to link such objects using bpftool causes a SIGSEGV due to
btf__get_nr_types accessing obj->btf which is NULL. Fix this by
checking for the NULL pointer, and return error.

Reproducer:
$ cat a.bpf.c
extern int foo(void);
int bar(void) { return foo(); }
$ cat b.bpf.c
int foo(void) { return 0; }
$ clang -O2 -target bpf -c a.bpf.c
$ clang -O2 -target bpf -c b.bpf.c
$ bpftool gen obj out a.bpf.o b.bpf.o
Segmentation fault (core dumped)

After fix:
$ bpftool gen obj out a.bpf.o b.bpf.o
libbpf: failed to find BTF info for object 'a.bpf.o'
Error: failed to link 'a.bpf.o': Unknown error -22 (-22)

Fixes: a46349227cd8 (libbpf: Add linker extern resolution support for functions and global variables)
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210924023725.70228-1-memxor@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/linker.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/linker.c b/tools/lib/bpf/linker.c
index 10911a8cad0f..2df880cefdae 100644
--- a/tools/lib/bpf/linker.c
+++ b/tools/lib/bpf/linker.c
@@ -1649,11 +1649,17 @@ static bool btf_is_non_static(const struct btf_type *t)
 static int find_glob_sym_btf(struct src_obj *obj, Elf64_Sym *sym, const char *sym_name,
 			     int *out_btf_sec_id, int *out_btf_id)
 {
-	int i, j, n = btf__get_nr_types(obj->btf), m, btf_id = 0;
+	int i, j, n, m, btf_id = 0;
 	const struct btf_type *t;
 	const struct btf_var_secinfo *vi;
 	const char *name;
 
+	if (!obj->btf) {
+		pr_warn("failed to find BTF info for object '%s'\n", obj->filename);
+		return -EINVAL;
+	}
+
+	n = btf__get_nr_types(obj->btf);
 	for (i = 1; i <= n; i++) {
 		t = btf__type_by_id(obj->btf, i);
 
-- 
2.33.0



