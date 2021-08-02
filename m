Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF5A3DD98C
	for <lists+stable@lfdr.de>; Mon,  2 Aug 2021 16:01:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235020AbhHBOBR (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 2 Aug 2021 10:01:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:40886 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236445AbhHBN7a (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 2 Aug 2021 09:59:30 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id C16B86113A;
        Mon,  2 Aug 2021 13:55:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1627912546;
        bh=zcmlo7zc7DGAIT0Vch6TvX/N7HW0XdjlfpGcs1JaJ9c=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ofZ0OCwldRS9XZDhQYmkwhpRJciKohMbyvskt8hyoG/iqwFdH/QsKSCywO1YpIiNs
         fhR5zoyH2WhfGLj4AI8/7p7l0ydhuv5C1KtWLoFuhxyQwlngBdX50hwMgVxhG0WXba
         xh4u5PwMFUVI3amfCIulTCcHyAU2auKwv3thdRxs=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Lorenz Bauer <lmb@cloudflare.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.13 041/104] bpf: Fix OOB read when printing XDP link fdinfo
Date:   Mon,  2 Aug 2021 15:44:38 +0200
Message-Id: <20210802134345.371373589@linuxfoundation.org>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210802134344.028226640@linuxfoundation.org>
References: <20210802134344.028226640@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Lorenz Bauer <lmb@cloudflare.com>

[ Upstream commit d6371c76e20d7d3f61b05fd67b596af4d14a8886 ]

We got the following UBSAN report on one of our testing machines:

    ================================================================================
    UBSAN: array-index-out-of-bounds in kernel/bpf/syscall.c:2389:24
    index 6 is out of range for type 'char *[6]'
    CPU: 43 PID: 930921 Comm: systemd-coredum Tainted: G           O      5.10.48-cloudflare-kasan-2021.7.0 #1
    Hardware name: <snip>
    Call Trace:
     dump_stack+0x7d/0xa3
     ubsan_epilogue+0x5/0x40
     __ubsan_handle_out_of_bounds.cold+0x43/0x48
     ? seq_printf+0x17d/0x250
     bpf_link_show_fdinfo+0x329/0x380
     ? bpf_map_value_size+0xe0/0xe0
     ? put_files_struct+0x20/0x2d0
     ? __kasan_kmalloc.constprop.0+0xc2/0xd0
     seq_show+0x3f7/0x540
     seq_read_iter+0x3f8/0x1040
     seq_read+0x329/0x500
     ? seq_read_iter+0x1040/0x1040
     ? __fsnotify_parent+0x80/0x820
     ? __fsnotify_update_child_dentry_flags+0x380/0x380
     vfs_read+0x123/0x460
     ksys_read+0xed/0x1c0
     ? __x64_sys_pwrite64+0x1f0/0x1f0
     do_syscall_64+0x33/0x40
     entry_SYSCALL_64_after_hwframe+0x44/0xa9
    <snip>
    ================================================================================
    ================================================================================
    UBSAN: object-size-mismatch in kernel/bpf/syscall.c:2384:2

>From the report, we can infer that some array access in bpf_link_show_fdinfo at index 6
is out of bounds. The obvious candidate is bpf_link_type_strs[BPF_LINK_TYPE_XDP] with
BPF_LINK_TYPE_XDP == 6. It turns out that BPF_LINK_TYPE_XDP is missing from bpf_types.h
and therefore doesn't have an entry in bpf_link_type_strs:

    pos:	0
    flags:	02000000
    mnt_id:	13
    link_type:	(null)
    link_id:	4
    prog_tag:	bcf7977d3b93787c
    prog_id:	4
    ifindex:	1

Fixes: aa8d3a716b59 ("bpf, xdp: Add bpf_link-based XDP attachment API")
Signed-off-by: Lorenz Bauer <lmb@cloudflare.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/bpf/20210719085134.43325-2-lmb@cloudflare.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/bpf_types.h | 1 +
 1 file changed, 1 insertion(+)

diff --git a/include/linux/bpf_types.h b/include/linux/bpf_types.h
index f883f01a5061..def596a85752 100644
--- a/include/linux/bpf_types.h
+++ b/include/linux/bpf_types.h
@@ -132,4 +132,5 @@ BPF_LINK_TYPE(BPF_LINK_TYPE_CGROUP, cgroup)
 BPF_LINK_TYPE(BPF_LINK_TYPE_ITER, iter)
 #ifdef CONFIG_NET
 BPF_LINK_TYPE(BPF_LINK_TYPE_NETNS, netns)
+BPF_LINK_TYPE(BPF_LINK_TYPE_XDP, xdp)
 #endif
-- 
2.30.2



