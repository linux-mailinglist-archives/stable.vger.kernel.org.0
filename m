Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C870C200FC3
	for <lists+stable@lfdr.de>; Fri, 19 Jun 2020 17:23:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2392901AbgFSPVr (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 19 Jun 2020 11:21:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53076 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2392898AbgFSPVq (ORCPT <rfc822;stable@vger.kernel.org>);
        Fri, 19 Jun 2020 11:21:46 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDA6120B80;
        Fri, 19 Jun 2020 15:21:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592580106;
        bh=eLGvbqasm5wT9Qyyy9tJRN20dYjw6ehaSKc9NufMyLk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CUQWBJBOelRxvzLRhAjYeh3GqBklH/Z/3YR9z3HWhz8+f5GI2QRqHZXEj01UCyMDp
         Dk+DrRIywSdsI1QQ6iTmZSKuiMAYAHwRdmd4cyfrziZt7x5ITNBXgjkDH/c42+EjFb
         ndCotoMVIcDyZTc8qBwdNF26rz3yhqwP62qnToEw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        KP Singh <kpsingh@google.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.7 125/376] libbpf: Fix huge memory leak in libbpf_find_vmlinux_btf_id()
Date:   Fri, 19 Jun 2020 16:30:43 +0200
Message-Id: <20200619141716.252418290@linuxfoundation.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200619141710.350494719@linuxfoundation.org>
References: <20200619141710.350494719@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Andrii Nakryiko <andriin@fb.com>

[ Upstream commit 3521ffa2ee9a48c3236c93f54ae11c074490ebce ]

BTF object wasn't freed.

Fixes: a6ed02cac690 ("libbpf: Load btf_vmlinux only once per object.")
Signed-off-by: Andrii Nakryiko <andriin@fb.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Cc: KP Singh <kpsingh@google.com>
Link: https://lore.kernel.org/bpf/20200429012111.277390-9-andriin@fb.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/lib/bpf/libbpf.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/tools/lib/bpf/libbpf.c b/tools/lib/bpf/libbpf.c
index 63fc872723fc..cd53204d33f0 100644
--- a/tools/lib/bpf/libbpf.c
+++ b/tools/lib/bpf/libbpf.c
@@ -6688,6 +6688,7 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 			       enum bpf_attach_type attach_type)
 {
 	struct btf *btf;
+	int err;
 
 	btf = libbpf_find_kernel_btf();
 	if (IS_ERR(btf)) {
@@ -6695,7 +6696,9 @@ int libbpf_find_vmlinux_btf_id(const char *name,
 		return -EINVAL;
 	}
 
-	return __find_vmlinux_btf_id(btf, name, attach_type);
+	err = __find_vmlinux_btf_id(btf, name, attach_type);
+	btf__free(btf);
+	return err;
 }
 
 static int libbpf_find_prog_btf_id(const char *name, __u32 attach_prog_fd)
-- 
2.25.1



