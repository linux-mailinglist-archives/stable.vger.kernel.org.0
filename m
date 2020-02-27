Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87ECE1720FA
	for <lists+stable@lfdr.de>; Thu, 27 Feb 2020 15:47:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730299AbgB0No6 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 27 Feb 2020 08:44:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:40712 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729949AbgB0No6 (ORCPT <rfc822;stable@vger.kernel.org>);
        Thu, 27 Feb 2020 08:44:58 -0500
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DB42A20578;
        Thu, 27 Feb 2020 13:44:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582811097;
        bh=NhUQGsnafUe+C5Bx0IIl7hrgX87gytrWYkGTQoNos+0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=0UpdUNz6Jtza2BQnHQH7DZvRtMBSIlufY4eFpexim7O9j4bztuWDZ9ZvG+vWZOSNb
         XpFpE0p1UlFTdR4tMsw60mpZ6CQjXj5sGJGgCCZ9ztUrW2uqNQl4bMDmg5WKWKVD6p
         PmHfk2Y+2dbiDI8m7pwUVk6C/pGkR3qXPcJQcTgw=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, Jann Horn <jannh@google.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Zubin Mithra <zsm@chromium.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.4 100/113] netfilter: xt_bpf: add overflow checks
Date:   Thu, 27 Feb 2020 14:36:56 +0100
Message-Id: <20200227132227.741017495@linuxfoundation.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200227132211.791484803@linuxfoundation.org>
References: <20200227132211.791484803@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Jann Horn <jannh@google.com>

[ Upstream commit 6ab405114b0b229151ef06f4e31c7834dd09d0c0 ]

Check whether inputs from userspace are too long (explicit length field too
big or string not null-terminated) to avoid out-of-bounds reads.

As far as I can tell, this can at worst lead to very limited kernel heap
memory disclosure or oopses.

This bug can be triggered by an unprivileged user even if the xt_bpf module
is not loaded: iptables is available in network namespaces, and the xt_bpf
module can be autoloaded.

Triggering the bug with a classic BPF filter with fake length 0x1000 causes
the following KASAN report:

==================================================================
BUG: KASAN: slab-out-of-bounds in bpf_prog_create+0x84/0xf0
Read of size 32768 at addr ffff8801eff2c494 by task test/4627

CPU: 0 PID: 4627 Comm: test Not tainted 4.15.0-rc1+ #1
[...]
Call Trace:
 dump_stack+0x5c/0x85
 print_address_description+0x6a/0x260
 kasan_report+0x254/0x370
 ? bpf_prog_create+0x84/0xf0
 memcpy+0x1f/0x50
 bpf_prog_create+0x84/0xf0
 bpf_mt_check+0x90/0xd6 [xt_bpf]
[...]
Allocated by task 4627:
 kasan_kmalloc+0xa0/0xd0
 __kmalloc_node+0x47/0x60
 xt_alloc_table_info+0x41/0x70 [x_tables]
[...]
The buggy address belongs to the object at ffff8801eff2c3c0
                which belongs to the cache kmalloc-2048 of size 2048
The buggy address is located 212 bytes inside of
                2048-byte region [ffff8801eff2c3c0, ffff8801eff2cbc0)
[...]
==================================================================

Fixes: e6f30c731718 ("netfilter: x_tables: add xt_bpf match")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
Signed-off-by: Zubin Mithra <zsm@chromium.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/xt_bpf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/netfilter/xt_bpf.c b/net/netfilter/xt_bpf.c
index dffee9d47ec4b..7b993f25aab92 100644
--- a/net/netfilter/xt_bpf.c
+++ b/net/netfilter/xt_bpf.c
@@ -25,6 +25,9 @@ static int bpf_mt_check(const struct xt_mtchk_param *par)
 	struct xt_bpf_info *info = par->matchinfo;
 	struct sock_fprog_kern program;
 
+	if (info->bpf_program_num_elem > XT_BPF_MAX_NUM_INSTR)
+		return -EINVAL;
+
 	program.len = info->bpf_program_num_elem;
 	program.filter = info->bpf_program;
 
-- 
2.20.1



