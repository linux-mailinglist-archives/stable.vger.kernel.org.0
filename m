Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6C93F170A7E
	for <lists+stable@lfdr.de>; Wed, 26 Feb 2020 22:35:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727552AbgBZVfG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Feb 2020 16:35:06 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:40024 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727550AbgBZVfG (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Feb 2020 16:35:06 -0500
Received: by mail-pl1-f195.google.com with SMTP id y1so215164plp.7
        for <stable@vger.kernel.org>; Wed, 26 Feb 2020 13:35:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c6erio/oOrlH9JXdjBouANmwddL47GXBzhj040V2O9s=;
        b=Z5gx1xSvq7u+5l3LGVc7PW6/POd4ilxTGdl56t2YFPjhDwGVsg2XFx0m03iSwfDAO9
         +hws6tDUjsmKjdqhOXE4VoXLIb5nc70Hb/YPW9BPCUrh5uT+TIlE9Dv34J0Prjdh+buE
         kWF5kuUgMU5cK2qlIueAiUy2vgcH4/bIVxwt4=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c6erio/oOrlH9JXdjBouANmwddL47GXBzhj040V2O9s=;
        b=LRyvT8zgW3+wKdbUXJt39X6jTpdDnPpXBrCAofzXuIhvpT4zyccuoTCdihR2YLp0+h
         gvgD96/cIWveC7aexKXVMJ+02DSjwtCXLcWaJ+s8rpu/zVmJjcmNBNzKp2qpAdjhQwKE
         COUghxp+c9OhliRLoRHOAQx+0wfkUEF9ysDE5EqPTTzBlLKDbttdjUaC8QTJUrDmTzS5
         TQ6uX3Z08YqqlpjWQMmDMqP5uYGIbxpHbryq68EB/k2a4FCUy8E2zdkjl4gQ8JacDVW3
         DKHPMu0bj1xTE65wKQWEo146EZPfufIIbQ2dSxVsTMGIkZB0VOT0nTQLCJLAW2U+KpC0
         VoGg==
X-Gm-Message-State: APjAAAWEwC0nM5gj2eQrZQ0OZg8wVqK/CtcUguEHyIZhCg0QmVorycLn
        b90WhHQTWI49m+NZz/b/XDefJaXlNho=
X-Google-Smtp-Source: APXvYqySZVssi6OEK3N6xVq6wAd+9Yhlp4x0NvkOu7r1RWIT1QzadQzJ68H7DRkJfpfjNtrf6z5qVQ==
X-Received: by 2002:a17:902:b70e:: with SMTP id d14mr1257193pls.295.1582752904776;
        Wed, 26 Feb 2020 13:35:04 -0800 (PST)
Received: from zsm-linux.mtv.corp.google.com ([2620:15c:202:201:49ea:b78f:4f04:4d25])
        by smtp.googlemail.com with ESMTPSA id z13sm3900872pge.29.2020.02.26.13.35.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Feb 2020 13:35:04 -0800 (PST)
From:   Zubin Mithra <zsm@chromium.org>
To:     stable@vger.kernel.org
Cc:     gregkh@linuxfoundation.org, groeck@chromium.org, jannh@google.com,
        pablo@netfilter.org
Subject: [v4.9.y, v4.4.y] netfilter: xt_bpf: add overflow checks
Date:   Wed, 26 Feb 2020 13:35:01 -0800
Message-Id: <20200226213501.113484-1-zsm@chromium.org>
X-Mailer: git-send-email 2.25.0.265.gbab2e86ba0-goog
MIME-Version: 1.0
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
---
* Syzkaller triggered an OOB read with the following stacktrace:
    __dump_stack lib/dump_stack.c:15 [inline]
    dump_stack+0xcb/0x130 lib/dump_stack.c:56
    print_trailer+0x151/0x15a mm/slub.c:658
    object_err+0x35/0x3d mm/slub.c:665
    print_address_description mm/kasan/report.c:188 [inline]
    kasan_report_error mm/kasan/report.c:285 [inline]
    kasan_report.part.0.cold+0x21a/0x4c1 mm/kasan/report.c:310
    kasan_report+0x25/0x30 mm/kasan/report.c:297
    check_memory_region_inline mm/kasan/kasan.c:292 [inline]
    check_memory_region+0x116/0x190 mm/kasan/kasan.c:299
    memcpy+0x24/0x50 mm/kasan/kasan.c:334
    bpf_prog_create+0xdd/0x230 net/core/filter.c:1075
    bpf_mt_check+0xb1/0x100 net/netfilter/xt_bpf.c:31
    xt_check_match+0x26b/0x560 net/netfilter/x_tables.c:444
    check_match net/ipv4/netfilter/ip_tables.c:593 [inline]
    find_check_match net/ipv4/netfilter/ip_tables.c:616 [inline]
    find_check_entry.isra.0+0x2fe/0x950 net/ipv4/netfilter/ip_tables.c:673
    translate_table+0xb3f/0x15b0 net/ipv4/netfilter/ip_tables.c:878
    do_replace net/ipv4/netfilter/ip_tables.c:1300 [inline]
    do_ipt_set_ctl+0x2cf/0x460 net/ipv4/netfilter/ip_tables.c:1864
    nf_sockopt net/netfilter/nf_sockopt.c:105 [inline]
    nf_setsockopt+0x72/0xd0 net/netfilter/nf_sockopt.c:114
    ip_setsockopt net/ipv4/ip_sockglue.c:1227 [inline]
    ip_setsockopt+0xa0/0xb0 net/ipv4/ip_sockglue.c:1212
    udp_setsockopt+0x53/0x90 net/ipv4/udp.c:2162
    sock_common_setsockopt+0x9f/0xe0 net/core/sock.c:2697
    SYSC_setsockopt net/socket.c:1769 [inline]
    SyS_setsockopt+0x146/0x210 net/socket.c:1748
    entry_SYSCALL_64_fastpath+0x1e/0xa0

* This commit is present in linux-4.14.y.

* This patch resolves conflicts that arise due to the following commit
not being present in linux-4.9.y, linux-4.4.y:
- 2c16d6033264 ("netfilter: xt_bpf: support ebpf")

* Tests run: syzkaller reproducer

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
2.25.0.265.gbab2e86ba0-goog

