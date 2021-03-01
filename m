Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F3897328B81
	for <lists+stable@lfdr.de>; Mon,  1 Mar 2021 19:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239300AbhCASgO (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 1 Mar 2021 13:36:14 -0500
Received: from mail.kernel.org ([198.145.29.99]:43156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240012AbhCAS2Y (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 1 Mar 2021 13:28:24 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 69C47652DF;
        Mon,  1 Mar 2021 17:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1614620339;
        bh=zvTLB1t4hGgtLgCjpybJcQ+GyOAitxKZMc/lErqvMfE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=eXLNzBSl1PyzyohSpETaiuDEPOKImFOwQ7POAM5EjQD62HvTt7gcoxtnapU4La9Za
         oVO9nd5B7CpJNd3R13tRg+o556/EU8N8SmswztJsLH8LNl7f+dELTsxRJRPmnGSJZO
         W+DWpc2vDo0nl4F4fC0xec9zd/qnfZqe9FQnItNw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 118/775] libbpf: Ignore non function pointer member in struct_ops
Date:   Mon,  1 Mar 2021 17:04:46 +0100
Message-Id: <20210301161207.507679493@linuxfoundation.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210301161201.679371205@linuxfoundation.org>
References: <20210301161201.679371205@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Martin KaFai Lau <kafai@fb.com>

[ Upstream commit d2836dddc95d5dd82c7cb23726c97d8c9147f050 ]

When libbpf initializes the kernel's struct_ops in
"bpf_map__init_kern_struct_ops()", it enforces all
pointer types must be a function pointer and rejects
others.  It turns out to be too strict.  For example,
when directly using "struct tcp_congestion_ops" from vmlinux.h,
it has a "struct module *owner" member and it is set to NULL
in a bpf_tcp_cc.o.

Instead, it only needs to ensure the member is a function
pointer if it has been set (relocated) to a bpf-prog.
This patch moves the "btf_is_func_proto(kern_mtype)" check
after the existing "if (!prog) { continue; }".  The original debug
message in "if (!prog) { continue; }" is also removed since it is
no longer valid.  Beside, there is a later debug message to tell
which function pointer is set.

The "btf_is_func_proto(mtype)" has already been guaranteed
in "bpf_object__collect_st_ops_relos()" which has been run
before "bpf_map__init_kern_struct_ops()".  Thus, this check
is removed.

v2:
- Remove outdated debug message (Andrii)
  Remove because there is a later debug message to tell
  which function pointer is set.
- Following mtype->type is no longer needed. Remove:
  "skip_mods_and_typedefs(btf, mtype->type, &mtype_id)"
- Do "if (!prog)" test before skip_mods_and_typedefs.

Fixes: 590a00888250 ("bpf: libbpf: Add STRUCT_OPS support")
Signed-off-by: Martin KaFai Lau <kafai@fb.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Acked-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210212021030.266932-1-kafai@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 22 +++++++++++-----------
 1 file changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 6ae748f6ea118..a0d4fc4de4027 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -883,24 +883,24 @@ static int bpf_map__init_kern_struct_ops(struct bpf_map *map,
 		if (btf_is_ptr(mtype)) {
 			struct bpf_program *prog;
 
-			mtype = skip_mods_and_typedefs(btf, mtype->type, &mtype_id);
+			prog = st_ops->progs[i];
+			if (!prog)
+				continue;
+
 			kern_mtype = skip_mods_and_typedefs(kern_btf,
 							    kern_mtype->type,
 							    &kern_mtype_id);
-			if (!btf_is_func_proto(mtype) ||
-			    !btf_is_func_proto(kern_mtype)) {
-				pr_warn("struct_ops init_kern %s: non func ptr %s is not supported\n",
+
+			/* mtype->type must be a func_proto which was
+			 * guaranteed in bpf_object__collect_st_ops_relos(),
+			 * so only check kern_mtype for func_proto here.
+			 */
+			if (!btf_is_func_proto(kern_mtype)) {
+				pr_warn("struct_ops init_kern %s: kernel member %s is not a func ptr\n",
 					map->name, mname);
 				return -ENOTSUP;
 			}
 
-			prog = st_ops->progs[i];
-			if (!prog) {
-				pr_debug("struct_ops init_kern %s: func ptr %s is not set\n",
-					 map->name, mname);
-				continue;
-			}
-
 			prog->attach_btf_id = kern_type_id;
 			prog->expected_attach_type = kern_member_idx;
 
-- 
2.27.0



