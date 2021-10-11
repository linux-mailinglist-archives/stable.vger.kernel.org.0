Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99454428F86
	for <lists+stable@lfdr.de>; Mon, 11 Oct 2021 15:58:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237131AbhJKN7R (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Oct 2021 09:59:17 -0400
Received: from mail.kernel.org ([198.145.29.99]:49804 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237290AbhJKN54 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 11 Oct 2021 09:57:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7F06060EB1;
        Mon, 11 Oct 2021 13:54:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1633960473;
        bh=dkN0Zv8DBhsso13JukK3ctqSMPp5GWlf+qBbx+xz99A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=b9VvAOLZRfl7GZlmayzSvmO6dmY/nULR6t7vlSnt9VAYdJz/61zKvW9CwIk4lZ6j6
         ovftgYPrmEYcL2bo0c3VjEFLMQubyA+TxLwHoDswuigi7vFEtFXzEGQOMXyqOVJvNC
         76U+4ruiW+4gYUeH6E/5+EqSKwTg4hLE1x5T+O20=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org,
        Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 37/83] bpf: Fix integer overflow in prealloc_elems_and_freelist()
Date:   Mon, 11 Oct 2021 15:45:57 +0200
Message-Id: <20211011134509.662607187@linuxfoundation.org>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <20211011134508.362906295@linuxfoundation.org>
References: <20211011134508.362906295@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>

[ Upstream commit 30e29a9a2bc6a4888335a6ede968b75cd329657a ]

In prealloc_elems_and_freelist(), the multiplication to calculate the
size passed to bpf_map_area_alloc() could lead to an integer overflow.
As a result, out-of-bounds write could occur in pcpu_freelist_populate()
as reported by KASAN:

[...]
[   16.968613] BUG: KASAN: slab-out-of-bounds in pcpu_freelist_populate+0xd9/0x100
[   16.969408] Write of size 8 at addr ffff888104fc6ea0 by task crash/78
[   16.970038]
[   16.970195] CPU: 0 PID: 78 Comm: crash Not tainted 5.15.0-rc2+ #1
[   16.970878] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[   16.972026] Call Trace:
[   16.972306]  dump_stack_lvl+0x34/0x44
[   16.972687]  print_address_description.constprop.0+0x21/0x140
[   16.973297]  ? pcpu_freelist_populate+0xd9/0x100
[   16.973777]  ? pcpu_freelist_populate+0xd9/0x100
[   16.974257]  kasan_report.cold+0x7f/0x11b
[   16.974681]  ? pcpu_freelist_populate+0xd9/0x100
[   16.975190]  pcpu_freelist_populate+0xd9/0x100
[   16.975669]  stack_map_alloc+0x209/0x2a0
[   16.976106]  __sys_bpf+0xd83/0x2ce0
[...]

The possibility of this overflow was originally discussed in [0], but
was overlooked.

Fix the integer overflow by changing elem_size to u64 from u32.

  [0] https://lore.kernel.org/bpf/728b238e-a481-eb50-98e9-b0f430ab01e7@gmail.com/

Fixes: 557c0c6e7df8 ("bpf: convert stackmap to pre-allocation")
Signed-off-by: Tatsuhiko Yasumatsu <th.yasumatsu@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20210930135545.173698-1-th.yasumatsu@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/stackmap.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/stackmap.c b/kernel/bpf/stackmap.c
index ebf60848d5eb..4477873ac3a0 100644
--- a/kernel/bpf/stackmap.c
+++ b/kernel/bpf/stackmap.c
@@ -64,7 +64,8 @@ static inline int stack_map_data_size(struct bpf_map *map)
 
 static int prealloc_elems_and_freelist(struct bpf_stack_map *smap)
 {
-	u32 elem_size = sizeof(struct stack_map_bucket) + smap->map.value_size;
+	u64 elem_size = sizeof(struct stack_map_bucket) +
+			(u64)smap->map.value_size;
 	int err;
 
 	smap->elems = bpf_map_area_alloc(elem_size * smap->map.max_entries,
-- 
2.33.0



