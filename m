Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 73646548B7D
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 18:10:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347431AbiFMMk7 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 08:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354640AbiFMMi5 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 08:38:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A6515C87D;
        Mon, 13 Jun 2022 04:08:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FE07B80EA8;
        Mon, 13 Jun 2022 11:08:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884C7C34114;
        Mon, 13 Jun 2022 11:08:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1655118508;
        bh=IvR3eCCtOZ3XtPUngNCBjuA5lrHcVgGvsgXLK6fYnZY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=EvkS9xOOTryeXOT9XMTmcTEEVyMIKtwXY0caXo5ZIvYm9+PuZl7OA9sNl6xBeNgQF
         a/R8lgqGsgkFd+3GAshyzgwjlfAg7vOLiObNis/Kgf1jbpSrUr8M9gw/CeFK7EsaPC
         aPpbMYnpJ/kODKqHtwtM2L7mw8GioMrkoiwsGwJU=
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org, syzbot <syzkaller@googlegroups.com>,
        Eric Dumazet <edumazet@google.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 101/172] bpf, arm64: Clear prog->jited_len along prog->jited
Date:   Mon, 13 Jun 2022 12:11:01 +0200
Message-Id: <20220613094914.647323821@linuxfoundation.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220613094850.166931805@linuxfoundation.org>
References: <20220613094850.166931805@linuxfoundation.org>
User-Agent: quilt/0.66
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 10f3b29c65bb2fe0d47c2945cd0b4087be1c5218 ]

syzbot reported an illegal copy_to_user() attempt
from bpf_prog_get_info_by_fd() [1]

There was no repro yet on this bug, but I think
that commit 0aef499f3172 ("mm/usercopy: Detect vmalloc overruns")
is exposing a prior bug in bpf arm64.

bpf_prog_get_info_by_fd() looks at prog->jited_len
to determine if the JIT image can be copied out to user space.

My theory is that syzbot managed to get a prog where prog->jited_len
has been set to 43, while prog->bpf_func has ben cleared.

It is not clear why copy_to_user(uinsns, NULL, ulen) is triggering
this particular warning.

I thought find_vma_area(NULL) would not find a vm_struct.
As we do not hold vmap_area_lock spinlock, it might be possible
that the found vm_struct was garbage.

[1]
usercopy: Kernel memory exposure attempt detected from vmalloc (offset 792633534417210172, size 43)!
kernel BUG at mm/usercopy.c:101!
Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:
CPU: 0 PID: 25002 Comm: syz-executor.1 Not tainted 5.18.0-syzkaller-10139-g8291eaafed36 #0
Hardware name: linux,dummy-virt (DT)
pstate: 60400009 (nZCv daif +PAN -UAO -TCO -DIT -SSBS BTYPE=--)
pc : usercopy_abort+0x90/0x94 mm/usercopy.c:101
lr : usercopy_abort+0x90/0x94 mm/usercopy.c:89
sp : ffff80000b773a20
x29: ffff80000b773a30 x28: faff80000b745000 x27: ffff80000b773b48
x26: 0000000000000000 x25: 000000000000002b x24: 0000000000000000
x23: 00000000000000e0 x22: ffff80000b75db67 x21: 0000000000000001
x20: 000000000000002b x19: ffff80000b75db3c x18: 00000000fffffffd
x17: 2820636f6c6c616d x16: 76206d6f72662064 x15: 6574636574656420
x14: 74706d6574746120 x13: 2129333420657a69 x12: 73202c3237313031
x11: 3237313434333533 x10: 3336323937207465 x9 : 657275736f707865
x8 : ffff80000a30c550 x7 : ffff80000b773830 x6 : ffff80000b773830
x5 : 0000000000000000 x4 : ffff00007fbbaa10 x3 : 0000000000000000
x2 : 0000000000000000 x1 : f7ff000028fc0000 x0 : 0000000000000064
Call trace:
 usercopy_abort+0x90/0x94 mm/usercopy.c:89
 check_heap_object mm/usercopy.c:186 [inline]
 __check_object_size mm/usercopy.c:252 [inline]
 __check_object_size+0x198/0x36c mm/usercopy.c:214
 check_object_size include/linux/thread_info.h:199 [inline]
 check_copy_size include/linux/thread_info.h:235 [inline]
 copy_to_user include/linux/uaccess.h:159 [inline]
 bpf_prog_get_info_by_fd.isra.0+0xf14/0xfdc kernel/bpf/syscall.c:3993
 bpf_obj_get_info_by_fd+0x12c/0x510 kernel/bpf/syscall.c:4253
 __sys_bpf+0x900/0x2150 kernel/bpf/syscall.c:4956
 __do_sys_bpf kernel/bpf/syscall.c:5021 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:5019 [inline]
 __arm64_sys_bpf+0x28/0x40 kernel/bpf/syscall.c:5019
 __invoke_syscall arch/arm64/kernel/syscall.c:38 [inline]
 invoke_syscall+0x48/0x114 arch/arm64/kernel/syscall.c:52
 el0_svc_common.constprop.0+0x44/0xec arch/arm64/kernel/syscall.c:142
 do_el0_svc+0xa0/0xc0 arch/arm64/kernel/syscall.c:206
 el0_svc+0x44/0xb0 arch/arm64/kernel/entry-common.c:624
 el0t_64_sync_handler+0x1ac/0x1b0 arch/arm64/kernel/entry-common.c:642
 el0t_64_sync+0x198/0x19c arch/arm64/kernel/entry.S:581
Code: aa0003e3 d00038c0 91248000 97fff65f (d4210000)

Fixes: db496944fdaa ("bpf: arm64: add JIT support for multi-function programs")
Reported-by: syzbot <syzkaller@googlegroups.com>
Signed-off-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Song Liu <songliubraving@fb.com>
Link: https://lore.kernel.org/bpf/20220531215113.1100754-1-eric.dumazet@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 9c6cab71ba98..18627cbd6da4 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1111,6 +1111,7 @@ struct bpf_prog *bpf_int_jit_compile(struct bpf_prog *prog)
 			bpf_jit_binary_free(header);
 			prog->bpf_func = NULL;
 			prog->jited = 0;
+			prog->jited_len = 0;
 			goto out_off;
 		}
 		bpf_jit_binary_lock_ro(header);
-- 
2.35.1



