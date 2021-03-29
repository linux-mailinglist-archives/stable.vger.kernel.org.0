Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E829234CA1B
	for <lists+stable@lfdr.de>; Mon, 29 Mar 2021 10:40:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232321AbhC2Ie5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 29 Mar 2021 04:34:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:53556 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232256AbhC2Ido (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 29 Mar 2021 04:33:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9CB0161581;
        Mon, 29 Mar 2021 08:33:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1617006824;
        bh=mQ2uRcTtKP0XI4FMbDo07DIebFGI9b0vlZso70Q3V7U=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ybjOPQoedzzeTGMFTPIvc/3ZHwLFtlyJfUUz3BsSm/TCOspztQ+4ZYo9588WuD+s4
         hLSPmdYBQMc27rE/a/Il98RPpU8juRIeXSn0p1AdwfzrB8zpHk235HJesyHf6lfh2B
         hP5L9A35Xa/ilCNQH24s5UDDmosdWNiK6YCsQRfM=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+8bab8ed346746e7540e8@syzkaller.appspotmail.com,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.11 111/254] bpf: Dont allow vmlinux BTF to be used in map_create and prog_load.
Date:   Mon, 29 Mar 2021 09:57:07 +0200
Message-Id: <20210329075636.860814709@linuxfoundation.org>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210329075633.135869143@linuxfoundation.org>
References: <20210329075633.135869143@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 350a5c4dd2452ea999cc5e1d4a8dbf12de2f97ef ]

The syzbot got FD of vmlinux BTF and passed it into map_create which caused
crash in btf_type_id_size() when it tried to access resolved_ids. The vmlinux
BTF doesn't have 'resolved_ids' and 'resolved_sizes' initialized to save
memory. To avoid such issues disallow using vmlinux BTF in prog_load and
map_create commands.

Fixes: 5329722057d4 ("bpf: Assign ID to vmlinux BTF and return extra info for BTF in GET_OBJ_INFO")
Reported-by: syzbot+8bab8ed346746e7540e8@syzkaller.appspotmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210307225248.79031-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c  | 5 +++++
 kernel/bpf/verifier.c | 4 ++++
 2 files changed, 9 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index e5999d86c76e..32ca33539052 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -854,6 +854,11 @@ static int map_create(union bpf_attr *attr)
 			err = PTR_ERR(btf);
 			goto free_map;
 		}
+		if (btf_is_kernel(btf)) {
+			btf_put(btf);
+			err = -EACCES;
+			goto free_map;
+		}
 		map->btf = btf;
 
 		if (attr->btf_value_type_id) {
diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ab23dfb9df1b..5b233e911c2c 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8580,6 +8580,10 @@ static int check_btf_info(struct bpf_verifier_env *env,
 	btf = btf_get_by_fd(attr->prog_btf_fd);
 	if (IS_ERR(btf))
 		return PTR_ERR(btf);
+	if (btf_is_kernel(btf)) {
+		btf_put(btf);
+		return -EACCES;
+	}
 	env->prog->aux->btf = btf;
 
 	err = check_btf_func(env, attr, uattr);
-- 
2.30.1



