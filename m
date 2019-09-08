Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 052B8ACE0B
	for <lists+stable@lfdr.de>; Sun,  8 Sep 2019 14:57:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731762AbfIHMtz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 8 Sep 2019 08:49:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:40226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731815AbfIHMty (ORCPT <rfc822;stable@vger.kernel.org>);
        Sun, 8 Sep 2019 08:49:54 -0400
Received: from localhost (unknown [62.28.240.114])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C781121E6F;
        Sun,  8 Sep 2019 12:49:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1567946993;
        bh=zJXcHOpUpraJB422KwiwL8D7cgDE6MmuuaHhybLGKZE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=fS6k770hDk4xK4QUcmvZpcR7OTUw/IMv8BkyxQPBhvb9Hj2SKHX6qym/o3446iDYK
         DKP2eKUuKSHRlVJZgI5L+fNdwvcMs0UrpWYvutipJLo+KL8eNJvaiypwu+zOwagNxK
         8ikUO2VaTk5+Zaz+WBvZaNoAVrYRCl+hJsqJi43s=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrey Ignatov <rdna@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.2 21/94] libbpf: fix erroneous multi-closing of BTF FD
Date:   Sun,  8 Sep 2019 13:41:17 +0100
Message-Id: <20190908121151.046303684@linuxfoundation.org>
X-Mailer: git-send-email 2.23.0
In-Reply-To: <20190908121150.420989666@linuxfoundation.org>
References: <20190908121150.420989666@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

[ Upstream commit 5d01ab7bac467edfc530e6ccf953921def935c62 ]

Libbpf stores associated BTF FD per each instance of bpf_program. When
program is unloaded, that FD is closed. This is wrong, because leads to
a race and possibly closing of unrelated files, if application
simultaneously opens new files while bpf_programs are unloaded.

It's also unnecessary, because struct btf "owns" that FD, and
btf__free(), called from bpf_object__close() will close it. Thus the fix
is to never have per-program BTF FD and fetch it from obj->btf, when
necessary.

Fixes: 2993e0515bb4 ("tools/bpf: add support to read .BTF.ext sections")
Reported-by: Andrey Ignatov <rdna@fb.com>
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 77e14d9954796..21355f6be2434 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -178,7 +178,6 @@ struct bpf_program {
 	bpf_program_clear_priv_t clear_priv;
 
 	enum bpf_attach_type expected_attach_type;
-	int btf_fd;
 	void *func_info;
 	__u32 func_info_rec_size;
 	__u32 func_info_cnt;
@@ -305,7 +304,6 @@ void bpf_program__unload(struct bpf_program *prog)
 	prog->instances.nr = -1;
 	zfree(&prog->instances.fds);
 
-	zclose(prog->btf_fd);
 	zfree(&prog->func_info);
 	zfree(&prog->line_info);
 }
@@ -382,7 +380,6 @@ bpf_program__init(void *data, size_t size, char *section_name, int idx,
 	prog->instances.fds = NULL;
 	prog->instances.nr = -1;
 	prog->type = BPF_PROG_TYPE_UNSPEC;
-	prog->btf_fd = -1;
 
 	return 0;
 errout:
@@ -1888,9 +1885,6 @@ bpf_program_reloc_btf_ext(struct bpf_program *prog, struct bpf_object *obj,
 		prog->line_info_rec_size = btf_ext__line_info_rec_size(obj->btf_ext);
 	}
 
-	if (!insn_offset)
-		prog->btf_fd = btf__fd(obj->btf);
-
 	return 0;
 }
 
@@ -2065,7 +2059,7 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	char *cp, errmsg[STRERR_BUFSIZE];
 	int log_buf_size = BPF_LOG_BUF_SIZE;
 	char *log_buf;
-	int ret;
+	int btf_fd, ret;
 
 	memset(&load_attr, 0, sizeof(struct bpf_load_program_attr));
 	load_attr.prog_type = prog->type;
@@ -2077,7 +2071,8 @@ load_program(struct bpf_program *prog, struct bpf_insn *insns, int insns_cnt,
 	load_attr.license = license;
 	load_attr.kern_version = kern_version;
 	load_attr.prog_ifindex = prog->prog_ifindex;
-	load_attr.prog_btf_fd = prog->btf_fd >= 0 ? prog->btf_fd : 0;
+	btf_fd = bpf_object__btf_fd(prog->obj);
+	load_attr.prog_btf_fd = btf_fd >= 0 ? btf_fd : 0;
 	load_attr.func_info = prog->func_info;
 	load_attr.func_info_rec_size = prog->func_info_rec_size;
 	load_attr.func_info_cnt = prog->func_info_cnt;
-- 
2.20.1



