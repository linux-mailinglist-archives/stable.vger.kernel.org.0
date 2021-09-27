Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 892A4419B07
	for <lists+stable@lfdr.de>; Mon, 27 Sep 2021 19:13:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236099AbhI0RPC (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 27 Sep 2021 13:15:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:56710 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237155AbhI0RN7 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 27 Sep 2021 13:13:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC7FA6135E;
        Mon, 27 Sep 2021 17:09:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1632762588;
        bh=eu/bJfp63toC+D5pqX4MdCsMCvLXE0Eer14DHA2QUe8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rpJOmptdIVHLG1XmQ+IUNDx95QNwE9vC5+jKStD5PK+LlcXoLCD0FK8sgsHOmbZaO
         Nu67LvoJoyMr79SOpIKa1Ow3UNZwfM+q9frCo1U0RW6fCOL5iN9cQtdxQApJ+QI2RE
         zFVwb9iQEcFQ7oF0BY85wTObAynYmYlZOzNLgKv0=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com,
        Bixuan Cui <cuibixuan@huawei.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Yonghong Song <yhs@fb.com>, Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 080/103] bpf: Add oversize check before call kvcalloc()
Date:   Mon, 27 Sep 2021 19:02:52 +0200
Message-Id: <20210927170228.531386981@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20210927170225.702078779@linuxfoundation.org>
References: <20210927170225.702078779@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Bixuan Cui <cuibixuan@huawei.com>

[ Upstream commit 0e6491b559704da720f6da09dd0a52c4df44c514 ]

Commit 7661809d493b ("mm: don't allow oversized kvmalloc() calls") add the
oversize check. When the allocation is larger than what kmalloc() supports,
the following warning triggered:

WARNING: CPU: 0 PID: 8408 at mm/util.c:597 kvmalloc_node+0x108/0x110 mm/util.c:597
Modules linked in:
CPU: 0 PID: 8408 Comm: syz-executor221 Not tainted 5.14.0-syzkaller #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
RIP: 0010:kvmalloc_node+0x108/0x110 mm/util.c:597
Call Trace:
 kvmalloc include/linux/mm.h:806 [inline]
 kvmalloc_array include/linux/mm.h:824 [inline]
 kvcalloc include/linux/mm.h:829 [inline]
 check_btf_line kernel/bpf/verifier.c:9925 [inline]
 check_btf_info kernel/bpf/verifier.c:10049 [inline]
 bpf_check+0xd634/0x150d0 kernel/bpf/verifier.c:13759
 bpf_prog_load kernel/bpf/syscall.c:2301 [inline]
 __sys_bpf+0x11181/0x126e0 kernel/bpf/syscall.c:4587
 __do_sys_bpf kernel/bpf/syscall.c:4691 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:4689 [inline]
 __x64_sys_bpf+0x78/0x90 kernel/bpf/syscall.c:4689
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x3d/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae

Reported-by: syzbot+f3e749d4c662818ae439@syzkaller.appspotmail.com
Signed-off-by: Bixuan Cui <cuibixuan@huawei.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Acked-by: Yonghong Song <yhs@fb.com>
Link: https://lore.kernel.org/bpf/20210911005557.45518-1-cuibixuan@huawei.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index cba1f86e75cd..0c26757ea7fb 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -8822,6 +8822,8 @@ static int check_btf_line(struct bpf_verifier_env *env,
 	nr_linfo = attr->line_info_cnt;
 	if (!nr_linfo)
 		return 0;
+	if (nr_linfo > INT_MAX / sizeof(struct bpf_line_info))
+		return -EINVAL;
 
 	rec_size = attr->line_info_rec_size;
 	if (rec_size < MIN_BPF_LINEINFO_SIZE ||
-- 
2.33.0



